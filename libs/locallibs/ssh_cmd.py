# -*- coding: utf-8 -*-
"""
 Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
 This program is licensed under Mulan PSL v2.
 You can use it according to the terms and conditions of the Mulan PSL v2.
          http://license.coscl.org.cn/MulanPSL2
 THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 See the Mulan PSL v2 for more details.
 
 @Author  : lemon-higgins
 @email   : lemon.higgins@aliyun.com
 @Date    : 2021-04-21 11:54:57
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 远端命令执行
"""

import os
import re
import sys
import base64
import argparse
import paramiko

SCRIPT_PATH = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPT_PATH)
import mugen_log

# 远端命令执行超时（秒）：dnf 等命令挂起时避免无限等待拖死整个用例会话
REMOTE_CMD_TIMEOUT = 600

# 提权判定/探测类命令自身较短，独立设超时，避免把用例会话拖死
RAW_CMD_TIMEOUT = 60

# 非 root 登录时给远端命令追加的 PATH 前缀（与改造前逐字节一致，不可改动）
PATH_PREFIX = (
    "export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:"
    "/usr/local/bin:/usr/local/sbin:/root/bin; "
)

# 提权临时脚本前缀。命令体经 base64 落到远端临时文件后由 sudo 执行，
# 避免引号转义、避免命令从 stdin 读走密码、避免命令正文进入 sudo 的 argv。
SUDO_TMP_PREFIX = "/tmp/.mgn_"

# shell 层文件缓存的生存时间（秒）。python 层无跨进程复用需求，
# 该常量由 libs/locallibs/common_lib_python.sh 的同名逻辑对齐使用。
PRIV_CACHE_TTL = 3600

# sudo 需要 tty 时，只有 `sudo -l` 会吐这段提示。
# 注意：不能用 "must have a tty"，实测永不命中（design.md §3.4 / D1）。
_TTY_RE = re.compile(r"terminal is required|askpass", re.IGNORECASE)

# 提权模式取值：root / none / nopasswd / password / unavailable
_PRIV_MODES = ("root", "none", "nopasswd", "password", "unavailable")


def _as_bool(value):
    """把配置里的字符串布尔值转成 bool

    Args:
        value: 配置值，可能是 bool/str/None

    Returns:
        [bool]: 归一化结果
    """
    if isinstance(value, bool):
        return value
    return str(value).strip().lower() in ("1", "true", "yes", "on")


def _raw_exec(conn, cmd, timeout=RAW_CMD_TIMEOUT):
    """执行远端命令，不加 PATH 前缀、不做提权包装

    仅用于提权判定与明确的只读探测。**不得**用于任何写操作。

    Args:
        conn ([class]): 和远端建立连接
        cmd ([str]): 需要执行的原始命令
        timeout ([int], optional): 命令超时. Defaults to RAW_CMD_TIMEOUT.

    Returns:
        [tuple]: (退出码, 标准输出, 标准错误)
    """
    stdin, stdout, stderr = conn.exec_command(cmd, timeout=timeout)
    exitcode = stdout.channel.recv_exit_status()
    out = stdout.read().decode("utf-8", errors="ignore")
    err = stderr.read().decode("utf-8", errors="ignore")
    return exitcode, out, err


def _raw_exec_rc(conn, cmd, timeout=RAW_CMD_TIMEOUT):
    """执行远端命令并返回合并输出

    Args:
        conn ([class]): 和远端建立连接
        cmd ([str]): 需要执行的原始命令
        timeout ([int], optional): 命令超时. Defaults to RAW_CMD_TIMEOUT.

    Returns:
        [tuple]: (退出码, 标准输出+标准错误)
    """
    exitcode, out, err = _raw_exec(conn, cmd, timeout)
    return exitcode, out + err


