
#!/usr/bin/bash
# 测试 twistd ftp 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-twisted"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./ftp_data
    touch ./ftp_data/testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    twistd --help | grep "ftp"
    CHECK_RESULT $? 0 0 "twistd --help does not contain ftp command"

    twistd ftp --help | grep "usage"
    CHECK_RESULT $? 0 0 "twistd ftp --help does not contain usage information"

    twistd -n ftp --port 2121 --root ./ftp_data
    CHECK_RESULT $? 0 0 "twistd ftp command failed to start"

    # 检查是否生成了twistd.pid文件
    test -f twistd.pid
    CHECK_RESULT $? 0 0 "twistd.pid file not found"

    # 停止twistd ftp服务
    kill `cat twistd.pid`
    rm twistd.pid
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "python-twisted"
    rm -rf ./ftp_data
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
