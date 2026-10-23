# -*- coding: utf-8 -*-
"""
# @Author : lemon-higgins
# @Date   : 2021-07-01 02:09:51
# @Email  : lemon.higgins@aliyun.com
# @License: Mulan PSL v2
# @Desc   : 命令执行超时
"""

import subprocess
import time
import os
import sys
import signal
import argparse
import re

SCRIPT_PATH = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPT_PATH)
import mugen_log

MUGEN_PID_FILE = "/tmp/mugen_timeout_pid"
MUGEN_REMOTE_CASE_FILE = "/tmp/mugen_remote_case_name"

# idle 探测默认阈值（秒）：超过该时长无任何输出，打印当前进程树便于定位卡住的命令
DEFAULT_IDLE_TIMEOUT = 120


def _kill_remote_processes():
    """超时后通过SSH向目标机发kill，清理远端残留的测试进程"""
    case_file = MUGEN_REMOTE_CASE_FILE
    if not os.path.exists(case_file):
        return
    with open(case_file, "r") as f:
        case_name = f.read().strip()
    if not case_name:
        return
    node_num = os.environ.get("MUGEN_SSH_NODE", "1")
    ip = os.environ.get("NODE" + node_num + "_IPV4")
    password = os.environ.get("NODE" + node_num + "_PASSWORD")
    port = os.environ.get("NODE" + node_num + "_SSH_PORT", "22")
    user = os.environ.get("NODE" + node_num + "_USER", "root")
    if not ip or not password:
        return
    kill_cmd = "pkill -9 -f '%s'" % case_name
    try:
        import paramiko
        conn = paramiko.SSHClient()
        conn.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        conn.connect(ip, int(port), user, password, timeout=10)
        conn.exec_command(kill_cmd)
        conn.close()
    except Exception:
        pass
    os.remove(case_file)


def _print_process_tree(p):
    """idle 超时时打印子进程（含子孙）的进程树，便于定位卡住的命令（如 dnf/expect）"""
    try:
        pgid = os.getpgid(p.pid)
    except Exception:
        return
    mugen_log.logging(
        "warn",
        "No output for a long time, current process tree (pgid=%s):" % pgid,
    )
    try:
        out = subprocess.run(
            ["ps", "-g", str(pgid), "-o", "pid,ppid,etime,args", "--forest"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=10,
        ).stdout
        sys.stdout.write(out)
        sys.stdout.flush()
    except Exception:
        mugen_log.logging("warn", "unable to dump process tree")


def _run_with_idle_probe(cmd, wait_time, idle_timeout):
    """mode=1 核心：PIPE + select 轮询转发输出，idle 超时打印进程树诊断（不杀进程）

    硬超时（wait_time 到）仍按原逻辑杀进程组并返回 143。
    """
    pid_file = MUGEN_PID_FILE
    p = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        shell=True,
        start_new_session=True,
    )
    with open(pid_file, "w") as f:
        f.write(str(p.pid))
    try:
        last_output = time.time()
        start = time.time()
        while True:
            remaining = wait_time - (time.time() - start)
            if remaining <= 0:
                raise subprocess.TimeoutExpired(cmd, wait_time)
            # 非阻塞读一行；无输出则 sleep 1s 后继续，兼顾 idle 判定与硬超时精度
            line = p.stdout.readline()
            if line:
                sys.stdout.write(line)
                sys.stdout.flush()
                last_output = time.time()
                continue
            if p.poll() is not None:
                break
            if time.time() - last_output >= idle_timeout:
                _print_process_tree(p)
                last_output = time.time()  # 重置，继续等硬超时，不杀进程
            else:
                time.sleep(1)
        exitcode = p.returncode
        if os.path.exists(pid_file):
            os.remove(pid_file)
        return exitcode
    except subprocess.TimeoutExpired as e:
        mugen_log.logging("error", "Timeout : " + str(e))
        try:
            os.killpg(os.getpgid(p.pid), signal.SIGKILL)
        except Exception:
            p.kill()
        if os.path.exists(pid_file):
            os.remove(pid_file)
        _kill_remote_processes()
        return 143


def sleep_wait(wait_time, cmd=None, mode=1, idle_timeout=DEFAULT_IDLE_TIMEOUT):
    """等待命令执行时长

    Args:
        wait_time ([str]): 待定时间
        cmd ([str], optional): 执行的命令. Defaults to None.
        mode (int, optional): 命令执行等待模式. Defaults to 1.
        idle_timeout (int, optional): idle 探测阈值（秒）. Defaults to 120.
    """
    if list(wait_time)[-1] == "m":
        wait_time = int(wait_time.replace("m", "")) * 60
    elif list(wait_time)[-1] == "h":
        wait_time = int(wait_time.replace("h", "")) * 3600
    elif re.search("[0-9]|s", list(wait_time)[-1]):
        wait_time = int(wait_time.replace("s", ""))
    else:
        mugen_log.logging("error", "sleep_wait的等待超时时长当前只支持小时(h),分钟(m),秒(s).")
        sys.exit(1)

    if not cmd:
        time.sleep(wait_time)
        sys.exit(0)
    if cmd and mode == 1:
        exitcode = _run_with_idle_probe(cmd, wait_time, idle_timeout)
        sys.exit(exitcode)

    if cmd and mode == 2:
        init = 0
        while init < wait_time:
            time.sleep(1)
            exitcode, output = subprocess.getstatusoutput(cmd)
            if exitcode == 0:
                print(output)
                sys.exit(0)
            elif init == wait_time:
                sys.exit(exitcode)

            init += 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="manual to this script")
    parser.add_argument("--time", type=str)
    parser.add_argument("--cmd", type=str)
    parser.add_argument("--mode", type=int, choices=[1, 2], default=1)
    parser.add_argument("--idle-timeout", type=int, default=DEFAULT_IDLE_TIMEOUT)
    args = parser.parse_args()

    sleep_wait(args.time, args.cmd, args.mode, args.idle_timeout)
