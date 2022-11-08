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


    tb_polgen --create --type nonfatal vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen create --type  failed"

    tb_polgen --add --num 1 --pcr 18 --hash any  vl.pol
    CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash  failed"

    lcp2_crtpol --create --alg sha1 --polver 3.2 --type any --pol list.pol --sign rsa-2048-sha1
    lcp2_crtpolelt --create --type pconf --out pconf.elt
    tb_polgen --unwrap --elt list.pol pconf.elt  --verbose 2>&1  | grep 'cmd'
    CHECK_RESULT $? 0 0 "Check tb_polgen --unwrap --elt failed"

    tb_polgen --show vl.pol 2>&1 | grep 'policy'
    CHECK_RESULT $? 0 0 "Check tb_polgen --show failed"

    tb_polgen --help 2>&1 | grep 'tb_polgen'
    CHECK_RESULT $? 0 0 "Check tb_polgen --help failed"

    rm -rf vl.pol list.pol pconf.elt

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE tboot

    LOG_INFO "Finish restoring the test environment."
}

main $@