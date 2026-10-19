
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase shell 命令

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
    # 测试 hbase shell 命令的基本用法
    hbase shell -h
    CHECK_RESULT $? 0 0 "hbase shell -h failed"

    # 测试 hbase shell 命令的配置目录选项
    hbase --config ./conf shell -h
    CHECK_RESULT $? 0 0 "hbase --config ./conf shell -h failed"

    # 测试 hbase shell 命令的主机列表选项
    hbase --hosts localhost shell -h
    CHECK_RESULT $? 0 0 "hbase --hosts localhost shell -h failed"

    # 测试 hbase shell 命令的认证选项
    hbase --auth-as-server shell -h
    CHECK_RESULT $? 0 0 "hbase --auth-as-server shell -h failed"

    # 测试 hbase shell 命令的内部类路径选项
    hbase --internal-classpath shell -h
    CHECK_RESULT $? 0 0 "hbase --internal-classpath shell -h failed"
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
