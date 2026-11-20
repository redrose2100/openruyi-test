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
 @Date    : 2021-04-22 11:37:36
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 软件包的安装卸载
"""

import os
import re
import sys
import subprocess
import tempfile
import argparse
import signal

SCRIPT_PATH = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPT_PATH)
import mugen_log
import ssh_cmd

# 本地 dnf 命令超时（秒）：dnf 挂起时避免无限等待拖死整个用例会话
DNF_TIMEOUT = 600

# 从 `dnf --assumeno install` 的交易表里抽取「Upgrading:」段中的包名。
#
# 不能用 `grep update`：那是按“仓库名”列做匹配。openRuyi 的仓库叫 Base，
# openEuler 的仓库叫 OS/everything/EPOL，只有极少数场景才叫 update，
# 因此 `grep update` 几乎总是把整个 Upgrading 段筛空，upList 恒为空，
# 随后走 len(upList)==0 分支（该分支没有 `grep -vE <up_alt>` 过滤），
# 于是同一交易中“被升级”的包会被当作“待删依赖”写进 tmpfile，
# 最终由 DNF_REMOVE 执行 `dnf -y remove <pkgs> <depList>` 把系统包卸掉。
# 段名按当前小节标题跟踪，与仓库名无关。
AWK_UPGRADING = (
    r"""awk -v arch="$(uname -m)" '"""
    r"""/^[[:space:]]*(Package|Installing|Upgrading|Downgrading|Removing|Reinstalling"""
    r"""|Replacing|Installing dependencies|Installing weak dependencies)[[:space:]:]*$/"""
    r""" {sec=$0; sub(/[[:space:]:]+$/,"",sec); next} """
    r"""/^[[:space:]]*Transaction (Summary|Test)/ {sec=""; next} """
    r"""sec=="Upgrading" && $0 ~ ("(^|[[:space:]])(" arch "|noarch)([[:space:]]|$)") """
    r"""&& $0 !~ /^[[:space:]]*replacing/ && NF>1 {print $1}'"""
)

# 从 `dnf --assumeno install` 的交易表里抽取“将要新增”的包名：
# Installing / Installing dependencies / Installing weak dependencies 三段，
# 排除已升级(Upgrading)与正在替换(replacing)的条目。
AWK_NEW_PKGS = (
    r"""awk -v arch="$(uname -m)" '"""
    r"""/^[[:space:]]*(Package|Installing|Upgrading|Downgrading|Removing|Reinstalling"""
    r"""|Replacing|Installing dependencies|Installing weak dependencies)[[:space:]:]*$/"""
    r""" {sec=$0; sub(/[[:space:]:]+$/,"",sec); next} """
    r"""/^[[:space:]]*Transaction (Summary|Test)/ {sec=""; next} """
    r"""(sec=="Installing" || sec=="Installing dependencies" """
    r"""|| sec=="Installing weak dependencies") """
    r"""&& $0 ~ ("(^|[[:space:]])(" arch "|noarch)([[:space:]]|$)") """
    r"""&& $0 !~ /^[[:space:]]*replacing/ && NF>1 {print $1}'"""
)


def local_cmd(cmd, conn=None):
    """本地命令执行，带超时保护

    Args:
        cmd ([str]): 需要执行的命令
        conn ([class], optional): 建立和远端的连接. Defaults to None.

    Returns:
        [list]: 命令执行后的返回码，命令执行结果
    """
    try:
        p = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            shell=True,
            start_new_session=True,
        )
        out, _ = p.communicate(timeout=DNF_TIMEOUT)
        return p.returncode, out
    except subprocess.TimeoutExpired:
        # 杀整个进程组（含 dnf 子进程），清 dnf 锁避免"另一个 dnf 实例运行中"假失败
        try:
            os.killpg(os.getpgid(p.pid), signal.SIGKILL)
        except Exception:
            p.kill()
        subprocess.run(
            "pkill -9 dnf; rm -f /var/cache/dnf/*.pid",
            shell=True,
            stderr=subprocess.DEVNULL,
        )
        mugen_log.logging("error", "local cmd timeout(>%ss): %s" % (DNF_TIMEOUT, cmd))
        return 143, "local cmd timeout"


def quit_parent_process(signal_name):
    parent_pid = os.getppid()
    os.kill(parent_pid, signal_name)


# 禁止被 DNF_REMOVE 卸载的系统关键包（精确包名）。
# 这些包一旦被删，测试框架自身依赖的命令（script/ssh/mount/lvm 等）会消失，
# 后续用例会以 rc=127 “command not found”静默失败，整批用例被记为 blocked。
PROTECTED_PKGS = frozenset(
    (
        "util-linux",
        "util-linux-core",
        "util-linux-libs",
        "glibc",
        "bash",
        "coreutils",
        "systemd",
        "systemd-libs",
        "systemd-udev",
        "openssh",
        "openssh-server",
        "openssh-clients",
        "dnf",
        "rpm",
        "python3",
        "python3-libs",
        "shadow",
        "shadow-utils",
        "pam",
        "openssl",
        "openssl-libs",
        "zlib",
        "kernel",
        "kernel-core",
    )
)

