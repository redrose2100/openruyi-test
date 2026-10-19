
#!/usr/bin/bash
# 本测试脚本用于测试caja命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "caja"
    # 准备测试数据等
    mkdir -p ./testdir
    touch ./testfile
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    caja --help
    CHECK_RESULT $? 0 0 "caja --help failed"
    
    caja --help-all
    CHECK_RESULT $? 0 0 "caja --help-all failed"
    
    caja --help-gtk
    CHECK_RESULT $? 0 0 "caja --help-gtk failed"
    
    caja --help-sm-client
    CHECK_RESULT $? 0 0 "caja --help-sm-client failed"
    
    # 测试应用选项
    caja --version
    CHECK_RESULT $? 0 0 "caja --version failed"
    
    caja --geometry=800x600
    CHECK_RESULT $? 0 0 "caja --geometry=800x600 failed"
    
    caja --no-default-window ./testdir
    CHECK_RESULT $? 0 0 "caja --no-default-window failed"
    
    caja --no-desktop
    CHECK_RESULT $? 0 0 "caja --no-desktop failed"
    
    caja --force-desktop
    CHECK_RESULT $? 0 0 "caja --force-desktop failed"
    
    caja --tabs ./testdir ./testfile
    CHECK_RESULT $? 0 0 "caja --tabs failed"
    
    caja --browser
    CHECK_RESULT $? 0 0 "caja --browser failed"
    
    caja --quit
    CHECK_RESULT $? 0 0 "caja --quit failed"
    
    caja --display=:0.0
    CHECK_RESULT $? 0 0 "caja --display=:0.0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "caja"
    rm -rf ./testdir ./testfile
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
