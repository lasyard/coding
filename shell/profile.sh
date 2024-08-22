# For zsh, cp to ~/.zlogin
# For bash, cp to ~/.bash_profile (CentOS) or ~/.profile (Ubuntu)

# If the current shell is not interactive, the scripts after this are useless.
# Especially, any output would break utilities like `scp`.
case $- in
*i*) ;;
*)
    return
    ;;
esac

# Set PATH
if [ -d "${HOME}/bin" ]; then
    PATH="${HOME}/bin:${PATH}"
fi
if [ -d "/usr/local/sbin" ]; then
    PATH="${PATH}:/usr/local/sbin"
fi
# For brew installed llvm on macOS
if [ -d "/usr/local/opt/llvm/bin" ]; then
    PATH="/usr/local/opt/llvm/bin:${PATH}"
fi

export PATH

if [ "${SHELL}" = "/bin/bash" ] && [ -f "${HOME}/.bashrc" ]; then
    . ${HOME}/.bashrc
fi

# Disable dotnet telemetry
if command -v "dotnet" >/dev/null; then
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
fi

# Alias
alias df='df -h'
alias du='du -h'
alias l='ls -lah'
if command -v "kubectl" >/dev/null; then
    alias k='kubectl'
    # using kube config in ${HOME}/.kube
    unset KUBECONFIG
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
else
    if command -v 'vim' >/dev/null; then
        alias vi=vim
        # for `systemctl edit`
        if command -v 'systemctl' >/dev/null; then
            export SYSTEMD_EDITOR="$(command -v 'vim')"
        fi
    fi
fi

# Set JAVA_HOME
if [ -x "/usr/libexec/java_home" ]; then # for MacOS
    if /usr/libexec/java_home 2>/dev/null; then
        JAVA_HOME="$(/usr/libexec/java_home -v "1.8.0")"
    else
        echo "Java is not installed, so JAVA_HOME is not set."
    fi
elif [ -e "/usr/lib/jvm/java" ]; then # JDK is installed on Linux
    JAVA_HOME="/usr/lib/jvm/java"
else
    java_path=$(command -v java)
    if [ -n "${java_path}" ]; then
        JAVA_HOME="${java_path%/bin/java}"
    fi
fi
export JAVA_HOME

# MySql
if [ -d "/usr/local/mysql/bin" ]; then
    PATH="${PATH}:/usr/local/mysql/bin"
fi

# Set GPG_TTY
GPG_TTY=$(tty)
export GPG_TTY

# Set ssh agent
TOKEN="${HOME}/.ssh/id_rsa"
if [ -f "${TOKEN}" ]; then
    trap 'test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`' 0
    # Do not start agent if the current shell is remotely logged in.
    if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
        eval "$(ssh-agent)"
        ssh-add "${TOKEN}"
    fi
fi

# Set Homebrew mirror
if command -v brew >/dev/null && [ -x "${HOME}/bin/brew_tuna.sh" ]; then
    . "${HOME}/bin/brew_tuna.sh"
fi

# Set proxy
proxy() {
    if [ -x "${HOME}/bin/proxy.sh" ]; then
        . "${HOME}/bin/proxy.sh" "$1"
    else
        echo "No proxy found."
    fi
}

# for scl-utils on CentOS
if command -v scl >/dev/null; then
    for c in $(scl list-collections); do
        . scl_source enable $c
    done
fi
