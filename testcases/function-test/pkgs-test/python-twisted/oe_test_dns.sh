
#!/usr/bin/bash
# 请填写测试用例描述：测试 twistd dns 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-twisted"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./test_zone_file
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    twistd dns -i 127.0.0.1 -p 53
    CHECK_RESULT $? 0 0 "twistd dns basic function failed"

    # 测试 --bindzone 参数
    twistd dns --bindzone=./test_zone_file
    CHECK_RESULT $? 0 0 "twistd dns --bindzone parameter failed"

    # 测试 --pyzone 参数
    twistd dns --pyzone=./test_zone_file
    CHECK_RESULT $? 0 0 "twistd dns --pyzone parameter failed"

    # 测试 --hosts-file 参数
    twistd dns --hosts-file=./test_zone_file
    CHECK_RESULT $? 0 0 "twistd dns --hosts-file parameter failed"

    # 测试 --resolv-conf 参数
    twistd dns --resolv-conf=./test_zone_file
    CHECK_RESULT $? 0 0 "twistd dns --resolv-conf parameter failed"

    # 测试 --secondary 参数
    twistd dns --secondary=127.0.0.1/example.com
    CHECK_RESULT $? 0 0 "twistd dns --secondary parameter failed"

    # 测试 --cache 参数
    twistd dns --cache
    CHECK_RESULT $? 0 0 "twistd dns --cache parameter failed"

    # 测试 --recursive 参数
    twistd dns --recursive
    CHECK_RESULT $? 0 0 "twistd dns --recursive parameter failed"

    # 测试 --verbose 参数
    twistd dns --verbose
    CHECK_RESULT $? 0 0 "twistd dns --verbose parameter failed"

    # 测试 --version 参数
    twistd dns --version
    CHECK_RESULT $? 0 0 "twistd dns --version parameter failed"

    # 测试 --help 参数
    twistd dns --help
    CHECK_RESULT $? 0 0 "twistd dns --help parameter failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "python-twisted"
    # 清理测试中间产物文件
    rm -f ./test_zone_file
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
