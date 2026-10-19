
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase hbck 命令的基本功能和参数组合

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
    # 测试 hbase hbck 命令的基本功能
    hbase hbck
    CHECK_RESULT $? 0 0 "hbase hbck command failed"

    # 测试 hbase hbck 命令的参数组合
    hbase hbck --auth-as-server
    CHECK_RESULT $? 0 0 "hbase hbck --auth-as-server command failed"

    hbase hbck --config ./conf
    CHECK_RESULT $? 0 0 "hbase hbck --config ./conf command failed"

    hbase hbck --hosts localhost
    CHECK_RESULT $? 0 0 "hbase hbck --hosts localhost command failed"

    hbase hbck --auth-as-server --config ./conf --hosts localhost
    CHECK_RESULT $? 0 0 "hbase hbck --auth-as-server --config ./conf --hosts localhost command failed"

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
