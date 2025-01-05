
#!/usr/bin/bash
# 请填写测试用例描述：测试 twistd portforward 命令

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
    twistd portforward --help
    CHECK_RESULT $? 0 0 "twistd portforward --help failed"
    
    twistd portforward --listen=127.0.0.1:8080 --connect=127.0.0.1:80
    CHECK_RESULT $? 0 0 "twistd portforward --listen=127.0.0.1:8080 --connect=127.0.0.1:80 failed"
    
    twistd portforward --listen=127.0.0.1:8081 --connect=127.0.0.1:81 --pidfile=./twistd.pid
    CHECK_RESULT $? 0 0 "twistd portforward --listen=127.0.0.1:8081 --connect=127.0.0.1:81 --pidfile=./twistd.pid failed"
    
    twistd portforward --listen=127.0.0.1:8082 --connect=127.0.0.1:82 --logfile=./twistd.log
    CHECK_RESULT $? 0 0 "twistd portforward --listen=127.0.0.1:8082 --connect=127.0.0.1:82 --logfile=./twistd.log failed"
    
    twistd portforward --listen=127.0.0.1:8083 --connect=127.0.0.1:83 --nodaemon
    CHECK_RESULT $? 0 0 "twistd portforward --listen=127.0.0.1:8083 --connect=127.0.0.1:83 --nodaemon failed"
    
    twistd portforward --listen=127.0.0.1:8084 --connect=127.0.0.1:84 --logfile=- --nodaemon
    CHECK_RESULT $? 0 0 "twistd portforward --listen=127.0.0.1:8084 --connect=127.0.0.1:84 --logfile=- --nodaemon failed"
    
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
