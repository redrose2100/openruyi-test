
#!/usr/bin/bash
# 请填写测试用例描述：测试 twistd socks 命令

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
    twistd --help | grep "socks"
    CHECK_RESULT $? 0 0 "twistd --help does not contain socks command"

    twistd --reactor=epoll socks --port=1080 --pidfile=./twistd.pid
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with epoll reactor"

    twistd --reactor=select socks --port=1081 --pidfile=./twistd.pid
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with select reactor"

    twistd --reactor=auto socks --port=1082 --pidfile=./twistd.pid
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with auto reactor"

    twistd --reactor=auto socks --port=1083 --pidfile=./twistd.pid --logfile=./twistd.log
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with auto reactor and logfile"

    twistd --reactor=auto socks --port=1084 --pidfile=./twistd.pid --logfile=- --syslog
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with auto reactor, logfile and syslog"

    twistd --reactor=auto socks --port=1085 --pidfile=./twistd.pid --logfile=- --syslog --uid=1000 --gid=1000
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with auto reactor, logfile, syslog, uid and gid"

    twistd --reactor=auto socks --port=1086 --pidfile=./twistd.pid --logfile=- --syslog --uid=1000 --gid=1000 --umask=0022
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with auto reactor, logfile, syslog, uid, gid and umask"

    twistd --reactor=auto socks --port=1087 --pidfile=./twistd.pid --logfile=- --syslog --uid=1000 --gid=1000 --umask=0022 --nodaemon
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with auto reactor, logfile, syslog, uid, gid, umask and nodaemon"

    twistd --reactor=auto socks --port=1088 --pidfile=./twistd.pid --logfile=- --syslog --uid=1000 --gid=1000 --umask=0022 --nodaemon --debug
    CHECK_RESULT $? 0 0 "twistd socks command failed to start with auto reactor, logfile, syslog, uid, gid, umask, nodaemon and debug"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "python-twisted"
    rm -f ./twistd.pid ./twistd.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
