# Set for TUNA mirror of Homebrew
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

if [ "$(git -C "/usr/local/Homebrew" remote get-url origin)" != "${HOMEBREW_BREW_GIT_REMOTE}" ]; then
    echo "Switching Homebrew to TUNA mirror..."
    git -C "/usr/local/Homebrew" remote set-url origin "${HOMEBREW_BREW_GIT_REMOTE}"
fi
