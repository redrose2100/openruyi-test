
#!/usr/bin/bash
# 测试botan命令中的check_bcrypt子命令，验证bcrypt密码哈希值

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "password123" > ./test_password.txt
    echo "$2a$10$N9qo8uLOUp2pmW7vQ.0kVeEpHnLgjWgXr0yjlJpJpMh7/.fL/.2b2" > ./test_hash.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容
    botan check_bcrypt $(cat ./test_password.txt) $(cat ./test_hash.txt)
    CHECK_RESULT $? 0 0 "check_bcrypt command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_password.txt ./test_hash.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
