
#!/usr/bin/bash
# 测试用例描述：测试mosquitto_sub命令的基本功能，包括订阅主题、设置QoS级别、设置客户端ID、设置超时时间等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mosquitto"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试订阅一个主题
    mosquitto_sub -t "test/topic" -C 1
    CHECK_RESULT $? 0 0 "Failed to subscribe to topic 'test/topic'"
    
    # 测试设置QoS级别
    mosquitto_sub -t "test/topic" -q 1 -C 1
    CHECK_RESULT $? 0 0 "Failed to set QoS level to 1"
    
    # 测试设置客户端ID
    mosquitto_sub -t "test/topic" -i "test_client" -C 1
    CHECK_RESULT $? 0 0 "Failed to set client ID to 'test_client'"
    
    # 测试设置超时时间
    mosquitto_sub -t "test/topic" -W 5 -C 1
    CHECK_RESULT $? 0 0 "Failed to set timeout to 5 seconds"
    
    # 测试多个主题订阅
    mosquitto_sub -t "test/topic1" -t "test/topic2" -C 1
    CHECK_RESULT $? 0 0 "Failed to subscribe to multiple topics"
    
    # 测试不打印保留消息
    mosquitto_sub -t "test/topic" -R -C 1
    CHECK_RESULT $? 0 0 "Failed to disable printing of retained messages"
    
    # 测试设置输出格式
    mosquitto_sub -t "test/topic" -F "%t %p" -C 1
    CHECK_RESULT $? 0 0 "Failed to set output format"
    
    # 测试设置会话过期时间
    mosquitto_sub -t "test/topic" -x 60 -C 1
    CHECK_RESULT $? 0 0 "Failed to set session expiry interval"
    
    # 测试设置持久会话模式
    mosquitto_sub -t "test/topic" -c -C 1
    CHECK_RESULT $? 0 0 "Failed to set persistent session mode"
    
    # 测试设置代理URL
    mosquitto_sub -L "mqtt://localhost/test/topic" -C 1
    CHECK_RESULT $? 0 0 "Failed to set proxy URL"
    
    # 测试设置TLS证书
    mosquitto_sub -t "test/topic" --cafile "/etc/ssl/certs/ca-certificates.crt" -C 1
    CHECK_RESULT $? 0 0 "Failed to set TLS certificate"
    
    # 测试设置TLS引擎
    mosquitto_sub -t "test/topic" --tls-engine "engine" -C 1
    CHECK_RESULT $? 0 0 "Failed to set TLS engine"
    
    # 测试设置TLS引擎密码
    mosquitto_sub -t "test/topic" --tls-engine-kpass-sha1 "sha1_password" -C 1
    CHECK_RESULT $? 0 0 "Failed to set TLS engine password"
    
    # 测试设置TLS使用操作系统证书
    mosquitto_sub -t "test/topic" --tls-use-os-certs -C 1
    CHECK_RESULT $? 0 0 "Failed to set TLS to use OS certificates"
    
    # 测试设置TLS预共享密钥
    mosquitto_sub -t "test/topic" --psk "0123456789abcdef" --psk-identity "identity" -C 1
    CHECK_RESULT $? 0 0 "Failed to set TLS pre-shared key"
    
    # 测试设置TLS代理
    mosquitto_sub -t "test/topic" --proxy "socks5h://localhost:1080" -C 1
    CHECK_RESULT $? 0 0 "Failed to set TLS proxy"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mosquitto"
    # 清理测试中间产物文件
    rm -rf ./test_file
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
