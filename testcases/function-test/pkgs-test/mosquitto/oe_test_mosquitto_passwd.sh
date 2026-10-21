
#!/usr/bin/bash
# 本测试用例用于验证mosquitto_passwd命令的基本功能，包括创建密码文件、添加用户、更新用户密码、删除用户等操作。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mosquitto"
    # 准备测试数据
    touch "./test_passwordfile"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 创建密码文件并添加用户
    mosquitto_passwd -c -H sha512 "./test_passwordfile" testuser1
    CHECK_RESULT $? 0 0 "Failed to create password file and add user"
    
    # 更新用户密码
    mosquitto_passwd -b "./test_passwordfile" testuser1 newpassword
    CHECK_RESULT $? 0 0 "Failed to update user password"
    
    # 删除用户
    mosquitto_passwd -D "./test_passwordfile" testuser1
    CHECK_RESULT $? 0 0 "Failed to delete user"
    
    # 更新密码文件为使用哈希密码
    mosquitto_passwd -U "./test_passwordfile"
    CHECK_RESULT $? 0 0 "Failed to update password file to use hashed passwords"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mosquitto"
    # 清理测试中间产物文件
    rm -f "./test_passwordfile"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
