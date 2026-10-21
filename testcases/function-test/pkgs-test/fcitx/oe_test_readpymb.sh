
#!/usr/bin/bash
# 测试用例描述：测试readPYMB命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    # 准备测试数据
    touch "./test.mb"
    echo "test data" > "./test.mb"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    readPYMB -f "./test.mb"
    CHECK_RESULT $? 0 0 "readPYMB -f failed"
    
    # 测试命令的-s参数
    readPYMB -f "./test.mb" -s
    CHECK_RESULT $? 0 0 "readPYMB -f -s failed"
    
    # 测试命令的-h参数
    readPYMB -h
    CHECK_RESULT $? 0 0 "readPYMB -h failed"
    
    # 测试命令的默认文件路径
    readPYMB -f "~/.config/fcitx/pyusrphrase.mb"
    CHECK_RESULT $? 0 0 "readPYMB default file failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "fcitx"
    # 清理测试中间产物文件
    rm -f "./test.mb"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
