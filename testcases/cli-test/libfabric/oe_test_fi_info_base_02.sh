source ${OET_PATH}/libs/locallibs/common_lib.sh

# 需要预加载的数据、参数配置 (不需要)
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start environmental preparation."
    dnf install -y libfabric
    LOG_INFO "End of environmental preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    fi_info -a'FI_FORMAT_UNSPEC' 2>&1 | grep 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info -a  failed"

    fi_info --addr_format='FI_FORMAT_UNSPEC' 2>&1 | grep 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info --addr_format  failed"

    fi_info -e 2>&1 | grep '# FI_LOG_LEVEL: String'
    CHECK_RESULT $? 0 0 "Check fi_info -e  failed"

    fi_info -l 2>&1 | grep 'usnic:'
    CHECK_RESULT $? 0 0 "Check fi_info -l  failed"

    fi_info --version 2>&1 | grep 'fi_info: 1.6.1'
    CHECK_RESULT $? 0 0 "Check fi_info --version  failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    dnf remove -y libfabric

    LOG_INFO "Finish restoring the test environment."
}

main $@