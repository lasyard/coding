# git

## 2.30.1

```sh
git --version
```

### Config

```sh
git config --global init.defaultBranch main
git config --global push.recurseSubmodules check
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
