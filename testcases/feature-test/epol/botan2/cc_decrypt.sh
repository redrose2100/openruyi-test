
#!/usr/bin/bash
# 测试用例描述：测试botan cc_decrypt命令，验证信用卡号码的FPE解密功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "encrypted_credit_card_number" > ./encrypted_cc.txt
    echo "passphrase" > ./passphrase.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试cc_decrypt命令的基本用法
    botan cc_decrypt ./encrypted_cc.txt ./passphrase.txt --tweak="tweak_value"
    CHECK_RESULT $? 0 0 "cc_decrypt command failed"

    # 测试cc_decrypt命令的错误用法，例如缺少参数
    botan cc_decrypt ./encrypted_cc.txt
    CHECK_RESULT $? 1 0 "cc_decrypt command should fail without passphrase"

    # 测试cc_decrypt命令的错误用法，例如缺少--tweak参数
    botan cc_decrypt ./encrypted_cc.txt ./passphrase.txt
    CHECK_RESULT $? 1 0 "cc_decrypt command should fail without --tweak parameter"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./encrypted_cc.txt ./passphrase.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
