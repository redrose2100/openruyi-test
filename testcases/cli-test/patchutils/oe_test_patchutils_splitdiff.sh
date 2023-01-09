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
# @Desc      :   verify the uasge of patchutils command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL patchutils
    mkdir patchutils
    cd patchutils
    cp ../common/1.txt ./
    cp ../common/2.txt ./
    diff -Naur 1.txt 2.txt >test1.patch
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    splitdiff --help 2>&1 | grep "usage: splitdiff"
    CHECK_RESULT $? 0 0 "Check splitdiff --help  failed"
    splitdiff --version | grep "splitdiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check splitdiff --version  failed"
    splitdiff -a -p 1 test1.patch | grep "Wrote >test1.patch"
    CHECK_RESULT $? 0 0 "Check splitdiff -a -p 1 test1.patch  failed"
    splitdiff -a -D ./ test1.patch && test -f 1.txt.patch
    CHECK_RESULT $? 0 0 "Check splitdiff -a -D ./ test1.patch  failed"
    splitdiff -a -d -E test1.patch | grep "Wrote >1.txt"
    CHECK_RESULT $? 0 0 "Check plitdiff -a -d -E test1.patch  failed"
    unwrapdiff --help 2>&1 | grep "usage: unwrapdiff"
    CHECK_RESULT $? 0 0 "Check unwrapdiff --help  failed"
    unwrapdiff --version 2>&1 | grep "unwrapdiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check unwrapdiff --version  failed"
    unwrapdiff -v ./ 1.txt | grep "@@ -1 +1,2 @@"
    CHECK_RESULT $? 0 0 "Check unwrapdiff -v ./ 1.txt  failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf patchutils
    LOG_INFO "Finish restore the test environment."
}

main "$@"
