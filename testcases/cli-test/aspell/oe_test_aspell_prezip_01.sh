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
    echo name >ziptest1.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    prezip -h 2>&1 | fgrep "usage /usr/bin/prezip [-dzhLV]"
    CHECK_RESULT $? 0 0 "Check prezip -h  failed"

    prezip --help 2>&1 | fgrep "usage /usr/bin/prezip [-dzhLV]"
    CHECK_RESULT $? 0 0 "Check prezip --help  failed"

    prezip -V | grep "prezip, a prefix delta compressor. Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check prezip -V  failed"

    prezip --version | grep "prezip, a prefix delta compressor. Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check prezip --version  failed"

    prezip -z ziptest1.txt && test -f ziptest1.txt.pz
    CHECK_RESULT $? 0 0 "Check prezip -z failed"

    prezip -d ziptest1.txt.pz && test -f ziptest1.txt
    CHECK_RESULT $? 0 0 "Check prezip -d failed"

    prezip --compress ziptest1.txt && test -f ziptest1.txt.pz
    CHECK_RESULT $? 0 0 "Check prezip --compress failed"

    prezip --decompress ziptest1.txt.pz && test -f ziptest1.txt
    CHECK_RESULT $? 0 0 "Check prezip --decompress failed"

    prezip -L 2>&1 | grep " Copyright (c)"
    CHECK_RESULT $? 0 0 "Check prezip -L failed"

    prezip --license 2>&1 | grep " Copyright (c)"
    CHECK_RESULT $? 0 0 "Check prezip --license failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ziptest*
    LOG_INFO "End to restore the test environment."
}

main "$@"
