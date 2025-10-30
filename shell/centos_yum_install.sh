#!/usr/bin/env sh

trap 'exit' INT

yum_install2() (
    package="$1"
    cmd="$2"
    if command -v "${cmd}" >/dev/null; then
        echo "\"${package}\" is already installed."
        return
    fi
    echo "Install ${package}..."
    yum install -y "${package}"
)

yum_install() {
    yum_install2 "$1" "$1"
}
