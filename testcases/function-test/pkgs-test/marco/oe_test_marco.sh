
#!/usr/bin/bash
# 本测试用例用于测试marco命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "marco"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 参数
    marco --help
    CHECK_RESULT $? 0 0 "marco --help failed"

    # 测试 --version 参数
    marco --version
    CHECK_RESULT $? 0 0 "marco --version failed"

    # 测试 --sm-disable 参数
    marco --sm-disable
    CHECK_RESULT $? 0 0 "marco --sm-disable failed"

    # 测试 --replace 参数
    marco --replace
    CHECK_RESULT $? 0 0 "marco --replace failed"

    # 测试 --sm-client-id 参数
    marco --sm-client-id "test_id"
    CHECK_RESULT $? 0 0 "marco --sm-client-id failed"

    # 测试 --display 参数
    marco --display ":0"
    CHECK_RESULT $? 0 0 "marco --display failed"

    # 测试 --sm-save-file 参数
    touch ./savefile
    marco --sm-save-file "./savefile"
    CHECK_RESULT $? 0 0 "marco --sm-save-file failed"
    rm ./savefile

    # 测试 --sync 参数
    marco --sync
    CHECK_RESULT $? 0 0 "marco --sync failed"

    # 测试 --composite 参数
    marco --composite
    CHECK_RESULT $? 0 0 "marco --composite failed"

    # 测试 --no-composite 参数
    marco --no-composite
    CHECK_RESULT $? 0 0 "marco --no-composite failed"

    # 测试 --no-force-fullscreen 参数
    marco --no-force-fullscreen
    CHECK_RESULT $? 0 0 "marco --no-force-fullscreen failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "marco"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
