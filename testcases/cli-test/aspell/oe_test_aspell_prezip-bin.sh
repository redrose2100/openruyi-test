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

    prezip-bin -z <1.txt >wordlist.cwl && test -f wordlist.cwl
    CHECK_RESULT $? 0 0 "Check prezip-bin -z failed"

    prezip-bin -d <wordlist.cwl >wordlist.txt && test -f wordlist.txt
    CHECK_RESULT $? 0 0 "Check prezip-bin -d failed"

    prezip-bin --help 2>&1 | grep "prezip, a prefix delta compressor"
    CHECK_RESULT $? 0 0 "Check prezip-bin --help failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf 1.txt wordlist.*
    LOG_INFO "End to restore the test environment."
}

main "$@"
