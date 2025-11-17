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

# For brew installed keg-only Formulae on macOS
if [ -d "/usr/local/opt/llvm/bin" ]; then
    PATH="/usr/local/opt/llvm/bin:${PATH}"
    CC=clang
    CXX=clang++
    export CC CXX
fi
if [ -d "/usr/local/opt/curl/bin" ]; then
    PATH="/usr/local/opt/curl/bin:${PATH}"
fi

export PATH

if [ "${SHELL}" = "/bin/bash" ]; then
    PS1="\[\033[0;45;32m\]\u@\h\[\033[0m\]:\[\033[32m\]\w$\[\033[0m\] "
    # conda will change PS1
    if [ -f "${HOME}/.bashrc" ]; then
        . ${HOME}/.bashrc
    fi
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
    alias kget='kubectl get -owide'
    alias kdesc='kubectl describe'
    alias kdel='kubectl delete'
    # using kube config in ${HOME}/.kube
    unset KUBECONFIG
fi

# Alias to bypass bastion host filter
alias uadd='sudo useradd'
alias udel='sudo userdel'
alias umod='sudo usermod'

# macOS
if [ "$(uname)" = "Darwin" ]; then
    if command -v 'mvim' >/dev/null; then
        # Set mvim
        alias vi='mvim --remote-tab-silent'
        alias vidiff='mvim -d'
        # Use original vim for fc
        export FCEDIT=vim
    fi
    # macOS version <= 12 is no longer supported by Homebrew, do not update
    if [ "$(sw_vers -productVersion | cut -d . -f 1)" -lt 13 ]; then
        export HOMEBREW_NO_AUTO_UPDATE=1
        export HOMEBREW_NO_INSTALL_FROM_API=1
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
        export JAVA_HOME="$(/usr/libexec/java_home -v "1.8.0")"
    else
        echo "Java is not installed, so JAVA_HOME is not set."
    fi
elif command -v 'java' >/dev/null; then # for Linux
    export $(/usr/bin/env java -XshowSettings:properties -version 2>&1 | grep 'java.home' | sed -e 's/java.home/JAVA_HOME/;s/ //g;')
fi

# MySql
if [ -d "/usr/local/mysql/bin" ]; then
    PATH="${PATH}:/usr/local/mysql/bin"
fi

# Set GPG_TTY
GPG_TTY=$(tty)
export GPG_TTY

# Set ssh agent, token is added in ssh config
trap 'test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`' 0
# Do not start agent if the current shell is remotely logged in.
if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
    eval "$(ssh-agent)"
fi

# Set proxy
proxy() {
    if [ -x "${HOME}/bin/proxy.sh" ]; then
        . "${HOME}/bin/proxy.sh" "$1"
    else
        echo "No proxy found."
    fi
}

# Set kubeconfig
kubeconfig() {
    if [ -f "${HOME}/.kube/${1}_config" ]; then
        export KUBECONFIG="${HOME}/.kube/${1}_config"
    else
        echo "No kubeconfig for cluster \"${1}\" found."
    fi
}

# for scl-utils on CentOS
if command -v scl >/dev/null; then
    for c in $(scl list-collections); do
        . scl_source enable $c
    done
fi

# for Spack
export SPACK_USER_CACHE_PATH="${HOME}/opt/spack-data"
if [ -f "${HOME}/opt/spack/share/spack/setup-env.sh" ]; then
    . "${HOME}/opt/spack/share/spack/setup-env.sh"
fi
