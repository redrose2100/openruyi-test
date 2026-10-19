
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl info 命令的不同参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl info 命令的基本用法
    crictl info
    CHECK_RESULT $? 0 0 "crictl info failed"

    # 测试 crictl info 命令的 --output 参数
    crictl info --output json
    CHECK_RESULT $? 0 0 "crictl info --output json failed"

    crictl info --output yaml
    CHECK_RESULT $? 0 0 "crictl info --output yaml failed"

    crictl info --output go-template
    CHECK_RESULT $? 0 0 "crictl info --output go-template failed"

    # 测试 crictl info 命令的 --quiet 参数
    crictl info --quiet
    CHECK_RESULT $? 0 0 "crictl info --quiet failed"

    # 测试 crictl info 命令的 --template 参数
    crictl info --template "{{.Runtime.Version}}"
    CHECK_RESULT $? 0 0 "crictl info --template failed"

    # 测试 crictl info 命令的 --output 和 --template 参数组合
    crictl info --output go-template --template "{{.Runtime.Version}}"
    CHECK_RESULT $? 0 0 "crictl info --output go-template --template failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -rf ./test_data
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
