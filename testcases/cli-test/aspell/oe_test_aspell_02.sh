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
    unzip common/aspell6-en-2020.12.07-0.zip
    cp -R ./aspell6-en-2020.12.07-0/* /usr/lib64/aspell-0.60
    export LANG=en_US
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    echo namee | aspell pipe | grep "& namee 34 0:"
    CHECK_RESULT $? 0 0 "Check aspell pipe failed"

    echo name | aspell soundslike | grep "NM"
    CHECK_RESULT $? 0 0 "Check aspell soundslike failed"

    echo name | aspell expand | grep "name"
    CHECK_RESULT $? 0 0 "Check aspell expand failed"

    echo and | aspell clean | grep "and"
    CHECK_RESULT $? 0 0 "Check aspell clean failed"

    echo "and name" | aspell munch-list | grep "and name"
    CHECK_RESULT $? 0 0 "Check aspell munch-list failed"

    aspell dicts | grep "en_US-variant_0"
    CHECK_RESULT $? 0 0 "Check aspell dicts failed"

    echo "this" | aspell munch --sug-mode=bad-spellers -l en dump | grep "this thi/S"
    CHECK_RESULT $? 0 0 "Check aspell munch --sug-mode=bad-spellers dump failed"

    echo "and" | aspell munch --sug-mode=bad-spellers -l en conv from to either none | grep "and"
    CHECK_RESULT $? 0 0 "Check aspell munch --sug-mode=bad-spellers conv from to either none failed"

    echo "name" | aspell munch --sug-mode=bad-spellers -l en norm-map | grep "name"
    CHECK_RESULT $? 0 0 "Check aspell munch --sug-mode=bad-spellers -l en norm-map 1.txt failed"

    echo namee >2.txt
    spell 2.txt | grep "namee"
    CHECK_RESULT $? 0 0 "Check spell failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf aspell6-en-2020.12.07-0 2.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
