FROM ubuntu:lunar

ARG TARGETARCH

# Versions for manually installed packages
ENV GRADLE_VER=8.2.1
ENV JULIA_MAJ_VER=1.9
ENV JULIA_VER=1.9.2
ENV NIM_VER=2.0.0
ENV PWSH_VER=7.3.6
ENV ZIG_VER=0.11.0-dev.4403+e84cda0eb

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
        curl \
        git \
        gpg \
        hyperfine \
        pkg-config \
        unzip \
        wget

# Ada
RUN apt update && apt install --no-install-recommends -y gnat

# C
RUN apt update && apt install --no-install-recommends -y clang

# C++
RUN apt update && apt install --no-install-recommends -y meson

# Cython
RUN apt update && apt install --no-install-recommends -y cython3

# D
RUN apt update && apt install --no-install-recommends -y gdc
    
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
RUN apt update && apt install --no-install-recommends -y golang

# Gradle
RUN wget -nv https://services.gradle.org/distributions/gradle-${GRADLE_VER}-bin.zip -O gradle-bin.zip
RUN unzip -q gradle-bin.zip && cp -r gradle-${GRADLE_VER}/bin gradle-${GRADLE_VER}/lib /usr/local/ && rm -rf gradle*

# Haskell
RUN apt update && apt install --no-install-recommends -y libghc-random-dev

# Java
RUN apt update && apt install --no-install-recommends -y openjdk-19-jdk-headless

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
RUN apt update && apt install --no-install-recommends -y lua5.4

# LuaJIT
RUN apt update && apt install --no-install-recommends -y luajit

# .NET SDK 7.0
RUN apt update && apt install --no-install-recommends -y dotnet-sdk-7.0

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
RUN ln -s . /usr/local/lib/nim/lib # I think this is a nim bug somewhere
RUN rm -rf nim*

# PHP
RUN apt update && apt install --no-install-recommends -y php

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
RUN apt update && apt install --no-install-recommends -y python-is-python3

# Ruby
RUN apt update && apt install --no-install-recommends -y ruby

# Rustup
RUN if [ "$DEVEL" = "true" ]; then \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile complete --default-toolchain stable -y; \
    else \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile minimal --default-toolchain stable -y; \
    fi

ENV PATH="$PATH:/root/.cargo/bin"

# Typescript
RUN apt update && apt install --no-install-recommends -y nodejs npm

# optional javascript runtimes
# Deno
# RUN if [ "$TARGETARCH" = "amd64" ]; then \
#         curl -fsSL https://deno.land/x/install/install.sh | sh; \
#     else \
#         cargo install deno --locked; \
#     fi
# Bun
RUN npm install -g bun

# V
RUN git clone --depth=1 https://github.com/vlang/v /opt/v
RUN cd /opt/v && make -j$(nproc)
ENV PATH="$PATH:/opt/v"

# Zig
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget -nv -O zig.tar.xz https://ziglang.org/builds/zig-linux-x86_64-${ZIG_VER}.tar.xz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget -nv -O zig.tar.xz https://ziglang.org/builds/zig-linux-aarch64-${ZIG_VER}.tar.xz; \
    else \
        echo "Unsupported arch: $TARGETARCH"; \
        exit 1; \
    fi
RUN tar xf zig.tar.xz
RUN mv zig-linux-*-${ZIG_VER} zig
RUN cp zig/zig /usr/local/bin/
RUN cp -r zig/lib /usr/local/lib/zig
RUN rm -rf zig*

RUN apt clean

COPY . /app
WORKDIR /app

ENTRYPOINT ["python", "benchmark.py", "--basic"]
