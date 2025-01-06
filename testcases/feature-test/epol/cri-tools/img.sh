
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl img 命令的各种参数组合和行为

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
    # 测试 crictl img 命令的基本用法
    crictl img
    CHECK_RESULT $? 0 0 "crictl img failed"

    # 测试 --digests 参数
    crictl img --digests
    CHECK_RESULT $? 0 0 "crictl img --digests failed"

    # 测试 --no-trunc 参数
    crictl img --no-trunc
    CHECK_RESULT $? 0 0 "crictl img --no-trunc failed"

    # 测试 --output 参数
    crictl img --output json
    CHECK_RESULT $? 0 0 "crictl img --output json failed"
    crictl img --output yaml
    CHECK_RESULT $? 0 0 "crictl img --output yaml failed"
    crictl img --output table
    CHECK_RESULT $? 0 0 "crictl img --output table failed"

    # 测试 --quiet 参数
    crictl img --quiet
    CHECK_RESULT $? 0 0 "crictl img --quiet failed"

    # 测试 --verbose 参数
    crictl img --verbose
    CHECK_RESULT $? 0 0 "crictl img --verbose failed"

    # 测试 REPOSITORY[:TAG] 参数
    crictl img "nginx:latest"
    CHECK_RESULT $? 0 0 "crictl img nginx:latest failed"

    # 测试多个参数组合
    crictl img --digests --no-trunc --output json --quiet --verbose "nginx:latest"
    CHECK_RESULT $? 0 0 "crictl img --digests --no-trunc --output json --quiet --verbose nginx:latest failed"

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
