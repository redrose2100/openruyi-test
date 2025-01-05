
#!/usr/bin/bash
# 本测试用例用于测试kiran-session-manager命令的基本功能，包括帮助信息、版本信息、会话类型和自启动目录的指定。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kiran-session-manager"
    # 准备测试数据等
    mkdir -p ./autostart_dir
    touch ./autostart_dir/test.desktop
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    kiran-session-manager -h
    CHECK_RESULT $? 0 0 "Failed to display help information."
    
    # 测试版本信息
    kiran-session-manager -v
    CHECK_RESULT $? 0 0 "Failed to display version information."
    
    # 测试指定会话类型
    kiran-session-manager -s "default"
    CHECK_RESULT $? 0 0 "Failed to specify session type."
    
    # 测试自启动目录
    kiran-session-manager -a "./autostart_dir"
    CHECK_RESULT $? 0 0 "Failed to specify autostart directory."
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kiran-session-manager"
    # 清理测试中间产物文件
    rm -rf ./autostart_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
