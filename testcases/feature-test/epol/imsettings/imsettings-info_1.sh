
#!/usr/bin/bash
# 测试用例描述：测试 imsettings-info 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "imsettings"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./xinput.conf"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本功能
    imsettings-info
    CHECK_RESULT $? 0 0 "imsettings-info command failed without arguments"
    
    # 测试命令的帮助选项
    imsettings-info -h
    CHECK_RESULT $? 0 0 "imsettings-info -h command failed"
    
    # 测试命令的输入参数
    imsettings-info "Input Method name"
    CHECK_RESULT $? 1 0 "imsettings-info with Input Method name failed"
    
    # 测试命令的配置文件参数
    imsettings-info "./xinput.conf"
    CHECK_RESULT $? 1 0 "imsettings-info with xinput.conf failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "imsettings"
    # 清理测试中间产物文件
    rm -f "./xinput.conf"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
