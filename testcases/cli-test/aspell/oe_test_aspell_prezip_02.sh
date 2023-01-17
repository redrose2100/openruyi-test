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
    echo name > ziptest1.txt
    echo name > ziptest2.txt
    echo name > ziptest3.txt
    echo name > ziptest4.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    prezip -k ziptest1.txt && test -f ziptest1.txt.pz && test -f ziptest1.txt
    CHECK_RESULT $? 0 0 "Check prezip -k failed"

    prezip -q -S -s ziptest2.txt && test -f ziptest2.txt.pz
    CHECK_RESULT $? 0 0 "Check prezip -q -S -s failed"

    prezip --keep ziptest3.txt && test -f ziptest3.txt.pz && test -f ziptest3.txt
    CHECK_RESULT $? 0 0 "Check prezip --keep failed"

    prezip --quiet --nocwl --sort ziptest4.txt && test -f ziptest4.txt.pz
    CHECK_RESULT $? 0 0 "Check prezip --quiet --nocwl --sort failed"

    prezip -f -c ziptest4.txt.pz | grep -a "name"
    CHECK_RESULT $? 0 0 "Check prezip -f -c failed"

    prezip --force --stdout ziptest4.txt.pz | grep -a "name"
    CHECK_RESULT $? 0 0 "Check prezip --force --stdout failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ziptest*
    LOG_INFO "End to restore the test environment."
}

main "$@"
