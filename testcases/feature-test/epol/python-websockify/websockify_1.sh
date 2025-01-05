
#!/usr/bin/bash
# 测试用例描述：测试websockify命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-websockify"
    # 准备测试数据等
    mkdir -p ./test_web
    echo "Hello, World!" > ./test_web/index.html
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 基本功能测试
    websockify 127.0.0.1:9000
    CHECK_RESULT $? 0 0 "websockify basic function test failed"

    # 测试参数组合
    websockify --verbose 127.0.0.1:9001
    CHECK_RESULT $? 0 0 "websockify --verbose test failed"

    websockify --record=./test_websockify 127.0.0.1:9002
    CHECK_RESULT $? 0 0 "websockify --record test failed"

    websockify --timeout=30 127.0.0.1:9003
    CHECK_RESULT $? 0 0 "websockify --timeout test failed"

    websockify --idle-timeout=60 127.0.0.1:9004
    CHECK_RESULT $? 0 0 "websockify --idle-timeout test failed"

    websockify --cert=./test_cert.pem --key=./test_key.pem 127.0.0.1:9005
    CHECK_RESULT $? 0 0 "websockify --cert --key test failed"

    websockify --ssl-only 127.0.0.1:9006
    CHECK_RESULT $? 0 0 "websockify --ssl-only test failed"

    websockify --ssl-target 127.0.0.1:9007
    CHECK_RESULT $? 0 0 "websockify --ssl-target test failed"

    websockify --web=./test_web 127.0.0.1:9008
    CHECK_RESULT $? 0 0 "websockify --web test failed"

    websockify --web-auth 127.0.0.1:9009
    CHECK_RESULT $? 0 0 "websockify --web-auth test failed"

    websockify --wrap-mode=ignore 127.0.0.1:9010
    CHECK_RESULT $? 0 0 "websockify --wrap-mode test failed"

    websockify --log-file=./test_websockify.log 127.0.0.1:9011
    CHECK_RESULT $? 0 0 "websockify --log-file test failed"

    websockify --syslog=/dev/log 127.0.0.1:9012
    CHECK_RESULT $? 0 0 "websockify --syslog test failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-websockify"
    # 清理测试中间产物文件
    rm -rf ./test_web
    rm -f ./test_websockify.*
    rm -f ./test_websockify.log
    rm -f ./test_cert.pem
    rm -f ./test_key.pem
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
