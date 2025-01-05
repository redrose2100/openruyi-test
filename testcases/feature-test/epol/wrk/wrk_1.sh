
#!/usr/bin/bash
# 测试wrk命令的基本功能，包括连接数、测试时长、线程数、Lua脚本、请求头、延迟统计、超时设置和版本信息

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "wrk"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo 'request = wrk.format("GET / HTTP/1.1\r\nHost: localhost\r\n\r\n")' > ./test_script.lua
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    wrk -c 10 -d 10s -t 2 -s ./test_script.lua http://localhost
    CHECK_RESULT $? 0 0 "wrk command failed with -c, -d, -t, -s options"

    wrk -H "Content-Type: application/json" --latency --timeout 5s http://localhost
    CHECK_RESULT $? 0 0 "wrk command failed with -H, --latency, --timeout options"

    wrk -c 100 -d 1m -t 4 http://localhost
    CHECK_RESULT $? 0 0 "wrk command failed with -c, -d, -t options"

    wrk -v
    CHECK_RESULT $? 0 0 "wrk command failed with -v option"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "wrk"
    rm -f ./test_script.lua
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
