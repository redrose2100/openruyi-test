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

    DNF_INSTALL openjade
    DNF_INSTALL git

    LOG_INFO "End of environmental preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    git clone https://gitee.com/src-openeuler/openjade.git
    cd openjade/
    tar -zxvf openjade-1.3.2.tar.gz
    cd openjade-1.3.2/testsuite

    sed -i '/.*JADE=..\/jade\/openjade*/c\JADE=\/usr\/bin\/openjade' Makefile
    sed -i '11s/.*/\tdiff $< .\//g' Makefile

    make
    CHECK_RESULT $? 0 0 "Check jade -c   failed"

    sed -i '/.*JADEX=$(JADE) -c ..\/dsssl\/catalog*/c\JADEX=$(JADE) -C ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -C  failed"


    sed -i '/.*JADEX=$(JADE) -C ..\/dsssl\/catalog*/c\JADEX=$(JADE) -b ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -b  failed"


    sed -i '/.*JADEX=$(JADE) -b ..\/dsssl\/catalog*/c\JADEX=$(JADE) -f ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -f  failed"


    sed -i '/.*JADEX=$(JADE) -f ..\/dsssl\/catalog*/c\JADEX=$(JADE) -e ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -e failed"


    sed -i '/.*JADEX=$(JADE) -e ..\/dsssl\/catalog*/c\JADEX=$(JADE) -v ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -v failed"


    sed -i '/.*JADEX=$(JADE) -v ..\/dsssl\/catalog*/c\JADEX=$(JADE) -D ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -D failed"


    sed -i '/.*JADEX=$(JADE) -D ..\/dsssl\/catalog*/c\JADEX=$(JADE) -R ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -R failed"


    sed -i '/.*JADEX=$(JADE) -R ..\/dsssl\/catalog*/c\JADEX=$(JADE) -a ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -a failed"


    sed -i '/.*JADEX=$(JADE) -a ..\/dsssl\/catalog*/c\JADEX=$(JADE) -A ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -A failed"


    sed -i '/.*JADEX=$(JADE) -A ..\/dsssl\/catalog*/c\JADEX=$(JADE) -E ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -E failed"


    sed -i '/.*JADEX=$(JADE) -E ..\/dsssl\/catalog*/c\JADEX=$(JADE) -e ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -e failed"


    sed -i '/.*JADEX=$(JADE) -e ..\/dsssl\/catalog*/c\JADEX=$(JADE) -g ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -g failed"


    sed -i '/.*JADEX=$(JADE) -g ..\/dsssl\/catalog*/c\JADEX=$(JADE) -n ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -n failed"


    sed -i '/.*JADEX=$(JADE) -n ..\/dsssl\/catalog*/c\JADEX=$(JADE) -x ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -x failed"


    sed -i '/.*JADEX=$(JADE) -x ..\/dsssl\/catalog*/c\JADEX=$(JADE) -i ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -i failed"


    sed -i '/.*JADEX=$(JADE) -i ..\/dsssl\/catalog*/c\JADEX=$(JADE) -w ..\/dsssl\/catalog' Makefile
    make
    CHECK_RESULT $? 0 0 "Check jade -w failed"


    openjade --help 2>&1 | grep 'Usage: openjade'
    CHECK_RESULT $? 0 0 "Check jade --help  failed"

    openjade -h 2>&1 | grep 'Usage: openjade'
    CHECK_RESULT $? 0 0 "Check jade -h  failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_INSTALL openjade
    DNF_INSTALL git
    rm -rf ../../../openjade
    LOG_INFO "Finish restoring the test environment."
}

main $@