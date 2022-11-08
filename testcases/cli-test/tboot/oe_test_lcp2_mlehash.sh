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

    lcp2_mlehash --create --alg sha1 --cmdline "logging=serial,memory,vga" /boot/tboot.gz > mle_hash
    CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create  failed"

    lcp2_mlehash --create --verbose --alg sha1 --cmdline "logging=serial,memory,vga" /boot/tboot.gz > mle_hash
    CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create  failed"

    lcp2_mlehash --version
    CHECK_RESULT $? 0 0 "Check lcp2_mlehash --version  failed"
    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE tboot

    LOG_INFO "Finish restoring the test environment."
}

main $@