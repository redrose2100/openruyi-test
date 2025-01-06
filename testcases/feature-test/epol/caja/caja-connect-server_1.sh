
#!/usr/bin/bash
# 请填写测试用例描述：测试 caja-connect-server 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "caja"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 caja-connect-server 命令的基本功能
    caja-connect-server
    CHECK_RESULT $? 0 0 "caja-connect-server command failed to run"

    # 测试 --help 参数
    caja-connect-server --help
    CHECK_RESULT $? 0 0 "caja-connect-server --help command failed"

    # 测试 --display 参数
    caja-connect-server --display=:0
    CHECK_RESULT $? 0 0 "caja-connect-server --display=:0 command failed"

    # 测试 --help-all 参数
    caja-connect-server --help-all
    CHECK_RESULT $? 0 0 "caja-connect-server --help-all command failed"

    # 测试 --help-gtk 参数
    caja-connect-server --help-gtk
    CHECK_RESULT $? 0 0 "caja-connect-server --help-gtk command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "caja"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
