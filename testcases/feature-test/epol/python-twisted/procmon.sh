
#!/usr/bin/bash
# 请填写测试用例描述：测试 twistd procmon 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-twisted"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_data
    touch ./test_data/test_process
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    twistd --help | grep "procmon"
    CHECK_RESULT $? 0 0 "twistd --help does not contain procmon command"

    twistd procmon --help
    CHECK_RESULT $? 0 0 "twistd procmon --help failed"

    twistd procmon --pidfile=./test_data/twistd.pid --logfile=./test_data/twistd.log --rundir=./test_data
    CHECK_RESULT $? 0 0 "twistd procmon failed to start with specified options"

    twistd procmon --pidfile=./test_data/twistd.pid --logfile=- --rundir=./test_data
    CHECK_RESULT $? 0 0 "twistd procmon failed to start with stdout logging"

    twistd procmon --pidfile=./test_data/twistd.pid --logfile=./test_data/twistd.log --rundir=./test_data --uid=1000 --gid=1000
    CHECK_RESULT $? 0 0 "twistd procmon failed to start with specified uid and gid"

    twistd procmon --pidfile=./test_data/twistd.pid --logfile=./test_data/twistd.log --rundir=./test_data --nodaemon
    CHECK_RESULT $? 0 0 "twistd procmon failed to start in nodaemon mode"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "python-twisted"
    rm -rf ./test_data
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
