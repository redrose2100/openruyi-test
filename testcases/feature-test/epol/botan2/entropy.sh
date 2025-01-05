
#!/usr/bin/bash
# 请填写测试用例描述：测试botan命令的entropy子命令，用于采样原始熵源

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    botan entropy --truncate-at=128 /dev/urandom --output=./entropy_output --error-output=./entropy_error_output --rng-type=system --drbg-seed=12345
    CHECK_RESULT $? 0 0 "botan entropy command failed"
    # 检查输出文件是否存在
    test -f ./entropy_output
    CHECK_RESULT $? 0 0 "entropy output file not found"
    test -f ./entropy_error_output
    CHECK_RESULT $? 0 0 "entropy error output file not found"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "botan2"
    rm -f ./entropy_output ./entropy_error_output
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
