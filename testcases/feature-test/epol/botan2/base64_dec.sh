
#!/usr/bin/bash
# 本测试用例用于测试botan2软件包中的base64_dec命令，该命令用于解码Base64编码的文件。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "SGVsbG8gV29ybGQh" > ./encoded.txt  # Base64编码的"Hello World!"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试base64_dec命令
    botan base64_dec ./encoded.txt > ./decoded.txt
    CHECK_RESULT $? 0 0 "base64_dec command failed"
    # 检查解码后的文件内容是否正确
    cat ./decoded.txt | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Decoded content is not correct"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./encoded.txt ./decoded.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
