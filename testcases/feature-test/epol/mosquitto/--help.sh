
#!/usr/bin/bash
# 请填写测试用例描述：测试mosquitto_rr --help命令，验证是否正确显示帮助信息

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mosquitto"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试mosquitto_rr --help命令
    mosquitto_rr --help > ./mosquitto_rr_help_output.txt
    CHECK_RESULT $? 0 0 "mosquitto_rr --help command failed"
    grep -q "mosquitto_rr is an mqtt client" ./mosquitto_rr_help_output.txt
    CHECK_RESULT $? 0 0 "mosquitto_rr --help output does not contain expected text"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mosquitto"
    # 清理测试中间产物文件
    rm -f ./mosquitto_rr_help_output.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
