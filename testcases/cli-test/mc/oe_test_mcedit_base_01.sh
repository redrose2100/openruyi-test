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
cat >1.txt <<EOL
 没有共产党
EOL

cat >2.txt <<EOL
  就没有新中国
EOL

    mcedit -V 2>&1 | grep 'GNU Midnight Commander '
    CHECK_RESULT $? 0 0 "Check mcedit -V  failed"

    mcdiff --version 2>&1 | grep 'GNU Midnight Commander '
    CHECK_RESULT $? 0 0 "Check mcedit --version  failed"

    mcedit -F 2>&1 | grep 'Home路径'  > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit -F  failed"

    mcedit --datadir-info 2>&1 | grep 'Home' > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit --datadir-info  failed"

    mcedit --configure-options 2>&1 | grep "'--build=" > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit --configure-options  failed"

    mcedit -P 1.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit -P  failed"

    mcedit --printwd=1.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit --printwd failed"

    mcedit -U 1.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit -U  failed"

    mcedit --subshell 1.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit --subshell  failed"

    mcedit -u 1.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcedit -u  failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE mc

    LOG_INFO "Finish restoring the test environment."
}

main $@