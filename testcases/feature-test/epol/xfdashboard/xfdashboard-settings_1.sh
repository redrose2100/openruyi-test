
#!/usr/bin/bash
# 测试xfdashboard-settings命令的基本用法和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfdashboard"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    xfdashboard-settings -h
    CHECK_RESULT $? 0 0 "xfdashboard-settings -h failed"
    
    # 测试 --help-all 选项
    xfdashboard-settings --help-all
    CHECK_RESULT $? 0 0 "xfdashboard-settings --help-all failed"
    
    # 测试 --help-gtk 选项
    xfdashboard-settings --help-gtk
    CHECK_RESULT $? 0 0 "xfdashboard-settings --help-gtk failed"
    
    # 测试 --version 选项
    xfdashboard-settings -V
    CHECK_RESULT $? 0 0 "xfdashboard-settings -V failed"
    
    # 测试 --socket-id 参数
    xfdashboard-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "xfdashboard-settings --socket-id=12345 failed"
    
    # 测试 --display 参数
    xfdashboard-settings --display=:0
    CHECK_RESULT $? 0 0 "xfdashboard-settings --display=:0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xfdashboard"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
