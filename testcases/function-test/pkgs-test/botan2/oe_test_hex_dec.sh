
#!/usr/bin/bash
# 本测试用例用于测试botan2的hex_dec命令，该命令用于将给定的文件从十六进制解码。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "48656c6c6f20576f726c64" > ./test_hex_file
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试hex_dec命令的基本功能
    botan2 hex_dec ./test_hex_file
    CHECK_RESULT $? 0 0 "hex_dec command failed"
    # 检查输出是否正确
    botan2 hex_dec ./test_hex_file > ./output_file
    CHECK_RESULT $? 0 0 "hex_dec output redirection failed"
    grep "Hello World" ./output_file
    CHECK_RESULT $? 0 0 "hex_dec output is incorrect"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_hex_file
    rm -f ./output_file
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
