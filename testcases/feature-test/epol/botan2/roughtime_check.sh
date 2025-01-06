
#!/usr/bin/bash
# 测试用例描述：测试 roughtime_check 命令，验证其是否能正确解析和验证 Roughtime 链文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Sample Roughtime chain data" > ./chain-file
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 roughtime_check 命令的基本用法
    botan roughtime_check --raw-time ./chain-file
    CHECK_RESULT $? 0 0 "roughtime_check command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./chain-file
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
