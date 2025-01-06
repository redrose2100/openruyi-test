
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase ltt 命令的各种参数组合

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
    # 测试基本参数组合
    hbase ltt -tn test_table -families cf1 -write 1:100 -read 100
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with basic parameters"

    # 测试多参数组合
    hbase ltt -tn test_table -families cf1,cf2 -write 1:100:10 -read 50:10 -update 20:10:0
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with multiple parameters"

    # 测试初始化参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -init_only
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with init_only parameter"

    # 测试压缩参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -compression GZ
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with compression parameter"

    # 测试多表参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -num_tables 2
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with num_tables parameter"

    # 测试多线程参数
    hbase ltt -tn test_table -families cf1 -write 1:100:20 -read 50:20 -update 20:20:0
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with multi-thread parameters"

    # 测试忽略初始化参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -skip_init
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with skip_init parameter"

    # 测试多区域参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -num_regions_per_server 10
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with num_regions_per_server parameter"

    # 测试区域副本参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -region_replication 2
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with region_replication parameter"

    # 测试区域副本ID参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -region_replica_id 1
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with region_replica_id parameter"

    # 测试MOB阈值参数
    hbase ltt -tn test_table -families cf1 -write 1:100 -mob_threshold 1000
    CHECK_RESULT $? 0 0 "failed to run hbase ltt with mob_threshold parameter"

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
