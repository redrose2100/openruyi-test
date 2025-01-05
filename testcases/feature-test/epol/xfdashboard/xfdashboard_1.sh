
#!/usr/bin/bash
# 本测试脚本用于测试xfdashboard命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfdashboard"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfdashboard --help
    CHECK_RESULT $? 0 0 "xfdashboard --help failed"
    xfdashboard --help-all
    CHECK_RESULT $? 0 0 "xfdashboard --help-all failed"
    xfdashboard --help-gtk
    CHECK_RESULT $? 0 0 "xfdashboard --help-gtk failed"
    xfdashboard --help-clutter
    CHECK_RESULT $? 0 0 "xfdashboard --help-clutter failed"
    xfdashboard --help-sm-client
    CHECK_RESULT $? 0 0 "xfdashboard --help-sm-client failed"

    # 测试应用选项
    xfdashboard -d
    CHECK_RESULT $? 0 0 "xfdashboard -d failed"
    xfdashboard -q
    CHECK_RESULT $? 0 0 "xfdashboard -q failed"
    xfdashboard -r
    CHECK_RESULT $? 0 0 "xfdashboard -r failed"
    xfdashboard -t
    CHECK_RESULT $? 0 0 "xfdashboard -t failed"
    xfdashboard --view=1
    CHECK_RESULT $? 0 0 "xfdashboard --view=1 failed"
    xfdashboard -v
    CHECK_RESULT $? 0 0 "xfdashboard -v failed"
    xfdashboard --display=:0
    CHECK_RESULT $? 0 0 "xfdashboard --display=:0 failed"
    xfdashboard --clutter-display=:0
    CHECK_RESULT $? 0 0 "xfdashboard --clutter-display=:0 failed"
    xfdashboard --screen=0
    CHECK_RESULT $? 0 0 "xfdashboard --screen=0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfdashboard"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
