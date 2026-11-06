#!/usr/bin/bash
# cri-tools 套件公共辅助库
# 说明：
#   crictl >= 1.30 使用新语法：crictl run [options] container-config.json pod-config.json
#   旧语法（--name/--image/--net 等）已废弃。本库封装容器/沙箱创建逻辑，
#   通过 host 网络（network: 2 = NODE）避免对 CNI 的依赖。

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
function cri_make_container_config() {
    local conf_file="$1"
    local container_name="$2"
    local image="${3:-busybox:latest}"
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
  "log_path": "${container_name}.log"
}
EOF
    else
        local cmd_json=""
        for arg in "$@"; do
            cmd_json="${cmd_json} \"${arg}\","
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
