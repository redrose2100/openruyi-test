
#!/usr/bin/bash
# 测试用例描述：测试 im-chooser 命令的各种帮助选项和应用选项

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "im-chooser"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    im-chooser --help
    CHECK_RESULT $? 0 0 "im-chooser --help failed"
    
    im-chooser --help-all
    CHECK_RESULT $? 0 0 "im-chooser --help-all failed"
    
    im-chooser --help-gtk
    CHECK_RESULT $? 0 0 "im-chooser --help-gtk failed"
    
    im-chooser --help-sm-client
    CHECK_RESULT $? 0 0 "im-chooser --help-sm-client failed"
    
    # 测试应用选项
    im-chooser --display=:0.0
    CHECK_RESULT $? 0 0 "im-chooser --display=:0.0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "im-chooser"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
