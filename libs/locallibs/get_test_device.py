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
 @Date    : 2021-04-22 10:52:19
 @License : Mulan PSL v2
 @Version : 1.0
 @Desc    : 测试设备名获取
"""

import os
import sys
import subprocess
import argparse

SCRIPT_PATH = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPT_PATH)
import ssh_cmd
import mugen_log
import rpm_manage


def get_test_nic(node=1):
    """获取可测试使用的网卡

    Args:
        node (int, optional): 节点号. Defaults to 1.

    Returns:
        [str]: 网卡名
    """
    tmpfile = None
    if os.environ.get("NODE" + str(node) + "_LOCALTION") == "local":
        lshw_installed = subprocess.getoutput("command -v lshw").strip() != ""
        is_ubuntu = "ubuntu" in subprocess.getoutput("cat /etc/os-release").lower()
    else:
        conn = ssh_cmd.pssh_conn(
            os.environ.get("NODE" + str(node) + "_IPV4"),
            os.environ.get("NODE" + str(node) + "_PASSWORD"),
            os.environ.get("NODE" + str(node) + "_SSH_PORT"),
            os.environ.get("NODE" + str(node) + "_USER"),
        )
        lshw_installed = ssh_cmd.pssh_cmd(conn, "command -v lshw")[1].strip() != ""
        is_ubuntu = "ubuntu" in ssh_cmd.pssh_cmd(conn, "cat /etc/os-release")[1].lower()
        ssh_cmd.pssh_close(conn)

    if not lshw_installed:
        if is_ubuntu:
            mugen_log.logging(
                "error",
                "The system is Ubuntu, please install lshw manually: sudo apt install lshw",
            )
            sys.exit(1)
        else:
            exitcode, tmpfile = rpm_manage.rpm_install(pkgs="lshw", node=node)
            if exitcode != 0:
                mugen_log.logging(
                    "error",
                    "Failed to install the dependent software package required to obtain the network card.",
                )
                sys.exit(exitcode)

    if os.environ.get("NODE" + str(node) + "_LOCALTION") == "local":
        dev_info = subprocess.getoutput("cat /proc/device-tree/model")
        if "Lichee Pi 4A" in dev_info:
            # 兼容  licheepi4a 硬件板
            output = subprocess.getoutput(
                "ip addr show | grep '^[0-9]:'|grep -v lo |grep -v virbr |grep -v wlan0 |grep -v dummy0 |grep -v sit0@NONE |grep -v ip_vti0@NONE |cut -d ':' -f2 |sed -e 's/^[[:space:]]*//' | grep -v '"
                + os.environ.get("NODE" + str(node) + "_NIC")
                + "'"
            ).replace("\n", " ")
        else:
            output = subprocess.getoutput(
                "ip link | grep 'state UP' | awk -F': ' '{print $2}' | grep -v '"
                + os.environ.get("NODE" + str(node) + "_NIC")
                + "'"
            ).replace("\n", " ")
    else:
        conn = ssh_cmd.pssh_conn(
            os.environ.get("NODE" + str(node) + "_IPV4"),
            os.environ.get("NODE" + str(node) + "_PASSWORD"),
            os.environ.get("NODE" + str(node) + "_SSH_PORT"),
            os.environ.get("NODE" + str(node) + "_USER"),
        )
        dev_info = ssh_cmd.pssh_cmd(
            conn,
            "cat /proc/device-tree/model"
        )[1]
        if "Lichee Pi 4A" in dev_info:
            # 兼容 licheepi4a 硬件板
            output = ssh_cmd.pssh_cmd(
                conn,
                "ip addr show | grep '^[0-9]:'|grep -v lo |grep -v virbr |grep -v wlan0 |grep -v dummy0 |grep -v sit0@NONE |grep -v ip_vti0@NONE |cut -d ':' -f2 |sed -e 's/^[[:space:]]*//' | grep -v '"
                + os.environ.get("NODE" + str(node) + "_NIC")
                + "'",
            )[1].replace("\n", " ")
        else:
            output = ssh_cmd.pssh_cmd(
                conn,
                "ip link | grep 'state UP' | awk -F': ' '{print $2}' | grep -v '"
                + os.environ.get("NODE" + str(node) + "_NIC")
                + "'",
            )[1].replace("\n", " ")

        ssh_cmd.pssh_close(conn)

    if tmpfile is not None:
        rpm_manage.rpm_remove(node=node, tmpfile=tmpfile)

    return output


# 磁盘枚举脚本：一次性输出可用测试盘（裸名，空格分隔）。
#
# 旧实现依赖 `lsblk -l | grep -e '/.*\|\[.*\]'` 反推“已被占用”的盘，只能识别
# 在 lsblk 列表里能看到挂载点的磁盘。在 qemu -machine virt 等场景下根盘可能
# 拿不到可见挂载点，于是系统盘被当成“空闲盘”返回，随后被 fdisk/pvcreate 写坏。
# 这里改为“先算保护集、再取差集”：保护集覆盖所有已挂载分区与 swap 设备向上
# 追溯到的整盘，因此系统盘永远不会出现在返回值里。
# 解析不出根盘时一律不返回任何盘（宁可失败也不误选），由上层报错。
_TEST_DISK_SCRIPT = r"""
_disk_protected=$(
    {
        lsblk -rno NAME,MOUNTPOINT 2>/dev/null | awk '$2 != "" {print "/dev/" $1}'
        awk 'NR > 1 && $1 ~ /^\/dev\// {print $1}' /proc/swaps 2>/dev/null
        findmnt -no SOURCE / 2>/dev/null
    } | while read -r _dev; do
            [ -n "$_dev" ] || continue
            # dm 设备在 lsblk 里显示为 openeuler-root 这类名字，真实节点在 /dev/mapper 下
            if [ ! -b "$_dev" ] && [ -b "/dev/mapper/$(basename "$_dev")" ]; then
                _dev="/dev/mapper/$(basename "$_dev")"
            fi
            [ -b "$_dev" ] || continue
            lsblk -sno NAME,TYPE "$_dev" 2>/dev/null | awk '$2 == "disk" {print $1}'
        done | sort -u | tr '\n' ' '
)
_root_dev=$(findmnt -no SOURCE / 2>/dev/null)
if [ ! -b "$_root_dev" ] && [ -b "/dev/mapper/$(basename "$_root_dev")" ]; then
    _root_dev="/dev/mapper/$(basename "$_root_dev")"
