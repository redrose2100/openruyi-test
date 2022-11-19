# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of aspell command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL aspell
    echo name >1.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    word-list-compress c <1.txt >wordlist.cwl && test -f wordlist.cwl
    CHECK_RESULT $? 0 0 "Check word-list-compress c failed"

    word-list-compress d <wordlist.cwl >wordlist.txt && test -f wordlist.txt
    CHECK_RESULT $? 0 0 "Check word-list-compress d failed"

    word-list-compress --help 2>&1 | grep "Compresses or uncompresses"
    CHECK_RESULT $? 0 0 "Check word-list-compress --help failed"

    run-with-aspell -a java -c -l prezip 1.txt && test -f 1.txt.pz
    CHECK_RESULT $? 0 0 "Check run-with-aspell -a java -c -l failed"

    run-with-aspell --help | fgrep "exec: exec [-cl]"
    CHECK_RESULT $? 0 0 "Check run-with-aspell --help failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf 1.txt.pz wordlist.*
    LOG_INFO "End to restore the test environment."
}

main "$@"
