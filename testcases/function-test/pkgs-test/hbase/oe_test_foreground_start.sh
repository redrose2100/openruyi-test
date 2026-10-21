
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase-daemon.sh 的 foreground_start 命令

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
    # 测试 hbase-daemon.sh foreground_start 命令
    hbase-daemon.sh foreground_start hbase-master
    CHECK_RESULT $? 0 0 "hbase-daemon.sh foreground_start hbase-master failed"
    
    hbase-daemon.sh --config /etc/hbase foreground_start hbase-master
    CHECK_RESULT $? 0 0 "hbase-daemon.sh --config /etc/hbase foreground_start hbase-master failed"
    
    hbase-daemon.sh foreground_start hbase-regionserver
    CHECK_RESULT $? 0 0 "hbase-daemon.sh foreground_start hbase-regionserver failed"
    
    hbase-daemon.sh --config /etc/hbase foreground_start hbase-regionserver
    CHECK_RESULT $? 0 0 "hbase-daemon.sh --config /etc/hbase foreground_start hbase-regionserver failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "hbase"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
