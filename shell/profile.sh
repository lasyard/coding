# Set PATH
if [ -d "${HOME}/bin" ]; then
    export PATH="${HOME}/bin:${PATH}"
fi

# If the current shell is not interactive, the scripts after this are useless.
# Especially, any output would break utilities like `scp`.
case $- in
*i*) ;;
*)
    return
    ;;
esac

# Alias
alias df='df -h'
alias du='du -h'
if ! command -v 'l' >/dev/null; then
    alias l='ls -lah'
fi

# macOS
if [ "$(uname)" = "Darwin" ]; then
    if command -v 'mvim' >/dev/null; then
        # Set mvim
        alias vi='mvim --remote-tab-silent'
        alias vidiff='mvim -d'
        # Use original vim for fc
        export FCEDIT=vim
    fi
fi

# Set JAVA_HOME
if [ -x "/usr/libexec/java_home" ]; then # for MacOS
    JAVA_HOME="$(/usr/libexec/java_home -v "1.8.0")"
    export JAVA_HOME
else
    java_path=$(command -v java)
    if [ -n "${java_path}" ]; then
        JAVA_HOME="${java_path%/bin/java}"
        export JAVA_HOME
    fi
fi

# Set GPG_TTY
GPG_TTY=$(tty)
export GPG_TTY

# Set ssh agent
TOKEN="${HOME}/.ssh/id_rsa"
if [ -f "${TOKEN}" ]; then
    # Do not start agent if the current shell is remotely logged in.
    if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
        eval "$(ssh-agent)"
        ssh-add "${TOKEN}"
    fi
fi

# Set proxy
proxy() {
    # $1: on/off
    if [ "$1" = 'off' ]; then
        export http_proxy=
        export https_proxy=
        return
    fi
    proxy="http://localhost:1087"
    if nc -z localhost 1087; then
        export http_proxy="${proxy}"
        export https_proxy="${proxy}"
        echo "Set http_proxy & https_proxy to \"${proxy}\"."
    else
        echo "No proxy found."
    fi
}