def _detect_tty_need(conn, sudo_tty=None):
    """判断 sudo 是否强制要求 tty

    `sudo -l` 实测耗时约 13.4s，因此配置了 NODE<n>_SUDO_TTY 就直接采信，
    只有配置缺失时才真正探测（design.md §3.4）。

    Args:
        conn ([class]): 和远端建立连接
        sudo_tty ([str|bool], optional): 显式配置. Defaults to None.

    Returns:
        [bool]: 是否需要 tty
    """
    if sudo_tty is not None and str(sudo_tty).strip() != "":
        return _as_bool(sudo_tty)
    try:
        exitcode, out = _raw_exec_rc(conn, "sudo -l")
    except Exception:
        return False
    if exitcode == 0:
        return False
    return bool(_TTY_RE.search(out))


def detect_privilege(conn, user, sudo_mode="auto", sudo_tty=None, password=None):
    """探测远端登录用户的提权能力

    判定顺序（命中即返回，尽量少发远端命令）：
        user == "root"      -> mode=root（零远端调用，T3 零回归）
        sudo_mode == "none" -> mode=none（等价于改造前行为）
        id -u == 0          -> mode=root
        sudo -n true rc==0  -> mode=nopasswd
        有密码              -> mode=password
        否则                -> mode=unavailable

    Args:
        conn ([class]): 和远端建立连接
        user ([str]): 远端登录用户
        sudo_mode ([str], optional): auto/none. Defaults to "auto".
        sudo_tty ([str|bool], optional): NODE<n>_SUDO_TTY 配置. Defaults to None.
        password ([str], optional): 提权密码，缺省取 conn 上缓存的登录密码

    Returns:
        [dict]: {"mode": ..., "tty": bool, "reason": str}
    """
    # T3：root 用户必须零远端调用、零输出变化
    if user == "root":
        return {"mode": "root", "tty": False, "reason": ""}

    if str(sudo_mode).strip().lower() == "none":
        return {"mode": "none", "tty": False, "reason": ""}

    if password is None:
        password = getattr(conn, "_password", None)

    try:
        exitcode, out = _raw_exec_rc(conn, "id -u")
        if exitcode == 0 and out.strip() == "0":
            return {"mode": "root", "tty": False, "reason": ""}

        exitcode, _ = _raw_exec_rc(conn, "sudo -n true")
        if exitcode == 0:
            return {"mode": "nopasswd", "tty": False, "reason": ""}

        tty = _detect_tty_need(conn, sudo_tty)

        if not password:
            return {
                "mode": "unavailable",
                "tty": tty,
                "reason": (
                    "remote user '%s' is not root and sudo requires a password, "
                    "but no password is configured for this node" % user
                ),
            }

        # 注意：这里只缓存判定结果(mode/tty)，绝不缓存凭证。
        # sudo ticket 不跨 ssh 会话复用，每条提权命令都必须重新送密码（design.md §4.5 / D4）。
        return {"mode": "password", "tty": tty, "reason": ""}
    except Exception as e:
        return {
            "mode": "unavailable",
            "tty": False,
            "reason": "privilege detection failed for '%s': %s" % (user, e),
        }


def wrap_cmd(cmd, sudo=None):
    """按提权模式包装远端命令

    Args:
        cmd ([str]): 原始远端命令
        sudo ([dict], optional): detect_privilege 的结果. Defaults to None.

    Returns:
        [str]: 包装后的命令；root/none 时与入参逐字节一致
    """
    if not sudo:
        return cmd

    mode = sudo.get("mode", "root")

    # 零回归短路：必须是函数第一条有效分支
    if mode in ("root", "none"):
        return cmd

    if mode not in ("nopasswd", "password"):
        # unavailable 由调用方拦截；其余未知取值保守放行原命令
        return cmd

    # base64 免除所有引号/换行/反引号/中文的转义问题
    payload = base64.b64encode(cmd.encode("utf-8")).decode("ascii")

    # python 层用空提示符即可：它无条件往 stdin 写密码，不需要匹配提示符。
    # shell/expect 层必须改用具名提示符，否则 expect 无字节可匹配而死锁（design.md §4.3 / D2）。
    if mode == "nopasswd":
        sudo_call = "sudo -n -H sh $T"
    else:
        sudo_call = "sudo -S -p '' -H sh $T"

    # 注意：这里不能用 % 格式化，模板里的 printf '%s' 会和占位符冲突，统一用字符串拼接
    return (
        "umask 077; "
        "T=$(mktemp " + SUDO_TMP_PREFIX + "XXXXXX 2>/dev/null) || T="
        + SUDO_TMP_PREFIX + "$$; "
        "printf '%s' '" + payload + "' | base64 -d > $T; "
        + sudo_call + "; r=$?; rm -f $T; exit $r"
    )


