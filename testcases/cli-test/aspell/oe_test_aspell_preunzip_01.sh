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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    preunzip -h 2>&1 | fgrep "usage /usr/bin/preunzip [-dzhLV]"
    CHECK_RESULT $? 0 0 "Check preunzip -h failed"

    preunzip --help 2>&1 | fgrep "usage /usr/bin/preunzip [-dzhLV]"
    CHECK_RESULT $? 0 0 "Check preunzip --help failed"

    preunzip -V | grep "prezip, a prefix delta compressor. Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check preunzip -V failed"

    preunzip --version | grep "prezip, a prefix delta compressor. Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check preunzip --version failed"

    preunzip -z unziptest1.txt && test -f unziptest1.txt.pz
    CHECK_RESULT $? 0 0 "Check preunzip -z failed"

    preunzip -d unziptest1.txt.pz && test -f unziptest1.txt
    CHECK_RESULT $? 0 0 "Check preunzip -d failed"

    preunzip --compress unziptest1.txt && test -f unziptest1.txt.pz
    CHECK_RESULT $? 0 0 "Check preunzip --compress failed"

    preunzip --decompress unziptest1.txt.pz && test -f unziptest1.txt
    CHECK_RESULT $? 0 0 "Check preunzip --decompress failed"

    preunzip -L 2>&1 | grep "Copyright (c) "
    CHECK_RESULT $? 0 0 "Check preunzip -L failed"

    preunzip --license 2>&1 | grep "Copyright (c) "
    CHECK_RESULT $? 0 0 "Check preunzip --license failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf unziptest*
    LOG_INFO "End to restore the test environment."
}

main "$@"
