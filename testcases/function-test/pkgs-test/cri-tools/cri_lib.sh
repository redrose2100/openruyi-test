#!/usr/bin/bash
# cri-tools 套件公共辅助库
# 说明：
#   crictl >= 1.30 使用新语法：crictl run [options] container-config.json pod-config.json
#   旧语法（--name/--image/--net 等）已废弃。本库封装容器/沙箱创建逻辑，
#   通过 host 网络（network: 2 = NODE）避免对 CNI 的依赖。

# CRI 服务端点。crictl 默认就指向该 socket，这里显式声明便于排障。
CRI_RUNTIME_SOCK="${CRI_RUNTIME_SOCK:-/run/containerd/containerd.sock}"

# 记录一条失败并以失败状态结束当前用例（EXIT trap 仍会执行 post_test 清理）。
# 用法: cri_abort "<错误描述>"
function cri_abort() {
    CHECK_RESULT 1 0 0 "${1:-cri-tools case aborted}"
    exit 1
}

# 校验容器/Pod ID 非空。CRI 服务异常时 crictl 会静默返回空串，
# 若不拦截，后续每条命令都会再报一次“ID cannot be empty”，把 1 个根因放大成 N 个失败。
# 用法: cri_require_id "<ID值>" "<上下文描述>"
function cri_require_id() {
    if [ -z "${1}" ]; then
        cri_abort "${2}: got empty ID from CRI runtime"
    fi
    return 0
}

# 引导 CRI 运行环境（containerd）。
# cri-tools 只提供 crictl 客户端，CRI 服务由 containerd 提供。
# 本套件原实现只执行 DNF_INSTALL "cri-tools"，从不安装/启动 containerd，
# 于是所有用例都撞在 "dial unix /run/containerd/containerd.sock: no such file or directory"。
# 用法: cri_ensure_runtime [等待 socket 的秒数，默认 60]
function cri_ensure_runtime() {
    local wait_secs="${1:-60}"
    local i

    export CONTAINER_RUNTIME_ENDPOINT="unix://${CRI_RUNTIME_SOCK}"

    # 1) containerd 未安装时补装（runc 为默认 runtime handler）
    if ! command -v containerd >/dev/null 2>&1; then
        DNF_INSTALL "containerd runc"
    fi
    if ! command -v containerd >/dev/null 2>&1; then
        LOG_ERROR "containerd is not installed, cannot serve CRI endpoint ${CRI_RUNTIME_SOCK}"
        return 1
    fi

    # 2) 启动 containerd。优先 systemd；本镜像 containerd.service 为 Type=notify，
    #    start 可能长时间停在 activating，因此不依赖 systemctl 返回值，只看 socket。
    if [ ! -S "${CRI_RUNTIME_SOCK}" ]; then
        systemctl start containerd >/dev/null 2>&1
        for i in $(seq 1 "${wait_secs}"); do
            [ -S "${CRI_RUNTIME_SOCK}" ] && break
            sleep 1
        done
    fi

    # 3) systemd 起不来时回退为后台进程（containerd suite 已验证该方式可用）
    if [ ! -S "${CRI_RUNTIME_SOCK}" ]; then
        LOG_WARN "containerd socket absent after systemctl start, fallback to nohup containerd &"
        nohup containerd >/tmp/cri-tools-containerd.log 2>&1 &
        for i in $(seq 1 "${wait_secs}"); do
            [ -S "${CRI_RUNTIME_SOCK}" ] && break
            sleep 1
        done
    fi

    if [ ! -S "${CRI_RUNTIME_SOCK}" ]; then
        LOG_ERROR "CRI endpoint ${CRI_RUNTIME_SOCK} still absent after ${wait_secs}s"
        return 1
    fi

    # 4) 连通性探测：socket 存在不等于 CRI 服务可应答
    if ! crictl info >/dev/null 2>&1; then
        LOG_ERROR "crictl cannot talk to CRI endpoint ${CRI_RUNTIME_SOCK}"
        return 1
    fi

    return 0
}

# 创建 pod 配置文件（host 网络）
# 用法: cri_make_pod_config <配置文件路径> <pod名称>
function cri_make_pod_config() {
    local conf_file="$1"
    local pod_name="$2"
    cat <<EOF > "${conf_file}"
{
  "metadata": {
    "name": "${pod_name}",
    "namespace": "default"
  },
  "log_directory": "/tmp",
  "linux": {
    "security_context": {
      "namespace_options": {
        "network": 2
      }
    }
  }
}
EOF
}

