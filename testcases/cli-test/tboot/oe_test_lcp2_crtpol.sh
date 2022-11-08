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
    DNF_INSTALL tboot
    LOG_INFO "End of environmental preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    lcp2_crtpol --create --alg sha1 --polver 3.2 --type any --pol list.pol --sign rsa-2048-sha1
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol --create  failed"

    lcp2_crtpol --show list.pol 2>&1 | grep 'version: 0x302'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol --show  failed"

    lcp2_crtpol --help 2>&1 | grep 'Usage: lcp2_crtpol'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol -h  failed"

    lcp2_crtpol --show list.pol --verbose  2>&1 | grep 'version: 0x302'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol -verbose  failed"

    lcp2_crtpol --version 2>&1 | grep 'lcp2_crtpol version'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol -version  failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE tboot

    LOG_INFO "Finish restoring the test environment."
}

main $@