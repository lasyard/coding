# macOS

## Big Sur

### Install "Oh My Zsh"

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Set key repeating for VSCode

```sh
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```

### System configuration utililty

```bash
scutil --get HostName
scutil --get LocalHostName
scutil --get ComputerName
scutil --set HostName my-macbook
scutil --set LocalHostName my-macbook
scutil --set ComputerName my-macbook
```

### Property list utility

```sh
plutil -p *.plist
```

### Package utility

```bash
pkgutil --pkgs
pkgutil --pkg-info com.apple.pkg.CLTools_Executables
```

### xcode-select

```bash
xcode-select -p
xcode-select --install
```
