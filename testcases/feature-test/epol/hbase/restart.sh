
#!/usr/bin/bash
# 测试 hbase-daemons.sh restart 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hbase"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "localhost" > ./regionservers
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 hbase-daemons.sh restart 命令
    hbase-daemons.sh --config /etc/hbase --hosts ./regionservers restart
    CHECK_RESULT $? 0 0 "hbase-daemons.sh restart failed"

    # 测试 hbase-daemons.sh restart 命令带 --autostart-window-size 参数
    hbase-daemons.sh --config /etc/hbase --hosts ./regionservers --autostart-window-size 2 restart
    CHECK_RESULT $? 0 0 "hbase-daemons.sh restart with --autostart-window-size failed"

    # 测试 hbase-daemons.sh restart 命令带 --autostart-window-retry-limit 参数
    hbase-daemons.sh --config /etc/hbase --hosts ./regionservers --autostart-window-retry-limit 3 restart
    CHECK_RESULT $? 0 0 "hbase-daemons.sh restart with --autostart-window-retry-limit failed"

    # 测试 hbase-daemons.sh restart 命令带 --autostart-window-size 和 --autostart-window-retry-limit 参数
    hbase-daemons.sh --config /etc/hbase --hosts ./regionservers --autostart-window-size 2 --autostart-window-retry-limit 3 restart
    CHECK_RESULT $? 0 0 "hbase-daemons.sh restart with --autostart-window-size and --autostart-window-retry-limit failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "hbase"
    # 清理测试中间产物文件
    rm -f ./regionservers
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
