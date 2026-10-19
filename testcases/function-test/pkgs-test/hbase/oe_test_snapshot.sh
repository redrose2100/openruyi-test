
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase snapshot 命令的 create, info, export 子命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hbase"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建测试表
    hbase shell <<EOF
create 'test_table', 'cf'
EOF
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 create 子命令
    hbase --config ./conf snapshot create 'test_table' 'test_snapshot'
    CHECK_RESULT $? 0 0 "Failed to create snapshot"

    # 测试 info 子命令
    hbase --config ./conf snapshot info 'test_snapshot'
    CHECK_RESULT $? 0 0 "Failed to get snapshot info"

    # 测试 export 子命令
    hbase --config ./conf snapshot export 'test_snapshot' '/tmp/exported_snapshot'
    CHECK_RESULT $? 0 0 "Failed to export snapshot"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "hbase"
    # 清理测试中间产物文件
    rm -rf /tmp/exported_snapshot
    # 删除测试表
    hbase shell <<EOF
disable 'test_table'
drop 'test_table'
EOF
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
