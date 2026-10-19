
#!/usr/bin/bash
# 测试 mate-terminal 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-terminal"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./test-config.conf"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 help 选项
    mate-terminal --help
    CHECK_RESULT $? 0 0 "failed to run --help"
    
    mate-terminal --help-all
    CHECK_RESULT $? 0 0 "failed to run --help-all"
    
    mate-terminal --help-terminal
    CHECK_RESULT $? 0 0 "failed to run --help-terminal"
    
    mate-terminal --help-window-options
    CHECK_RESULT $? 0 0 "failed to run --help-window-options"
    
    mate-terminal --help-terminal-options
    CHECK_RESULT $? 0 0 "failed to run --help-terminal-options"
    
    mate-terminal --help-gtk
    CHECK_RESULT $? 0 0 "failed to run --help-gtk"
    
    mate-terminal --help-sm-client
    CHECK_RESULT $? 0 0 "failed to run --help-sm-client"
    
    # 测试应用选项
    mate-terminal --disable-factory
    CHECK_RESULT $? 0 0 "failed to run --disable-factory"
    
    mate-terminal --load-config=./test-config.conf
    CHECK_RESULT $? 0 0 "failed to run --load-config"
    
    mate-terminal --save-config=./test-config.conf
    CHECK_RESULT $? 0 0 "failed to run --save-config"
    
    mate-terminal --display=:0
    CHECK_RESULT $? 0 0 "failed to run --display"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mate-terminal"
    # 清理测试中间产物文件
    rm -f "./test-config.conf"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
