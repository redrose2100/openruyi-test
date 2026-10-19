
#!/usr/bin/bash
# 测试botan fec_decode命令，验证其解码FEC shares的功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "This is a test share 1" > ./share1
    echo "This is a test share 2" > ./share2
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容
    botan fec_decode ./share1 ./share2
    CHECK_RESULT $? 1 0 "fec_decode command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./share1 ./share2
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
