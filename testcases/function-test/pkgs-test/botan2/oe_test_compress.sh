
#!/usr/bin/bash
# 请填写测试用例描述：测试botan compress命令，包括不同参数组合和文件压缩操作

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
    # 测试压缩文件
    botan compress --type=gzip --level=6 --buf-size=8192 ./testfile.txt
    CHECK_RESULT $? 0 0 "compress command failed"
    # 测试不同压缩级别
    botan compress --type=gzip --level=9 --buf-size=8192 ./testfile.txt
    CHECK_RESULT $? 0 0 "compress command with level 9 failed"
    # 测试不同缓冲区大小
    botan compress --type=gzip --level=6 --buf-size=16384 ./testfile.txt
    CHECK_RESULT $? 0 0 "compress command with buf-size 16384 failed"
    # 测试不同压缩类型
    botan compress --type=lzma --level=6 --buf-size=8192 ./testfile.txt
    CHECK_RESULT $? 0 0 "compress command with type lzma failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testfile.txt
    rm -f ./testfile.txt.gz
    rm -f ./testfile.txt.lzma
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
