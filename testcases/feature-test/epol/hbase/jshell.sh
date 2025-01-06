
#!/usr/bin/bash
# 请填写测试用例描述：测试 hbase jshell 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "hbase"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./conf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 hbase jshell 命令的基本用法
    hbase jshell
    CHECK_RESULT $? 0 0 "hbase jshell command failed"

    # 测试 hbase jshell 命令加上 --config 参数
    hbase --config ./conf jshell
    CHECK_RESULT $? 0 0 "hbase jshell command with --config failed"

    # 测试 hbase jshell 命令加上 --auth-as-server 参数
    hbase --auth-as-server jshell
    CHECK_RESULT $? 0 0 "hbase jshell command with --auth-as-server failed"

    # 测试 hbase jshell 命令加上 --internal-classpath 参数
    hbase --internal-classpath jshell
    CHECK_RESULT $? 0 0 "hbase jshell command with --internal-classpath failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "hbase"
    # 清理测试中间产物文件
    rm -rf ./conf
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
