FROM ubuntu:lunar

ARG TARGETARCH
ARG DEVEL="false"

# Versions for manually installed packages
ENV GRADLE_VER=8.1.1
ENV JULIA_MAJ_VER=1.8
ENV JULIA_VER=1.8.5
ENV NIM_VER=1.6.12
ENV PWSH_VER=7.3.4

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
        curl \
        git \
        gpg \
        pkg-config \
        unzip \
        wget

# Ada
RUN apt update && apt install -y gnat

# C
RUN apt update && apt install -y clang

# C++
RUN apt update && apt install -y meson

# D
RUN apt update && apt install -y gdc
    
# Dart SDK
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://storage.googleapis.com/dart-archive/channels/be/raw/latest/sdk/dartsdk-linux-x64-release.zip -O dart-sdk.zip; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv https://storage.googleapis.com/dart-archive/channels/be/raw/latest/sdk/dartsdk-linux-arm64-release.zip -O dart-sdk.zip; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN unzip -q dart-sdk.zip
RUN mv dart-sdk /opt/dart-sdk
ENV PATH="$PATH:/opt/dart-sdk/bin"

# Go
RUN apt update && apt install -y golang

# Gradle
RUN wget -nv https://services.gradle.org/distributions/gradle-${GRADLE_VER}-bin.zip -O gradle-bin.zip
RUN unzip -q gradle-bin.zip && cp -r gradle-${GRADLE_VER}/bin gradle-${GRADLE_VER}/lib /usr/local/ && rm -rf gradle*

# Haskell
RUN apt update && apt install -y libghc-random-dev

# Java
RUN apt update && apt install -y openjdk-19-jdk-headless

# Julia
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_MAJ_VER}/julia-${JULIA_VER}-linux-x86_64.tar.gz -O julia.tar.gz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv https://julialang-s3.julialang.org/bin/linux/aarch64/${JULIA_MAJ_VER}/julia-${JULIA_VER}-linux-aarch64.tar.gz -O julia.tar.gz; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN tar -xzf julia.tar.gz
RUN cp -r julia-${JULIA_VER}/bin julia-${JULIA_VER}/lib julia-${JULIA_VER}/libexec julia-${JULIA_VER}/include julia-${JULIA_VER}/share /usr/local/
RUN cp -r julia-${JULIA_VER}/etc /
RUN rm -rf julia*

# Lua
RUN apt update && apt install lua5.4

# .NET SDK 7.0
RUN wget https://packages.microsoft.com/config/ubuntu/22.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt update && apt install -y dotnet-sdk-7.0

# Nim
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://nim-lang.org/download/nim-${NIM_VER}-linux_x64.tar.xz -O nim.tar.xz; \
    else \
        wget  -nv https://nim-lang.org/download/nim-${NIM_VER}.tar.xz -O nim.tar.xz; \
    fi
RUN tar -xf nim.tar.xz
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        cd nim-${NIM_VER}; \
        sh ./install.sh /usr/local/bin; \
    else \
        cd nim-${NIM_VER}; \
        sh ./build.sh; \
        sh ./install.sh /usr/local/bin; \
    fi
RUN rm -rf nim*

# PowerShell
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VER}/powershell-${PWSH_VER}-linux-x64.tar.gz -O pwsh.tar.gz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VER}/powershell-${PWSH_VER}-linux-arm64.tar.gz -O pwsh.tar.gz; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN mkdir -p /opt/microsoft/powershell/7
RUN tar -xf pwsh.tar.gz -C /opt/microsoft/powershell/7
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/local/bin/pwsh
RUN rm -rf pwsh*

# Python
RUN apt update && apt install -y python-is-python3

# Ruby
RUN apt update && apt install -y ruby

# Rustup
RUN if [ "$DEVEL" = "true" ]; then \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile complete --default-toolchain stable -y; \
    else \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile minimal --default-toolchain stable -y; \
    fi

ENV PATH="$PATH:/root/.cargo/bin"

# Typescript
RUN apt update && apt install -y nodejs npm

# optional javascript runtimes
# Deno
# RUN if [ "$TARGETARCH" = "amd64" ]; then \
#         curl -fsSL https://deno.land/x/install/install.sh | sh; \
#     else \
#         cargo install deno --locked; \
#     fi
# Bun
RUN curl -fsSL https://bun.sh/install | bash

# V
RUN git clone --depth=1 https://github.com/vlang/v /opt/v
RUN cd /opt/v && make -j$(nproc)
ENV PATH="$PATH:/opt/v"

# Zig
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
RUN apt install -y \
        cmake \
        libllvm16 \
        llvm-16 \
        llvm-16-dev \
        clang-16 \
        libclang-16-dev \
        lld-16 \
        liblld-16-dev
RUN git clone https://github.com/ziglang/zig
RUN mkdir zig/build
RUN cd zig/build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j$(nproc) install
RUN rm -rf zig

# ZLS
RUN if [ "$DEVEL" = "true" ]; then \
        git clone --depth=1 https://github.com/zigtools/zls; \
        cd zls; \
        zig build -Doptimize=ReleaseSafe; \
        cp zig-out/bin/zls /usr/local/bin; \
    fi
RUN rm -rf zls

# Tools
RUN if [ "$DEVEL" = "true" ]; then \
        apt install --no-install-recommends -y \
        delve \
        gdb \
        gopls \
        go-staticcheck \
        lldb-16; \
    fi

# Zx
RUN npm install -g zx
RUN npm install -g average csv-stringify table

COPY . /app
WORKDIR /app

ENTRYPOINT ["zx", "./benchmark.mjs"]
