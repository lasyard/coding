#!/usr/bin/env sh

if ! command -v brew >/dev/null; then
    echo '"Homebrew" is not installed! Run the following command to install it.'
    echo "bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

brew_install() (
    formula="$1"
    if command -v "${formula}" >/dev/null; then
        if [ "$(command -v "${formula}")" = "$(brew --prefix)/bin/${formula}" ]; then
            echo "\"${formula}\" is already installed by \"Homebrew\"."
            return
        fi
        echo "\"${formula}\" is already installed."
        # shellcheck disable=SC2039
        read -rp "Do you want to install another copy by \"Homebrew\"? (y/N)" ans
        if [ "${ans}" != 'y' ] && [ "${ans}" != 'Y' ]; then
            return
        fi
    fi
    echo "Install ${formula}..."
    brew install "${formula}"
)

for formula in \
    cmake \
    composer \
    ffmpeg \
    jq; do
    brew_install "${formula}"
done