def _feed_sudo_password(stdin, password):
    """把 sudo 密码写入远端命令的 stdin

    仅 password 模式调用。写完必须 shutdown_write，
    否则 sudo 等不到 EOF 会一直阻塞到 15s 超时（design.md §9 / D3）。

    Args:
        stdin ([class]): exec_command 返回的标准输入
        password ([str]): 提权密码；为空表示不需要送密码
    """
    if not password:
        return
    try:
        stdin.write(password + "\n")
        stdin.flush()
    finally:
        try:
            stdin.channel.shutdown_write()
        except Exception:
            pass


def _node_env_name(ip, port=None):
    """按远端 ip/端口反查节点编号，用于读取 NODE<n>_* 配置

    Args:
        ip ([str]): 远端ip
        port ([int], optional): 远端ssh端口. Defaults to None.

    Returns:
        [str]: "NODE<n>_"，查不到时返回 ""
    """
    port = str(port) if port is not None else None
    for idx in range(1, 10):
        prefix = "NODE" + str(idx) + "_"
        if os.environ.get(prefix + "IPV4") != ip:
            continue
        env_port = os.environ.get(prefix + "SSH_PORT")
        if port is not None and env_port is not None and str(env_port) != port:
            continue
        return prefix
    return ""


def _resolve_sudo_conf(ip, port, sudo_mode=None, sudo_tty=None):
    """解析提权配置，未显式传入时按节点环境变量回退

    优先级：函数入参 > NODE<n>_SUDO_MODE / NODE<n>_SUDO_TTY > MUGEN_SUDO_MODE 全局默认

    Args:
        ip ([str]): 远端ip
        port ([int]): 远端ssh端口
        sudo_mode ([str], optional): 显式提权模式. Defaults to None.
        sudo_tty ([str|bool], optional): 显式 tty 需求. Defaults to None.

    Returns:
        [tuple]: (sudo_mode, sudo_tty)
    """
    node_prefix = _node_env_name(ip, port)

    if sudo_mode is None:
        sudo_mode = (
            os.environ.get(node_prefix + "SUDO_MODE")
            or os.environ.get("MUGEN_SUDO_MODE")
            or "auto"
        )
    if sudo_tty is None:
        sudo_tty = os.environ.get(node_prefix + "SUDO_TTY") or os.environ.get(
            "MUGEN_SUDO_TTY"
        )
        if sudo_tty is not None and str(sudo_tty).strip() == "":
            sudo_tty = None

    return sudo_mode, sudo_tty


def pssh_conn(
    ip,
    password,
    port=22,
    user="root",
    timeout=None,
    log_level="error",
    sudo_mode=None,
    sudo_tty=None,
):
    """和远端建立连接

    Args:
        ip ([str]): 远端ip
        password ([str]): 远端用户密码
        port (int, optional): 远端ssh的端口号. Defaults to 22.
        user (str, optional): 远端用户名. Defaults to "root".
        timeout ([int], optional): ssh的超时时长. Defaults to None.
        sudo_mode (str, optional): auto/none，非 root 用户是否尝试提权. Defaults to None.
        sudo_tty ([str|bool], optional): 显式指定 sudo 是否需要 tty. Defaults to None.

    Returns:
        [class]: 建立起来的连接
    """
    conn = paramiko.SSHClient()
    conn.set_missing_host_key_policy(paramiko.AutoAddPolicy)
    conn._ip = ip
    conn._password = password
    conn._port = port
    conn._user = user
    conn._timeout = timeout
    conn._log_level = log_level
    try:
        conn.connect(ip, port, user, password, timeout=timeout,
                     allow_agent=False, look_for_keys=False)
    except paramiko.ssh_exception.BadAuthenticationType:
        transport = paramiko.Transport((ip, port))
        transport.connect(username=user)
        def handler(title, instructions, prompts):
            return [password] * len(prompts)
        transport.auth_interactive(user, handler)
        conn._transport = transport
    except (
        paramiko.ssh_exception.NoValidConnectionsError,
        paramiko.ssh_exception.AuthenticationException,
        paramiko.ssh_exception.SSHException,
        TypeError,
        AttributeError,
    ) as e:
        mugen_log.logging(log_level, "Failed to connect the remote machine:%s." % ip)
        mugen_log.logging(log_level, e)
        return 519

    # 只在建连成功后探测提权能力；失败路径不设置 conn._sudo，保持原返回语义
    sudo_mode, sudo_tty = _resolve_sudo_conf(ip, port, sudo_mode, sudo_tty)
    conn._sudo_mode = sudo_mode
    conn._sudo_tty = sudo_tty
    conn._sudo = detect_privilege(conn, user, sudo_mode, sudo_tty, password)
    if conn._sudo["mode"] == "unavailable":
        mugen_log.logging(log_level, conn._sudo["reason"])

    return conn


