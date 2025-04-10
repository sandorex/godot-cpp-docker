#!/bin/sh

set -euo pipefail

arg="${1:-}"
case "$arg" in
    linux64|linux_arm64|win64|android_x64|android_arm64)
        toolchain_file="cmake/zig_${arg}.cmake"
        echo "Using toolchain '${toolchain_file}'"
        ;;
    *)
        cat <<EOF
Builds specified platform in current directory

Usage: $0 <PLATFORM>

PLATFORMS:
    linux64
    linux_arm64
    win64
    android_x64
    android_arm64

EOF
        # allow help call
        case "$arg" in
            ''|-h|--help)
                ;;
            *)
                echo "Invalid argument '${arg}'"
                exit 1
                ;;
        esac

        exit 0
        ;;
esac
