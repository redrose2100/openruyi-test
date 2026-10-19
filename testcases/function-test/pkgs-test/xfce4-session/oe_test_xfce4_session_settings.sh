
#!/usr/bin/bash
# 测试xfce4-session-settings命令的各个选项，包括帮助选项、版本信息选项、socket-id选项和display选项

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-session"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -h, --help 选项
    xfce4-session-settings -h
    CHECK_RESULT $? 0 0 "failed to run xfce4-session-settings -h"
    
    # 测试 --help-all 选项
    xfce4-session-settings --help-all
    CHECK_RESULT $? 0 0 "failed to run xfce4-session-settings --help-all"
    
    # 测试 --help-gtk 选项
    xfce4-session-settings --help-gtk
    CHECK_RESULT $? 0 0 "failed to run xfce4-session-settings --help-gtk"
    
    # 测试 -V, --version 选项
    xfce4-session-settings -V
    CHECK_RESULT $? 0 0 "failed to run xfce4-session-settings -V"
    
    # 测试 -s, --socket-id 选项
    xfce4-session-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "failed to run xfce4-session-settings --socket-id=12345"
    
    # 测试 --display 选项
    xfce4-session-settings --display=:0
    CHECK_RESULT $? 0 0 "failed to run xfce4-session-settings --display=:0"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-session"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
