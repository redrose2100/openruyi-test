# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2022-12-26
# @License   :   Mulan PSL v2
# @Desc      :   Command test-bsdcpio 
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo "111" >testfile1
    CHECK_RESULT $? 0 0 "check create file fail"
    find testfile1|bsdcpio -ovc >test
    CHECK_RESULT $? 0 0  "tar file fail"
    test -f test
    CHECK_RESULT $? 0 0  "the file not exist"
    bsdcpio --help|grep bsdcpio
    CHECK_RESULT $? 0 0  "check command fail"
    bsdcpio --version|grep libarchive    
    CHECK_RESULT $? 0 0  "check command fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf testfile1 test
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

