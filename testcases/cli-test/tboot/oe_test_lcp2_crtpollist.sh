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

    lcp2_crtpollist  --create --listver  0x200 --out list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --listver --out failed"

    openssl genrsa -out privkey.pem 2048
    openssl rsa -pubout -in privkey.pem -out pubkey.pem
    lcp2_crtpollist --sign --sigalg rsa --pub pubkey.pem --priv privkey.pem --out list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --sign --sigalg --pub --priv --out  failed"

    lcp2_crtpollist --show list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show failed"

    lcp2_crtpollist --verify list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --verify  failed"

    lcp2_crtpollist --help
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --help  failed"

   lcp2_crtpollist --show list_unsig.lst --verbose 2>&1 | grep 'cmdline opt'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show --verbose failed"

    lcp2_crtpollist --version 2>&1 | grep 'lcp2_crtpollist version'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --version  failed"

    rm -rf list_unsig privkey.pem pubkey.pem

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE tboot

    LOG_INFO "Finish restoring the test environment."
}

main $@