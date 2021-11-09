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

for package in \
    cpan \
    java \
    nc \
    python3 \
    tmux \
    vim \
    wget; do
    yum_install "${package}"
done

yum_install2 java-1.8.0-openjdk-devel jps
yum_install2 perl-devel prove
