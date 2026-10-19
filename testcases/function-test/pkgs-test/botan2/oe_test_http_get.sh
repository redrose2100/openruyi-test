
#!/usr/bin/bash
# 测试botan http_get命令，验证其基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    wget -O ./testfile.txt https://example.com/testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    botan http_get --redirects=1 --timeout=3000 https://example.com/testfile.txt
    CHECK_RESULT $? 0 0 "botan http_get command failed"

    # 测试不同的参数组合
    botan http_get --redirects=0 --timeout=1000 https://example.com/testfile.txt
    CHECK_RESULT $? 0 0 "botan http_get command with redirects=0 failed"

    botan http_get --redirects=1 --timeout=5000 https://example.com/testfile.txt
    CHECK_RESULT $? 0 0 "botan http_get command with timeout=5000 failed"

    # 测试错误情况
    botan http_get --redirects=1 --timeout=3000 https://invalid-url.com/testfile.txt
    CHECK_RESULT $? 1 0 "botan http_get command with invalid URL should fail"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "botan2"
    rm -f ./testfile.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
