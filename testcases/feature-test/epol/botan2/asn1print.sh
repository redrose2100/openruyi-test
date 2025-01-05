
#!/usr/bin/bash
# 本测试脚本用于测试botan2软件包中的asn1print命令，包括基本功能和参数组合测试。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "3082024230820210020101300d06092a864886f70d0101050500048201f8308201f4a003020102020900c9a8252162860101a10403020102a207030500010101a32b30293027a003020102a120301e170da0c05300906072a8648ce380401161f68747470733a2f2f636c69656e7472657365617263682e636f6d301ea00c300a06082a8648ce380403030107a10e300c060a2b06010401d67902040201300d06092a864886f70d0101050500" > ./test.asn1
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 基本功能测试
    botan2 asn1print --pem ./test.asn1
    CHECK_RESULT $? 0 0 "asn1print basic function test failed"

    # 测试--skip-context-specific参数
    botan2 asn1print --skip-context-specific --pem ./test.asn1
    CHECK_RESULT $? 0 0 "asn1print --skip-context-specific test failed"

    # 测试--print-limit参数
    botan2 asn1print --print-limit=100 --pem ./test.asn1
    CHECK_RESULT $? 0 0 "asn1print --print-limit test failed"

    # 测试--bin-limit参数
    botan2 asn1print --bin-limit=100 --pem ./test.asn1
    CHECK_RESULT $? 0 0 "asn1print --bin-limit test failed"

    # 测试--max-depth参数
    botan2 asn1print --max-depth=10 --pem ./test.asn1
    CHECK_RESULT $? 0 0 "asn1print --max-depth test failed"

    # 测试参数组合
    botan2 asn1print --skip-context-specific --print-limit=100 --bin-limit=100 --max-depth=10 --pem ./test.asn1
    CHECK_RESULT $? 0 0 "asn1print combined parameters test failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -rf ./test.asn1
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
