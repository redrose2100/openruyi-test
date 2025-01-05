
#!/usr/bin/bash
# 测试botan ocsp_check命令，验证其基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "-----BEGIN CERTIFICATE-----" > ./subject.crt
    echo "Subject Certificate" >> ./subject.crt
    echo "-----END CERTIFICATE-----" >> ./subject.crt
    echo "-----BEGIN CERTIFICATE-----" > ./issuer.crt
    echo "Issuer Certificate" >> ./issuer.crt
    echo "-----END CERTIFICATE-----" >> ./issuer.crt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    botan ocsp_check --timeout=3000 ./subject.crt ./issuer.crt
    CHECK_RESULT $? 0 0 "ocsp_check command failed"

    # 测试不同的超时时间
    botan ocsp_check --timeout=1000 ./subject.crt ./issuer.crt
    CHECK_RESULT $? 0 0 "ocsp_check with --timeout=1000 failed"

    # 测试错误的参数顺序
    botan ocsp_check ./subject.crt ./issuer.crt --timeout=3000
    CHECK_RESULT $? 0 0 "ocsp_check with wrong parameter order failed"

    # 测试错误的参数组合
    botan ocsp_check --timeout=3000 ./issuer.crt ./subject.crt
    CHECK_RESULT $? 1 0 "ocsp_check with wrong parameter combination should fail"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./subject.crt ./issuer.crt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
