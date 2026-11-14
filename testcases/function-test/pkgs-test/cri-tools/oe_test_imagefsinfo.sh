
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl imagefsinfo 命令及其参数

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
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl imagefsinfo 命令
    crictl imagefsinfo
    CHECK_RESULT $? 0 0 "crictl imagefsinfo failed"

    # 测试 crictl imagefsinfo --output json
    crictl imagefsinfo --output json
    CHECK_RESULT $? 0 0 "crictl imagefsinfo --output json failed"

    # 测试 crictl imagefsinfo --output yaml
    crictl imagefsinfo --output yaml
    CHECK_RESULT $? 0 0 "crictl imagefsinfo --output yaml failed"

    # 测试 crictl imagefsinfo --output go-template
    # 原实现的模板字段 ".ImageFilesystem" 在 1.36 的响应结构里不存在，
    # 正确字段是 .status.imageFilesystem（顶层键为 status）
    crictl imagefsinfo --output go-template --template "{{.status.imageFilesystem}}"
    CHECK_RESULT $? 0 0 "crictl imagefsinfo --output go-template failed"

    # 测试 crictl imagefsinfo --output table
    crictl imagefsinfo --output table
    CHECK_RESULT $? 0 0 "crictl imagefsinfo --output table failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
