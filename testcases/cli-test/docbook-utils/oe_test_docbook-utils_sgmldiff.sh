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
# @Desc      :   verify the uasge of docbook-utils command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL docbook-utils
    cp -r ./common doc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    sgmldiff -a -s -c textpos doc/helloworld.sgml doc/helloworld1.sgml | grep "Hello World"
    CHECK_RESULT $? 0 0 "Check sgmldiff -a -s -c failed"

    sgmldiff --attributes --statistics --context textpos doc/helloworld.sgml doc/helloworld1.sgml | grep "Hello World"
    CHECK_RESULT $? 0 0 "Check sgmldiff --attributes --statistics --context failed"

    sgmldiff -h 2>&1 | fgrep "Usage: sgmldiff [options]"
    CHECK_RESULT $? 0 0 "Check sgmldiff -h failed"

    sgmldiff --help 2>&1 | fgrep "Usage: sgmldiff [options]"
    CHECK_RESULT $? 0 0 "Check sgmldiff --help failed"

    sgmldiff -v | grep "sgmldiff v[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check sgmldiff -v failed"

    sgmldiff --version | grep "sgmldiff v[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check sgmldiff --version failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doc
    LOG_INFO "Finish restore the test environment."
}

main "$@"
