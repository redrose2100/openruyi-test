
#!/usr/bin/bash
# 本测试用例用于测试 hbase-daemons.sh 的 autorestart 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hbase"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建 regionservers 文件
    echo "localhost" > ./regionservers
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 autorestart 命令
    hbase-daemons.sh --config /etc/hbase --hosts ./regionservers autorestart help
    CHECK_RESULT $? 0 0 "autorestart command failed"
    # 检查日志文件是否存在
    test -f /var/log/hbase/hbase-root-help-ecs-for-eulercopilot-master.out
    CHECK_RESULT $? 0 0 "log file not found"
    # 检查 pid 文件是否存在
    test -f /var/run/hbase/hbase-root-help.pid
    CHECK_RESULT $? 0 0 "pid file not found"
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
    rm -f /var/log/hbase/hbase-root-help-ecs-for-eulercopilot-master.out
    rm -f /var/run/hbase/hbase-root-help.pid
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
