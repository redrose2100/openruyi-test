
#!/usr/bin/bash
# 本测试用例用于测试botan2软件包中的base58_enc命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Hello, World!" > ./test_input.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试base58_enc命令的基本功能
    botan base58_enc --check ./test_input.txt
    CHECK_RESULT $? 0 0 "base58_enc command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_input.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