def pssh_cmd(conn, cmd):
    """远端命令执行

    Args:
        conn ([class]): 和远端建立连接
        cmd ([str]): 需要执行的命令

    Returns:
        [list]: 错误码，命令执行结果
    """
    if conn == 519:
        return 519, ""

    sudo = getattr(conn, "_sudo", None) or {"mode": "root", "tty": False, "reason": ""}
    if sudo["mode"] == "unavailable":
        # 非 root 且无法提权：明确失败，绝不在无权限的前提下"假装执行"
        return 1, sudo.get("reason", "sudo unavailable")

    sudo_pwd = ""
    if sudo["mode"] == "password":
        # 每条提权命令都要送密码：sudo ticket 不跨 ssh 会话复用（design.md §4.5 / D4）
        sudo_pwd = getattr(conn, "_password", None) or ""

    full_cmd = PATH_PREFIX + wrap_cmd(cmd, sudo)
    try:
        stdin, stdout, stderr = conn.exec_command(full_cmd, timeout=REMOTE_CMD_TIMEOUT)
        _feed_sudo_password(stdin, sudo_pwd)
        exitcode = stdout.channel.recv_exit_status()
        out = stdout.read().decode("utf-8", errors="ignore")
        err = stderr.read().decode("utf-8", errors="ignore")
        if exitcode == 0:
            output = out.strip("\n")
        else:
            output = (err + out).strip("\n")
        return exitcode, output
    except paramiko.ssh_exception.SSHException:
        # 超时（exec_command 超时会抛 SSHException）：清理远端 dnf 锁/残留进程后快速失败，
        # 不再进入 360x10s 重连循环，避免挂起的 dnf 拖死整个用例会话。
        mugen_log.logging("error", "remote cmd timeout(>%ss): %s" % (REMOTE_CMD_TIMEOUT, cmd))
        try:
            clean_cmd = PATH_PREFIX + wrap_cmd(
                "pkill -9 dnf 2>/dev/null; rm -f /var/cache/dnf/*.pid 2>/dev/null; "
                "pkill -9 -f mugen_re.log 2>/dev/null; echo done",
                sudo,
            )
            stdin, stdout, stderr = conn.exec_command(clean_cmd, timeout=30)
            _feed_sudo_password(stdin, sudo_pwd)
            stdout.channel.recv_exit_status()
        except Exception:
            pass
        return 143, "remote command timeout"
    except Exception:
        pass

    import time
    time.sleep(10)
    for _ in range(360):
        try:
            # 重连时沿用原连接的提权配置；pssh_conn 会重新探测，_sudo 随之刷新
            new_conn = pssh_conn(
                conn._ip,
                conn._password,
                conn._port,
                conn._user,
                conn._timeout,
                getattr(conn, "_log_level", "error"),
                getattr(conn, "_sudo_mode", None),
                getattr(conn, "_sudo_tty", None),
            )
            if new_conn == 519:
                time.sleep(10)
                continue
            stdin, stdout, stderr = new_conn.exec_command("cat /tmp/mugen_re.log 2>/dev/null; echo '__MUGEN_RET__=$?'", timeout=30)
            exitcode = stdout.channel.recv_exit_status()
            out = stdout.read().decode("utf-8", errors="ignore")
            pssh_close(new_conn)
            if "__MUGEN_RET__" in out:
                break
        except Exception:
            pass
        time.sleep(10)

    try:
        result_out = out
    except NameError:
        return 1, "SSH connection lost and unable to recover result"

    ret_line = [l for l in result_out.split("\n") if "__MUGEN_RET__" in l]
    if ret_line:
        try:
            exitcode = int(ret_line[-1].split("=")[-1].strip())
        except (ValueError, IndexError):
            exitcode = 1
    else:
        exitcode = 1

    output = result_out.replace(ret_line[-1], "").strip("\n") if ret_line else result_out.strip("\n")
    return exitcode, output


