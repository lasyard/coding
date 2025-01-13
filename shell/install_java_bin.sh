#!/usr/bin/env sh

trap 'exit' INT

if [ $# -lt 3 ]; then
    echo "Usage: $0 <app-name> <compressed-package> <install-dir>"
    exit 1
fi

app="$1"
package="$2"
dir="${3%%/}"

if [ ! -f "${package}" ]; then
    echo "File ${package} does not exists." >&2
    exit 1
fi

if [ ! -d "${dir}" ]; then
    echo "${dir} is not a directory." >&2
    exit 1
fi

fileType() (
    f="$1"
    t="unknown"
    e="${f##*\.}"
    if [ "${e}" = 'zip' ]; then
        t='zip'
    elif [ "${e}" = 'gz' ]; then
        t='gz'
    elif [ "${e}" = 'bz2' ]; then
        t='bz2'
    elif [ "${e}" = 'tgz' ]; then
        t='tar.gz'
    fi
    f1=${f%\.*}
    e1=${f1##*\.}
    if [ "${e1}" = 'tar' ]; then
        t="tar.${t}"
    fi
    echo "${t}"
)

extract() {
    # $1: the compressed file
    # $2: the target dir
    # $sudo: 'sudo' to be used, empty if not necessary
    # target: output, the target dir
    t="$(fileType "$1")"
    case "$t" in
    'zip')
        target=$(unzip -l "$1" | head -n 4 | tr -s '[:blank:]' "\n" | tail -n 1 | cut -d '/' -f 1)
        ${sudo} unzip -d "$2" "$1"
        ;;
    'tar.gz')
        target=$(tar -tvf "$1" | head -n 1 | tr -s "[:blank:]" "\n" | tail -n 1 | cut -d '/' -f 1)
        ${sudo} tar -poC "$2" -xzf "$1"
        ;;
    'tar.bz2')
        target=$(tar -tvf "$1" | head -n 1 | tr -s "[:blank:]" "\n" | tail -n 1 | cut -d '/' -f 1)
        ${sudo} tar -poC "$2" -xjf "$1"
        ;;
    *)
        echo "Unsupported file type." >&2
        exit 1
        ;;
    esac
}

add_path() {
    # $1: the path
    # $app: the app name
    if [ -d "$1" ]; then
        if [ -d "/etc/profile.d" ]; then
            echo "PATH=\"$1:\${PATH}\"" | sudo tee -a "/etc/profile.d/${app}.sh"
            echo "\"$1\" added to \"/etc/profile.d/${app}.sh\"."
        elif [ -d "/etc/paths.d" ]; then
            echo "$1" | sudo tee -a "/etc/paths.d/${app}"
            echo "\"$1\" added to \"/etc/paths.d/${app}\"."
        else
            echo "Cannot find \"/etc/profile.d\" or \"/etc/paths.d\" to put path \"$1\""
            return 1
        fi
        return 0
    fi
    echo "\"$1\" is not a directory."
}

if [ -x "${dir}" ] && [ -w "${dir}" ]; then
    sudo=""
else
    sudo="sudo"
fi
extract "${package}" "${dir}" "${app}"

app_dir="${dir}/${app}"
${sudo} ln -snvf "${dir}/${target}" "${app_dir}"

add_path "${app_dir}/bin"
add_path "${app_dir}/sbin"
