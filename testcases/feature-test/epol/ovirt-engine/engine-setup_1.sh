
#!/usr/bin/bash
# 测试 ovirt-engine-setup 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./test_config.conf
    touch ./test_answer.conf
    touch ./test_log.log
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --log 参数
    /usr/bin/engine-setup --log=./test_log.log
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --log parameter"

    # 测试 --config 参数
    /usr/bin/engine-setup --config=./test_config.conf
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --config parameter"

    # 测试 --config-append 参数
    /usr/bin/engine-setup --config-append=./test_answer.conf
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --config-append parameter"

    # 测试 --offline 参数
    /usr/bin/engine-setup --offline
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --offline parameter"

    # 测试 --generate-answer 参数
    /usr/bin/engine-setup --generate-answer=./test_answer.conf
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --generate-answer parameter"

    # 测试 --reconfigure-optional-components 参数
    /usr/bin/engine-setup --reconfigure-optional-components
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --reconfigure-optional-components parameter"

    # 测试 --jboss-home 参数
    /usr/bin/engine-setup --jboss-home=/usr/share/jbossas
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --jboss-home parameter"

    # 测试 --reconfigure-dwh-scale 参数
    /usr/bin/engine-setup --reconfigure-dwh-scale
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --reconfigure-dwh-scale parameter"

    # 测试 --accept-defaults 参数
    /usr/bin/engine-setup --accept-defaults
    CHECK_RESULT $? 0 0 "failed to run engine-setup with --accept-defaults parameter"

    # 测试多个参数组合
    /usr/bin/engine-setup --log=./test_log.log --config=./test_config.conf --config-append=./test_answer.conf --offline --generate-answer=./test_answer.conf --reconfigure-optional-components --jboss-home=/usr/share/jbossas --reconfigure-dwh-scale --accept-defaults
    CHECK_RESULT $? 0 0 "failed to run engine-setup with multiple parameters"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "ovirt-engine"
    rm -f ./test_config.conf ./test_answer.conf ./test_log.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