fi
_root_disk=$(lsblk -sno NAME,TYPE "$_root_dev" 2>/dev/null | awk '$2 == "disk" {print $1}' | head -n 1)
if [ -z "$_root_disk" ]; then
    # 无法可靠识别系统盘：拒绝输出任何测试盘，避免把系统盘交给破坏性用例
    exit 0
fi
case " ${_disk_protected} " in
    *" ${_root_disk} "*) ;;
    *) exit 0 ;;
esac
lsblk -dno NAME,TYPE 2>/dev/null \
    | awk '$2 == "disk" {print $1}' \
    | grep -vE '^(nbd|mmcblk|mtdblock|zram|ram|sr|loop|fd)' \
    | while read -r _d; do
            case " ${_disk_protected} " in
                *" ${_d} "*) ;;
                *) echo "$_d" ;;
            esac
        done | tr '\n' ' '
"""


def get_test_disk(node=1):
    """获取可测试使用的磁盘

    Args:
        node (int, optional): 节点号. Defaults to 1.

    Returns:
        [str]: 磁盘名称
    """
    if os.environ.get("NODE" + str(node) + "_LOCALTION") == "local":
        result = subprocess.run(
            ["sh", "-c", _TEST_DISK_SCRIPT],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
        )
        test_disk = result.stdout.decode("utf-8", "replace")
    else:
        conn = ssh_cmd.pssh_conn(
            os.environ.get("NODE" + str(node) + "_IPV4"),
            os.environ.get("NODE" + str(node) + "_PASSWORD"),
            os.environ.get("NODE" + str(node) + "_SSH_PORT"),
            os.environ.get("NODE" + str(node) + "_USER"),
        )
        test_disk = ssh_cmd.pssh_cmd(conn, _TEST_DISK_SCRIPT)[1]

    # 统一成单行空格分隔，调用方（bash 的 read -a / python 的 split）无需处理换行
    return " ".join(test_disk.split())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="manual to this script")
    parser.add_argument("--node", type=int, default=1)
    parser.add_argument("--device", type=str, choices=["nic", "disk"], default="nic")
    args = parser.parse_args()

    if args.device == "nic":
        print(get_test_nic(args.node))
    elif args.device == "disk":
        print(get_test_disk(args.node))
    else:
        mugen_log.logging(
            "warn",
            "No other test driven acquisition is provided at this time, you can issue to us for follow-up.",
        )
        sys.exit(1)
