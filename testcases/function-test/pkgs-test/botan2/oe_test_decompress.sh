
#!/usr/bin/bash
# 请填写测试用例描述：测试botan的decompress命令，验证其能否正确解压缩文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "test data" > ./test_data.txt
    botan2 compress --buf-size=8192 ./test_data.txt -o ./compressed_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试decompress命令的基本功能
    botan2 decompress --buf-size=8192 ./compressed_data.txt -o ./decompressed_data.txt
    CHECK_RESULT $? 0 0 "decompress command failed"
    # 验证解压缩后的文件内容是否正确
    cmp ./test_data.txt ./decompressed_data.txt
    CHECK_RESULT $? 0 0 "decompressed file content mismatch"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_data.txt ./compressed_data.txt ./decompressed_data.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
