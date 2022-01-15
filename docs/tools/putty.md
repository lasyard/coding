# PuTTY

## 0.7

### 使用 Key 登录

首先要使用 `PuTTYgen` 工具生成私钥和公钥，然后将私钥保存成文件，将产生的公钥（即界面上 "Public key for pasting into OpenSSH authorized_keys file" 下面的文本框中的全部内容）复制到被登录主机家目录下的 `.ssh/authorized_keys` 文件中作为单独一行。

如果是 CentOS 系统，不能使用上述密钥，请使用 OpenSSH 生成的密钥。在 Linux 上运行

```sh
cd
mkdir .ssh
chmod go-w .ssh
cd .ssh
ssh-keygen
cat id_rsa.pub >> authorized_keys
chmod go-w authorized_keys
```

然后将 `~/.ssh/id_rsa` 文件复制到 Windows 系统，在 PuTTYgen 中导入。

让 PuTTY 使用密钥的方法有两种。

一是在如下选项中输入私钥文件的路径

```text
Connection->SSH->Auth->Private key file for authentication
```

这种方法的缺点是：如果私钥文件是有 Passphrase 保护（可在保存私钥文件前设置）的，则每次登录时还是要输入 Passphrase 进行验证。当然，如果没有 Passphrase 保护，别人得到你的私钥文件就可以随意使用。

二是使用 Pageant, 它可以保存密钥信息供 PuTTY 使用。这时 PuTTY 中必须选中如下选项

```text
Connection->SSH->Auth->Attempt authentication using Pageant
```

这时 Passphrase 只需要在 Pageant 中 Add Key 时输入一次就可以了。

如果密码都懒得输，当然最好连用户名也省了，这可以通过在 PuTTY 中设置如下选项实现

```text
Connection->Data->Auto-login username
```
