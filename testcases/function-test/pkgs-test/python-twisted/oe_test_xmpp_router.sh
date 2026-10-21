
#!/usr/bin/bash
# 请填写测试用例描述：测试 twistd xmpp-router 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-twisted"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    twistd --help
    CHECK_RESULT $? 0 0 "twistd --help failed"

    twistd --version
    CHECK_RESULT $? 0 0 "twistd --version failed"

    twistd --reactor=epoll xmpp-router
    CHECK_RESULT $? 0 0 "twistd --reactor=epoll xmpp-router failed"

    twistd --logfile=./twistd.log xmpp-router
    CHECK_RESULT $? 0 0 "twistd --logfile=./twistd.log xmpp-router failed"

    twistd --pidfile=./twistd.pid xmpp-router
    CHECK_RESULT $? 0 0 "twistd --pidfile=./twistd.pid xmpp-router failed"

    twistd --uid=1000 --gid=1000 xmpp-router
    CHECK_RESULT $? 0 0 "twistd --uid=1000 --gid=1000 xmpp-router failed"

    twistd --nodaemon xmpp-router
    CHECK_RESULT $? 0 0 "twistd --nodaemon xmpp-router failed"

    twistd --syslog xmpp-router
    CHECK_RESULT $? 0 0 "twistd --syslog xmpp-router failed"

    twistd --profiler=cprofile --profile=./profile.out xmpp-router
    CHECK_RESULT $? 0 0 "twistd --profiler=cprofile --profile=./profile.out xmpp-router failed"

    twistd --spew xmpp-router
    CHECK_RESULT $? 0 0 "twistd --spew xmpp-router failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "python-twisted"
    rm -f ./twistd.log ./twistd.pid ./profile.out
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
