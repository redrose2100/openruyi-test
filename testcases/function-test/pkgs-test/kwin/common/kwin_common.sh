#!/usr/bin/bash
# kwin 测试套公共函数
#
# 背景：kwin_wayland 不是普通的一次性命令，而是一个 Wayland 合成器（常驻进程）。
# 只要参数被解析器接受，它就会启动事件循环并且永不返回；只有参数非法时才会
# 立刻打印 "kwin: Unknown option 'xxx'." 并以非 0 退出。
#
# 因此原来脚本里这种写法
#     kwin_wayland --drm
#     CHECK_RESULT $? 0 0 "kwin_wayland --drm failed"
# 必然挂死到 runner 的用例超时（1800s）才被杀死，测试结果完全失真，而且被杀死
# 的合成器还占着 /run/user/0/wayland-N.lock，把后面的用例一起拖死。
#
# 本文件用一个同名 shell 函数遮蔽 kwin_wayland 命令：限时后台启动，按
# “参数是否被解析器接受”返回 0/1。脚本里既有的
#     kwin_wayland <opt>
#     CHECK_RESULT $? 0 0 "..."
# 写法无需改动即正确。
#
# 判定只看参数解析结果，不要求合成器在无头虚机上真的把画面渲染出来：
# 无头环境没有 DRM 设备、也没有父 Wayland 合成器，运行期失败属于环境限制，
# 不是被测参数的问题，因此只 LOG_WARN，不判失败。
#
# 用法：在 source common_lib.sh 之后 source 本文件即可。

# 真正要执行的二进制。本文件定义了同名函数，必须用绝对路径，否则会递归调用自己。
KWIN_WAYLAND_BIN=${KWIN_WAYLAND_BIN:-/usr/bin/kwin_wayland}

# 遮蔽 kwin_wayland：限时后台启动并按“参数是否被接受”返回。
#   return 0 -> 参数被接受（一次性命令正常退出，或常驻后被我们主动结束）
#   return 1 -> 参数被拒绝（kwin 打印 Unknown option / invalid option）
function kwin_wayland() {
    local outfile=./kwin_wayland_run.$$.log
    local pid=""
    local waited=0
    local rc=0

    if [ ! -x "${KWIN_WAYLAND_BIN}" ]; then
        LOG_ERROR "kwin_wayland binary not found: ${KWIN_WAYLAND_BIN}"
        return 1
    fi

    : >"${outfile}"
    "${KWIN_WAYLAND_BIN}" "$@" >"${outfile}" 2>&1 &
    pid=$!

    # 参数解析是毫秒级的，最多观察 2s 足够区分“已接受”与“被拒绝”
    while [ "${waited}" -lt 4 ]; do
        kill -0 "${pid}" 2>/dev/null || break
        sleep 0.5
        waited=$((waited + 1))
    done

    if kill -0 "${pid}" 2>/dev/null; then
        # 仍在运行：参数已被接受，合成器进入事件循环，主动结束它
        kill -TERM "${pid}" >/dev/null 2>&1
        sleep 0.5
        kill -9 "${pid}" >/dev/null 2>&1
        wait "${pid}" >/dev/null 2>&1
        # 只回显前几行启动信息，避免刷屏
        sed -n '1,3p' "${outfile}" 2>/dev/null
        rm -f "${outfile}"
        return 0
    fi

    wait "${pid}" >/dev/null 2>&1
    rc=$?

    if grep -qE "Unknown option|unknown option|invalid option" "${outfile}" 2>/dev/null; then
        LOG_ERROR "kwin_wayland '$*' rejected: $(grep -m 1 -E "Unknown option|unknown option|invalid option" "${outfile}")"
        rm -f "${outfile}"
        return 1
    fi

    # 参数解析通过且进程自行退出（--help / --version 之类一次性命令）。
    # 回显前 40 行便于查证，同时避免 --help-all 把用例日志刷爆。
    sed -n '1,40p' "${outfile}" 2>/dev/null
    if [ "${rc}" -ne 0 ]; then
        # 参数解析已经通过，失败发生在运行期（无 DRM 设备 / 无父合成器等），仅告警
        LOG_WARN "kwin_wayland '$*' option accepted but exited with ${rc}"
    fi

    rm -f "${outfile}"
    return 0
}

# 清理残留的合成器进程与 wayland socket 锁文件。
# 必须先杀进程再删锁：被杀死的合成器仍占着 /run/user/0/wayland-N.lock 时，
# 后续调用会一直打印 "unable to lock lockfile ... maybe another compositor
# is running" 并不断换 socket 号重试，把整条用例拖到超时。
#
# 只按进程名(comm)精确匹配，不能用 proc_pids_by_cmdline：用例脚本自身路径
#   /opt/os-autotest/testcases/function-test/pkgs-test/kwin/oe_test_kwin_wayland_wrapper.sh
# 与 runner 的 mugen.sh 命令行里都含有 "kwin_wayland" 字样，命令行子串匹配
# 会把本用例的 shell 及其父 shell 一起 kill 掉（脚本名含 kwin_wayland 的
# oe_test_kwin_wayland_wrapper 必中，其它 kwin 用例不含该字样所以不中）。
# 现场表现就是用例跑到 post_test 后日志只剩
#   Session terminated, killing shell...,
# 结果文件生成不出来，平台把用例记为 blocked。
# comm 只有可执行文件名、不含参数和脚本路径，不会误伤自身。
function kwin_wayland_cleanup() {
    local pids

    pids=$(proc_pids_by_name kwin_wayland 2>/dev/null)
    [ -n "${pids}" ] && kill -TERM ${pids} >/dev/null 2>&1
    sleep 0.5

    pids=$(proc_pids_by_name kwin_wayland 2>/dev/null)
    [ -n "${pids}" ] && kill -9 ${pids} >/dev/null 2>&1

    rm -f /run/user/0/wayland-*.lock
    rm -f ./kwin_wayland_run.*.log
    return 0
}
