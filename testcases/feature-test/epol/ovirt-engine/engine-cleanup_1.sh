
#!/usr/bin/bash
# 请填写测试用例描述：测试 engine-cleanup 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./test_config.conf
    touch ./test_extra_config.conf
    touch ./test_answer_file.conf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --log 参数
    /usr/bin/engine-cleanup --log=./test_log.log
    CHECK_RESULT $? 0 0 "engine-cleanup --log failed"

    # 测试 --config 参数
    /usr/bin/engine-cleanup --config=./test_config.conf
    CHECK_RESULT $? 0 0 "engine-cleanup --config failed"

    # 测试 --config-append 参数
    /usr/bin/engine-cleanup --config-append=./test_extra_config.conf
    CHECK_RESULT $? 0 0 "engine-cleanup --config-append failed"

    # 测试 --generate-answer 参数
    /usr/bin/engine-cleanup --generate-answer=./test_answer_file.conf
    CHECK_RESULT $? 0 0 "engine-cleanup --generate-answer failed"

    # 测试参数组合
    /usr/bin/engine-cleanup --log=./test_log.log --config=./test_config.conf --config-append=./test_extra_config.conf --generate-answer=./test_answer_file.conf
    CHECK_RESULT $? 0 0 "engine-cleanup combined parameters failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "ovirt-engine"
        # 清理测试中间产物文件
        rm -f ./test_config.conf ./test_extra_config.conf ./test_answer_file.conf ./test_log.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
