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
    cp ./common/1.txt.pz ./
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    precat -h 2>&1 | fgrep "usage /usr/bin/precat [-dzhLV]"
    CHECK_RESULT $? 0 0 "Check precat -h failed"

    precat --help 2>&1 | fgrep "usage /usr/bin/precat [-dzhLV]"
    CHECK_RESULT $? 0 0 "Check precat --help failed"

    precat -V | grep "prezip, a prefix delta compressor. Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check precat -V  failed"

    precat --version | grep "prezip, a prefix delta compressor. Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check precat --version failed"

    precat -d 1.txt.pz | grep "aaa"
    CHECK_RESULT $? 0 0 "Check precat -d 1.txt.pz failed"

    precat --decompress 1.txt.pz | grep "aaa"
    CHECK_RESULT $? 0 0 "Check precat --decompress 1.txt.pz failed"

    precat -z 1.txt.pz | grep -a "bbb"
    CHECK_RESULT $? 0 0 "Check precat -z 1.txt.pz failed"

    precat --compress 1.txt.pz | grep -a "bbb"
    CHECK_RESULT $? 0 0 "Check precat --compress 1.txt.pz failed"

    precat -L 2>&1 | grep "Copyright (c)"
    CHECK_RESULT $? 0 0 "Check precat -L failed"

    precat --license 2>&1 | grep "Copyright (c)"
    CHECK_RESULT $? 0 0 "Check precat --license failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf 1.txt.pz
    LOG_INFO "End to restore the test environment."
}

main "$@"
