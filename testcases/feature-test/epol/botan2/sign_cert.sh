
#!/usr/bin/bash
# 请填写测试用例描述：测试botan sign_cert命令，验证证书签名功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "-----BEGIN CERTIFICATE-----" > ./ca_cert
    echo "CA certificate content" >> ./ca_cert
    echo "-----END CERTIFICATE-----" >> ./ca_cert

    echo "-----BEGIN PRIVATE KEY-----" > ./ca_key
    echo "CA private key content" >> ./ca_key
    echo "-----END PRIVATE KEY-----" >> ./ca_key

    echo "-----BEGIN CERTIFICATE REQUEST-----" > ./pkcs10_req
    echo "PKCS10 CSR content" >> ./pkcs10_req
    echo "-----END CERTIFICATE REQUEST-----" >> ./pkcs10_req

    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试botan sign_cert命令的基本用法
    botan sign_cert --ca-key-pass=password --hash=SHA-256 --duration=365 --emsa=PSS ./ca_cert ./ca_key ./pkcs10_req
    CHECK_RESULT $? 0 0 "botan sign_cert command failed"

    # 测试不同的哈希算法
    botan sign_cert --ca-key-pass=password --hash=SHA-512 --duration=365 --emsa=PSS ./ca_cert ./ca_key ./pkcs10_req
    CHECK_RESULT $? 0 0 "botan sign_cert with SHA-512 failed"

    # 测试不同的签名机制
    botan sign_cert --ca-key-pass=password --hash=SHA-256 --duration=365 --emsa=EMSA1 ./ca_cert ./ca_key ./pkcs10_req
    CHECK_RESULT $? 0 0 "botan sign_cert with EMSA1 failed"

    # 测试不同的有效期
    botan sign_cert --ca-key-pass=password --hash=SHA-256 --duration=730 --emsa=PSS ./ca_cert ./ca_key ./pkcs10_req
    CHECK_RESULT $? 0 0 "botan sign_cert with 730 days duration failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./ca_cert ./ca_key ./pkcs10_req
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
