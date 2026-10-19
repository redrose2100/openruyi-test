
#!/usr/bin/bash
# 本测试用例用于测试botan2软件包中的base64_enc命令，确保其能够正确地对文件进行Base64编码。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "This is a test string." > ./test_input.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试base64_enc命令的基本功能
    botan base64_enc ./test_input.txt > ./test_output.txt
    CHECK_RESULT $? 0 0 "base64_enc command failed"
    # 检查输出文件是否正确
    cat ./test_output.txt | grep "VGhpcyBpcyBhIHRlc3Qgc3RyaW5nLg=="
    CHECK_RESULT $? 0 0 "base64_enc output is incorrect"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_input.txt ./test_output.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
