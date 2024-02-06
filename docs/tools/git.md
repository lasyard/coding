# git

## 2.30.1

```sh
git --version
```

### Config

```sh
git config --global init.defaultBranch main
git config --global push.recurseSubmodules check
git config --global url.git@github.com:.insteadOf https://github.com/
git config --global url.https://github.com/.insteadOf git@github.com:
```

### See last commit

```sh
git log -p -1
git show
git show --name-status
```

### Stash with untracked files

```sh
git stash --include-untracked
```

### Clean

```sh
git clean -dxf
```
