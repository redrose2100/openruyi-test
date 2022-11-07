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

    fi_info -h 2>&1 | grep 'Usage: fi_info'
    CHECK_RESULT $? 0 0 "Check fi_info -h  failed"

    fi_info --help 2>&1 | grep 'Usage: fi_info'
    CHECK_RESULT $? 0 0 "Check fi_info --help  failed"

    fi_info -n'http://127.0.0.1' 2>&1 | grep 'provider: shm'
    CHECK_RESULT $? 0 0 "Check fi_info -n failed"

    fi_info --node='http://127.0.0.1' 2>&1 | grep 'provider: shm'
    CHECK_RESULT $? 0 0 "Check fi_info --node  failed"

    fi_info -c'FI_MSG' 2>&1 | grep 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info -c  failed"

    fi_info --caps='FI_MSG' 2>&1 | grep 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info --caps  failed"

    fi_info -t'FI_EP_MSG' 2>&1 | grep 'provider: sockets'
    CHECK_RESULT $? 0 0 "Check fi_info -t  failed"

    fi_info --ep_type='FI_EP_MSG' 2>&1 | grep 'provider: sockets'
    CHECK_RESULT $? 0 0 "Check fi_info --ep_type  failed"

    fi_info -f'NAME' 2>&1 | grep 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info -f  failed"

    fi_info --fabric='NAME' 2>&1 | grep 'provider: UDP'
    CHECK_RESULT $? 0 0 "Check fi_info --fabric  failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    dnf remove -y libfabric

    LOG_INFO "Finish restoring the test environment."
}

main $@