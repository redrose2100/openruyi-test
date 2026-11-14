
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl ps 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/cri_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"

    # 引导 CRI 服务（containerd）：cri-tools 只提供客户端，服务端须自行拉起
    cri_ensure_runtime || cri_abort "CRI runtime (containerd) is not available"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个真实容器与 sandbox，使 --id/--pod/--name 等过滤参数能在真实数据上验证
    cri_run_container ps-container busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test container"
    CONTAINER_ID=$(crictl ps -q)
    cri_require_id "$CONTAINER_ID" "Failed to get container ID"
    POD_ID=$(crictl pods -q | head -1)
    cri_require_id "$POD_ID" "Failed to get pod ID"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl ps 命令的各种参数组合
    crictl ps
    CHECK_RESULT $? 0 0 "crictl ps failed"

    crictl ps --all
    CHECK_RESULT $? 0 0 "crictl ps --all failed"

    crictl ps --id "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "crictl ps --id $CONTAINER_ID failed"

    crictl ps --image "busybox:latest"
    CHECK_RESULT $? 0 0 "crictl ps --image busybox:latest failed"

    crictl ps --label "key=value"
    CHECK_RESULT $? 0 0 "crictl ps --label key=value failed"

    crictl ps --last 5
    CHECK_RESULT $? 0 0 "crictl ps --last 5 failed"

    crictl ps --latest
    CHECK_RESULT $? 0 0 "crictl ps --latest failed"

    crictl ps --name "ps-container"
    CHECK_RESULT $? 0 0 "crictl ps --name ps-container failed"

    crictl ps --no-trunc
    CHECK_RESULT $? 0 0 "crictl ps --no-trunc failed"

    crictl ps --output json
    CHECK_RESULT $? 0 0 "crictl ps --output json failed"

    crictl ps --output yaml
    CHECK_RESULT $? 0 0 "crictl ps --output yaml failed"

    crictl ps --output table
    CHECK_RESULT $? 0 0 "crictl ps --output table failed"

    crictl ps --pod "$POD_ID"
    CHECK_RESULT $? 0 0 "crictl ps --pod $POD_ID failed"

    crictl ps --quiet
    CHECK_RESULT $? 0 0 "crictl ps --quiet failed"

    crictl ps --state "running"
    CHECK_RESULT $? 0 0 "crictl ps --state running failed"

    crictl ps --verbose
    CHECK_RESULT $? 0 0 "crictl ps --verbose failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    crictl stop "$CONTAINER_ID" >/dev/null 2>&1
    crictl rm -f "$CONTAINER_ID" >/dev/null 2>&1
    crictl rmp -f "$POD_ID" >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
