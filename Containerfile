FROM ubuntu:kinetic

ARG TARGETARCH
ARG DEVEL="false"

# Versions for manually installed packages
ENV GRADLE_VER=7.6
ENV JULIA_MAJ_VER=1.8
ENV JULIA_VER=1.8.5
ENV NIM_VER=1.6.10
ENV PWSH_VER=7.3.2

# Set locale
RUN apt update && apt install -y locales
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     

# Ubuntu dependencies
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gdc \
    git \
    gnat \
    golang \
    gpg \
    libghc-random-dev \
    lua5.4 \
    meson \
    nodejs \
    npm \
    openjdk-19-jdk-headless \
    pkg-config \
    python-is-python3 \
    ruby \
    unzip \
    wget

# LLVM Dependencies for Zig
RUN echo '\ndeb http://apt.llvm.org/kinetic/ llvm-toolchain-kinetic-16 main' >> /etc/apt/sources.list
RUN wget -nv https://apt.llvm.org/llvm-snapshot.gpg.key -O /etc/apt/trusted.gpg.d/apt.llvm.org.asc
RUN apt update && apt install -y \
    clang-16 \
    libclang-common-16-dev \
    libclang-16-dev \
    libclang1-16 \
    libllvm16 \
    llvm-16 \
    llvm-16-dev \
    llvm-16-runtime \
    lld-16 \
    liblld-16 \
    liblld-16-dev \
    libz-dev

RUN if [ "$DEVEL" = "true" ]; then \
        apt install --no-install-recommends -y \
        gdb \
        lldb-16; \
    fi
    
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
RUN if [ "$DEVEL" = "true" ]; then \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile complete --default-toolchain stable -y; \
    else \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile minimal --default-toolchain stable -y; \
    fi

ENV PATH="$PATH:/root/.cargo/bin"

# V
RUN git clone --depth=1 https://github.com/vlang/v /opt/v
RUN cd /opt/v && make
ENV PATH="$PATH:/opt/v"

# Yarn
RUN npm install -g corepack
RUN corepack enable

# Zig
RUN git clone --depth=1 https://github.com/ziglang/zig && \
    cd zig && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make install && \
    cd ../.. && rm -rf zig

# ZLS
RUN if [ "$DEVEL" = "true" ]; then \
        git clone --depth=1 https://github.com/zigtools/zls && \
        cd zls && \
        zig build -Doptimize=ReleaseSafe && \
        cd .. && rm -rf zls; \
    fi

# Zx
RUN npm install -g zx

COPY . /app
WORKDIR /app

ENTRYPOINT ["zx", "--install", "./benchmark.mjs"]
