
#!/usr/bin/bash
# 本测试用例用于测试xfce4-appfinder命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-appfinder"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfce4-appfinder --help
    CHECK_RESULT $? 0 0 "xfce4-appfinder --help failed"
    
    # 测试所有帮助选项
    xfce4-appfinder --help-all
    CHECK_RESULT $? 0 0 "xfce4-appfinder --help-all failed"
    
    # 测试GTK+选项
    xfce4-appfinder --help-gtk
    CHECK_RESULT $? 0 0 "xfce4-appfinder --help-gtk failed"
    
    # 测试版本信息
    xfce4-appfinder --version
    CHECK_RESULT $? 0 0 "xfce4-appfinder --version failed"
    
    # 测试替换现有服务
    xfce4-appfinder --replace
    CHECK_RESULT $? 0 0 "xfce4-appfinder --replace failed"
    
    # 测试退出所有实例
    xfce4-appfinder --quit
    CHECK_RESULT $? 0 0 "xfce4-appfinder --quit failed"
    
    # 测试不使用或成为D-Bus服务
    xfce4-appfinder --disable-server
    CHECK_RESULT $? 0 0 "xfce4-appfinder --disable-server failed"
    
    # 测试X display选项
    xfce4-appfinder --display=:0
    CHECK_RESULT $? 0 0 "xfce4-appfinder --display=:0 failed"
    
    # 测试折叠模式
    xfce4-appfinder --collapsed
    CHECK_RESULT $? 0 0 "xfce4-appfinder --collapsed failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-appfinder"
    # 清理测试中间产物文件
    rm -rf ./testfile*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
