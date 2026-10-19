
#!/usr/bin/bash
# 本测试用例用于测试 mate-system-log 命令的基本功能，包括显示帮助信息、显示版本信息等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-utils"
    # 创建测试日志文件
    touch ./testfile.log
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试显示帮助信息
    mate-system-log --help
    CHECK_RESULT $? 0 0 "Failed to show help options"

    # 测试显示所有帮助信息
    mate-system-log --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"

    # 测试显示 GTK+ 选项
    mate-system-log --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"

    # 测试显示版本信息
    mate-system-log --version
    CHECK_RESULT $? 0 0 "Failed to show version information"

    # 测试指定显示设备
    mate-system-log --display=:0.0
    CHECK_RESULT $? 1 0 "Failed to specify display"

    # 测试指定日志文件
    mate-system-log ./testfile.log
    CHECK_RESULT $? 0 0 "Failed to specify log file"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-utils"
    # 清理测试中间产物文件
    rm -rf ./testfile.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
