
#!/usr/bin/bash
# 测试botan check_argon2命令，验证密码哈希值

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo -n "testpassword" > ./test_password.txt
    echo -n "$argon2id$v=19$m=65536,t=2,p=1$U21hcnRHcm91cA$VXNlck5hbWU=" > ./test_hash.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试botan check_argon2命令
    botan check_argon2 $(cat ./test_password.txt) $(cat ./test_hash.txt)
    CHECK_RESULT $? 0 0 "botan check_argon2 command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_password.txt ./test_hash.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
