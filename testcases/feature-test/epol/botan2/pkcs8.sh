
#!/usr/bin/bash
# 测试botan的pkcs8命令，包括各种参数组合和参数顺序

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "testkey" > ./testkey.pem
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    botan2 pkcs8 --pass-in=test123 --pub-out --der-out --pass-out=test123 --pbe=aes256cbc --pbe-millis=300 ./testkey.pem
    CHECK_RESULT $? 0 0 "botan2 pkcs8 command failed with all parameters"

    botan2 pkcs8 --pub-out --der-out ./testkey.pem
    CHECK_RESULT $? 0 0 "botan2 pkcs8 command failed with --pub-out and --der-out parameters"

    botan2 pkcs8 --pass-in=test123 --pass-out=test123 ./testkey.pem
    CHECK_RESULT $? 0 0 "botan2 pkcs8 command failed with --pass-in and --pass-out parameters"

    botan2 pkcs8 --pbe=aes256cbc --pbe-millis=300 ./testkey.pem
    CHECK_RESULT $? 0 0 "botan2 pkcs8 command failed with --pbe and --pbe-millis parameters"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "botan2"
    rm -f ./testkey.pem
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
