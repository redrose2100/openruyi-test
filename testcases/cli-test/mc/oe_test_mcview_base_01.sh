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


    mcview -V 2>&1 | grep 'GNU Midnight Commander'
    CHECK_RESULT $? 0 0 "Check mcview -V failed"

    mcview --version 2>&1 | grep 'GNU Midnight Commander '
    CHECK_RESULT $? 0 0 "Check mcview --version failed"

    mcview -F 2>&1 | grep 'Home路径' > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview -F failed"

    mcview --datadir-info 2>&1 | grep 'Home' > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview --datadir-info failed"

    mcview --configure-options 2>&1 | grep "'--build=" > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview --configure-options failed"

    mcview -P 1.txt 2.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview -P failed"

    mcview --printwd=1.txt 2.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview --printwd failed"

    mcview -U 1.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview -U failed"

    mcview --subshell 1.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview --subshell failed"

    mcview -u 1.txt 2.txt > /dev/nul 2>&1 &
    CHECK_RESULT $? 0 0 "Check mcview -u failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE mc

    LOG_INFO "Finish restoring the test environment."
}

main $@