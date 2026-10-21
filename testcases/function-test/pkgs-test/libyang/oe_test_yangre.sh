
#!/usr/bin/bash
# 测试用例描述：测试libyang的yangre命令，验证其正则表达式处理功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "libyang"
    # 准备测试数据
    echo -e '"[0-9a-fA-F]*"\n1F' > ./test_data1.txt
    echo -e '"[a-zA-Z0-9\\-_.]*"\na-b' > ./test_data2.txt
    echo -e '"[xX][mM][lL].*"\nxml-encoding' > ./test_data3.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    yangre -h
    CHECK_RESULT $? 0 0 "yangre -h failed"
    # 测试版本信息
    yangre -v
    CHECK_RESULT $? 0 0 "yangre -v failed"
    # 测试正则表达式匹配
    yangre -p '"[0-9a-fA-F]*"' '1F'
    CHECK_RESULT $? 0 0 "yangre -p '[0-9a-fA-F]*' '1F' failed"
    # 测试正则表达式不匹配
    yangre -p '"[0-9a-fA-F]*"' 'AB'
    CHECK_RESULT $? 1 0 "yangre -p '[0-9a-fA-F]*' 'AB' failed"
    # 测试invert-match
    yangre -p '"[0-9a-fA-F]*"' -i '1F'
    CHECK_RESULT $? 1 0 "yangre -p '[0-9a-fA-F]*' -i '1F' failed"
    # 测试从文件读取模式和字符串
    yangre -f ./test_data1.txt
    CHECK_RESULT $? 0 0 "yangre -f ./test_data1.txt failed"
    yangre -f ./test_data2.txt
    CHECK_RESULT $? 0 0 "yangre -f ./test_data2.txt failed"
    yangre -f ./test_data3.txt
    CHECK_RESULT $? 0 0 "yangre -f ./test_data3.txt failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "libyang"
    # 清理测试中间产物文件
    rm -f ./test_data1.txt ./test_data2.txt ./test_data3.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
