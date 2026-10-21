
#!/usr/bin/bash
# 请填写测试用例描述：测试 botan is_prime 命令，验证其是否能正确判断给定整数是否为质数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "2" > ./test_prime.txt
    echo "4" > ./test_composite.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    botan is_prime --prob=56 $(cat ./test_prime.txt)
    CHECK_RESULT $? 0 0 "botan is_prime failed for prime number"
    
    botan is_prime --prob=56 $(cat ./test_composite.txt)
    CHECK_RESULT $? 1 0 "botan is_prime failed for composite number"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "botan2"
    rm -f ./test_prime.txt ./test_composite.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