def pssh_close(conn):
    """关闭和远端的连接

    Args:
        conn ([class]): 和远端的连接
    """
    if conn != 519:
        conn.close()


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="manual to this script")
    parser.add_argument("--cmd", type=str, default=None)
    # 默认节点号必须保持 2：大量用例以 P_SSH_CMD --cmd "..." 省略 --node 调用，
    # 依赖该默认值读取 NODE2_* 环境变量（零回归约束）
    parser.add_argument("--node", type=int, default=2)
    parser.add_argument("--ip", type=str, default=None)
    parser.add_argument("--password", type=str, default=None)
    parser.add_argument("--port", type=int, default=22)
    parser.add_argument("--user", type=str, default="root")
    parser.add_argument("--timeout", type=int, default=None)
    parser.add_argument(
        "--raw",
        action="store_true",
        help="skip PATH prefix and privilege wrapping (read-only probes only)",
    )
    parser.add_argument(
        "--sudo-mode",
        type=str,
        default=None,
        help="auto/none; whether a non-root login user should escalate via sudo",
    )
    parser.add_argument(
        "--sudo-tty",
        type=str,
        default=None,
        help="true/false; skip the slow sudo -l probe when explicitly configured",
    )
    parser.add_argument(
        "--print-home",
        action="store_true",
        help="print the login user's HOME directory (equals --raw --cmd 'echo $HOME')",
    )
    args = parser.parse_args()

    if args.print_home:
        args.raw = True
        args.cmd = "echo $HOME"
    elif args.cmd is None:
        parser.error("the following arguments are required: --cmd (or use --print-home)")

    # --raw 是纯只读探测通道，不需要提权能力，因此默认跳过探测，
    # 避免为拿一个 $HOME 白付 sudo -l 的 13.4s
    if args.raw and args.sudo_mode is None:
        args.sudo_mode = "none"

    if args.node is not None:
        node_ip = os.environ.get("NODE" + str(args.node) + "_IPV4")
        node_password = os.environ.get("NODE" + str(args.node) + "_PASSWORD")
        node_port = os.environ.get("NODE" + str(args.node) + "_SSH_PORT")
        node_user = os.environ.get("NODE" + str(args.node) + "_USER")

        args.ip = node_ip
        args.password = node_password
        if node_port is not None:
            args.port = int(node_port)
        args.user = node_user

        if args.ip is None or args.password is None or args.user is None:
            mugen_log.logging(
                "error",
                "You need to check the environment configuration file to see if this node information exists.",
            )
            sys.exit(1)

    conn = pssh_conn(
        args.ip,
        args.password,
        args.port,
        args.user,
        args.timeout,
        sudo_mode=args.sudo_mode,
        sudo_tty=args.sudo_tty,
    )
    if args.raw:
        if conn == 519:
            sys.exit(519)
        # --raw 跳过 PATH 前缀与提权包装，用于 $HOME 探测等只读场景
        exitcode, output = _raw_exec_rc(conn, args.cmd)
        output = output.strip("\n")
    else:
        exitcode, output = pssh_cmd(conn, args.cmd)
    pssh_close(conn)

    print(output)

    sys.exit(exitcode)
