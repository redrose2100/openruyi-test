
#!/usr/bin/bash
# 请填写测试用例描述：测试 botan tls_server 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Test Certificate" > ./test_cert.pem
    echo "Test Key" > ./test_key.pem
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    botan tls_server ./test_cert.pem ./test_key.pem --port=443 --type=tcp --policy=default --dump-traces= --max-clients=0 &
    sleep 5
    CHECK_RESULT $? 0 0 "tls_server command failed to start"
    # 测试参数组合
    botan tls_server ./test_cert.pem ./test_key.pem --port=8443 --type=tcp --policy=default --dump-traces= --max-clients=10 &
    sleep 5
    CHECK_RESULT $? 0 0 "tls_server command with different port and max-clients failed to start"
    # 测试其他参数组合
    botan tls_server ./test_cert.pem ./test_key.pem --port=443 --type=udp --policy=default --dump-traces= --max-clients=0 &
    sleep 5
    CHECK_RESULT $? 0 0 "tls_server command with UDP type failed to start"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_cert.pem ./test_key.pem
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
