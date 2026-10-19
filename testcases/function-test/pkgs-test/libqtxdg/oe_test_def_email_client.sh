
#!/usr/bin/bash
# 请填写测试用例描述：测试 qtxdg-mat def-email-client 命令的参数功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "libqtxdg"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的帮助信息
    qtxdg-mat --help
    CHECK_RESULT $? 0 0 "Failed to display help information"
    
    # 测试命令的版本信息
    qtxdg-mat --version
    CHECK_RESULT $? 0 0 "Failed to display version information"
    
    # 测试获取默认的邮件客户端
    qtxdg-mat def-email-client
    CHECK_RESULT $? 0 0 "Failed to get default email client"
    
    # 测试列出可用的邮件客户端
    qtxdg-mat def-email-client -l
    CHECK_RESULT $? 0 0 "Failed to list available email clients"
    
    # 测试设置默认的邮件客户端
    # 注意：这里需要确保 "thunderbird" 是可用的邮件客户端
    qtxdg-mat def-email-client -s "thunderbird"
    CHECK_RESULT $? 0 0 "Failed to set default email client"
    
    # 验证设置是否成功
    qtxdg-mat def-email-client
    CHECK_RESULT $? 0 0 "Failed to verify default email client setting"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "libqtxdg"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
