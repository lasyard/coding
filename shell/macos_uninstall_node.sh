#!/usr/bin/env sh

# According to outputs of
# `pkgutil --files org.nodejs.npm.pkg`
# `pkgutil --files org.nodejs.node.pkg`

# Unistall npm and remove modules
sudo npm uninstall -g npm
sudo rm -rf /usr/local/lib/node_modules

# Remove node files
sudo rm usr/local/bin/corepack
sudo rm usr/local/bin/node
sudo rm -rf /usr/local/include/node
sudo rm -rf /usr/local/share/doc/node
sudo rm usr/local/share/man/man1/node.1

# Remove packages
sudo pkgutil --forget org.nodejs.npm.pkg
sudo pkgutil --forget org.nodejs.node.pkg
