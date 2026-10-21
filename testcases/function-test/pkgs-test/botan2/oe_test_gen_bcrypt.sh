
#!/usr/bin/bash
# 本测试脚本用于测试botan命令的gen_bcrypt子命令，该命令用于生成bcrypt密码哈希。

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
    # 测试gen_bcrypt命令的基本用法
    botan gen_bcrypt ./testpassword.txt
    CHECK_RESULT $? 0 0 "botan gen_bcrypt failed"
    # 测试gen_bcrypt命令的输出
    botan gen_bcrypt ./testpassword.txt > ./bcrypt_output.txt
    CHECK_RESULT $? 0 0 "botan gen_bcrypt output failed"
    # 检查输出文件是否包含预期的哈希值
    grep -q "\$2a\$12\$" ./bcrypt_output.txt
    CHECK_RESULT $? 0 0 "bcrypt output does not match expected format"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testpassword.txt ./bcrypt_output.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
