#!/usr/bin/env sh

if ! command -v mmdc >/dev/null; then
    echo "Cannot find mmdc. Install it with:"
    echo
    echo "npm install -g @mermaid-js/mermaid-cli"
    exit 1
fi

mmdc -i "$1" -o "$1.png" -t neutral -e png -b white
