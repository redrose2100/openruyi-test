
#!/usr/bin/bash
# 请填写测试用例描述：测试botan tss_split命令，验证其参数组合和功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "This is a test file." > ./testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试tss_split命令的基本用法
    botan tss_split 2 3 ./testfile.txt --id=123 --share-prefix=share --share-suffix=tss --hash=SHA-256
    CHECK_RESULT $? 0 0 "tss_split command failed"

    # 测试不同的M和N值
    botan tss_split 3 5 ./testfile.txt --id=456 --share-prefix=share --share-suffix=tss --hash=SHA-256
    CHECK_RESULT $? 0 0 "tss_split command with different M and N failed"

    # 测试不同的哈希算法
    botan tss_split 2 3 ./testfile.txt --id=789 --share-prefix=share --share-suffix=tss --hash=SHA-512
    CHECK_RESULT $? 0 0 "tss_split command with different hash algorithm failed"

    # 测试不同的前缀和后缀
    botan tss_split 2 3 ./testfile.txt --id=101 --share-prefix=myshare --share-suffix=mytss --hash=SHA-256
    CHECK_RESULT $? 0 0 "tss_split command with different prefix and suffix failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testfile.txt
    rm -f ./share*.tss
    rm -f ./myshare*.mytss
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
