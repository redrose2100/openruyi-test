#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test bacon
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-bacon tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    # test -n
    bacon -a -n "should have" | grep "46 specifications (618 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon -n failed"
    # test --name
    bacon -a --name "should have" | grep "46 specifications (618 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon --name failed"
    # test -d
    bacon --tap ./data/whirlwind.rb  -d > tmp.txt 2>&1
    grep "Exception " tmp.txt
    CHECK_RESULT $? 0 0 "Check bacon -d failed"
    rm -f tmp.txt
    # test --debug
    bacon --tap ./data/whirlwind.rb  --debug > tmp.txt 2>&1
    grep "Exception " tmp.txt
    CHECK_RESULT $? 0 0 "Check bacon --debug failed"
    rm -f tmp.txt
    # test -w
    bacon --tap ./test/spec_nontrue.rb  -w | grep "WARN -- : this is warn log"
    CHECK_RESULT $? 0 0 "Check bacon -w failed"
    # test --warn
    bacon --tap ./test/spec_nontrue.rb  --warn | grep "WARN -- : this is warn log"
    CHECK_RESULT $? 0 0 "Check bacon --warn failed"
    # test -I
    bacon ./test/spec_bacon_nolib.rb -I ./lib/ -r ./lib/bacon | grep "43 specifications (398 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon -I failed"
    # test --include
    bacon ./test/spec_bacon_nolib.rb --include ./lib/ -r ./lib/bacon | grep "43 specifications (398 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon --include failed"
    # test -r
    bacon ./test/spec_bacon_nolib.rb -I ./lib/ -r ./lib/bacon | grep "43 specifications (398 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon -r failed"
    # test --require
    bacon ./test/spec_bacon_nolib.rb -I ./lib/ --require ./lib/bacon | grep "43 specifications (398 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon --require failed"
    # test -t
    bacon -t 'demo' ./data/whirlwind.rb | grep "0 specifications (0 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon -t failed"
    # test --testcase
    bacon --testcase 'demo' ./data/whirlwind.rb | grep "0 specifications (0 requirements), 0 failures, 0 errors"
    CHECK_RESULT $? 0 0 "Check bacon --testcase failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data ./lib/ ./test/
    LOG_INFO "End to restore the test environment."
}
main "$@"
