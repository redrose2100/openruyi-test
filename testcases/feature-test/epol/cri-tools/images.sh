
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl images 命令及其参数

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
    # 测试 crictl images 命令及其参数
    crictl images
    CHECK_RESULT $? 0 0 "crictl images failed"

    crictl images --digests
    CHECK_RESULT $? 0 0 "crictl images --digests failed"

    crictl images --no-trunc
    CHECK_RESULT $? 0 0 "crictl images --no-trunc failed"

    crictl images --output json
    CHECK_RESULT $? 0 0 "crictl images --output json failed"

    crictl images --output yaml
    CHECK_RESULT $? 0 0 "crictl images --output yaml failed"

    crictl images --output table
    CHECK_RESULT $? 0 0 "crictl images --output table failed"

    crictl images --quiet
    CHECK_RESULT $? 0 0 "crictl images --quiet failed"

    crictl images --verbose
    CHECK_RESULT $? 0 0 "crictl images --verbose failed"

    crictl images --digests --no-trunc --output json --quiet --verbose
    CHECK_RESULT $? 0 0 "crictl images --digests --no-trunc --output json --quiet --verbose failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "cri-tools"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
