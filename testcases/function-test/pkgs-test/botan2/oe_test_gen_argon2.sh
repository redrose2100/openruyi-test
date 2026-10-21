
#!/usr/bin/bash
# 本测试用例用于测试botan命令中的gen_argon2子命令，该命令用于生成Argon2密码哈希。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "testpassword" > ./testpassword.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试gen_argon2命令的基本用法
    botan gen_argon2 --mem=65536 --p=1 --t=1 testpassword > ./argon2hash.txt
    CHECK_RESULT $? 0 0 "botan gen_argon2 command failed"
    # 检查生成的哈希文件是否存在
    test -f ./argon2hash.txt
    CHECK_RESULT $? 0 0 "argon2 hash file not found"
    # 测试gen_argon2命令的参数组合
    botan gen_argon2 --mem=131072 --p=2 --t=2 testpassword > ./argon2hash2.txt
    CHECK_RESULT $? 0 0 "botan gen_argon2 command with parameters failed"
    # 检查生成的哈希文件是否存在
    test -f ./argon2hash2.txt
    CHECK_RESULT $? 0 0 "argon2 hash file with parameters not found"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testpassword.txt ./argon2hash.txt ./argon2hash2.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
