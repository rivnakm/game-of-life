FROM ubuntu:kinetic

ARG TARGETARCH

# Versions for manually installed packages
ENV GRADLE_VER=7.6
ENV JULIA_MAJ_VER=1.8
ENV JULIA_VER=1.8.5
ENV NIM_VER=1.6.10
ENV ZIG_VER=0.11.0-dev.1575+289e8fab7
ENV PWSH_VER=7.3.2

RUN echo "${TARGETARCH}"

## Ubuntu dependencies
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y apt-transport-https build-essential curl golang lua5.4 meson nodejs npm openjdk-19-jdk-headless pkg-config python-is-python3 ruby unzip wget

# Dart SDK
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://storage.googleapis.com/dart-archive/channels/be/raw/latest/sdk/dartsdk-linux-x64-release.zip -O dart-sdk.zip; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv https://storage.googleapis.com/dart-archive/channels/be/raw/latest/sdk/dartsdk-linux-arm64-release.zip -O dart-sdk.zip; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN unzip -q dart-sdk.zip && \
    cp -r dart-sdk/bin dart-sdk/lib dart-sdk/include /usr/local/ && \
    rm -rf dart*

# Gradle
RUN wget -nv https://services.gradle.org/distributions/gradle-${GRADLE_VER}-bin.zip -O gradle-bin.zip
RUN unzip -q gradle-bin.zip && cp -r gradle-${GRADLE_VER}/bin gradle-${GRADLE_VER}/lib /usr/local/bin/ && rm -rf gradle*

# Julia
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_MAJ_VER}/julia-${JULIA_VER}-linux-x86_64.tar.gz -O julia.tar.gz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv https://julialang-s3.julialang.org/bin/linux/aarch64/${JULIA_MAJ_VER}/julia-${JULIA_VER}-linux-aarch64.tar.gz -O julia.tar.gz; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN tar -xzf julia.tar.gz && \
    cp -r julia-${JULIA_VER}/bin julia-${JULIA_VER}/lib julia-${JULIA_VER}/libexec julia-${JULIA_VER}/include julia-${JULIA_VER}/share /usr/local/ && \
    cp -r julia-${JULIA_VER}/etc / && \
    rm -rf julia*

# .NET SDK 7.0
RUN wget https://packages.microsoft.com/config/ubuntu/22.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && apt install -y dotnet-sdk-7.0

# Nim
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://nim-lang.org/download/nim-${NIM_VER}-linux_x64.tar.xz -O nim.tar.xz; \
        tar xf nim.tar.zx; \
        cd nim-${NIM_VER}; \
        sh ./install.sh /usr/local/bin; \
        cd ..; \
        rm -rf nim*; \
    else \
        wget  -nv https://nim-lang.org/download/nim-${NIM_VER}.tar.xz -O nim-src.tar.xz; \
        tar xf nim-src.tar.xz; \
        cd nim-${NIM_VER}; \
        sh ./build.sh; \
        sh ./install.sh /usr/local/bin; \
        cd ..; \
        rm -rf nim*; \
    fi

# PowerShell
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-${PWSH_VER}-linux-x64.tar.gz -O pwsh.tar.gz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv https://github.com/PowerShell/PowerShell/releases/download/v7.3.2/powershell-${PWSH_VER}-linux-arm64.tar.gz -O pwsh.tar.gz; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN mkdir -p /opt/microsoft/powershell/7 && \
    tar -xf pwsh.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/local/bin/pwsh && \
    rm -rf pwsh*

# Rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile minimal --default-toolchain stable -y
ENV PATH="$PATH:/root/.cargo/bin"

# Yarn
RUN npm install -g corepack
RUN corepack enable

# Zig
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://ziglang.org/builds/zig-linux-x86_64-${ZIG_VER}.tar.xz -O zig.tar.xz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv https://ziglang.org/builds/zig-linux-aarch64-${ZIG_VER}.tar.xz -O zig.tar.xz; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN tar xf zig.tar.xz && \
    mv zig-*-${ZIG_VER} zig-${ZIG_VER} && \
    cp -r zig-${ZIG_VER}/zig /usr/local/bin/ && \
    cp -r zig-${ZIG_VER}/lib /usr/local/ && \
    rm -rf zig*


# Zx
RUN npm install -g zx

COPY . /app
WORKDIR /app

ENTRYPOINT ["zx", "--install", "./benchmark.mjs"]