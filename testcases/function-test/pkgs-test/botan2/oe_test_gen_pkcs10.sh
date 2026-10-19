
#!/usr/bin/bash
# 请填写测试用例描述：测试botan gen_pkcs10命令，生成PKCS #10证书签名请求

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "testkey" > ./testkey.pem
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试gen_pkcs10命令的基本用法
    botan gen_pkcs10 ./testkey.pem "CN=TestUser" --country=CN --organization="TestOrg" --email=test@example.com --dns=test.example.com --ext-ku="digitalSignature,nonRepudiation" --key-pass=testpass --hash=SHA-256 --emsa=EMSA1_SHA256
    CHECK_RESULT $? 0 0 "botan gen_pkcs10 command failed"

    # 测试不同的参数组合
    botan gen_pkcs10 ./testkey.pem "CN=TestUser2" --country=US --organization="TestOrg2" --ca --path-limit=2 --dns=test2.example.com --ext-ku="keyAgreement" --key-pass=testpass2 --hash=SHA-384 --emsa=EMSA1_SHA384
    CHECK_RESULT $? 0 0 "botan gen_pkcs10 command with different parameters failed"

    # 测试缺少必填参数的情况
    botan gen_pkcs10 ./testkey.pem "CN=TestUser3" --country=CN --organization="TestOrg3" --email=test3@example.com --dns=test3.example.com --ext-ku="digitalSignature" --key-pass=testpass3 --hash=SHA-256 --emsa=EMSA1_SHA256
    CHECK_RESULT $? 0 0 "botan gen_pkcs10 command with missing parameters failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testkey.pem
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
