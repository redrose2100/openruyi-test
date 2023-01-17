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
    echo name > unziptest1.txt
    preunzip -z unziptest1.txt
    echo name > unziptest2.txt
    preunzip -z unziptest2.txt
    echo name > unziptest3.txt
    preunzip -z unziptest3.txt
    echo name > unziptest4.txt
    preunzip -z unziptest4.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    preunzip -k unziptest1.txt.pz && test -f unziptest1.txt.pz && test -f unziptest1.txt
    CHECK_RESULT $? 0 0 "Check preunzip -k failed"

    preunzip --keep unziptest2.txt.pz && test -f unziptest2.txt.pz && test -f unziptest2.txt
    CHECK_RESULT $? 0 0 "Check preunzip --keep failed"

    preunzip -q -S -s unziptest3.txt.pz && test -f unziptest3.txt
    CHECK_RESULT $? 0 0 "Check preunzip -q -S -s failed"

    preunzip --quiet --nocwl --sort unziptest4.txt.pz && test -f unziptest4.txt
    CHECK_RESULT $? 0 0 "Check preunzip --quiet --nocwl --sort failed"

    preunzip -f -c unziptest2.txt.pz | grep "name"
    CHECK_RESULT $? 0 0 "Check preunzip -f -c failed"

    preunzip --force --stdout unziptest2.txt.pz | grep "name"
    CHECK_RESULT $? 0 0 "Check preunzip --force --stdout failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf unziptest*
    LOG_INFO "End to restore the test environment."
}

main "$@"
