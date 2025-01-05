
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase 的 local-regionservers.sh 命令的 stop 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hbase"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    local-regionservers.sh stop 1
    CHECK_RESULT $? 0 0 "local-regionservers.sh stop 1 failed"
    
    local-regionservers.sh stop 2
    CHECK_RESULT $? 0 0 "local-regionservers.sh stop 2 failed"
    
    local-regionservers.sh stop 1 2
    CHECK_RESULT $? 0 0 "local-regionservers.sh stop 1 2 failed"
    
    local-regionservers.sh stop
    CHECK_RESULT $? 1 0 "local-regionservers.sh stop without offset(s) should fail"
    
    local-regionservers.sh --config ./conf-dir stop 1
    CHECK_RESULT $? 0 0 "local-regionservers.sh --config ./conf-dir stop 1 failed"
    
    local-regionservers.sh --autostart-window-size 2 stop 1
    CHECK_RESULT $? 0 0 "local-regionservers.sh --autostart-window-size 2 stop 1 failed"
    
    local-regionservers.sh --autostart-window-retry-limit 3 stop 1
    CHECK_RESULT $? 0 0 "local-regionservers.sh --autostart-window-retry-limit 3 stop 1 failed"
    
    local-regionservers.sh --config ./conf-dir --autostart-window-size 2 --autostart-window-retry-limit 3 stop 1
    CHECK_RESULT $? 0 0 "local-regionservers.sh --config ./conf-dir --autostart-window-size 2 --autostart-window-retry-limit 3 stop 1 failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "hbase"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
