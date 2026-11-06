# 非 root 用户支持说明

## 1. 背景

mugen 框架早期默认以 `root` 登录被测节点。实际部署中常遇到两种情况：

- 安全加固环境禁用了 root 远程登录（`PermitRootLogin no`）；
- 客户只提供一个普通账号，需要 `sudo` 提权才能安装包、改配置、重启服务。

本框架现在支持普通用户登录，并自动完成 `sudo` 提权，用例代码基本无需改动。

## 2. 前置条件

被测节点（每台）必须满足：

1. 已安装 `sudo`；
2. 登录用户具备以下任意一种权限：
   - 免密 sudo（`NOPASSWD`）；
   - 带密码 sudo（密码从配置读取）。
3. 登录用户的密码写在 `NODE<n>_PASSWORD` 中。**如果 sudo 密码与登录密码不同，本框架暂不支持**，请把两者改为一致，或改为 `NOPASSWD`。

检查命令（在目标机上以登录用户执行）：

```bash
sudo -n true; echo "nopasswd rc=$?"
sudo -l >/dev/null 2>&1; echo "sudo rc=$?"
```

- `nopasswd rc=0` → 免密，`SUDO_MODE=nopasswd`
- `nopasswd rc!=0` 且 `sudo rc=0` → 需要密码，`SUDO_MODE=password`
- 两者都失败 → 该用户无 sudo 权限，框架会输出 `unavailable` 并拒绝执行需要提权的用例

## 3. 配置方法

### 3.1 生成配置

```bash
bash mugen.sh -c --ip 192.168.1.10 --password 'YourPasswd' --user test --port 22
```

生成的 `conf/env.json` 中该节点的 `USER` 为 `test`。

### 3.2 可选字段

`SUDO_MODE` 与 `SUDO_TTY` 都是可选项，旧配置文件不加也能正常工作。

| 字段 | 取值 | 说明 |
| --- | --- | --- |
| `SUDO_MODE` | `auto`（默认）、`none`、`nopasswd`、`password` | 是否提权以及如何判定 |
| `SUDO_TTY` | `true` / `false` | 强制 `ssh -tt`；仅当 sudo 明确报 `terminal is required` 时才需要 |

示例：

```json
{
    "ID": 1,
    "LOCALTION": "remote",
    "MACHINE": "physical",
    "USER": "test",
    "PASSWORD": "YourPasswd",
    "SSH_PORT": 22,
    "IPV4": "192.168.1.10",
    "SUDO_MODE": "password",
    "SUDO_TTY": "false"
}
```

### 3.3 取值语义

- `auto`：首次连接时探测一次，结果缓存 1 小时，避免每条命令都付出探测开销。
- `none`：明确不提权，等价于历史行为。适合只跑不需要特权的用例。
- `nopasswd`：直接用 `sudo -n`，不喂密码。
- `password`：用 `sudo -S` 并从配置喂密码。

探测耗时说明：`sudo -l` 在部分系统上要 13 秒以上，因此**已知账号形态时建议直接写 `SUDO_MODE`**，可显著加快整体执行。

## 4. 部署路径变化

| 登录用户 | 远端部署根目录 |
| --- | --- |
| `root` | `/mugen_re`（与历史版本完全一致） |
| 非 `root` | `$HOME/mugen_re`（登录用户家目录下） |

原因：普通用户无法在 `/` 下创建目录。

日志文件始终在 `/tmp/mugen_re.log`，该路径**不随用户变化**，框架的超时恢复逻辑依赖它。

## 5. 密码安全性

- 密码通过 `stdin` 传给远端进程，不作为命令行参数出现，`ps -ef` 无法看到；
- 提权命令以 `base64` 形式写入远端临时文件 `/tmp/.mgn_XXXXXX`，文件权限为 `umask 077`，执行完立即删除；
- 异常中断后如残留 `/tmp/.mgn_*` 文件，可安全清理：`rm -f /tmp/.mgn_*`。

## 6. 常见问题

### 6.1 报 `unavailable`

登录用户没有可用 sudo。处理方式：

- 为该用户配置 sudo 权限；或
- 把 `SUDO_MODE` 设为 `none` 并只执行不需要特权的用例。

### 6.2 报 `terminal is required`

sudo 配置了 `requiretty`。处理方式：

- 在节点配置中加 `"SUDO_TTY": "true"`；或
- 在目标机 `/etc/sudoers` 中移除 `requiretty`（推荐，`Defaults !requiretty`）。

### 6.3 用例里硬编码了 `root@`

部分历史用例写成 `ssh root@$NODE2_IPV4`，在非 root 场景会失败。运行下列命令可列出全部位置：

```bash
python3 check_casename.py
```

输出形如：

```text
WARNING: 23 place(s) hardcode 'root@', which breaks non-root deployments.
```

建议改为：

```bash
ssh "${NODE2_USER}@${NODE2_IPV4}"
```

该检查**只告警，不阻断**，退出码不受影响。

### 6.4 `-s` 模式（节点 1 分发执行）能否工作

可以。框架会自动把 `/mugen_re` 换成非 root 用户的 `$HOME/mugen_re`，包括分发目录、清理路径与远端环境文件加载。

### 6.5 多节点时每个节点的用户能否不同

可以。`USER`、`PASSWORD`、`SUDO_MODE` 都是按节点配置的，支持 node1 为 `root`、node2 为普通用户的混搭场景。
