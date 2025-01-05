
#!/usr/bin/bash
# 测试用例描述：测试htmlcxx命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "htmlcxx"
    # 准备测试数据
    echo "<html><body><h1>Test</h1></body></html>" > ./test.html
    echo "body { background-color: powderblue; }" > ./test.css
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    htmlcxx ./test.html
    CHECK_RESULT $? 0 0 "htmlcxx command failed to run with basic usage"
    
    # 测试命令的参数组合
    htmlcxx -h
    CHECK_RESULT $? 0 0 "htmlcxx command failed to run with -h option"
    
    htmlcxx -V
    CHECK_RESULT $? 0 0 "htmlcxx command failed to run with -V option"
    
    # 测试命令的文件参数
    htmlcxx ./test.html ./test.css
    CHECK_RESULT $? 0 0 "htmlcxx command failed to run with file parameters"
    
    # 测试命令的无效选项
    ! htmlcxx -x
    CHECK_RESULT $? 1 0 "htmlcxx command should fail with invalid option"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "htmlcxx"
    # 清理测试中间产物文件
    rm -f ./test.html ./test.css
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
