
#!/usr/bin/bash
# 本测试用例用于测试kf5-kjs命令的基本功能，包括帮助信息、版本信息以及执行脚本和语句。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-kjs"
    # 准备测试数据
    echo "print('Hello, World!');" > ./test_script.js
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    kjs5 -h
    CHECK_RESULT $? 0 0 "Failed to display help information"
    
    # 测试版本信息
    kjs5 -v
    CHECK_RESULT $? 0 0 "Failed to display version information"
    
    # 测试执行脚本
    kjs5 ./test_script.js
    CHECK_RESULT $? 0 0 "Failed to execute script"
    
    # 测试执行语句
    kjs5 -e "print('Hello, World!');"
    CHECK_RESULT $? 0 0 "Failed to execute statement"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-kjs"
    # 清理测试中间产物文件
    rm -f ./test_script.js
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
