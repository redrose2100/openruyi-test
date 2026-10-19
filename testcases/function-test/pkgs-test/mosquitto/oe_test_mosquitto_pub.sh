
#!/usr/bin/bash
# 测试用例描述：测试mosquitto_pub命令的各种参数组合，包括发布消息、持久会话、会话过期、认证、URL发布、遗嘱消息等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mosquitto"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "Test message" > ./test_message.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    mosquitto_pub -h localhost -t "test/topic" -m "Hello, World!"
    CHECK_RESULT $? 0 0 "Failed to publish message with -m option"

    mosquitto_pub -h localhost -t "test/topic" -f ./test_message.txt
    CHECK_RESULT $? 0 0 "Failed to publish message with -f option"

    mosquitto_pub -h localhost -t "test/topic" -l <<< "Line 1\nLine 2"
    CHECK_RESULT $? 0 0 "Failed to publish message with -l option"

    mosquitto_pub -h localhost -t "test/topic" -n
    CHECK_RESULT $? 0 0 "Failed to publish null message with -n option"

    mosquitto_pub -h localhost -t "test/topic" -r -m "Retained message"
    CHECK_RESULT $? 0 0 "Failed to publish retained message with -r option"

    mosquitto_pub -h localhost -t "test/topic" -q 1 -m "QoS 1 message"
    CHECK_RESULT $? 0 0 "Failed to publish QoS 1 message with -q option"

    mosquitto_pub -h localhost -t "test/topic" -q 2 -m "QoS 2 message"
    CHECK_RESULT $? 0 0 "Failed to publish QoS 2 message with -q option"

    mosquitto_pub -h localhost -t "test/topic" -c -i "test_client" -m "Persistent session message"
    CHECK_RESULT $? 0 0 "Failed to publish message with persistent session using -c option"

    mosquitto_pub -h localhost -t "test/topic" -x 3600 -m "Session expiry message"
    CHECK_RESULT $? 0 0 "Failed to publish message with session expiry using -x option"

    mosquitto_pub -h localhost -t "test/topic" -u "testuser" -P "testpass" -m "Authenticated message"
    CHECK_RESULT $? 0 0 "Failed to publish message with authentication using -u and -P options"

    mosquitto_pub -h localhost -t "test/topic" -L "mqtt://testuser:testpass@localhost/test/topic" -m "URL message"
    CHECK_RESULT $? 0 0 "Failed to publish message with URL using -L option"

    mosquitto_pub -h localhost -t "test/topic" --will-topic "will/topic" --will-payload "Will message" -m "Message with will"
    CHECK_RESULT $? 0 0 "Failed to publish message with will using --will-topic and --will-payload options"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "mosquitto"
    rm -f ./test_message.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