# 受保护包的前缀（子包/语言包同样不能删）。
PROTECTED_PREFIXES = (
    "util-linux-",
    "glibc-",
    "systemd-",
    "python3-",
    "openssh-",
    "kernel-",
)


def sanitize_remove_list(tokens):
    """过滤 dnf remove 参数，剔除受保护的系统包与非法 token。

    Args:
        tokens (list): 待传给 `dnf -y remove` 的参数列表

    Returns:
        list: 过滤后的参数列表
    """
    safe = []
    seen = set()
    dropped = []
    for tk in tokens:
        if not tk:
            continue
        # 只接受合法包名；拒绝被误传进来的命令行选项（如 `-x`）与路径。
        # 包名允许字母、数字、`-`、`_`、`.`、`+`、`@`（如 device-mapper-event、
        # libstdc++、pkg@ver）。
        if tk.startswith("-") or "/" in tk or not re.match(
            r"^[A-Za-z0-9_.+@][A-Za-z0-9_.+@-]*$", tk
        ):
            dropped.append(tk)
            continue
        base = tk.split(".")[0]
        if tk in PROTECTED_PKGS or tk in seen:
            if tk in PROTECTED_PKGS:
                dropped.append(tk)
            continue
        if any(base.startswith(p) for p in PROTECTED_PREFIXES):
            dropped.append(tk)
            continue
        seen.add(tk)
        safe.append(tk)
    if dropped:
        mugen_log.logging(
            "warning",
            "skip protected/illegal packages in dnf remove: %s" % " ".join(dropped),
        )
    return safe


def rpm_install(pkgs, node=1, tmpfile=""):
    """安装软件包

    Args:
        pkgs ([str]): 软包包名，"bc" or "bc vim"
        node (int, optional): 节点号. Defaults to 1.
        tmpfile (str, optional): 软件包及其依赖包的缓存文件. Defaults to "".

    Returns:
        [list]: 错误码，安装的包的列表
    """
    if pkgs == "":
        mugen_log.logging("error", "the following arguments are required:pkgs")
        sys.exit(1)

    localtion = os.environ.get("NODE" + str(node) + "_LOCALTION")
    if localtion == "local":
        conn = None
        func = local_cmd
    else:
        conn = ssh_cmd.pssh_conn(
            os.environ.get("NODE" + str(node) + "_IPV4"),
            os.environ.get("NODE" + str(node) + "_PASSWORD"),
            os.environ.get("NODE" + str(node) + "_SSH_PORT"),
            os.environ.get("NODE" + str(node) + "_USER"),
        )
        func = ssh_cmd.pssh_cmd

    result = func(conn=conn, cmd="dnf --assumeno install " + pkgs)[1]
    if "is already installed" in result and "Nothing to do" in result:
        mugen_log.logging("info", "pkgs:(%s) is already installed" % pkgs)
        return 0, None

    # === 新增逻辑1：处理软件包不存在，导致安装失败的问题 ===
    if "No match for argument" in result or "is not a package file" in result:
        mugen_log.logging("error", "pkgs:(%s) does not exist. Installation failed exit script." % pkgs)
        return 1, "package not exists"

    # === 新增逻辑2：处理软件包安装冲突问题 ===
    if "conflicts" in result and "cannot install the best candidate for the job" in result or "冲突" in result and "无法为该任务安装最佳候选" in result:
        mugen_log.logging("error", "pkgs:(%s) installation conflict. Exiting script." % pkgs)
        return 1, "package installation conflict"

    # 被“升级/替换”的包：绝对不能进入删除清单。
    # 注意 `xargs` 在空输入时退码恒为 0，不能当管道失败哨兵用，
    # 因此这里只取其输出内容，失败与否以 python 侧解析结果为准。
    upCode, upList = func(
        conn=conn,
        cmd="dnf --assumeno install " + pkgs + " 2>&1 | " + AWK_UPGRADING,
    )
    upList = " ".join(upList.split())
    if upCode != 0:
        mugen_log.logging(
            "warning",
            "cannot enumerate packages upgraded by (%s), assume none: rc=%s"
            % (pkgs, upCode),
        )

    up_alt = "|".join(upList.split())

    # 删除清单只允许包含本次真正“新增”的包（Installing* 段），
    # 并与 Upgrading 段做二次求差，杜绝把系统既有包写进清单。
    depCmd = "dnf --assumeno install " + pkgs + " 2>&1 | " + AWK_NEW_PKGS
    if up_alt:
        depCmd += " | grep -vxE '" + up_alt + "'"
    depCode, depList = func(conn=conn, cmd=depCmd)
    if depCode != 0:
        mugen_log.logging(
            "warning",
            "cannot enumerate dependencies of (%s), keep removal list empty: rc=%s"
            % (pkgs, depCode),
        )
        depList = ""

    exitcode, result = func(conn=conn, cmd="dnf -y install " + pkgs)

    if tmpfile == "":
        tmpfile = tempfile.mkstemp(dir="/tmp")[1]

    # 只写非空包名，避免把空行/空白当成包名传给后续 dnf remove
    with open(tmpfile, "a+") as f:
        for depPkg in depList.split():
            if depPkg and not depPkg.startswith("-"):
                f.write(depPkg + " ")

    if exitcode == 0:
        result = f.name

    return exitcode, result


