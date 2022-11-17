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

    mc -h 2>&1 | grep '用法'
    CHECK_RESULT $? 0 0 "Check mc -h  failed"

    mc --help 2>&1 | grep '用法'
    CHECK_RESULT $? 0 0 "Check mc --help  failed"

    mc -V 2>&1 | grep 'GNU Midnight Commander'  > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -V  failed"

    mc --version 2>&1 | grep 'GNU Midnight Commander' > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --version  failed"

    mc -f 2>&1 | grep '/etc/mc/ (/usr/share/mc/)' > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -f  failed"

    mc --datadir 2>&1 | grep '/etc/mc/ (/usr/share/mc/)'  > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --datadir  failed"

    mc -F 2>&1 | grep 'Home路径'   > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -F  failed"

    mc --datadir-info 2>&1  | grep 'Home'   > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --datadir-info  failed"

    mc --configure-options  2>&1 | grep "'--build="  > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc --configure-options  failed"

    mc -P mc.txt  > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mc -P  failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE mc

    LOG_INFO "Finish restoring the test environment."
}

main $@