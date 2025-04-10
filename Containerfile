LABEL name="godot-cpp-docker" \
      summary="Container for building godot gdextensions"

FROM debian:bookworm

ENV CMAKE_VERSION=4.0.0
ENV ZIG_VERSION=0.14.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    xz-utils \
    gzip \
    curl \
    ca-certificates \
    git \
    python3-pip \
    && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# install scons from pip as the distro package is ancient
RUN pip install --no-cache-dir --break-system-packages --upgrade pip \
    && pip install --no-cache-dir --break-system-packages scons

# install more up-to-date cmake than debian provides
RUN curl -L https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz \
    | tar xfz - --strip-components=1 -C /usr/

# zig tarball is weirdly structured so i have to manually move the executable to /usr/bin/zig
RUN curl -L https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz \
    | tar xfJ - --strip-components=1 --exclude=README.md --exclude=LICENSE -C /usr/ \
    && mv /usr/zig /usr/bin/zig
