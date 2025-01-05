
#!/usr/bin/bash
# 测试 botan timing_test 命令的不同参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Test data" > ./test_data_file.txt
    mkdir -p ./test_data_dir
    echo "Test data in directory" > ./test_data_dir/test_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试不同的 test_type 参数
    for test_type in bleichenbacher manger ecdsa ecc_mul inverse_mod pow_mod lucky13sec3 lucky13sec4sha1 lucky13sec4sha256 lucky13sec4sha384; do
        botan2 timing_test $test_type --test-data-file=./test_data_file.txt --test-data-dir=./test_data_dir --warmup-runs=5000 --measurement-runs=50000
        CHECK_RESULT $? 0 0 "failed for test_type: $test_type"
    done
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_data_file.txt
    rm -rf ./test_data_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
