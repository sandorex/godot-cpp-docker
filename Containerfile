LABEL name="godot-cpp-docker" \
      summary="Container for building godot gdextensions"

FROM debian:bookworm

ENV CMAKE_VERSION=4.0.0
ENV ZIG_VERSION=0.14.0
ENV NINJA_VERSION=1.12.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    xz-utils \
    gzip \
    unzip \
    curl \
    ca-certificates \
    git \
    python3 \
    && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# install more up-to-date ninja from github
RUN curl -L https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip -o ninja.zip \
    && unzip ninja.zip -d /usr/bin/ \
    && rm ninja.zip

# install more up-to-date cmake from github
RUN curl -L https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz \
    | tar xfz - --strip-components=1 -C /usr/

# zig tarball is weirdly structured so i have to manually move the executable to /usr/bin/zig
RUN curl -L https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz \
    | tar xfJ - --strip-components=1 --exclude=README.md --exclude=LICENSE -C /usr/ \
    && mv /usr/zig /usr/bin/zig

# add wrappers for zig
RUN <<'EOF'
    cat <<'eof' > /bin/zig-c++
#!/bin/sh
zig c++ "$@"
eof
    chmod +x /bin/zig-c++

cat <<'eof' > /bin/zig-cc
#!/bin/sh
zig cc "$@"
eof
    chmod +x /bin/zig-cc

cat <<'eof' > /bin/zig-ar
#!/bin/sh
zig ar "$@"
eof
    chmod +x /bin/zig-ar

cat <<'eof' > /bin/zig-ranlib
#!/bin/sh
zig ranlib "$@"
eof
    chmod +x /bin/zig-ranlib
EOF
