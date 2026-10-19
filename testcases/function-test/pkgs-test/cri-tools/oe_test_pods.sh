
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl pods 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl pods 命令的各种参数组合
    crictl pods
    CHECK_RESULT $? 0 0 "crictl pods failed"

    crictl pods --id "pod-id"
    CHECK_RESULT $? 0 0 "crictl pods --id failed"

    crictl pods --label "key=value"
    CHECK_RESULT $? 0 0 "crictl pods --label failed"

    crictl pods --last 5
    CHECK_RESULT $? 0 0 "crictl pods --last failed"

    crictl pods --latest
    CHECK_RESULT $? 0 0 "crictl pods --latest failed"

    crictl pods --name "pod-name"
    CHECK_RESULT $? 0 0 "crictl pods --name failed"

    crictl pods --namespace "namespace"
    CHECK_RESULT $? 0 0 "crictl pods --namespace failed"

    crictl pods --no-trunc
    CHECK_RESULT $? 0 0 "crictl pods --no-trunc failed"

    crictl pods --output json
    CHECK_RESULT $? 0 0 "crictl pods --output json failed"

    crictl pods --output yaml
    CHECK_RESULT $? 0 0 "crictl pods --output yaml failed"

    crictl pods --output table
    CHECK_RESULT $? 0 0 "crictl pods --output table failed"

    crictl pods --quiet
    CHECK_RESULT $? 0 0 "crictl pods --quiet failed"

    crictl pods --state "running"
    CHECK_RESULT $? 0 0 "crictl pods --state failed"

    crictl pods --verbose
    CHECK_RESULT $? 0 0 "crictl pods --verbose failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
