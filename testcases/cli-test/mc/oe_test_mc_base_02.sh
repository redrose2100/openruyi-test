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
    DNF_INSTALL mc
    LOG_INFO "End of environmental preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    mc --printwd=mc.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --printwd  failed"

    mc -U > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -U  failed"

    mc --subshell > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --subshell  failed"

    mc -u > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -u  failed"

    mc -l ./mc.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -l  failed"

    mc --ftplog=txt.mc > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --ftplog  failed"

    mc -v mc.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -v  failed"

    mc --view=mc.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --view  failed"

    mc -e mc.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -e  failed"

    mc --edit=mc.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --edit  failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE mc

    LOG_INFO "Finish restoring the test environment."
}

main $@