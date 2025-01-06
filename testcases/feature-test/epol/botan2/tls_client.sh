
#!/usr/bin/bash
# 请填写测试用例描述：测试 botan tls_client 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "This is a test file" > ./testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2 --skip-system-cert-store --trusted-cas=./testfile.txt --session-db=./testfile.txt --session-db-pass=testpass --next-protocols=h2 --type=tcp
    CHECK_RESULT $? 0 0 "tls_client command failed with all parameters"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2 --skip-system-cert-store --trusted-cas=./testfile.txt --session-db=./testfile.txt --session-db-pass=testpass --type=tcp
    CHECK_RESULT $? 0 0 "tls_client command failed without --next-protocols parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2 --skip-system-cert-store --trusted-cas=./testfile.txt --session-db=./testfile.txt --session-db-pass=testpass --next-protocols=h2
    CHECK_RESULT $? 0 0 "tls_client command failed without --type parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2 --skip-system-cert-store --trusted-cas=./testfile.txt --session-db=./testfile.txt --session-db-pass=testpass
    CHECK_RESULT $? 0 0 "tls_client command failed without --next-protocols and --type parameters"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2 --skip-system-cert-store --trusted-cas=./testfile.txt --session-db=./testfile.txt
    CHECK_RESULT $? 0 0 "tls_client command failed without --session-db-pass parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2 --skip-system-cert-store --trusted-cas=./testfile.txt
    CHECK_RESULT $? 0 0 "tls_client command failed without --session-db parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2 --skip-system-cert-store
    CHECK_RESULT $? 0 0 "tls_client command failed without --trusted-cas parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1 --tls1.2
    CHECK_RESULT $? 0 0 "tls_client command failed without --skip-system-cert-store parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0 --tls1.1
    CHECK_RESULT $? 0 0 "tls_client command failed without --tls1.2 parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default --tls1.0
    CHECK_RESULT $? 0 0 "tls_client command failed without --tls1.1 parameter"
    
    botan tls_client example.com --port=443 --print-certs --policy=default
    CHECK_RESULT $? 0 0 "tls_client command failed without --tls1.0 parameter"
    
    botan tls_client example.com --port=443 --print-certs
    CHECK_RESULT $? 0 0 "tls_client command failed without --policy parameter"
    
    botan tls_client example.com --port=443
    CHECK_RESULT $? 0 0 "tls_client command failed without --print-certs parameter"
    
    botan tls_client example.com
    CHECK_RESULT $? 0 0 "tls_client command failed without --port parameter"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "botan2"
    rm -f ./testfile.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