# 创建容器配置文件
# 用法: cri_make_container_config <配置文件路径> <容器名称> [镜像] [命令...]
# 环境变量 CRI_CONTAINER_TTY=true 时生成的容器开启 stdin/tty，
# 供 crictl attach / exec --tty 使用（未开启 tty 的容器 attach 会被 CRI 拒绝）
function cri_make_container_config() {
    local conf_file="$1"
    local container_name="$2"
    local image="${3:-busybox:latest}"
    local tty_val="false"
    if [ "${CRI_CONTAINER_TTY:-false}" = "true" ]; then
        tty_val="true"
    fi
    shift 3
    if [ $# -eq 0 ]; then
        # 默认命令保持容器运行，避免容器在无 TTY 环境下因交互式 sh 读 EOF 立即退出
        cat <<EOF > "${conf_file}"
{
  "metadata": {
    "name": "${container_name}"
  },
  "image": {
    "image": "${image}"
  },
  "command": [
    "/bin/sh",
    "-c",
    "sleep 3600"
  ],
  "tty": ${tty_val},
  "stdin": ${tty_val},
  "log_path": "${container_name}.log"
}
EOF
    else
        local cmd_json=""
        local esc_arg=""
        for arg in "$@"; do
            # 转义反斜杠与双引号，避免命令参数里带 " 或 \ 时生成非法 JSON
            esc_arg=$(printf '%s' "${arg}" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')
            cmd_json="${cmd_json} \"${esc_arg}\","
        done
        cmd_json="${cmd_json%,}"
        cat <<EOF > "${conf_file}"
{
  "metadata": {
    "name": "${container_name}"
  },
  "image": {
    "image": "${image}"
  },
  "command": [
    ${cmd_json}
  ],
  "tty": ${tty_val},
  "stdin": ${tty_val},
  "log_path": "${container_name}.log"
}
EOF
    fi
}

# 创建容器并输出容器 ID
# 用法: cri_run_container <容器名称> [镜像] [命令...]
# 依赖当前目录下的 container-config.json / pod-config.json（未指定时自动创建）
function cri_run_container() {
    local container_name="$1"
    local image="${2:-busybox:latest}"
    shift 2
    cri_make_container_config ./container-config.json "${container_name}" "${image}" "$@"
    cri_make_pod_config ./pod-config.json "${container_name}-pod"
    crictl run ./container-config.json ./pod-config.json
}

# 创建沙箱后返回其 ID；失败时返回空串（调用方用 cri_require_id 拦截）
# 用法: cri_run_pod_id <pod名称>
function cri_run_pod_id() {
    cri_run_pod "$1"
}

# 创建沙箱（pod）并输出 pod ID
# 用法: cri_run_pod <pod名称>
function cri_run_pod() {
    local pod_name="$1"
    cri_make_pod_config ./pod-config.json "${pod_name}"
    crictl runp ./pod-config.json
}

# 创建容器但不启动（created 状态），供 crictl start 测试使用
# 用法: cri_create_container <容器名称> [镜像] [命令...]
# 依赖当前目录下的 container-config.json / pod-config.json（未指定时自动创建）
function cri_create_container() {
    local container_name="$1"
    local image="${2:-busybox:latest}"
    shift 2
    cri_make_pod_config ./pod-config.json "${container_name}-pod"
    local pod_id
    pod_id=$(crictl runp ./pod-config.json)
    if [ -z "$pod_id" ]; then
        echo "Failed to create pod for container" >&2
        return 1
    fi
    cri_make_container_config ./container-config.json "${container_name}" "${image}" "$@"
    crictl create "${pod_id}" ./container-config.json ./pod-config.json
}

# 运行可能长期阻塞的流式命令（attach / logs --follow / stats --watch / exec --tty）
# 用法: cri_run_stream <超时秒数> <命令...>
# 返回 0 表示命令正常结束，或被 timeout 正常终止（rc=124/137，说明命令确实在持续输出）
function cri_run_stream() {
    local limit="$1"
    shift
    timeout "${limit}" "$@" < /dev/null
    local rc=$?
    case "${rc}" in
        0|124|137)
            return 0
            ;;
        *)
            return "${rc}"
            ;;
    esac
}