def rpm_remove(node=1, pkgs="", tmpfile=""):
    """卸载软件包

    Args:
        node (int, optional): 节点号. Defaults to 1.
        pkgs (str, optional): 需要卸载的软件包. Defaults to "".
        tmpfile (str, optional): 安装时所有涉及的包. Defaults to "".

    Returns:
        list: 错误码，卸载列表或错误信息
    """
    if pkgs == "" and tmpfile == "":
        mugen_log.logging(
            "error", "Packages or package files these need to be removed must be added"
        )
        sys.exit(1)

    localtion = os.environ.get("NODE" + str(node) + "_LOCALTION")
    if localtion == "local":
        conn = None
        func = local_cmd
    else:
        conn = ssh_cmd.pssh_conn(
            os.environ.get("NODE" + str(node) + "_IPV4"),
            os.environ.get("NODE" + str(node) + "_PASSWORD"),
            os.environ.get("NODE" + str(node) + "_SSH_PORT"),
            os.environ.get("NODE" + str(node) + "_USER"),
        )
        func = ssh_cmd.pssh_cmd

    depList = ""
    if tmpfile != "":
        with open(tmpfile, "r") as f:
            depList = f.read()

    remove_list = sanitize_remove_list((pkgs + " " + depList).split())
    if not remove_list:
        mugen_log.logging("info", "nothing to remove after sanitizing, skip dnf remove.")
        if localtion != "local":
            ssh_cmd.pssh_close(conn)
        return 0

    # 关键：禁用 clean_requirements_on_remove（dnf 默认 True）。
    #
    # 实测（openRuyi riscv64 真实仓库）：
    #   dnf install device-mapper  -> util-linux 作为纯依赖被装上，/usr/bin/script 存在
    #   dnf remove  device-mapper  -> clean_requirements_on_remove=True 时级联
    #                                 "Erasing: util-linux"，/usr/bin/script 消失
    #   同样操作在 clean_requirements_on_remove=False 时 util-linux 保留完好
    #
    # 用例 post_test 走 DNF_REMOVE 时会传入本次安装拉进来的全部依赖（如 lvm2、
    # xfsprogs 携带 device-mapper*），once util-linux 被当作"多余依赖"清掉，
    # 运行器下一步 `script -q -c "bash mugen.sh ..."` 就变成
    # "script: command not found"（rc=127），该套件后续所有用例全部 blocked。
    #
    # 用例只应卸载自己显式安装的包；系统和基础包绝不能被隐式级联删除。
    exitcode = func(
        conn=conn,
        cmd="dnf --setopt=clean_requirements_on_remove=False -y remove "
        + " ".join(remove_list),
    )[0]
    if localtion != "local":
        ssh_cmd.pssh_close(conn)
    return exitcode


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        usage="rpm_manage.py install|remove [-h] [--node NODE] [--pkgs PKG] [--tempfile TEPMFILE]",
        description="manual to this script",
    )
    parser.add_argument(
        "operation", type=str, choices=["install", "remove"], default=None
    )
    parser.add_argument("--node", type=int, default=1)
    parser.add_argument("--pkgs", type=str, default="")
    parser.add_argument("--tempfile", type=str, default="")
    args = parser.parse_args()

    if sys.argv[1] == "install":
        exitcode, output = rpm_install(args.pkgs, args.node, args.tempfile)
        if exitcode == 1:
            # === 新增逻辑1：处理软件包不存在
            if output == "package not exists":
                quit_parent_process(signal.SIGRTMIN)
            # === 新增逻辑2：处理软件包安装冲突
            elif output == "package installation conflict":
                quit_parent_process(signal.SIGRTMIN+1)
        # 仅成功时向 stdout 输出临时文件路径；失败信息走 stderr（mugen_log），
        # 避免 DNF_INSTALL 把错误文本当 tmpfile 捕获、后续 DNF_REMOVE 用它 open() 崩溃
        if exitcode == 0 and output is not None:
            print(output)
        sys.exit(exitcode)
    elif sys.argv[1] == "remove":
        exitcode = rpm_remove(args.node, args.pkgs, args.tempfile)
        sys.exit(exitcode)
    else:
        mugen_log.logging(
            "error",
            "usage: rpm_manage.py install|remove [-h] [--node NODE] [--pkg PKG] [--tempfile TEPMFILE]",
        )
        sys.exit(1)
