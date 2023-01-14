# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of openjade command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openjade
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    openjade -b utf-8 -f ./error.log common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -b failed"
    openjade --encoding utf-8 -f ./error.log common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --encoding failed"
    openjade -b utf-8 -f ./error.log common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade -f failed"
    openjade -b utf-8 --error-file ./error.log common/null.sgml
    CHECK_RESULT $? 0 0 "Check openjade --error-file failed"
    openjade -v -t rtf common/null.sgml 2>&1 | grep $(rpm -q openjade --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check openjade -v failed"
    openjade --version -t rtf common/null.sgml 2>&1 | grep $(rpm -q openjade --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check openjade --version failed"
    openjade -h 2>&1 | grep 'Usage'
    CHECK_RESULT $? 0 0 "Check openjade -h failed"
    openjade --help 2>&1 | grep 'Usage'
    CHECK_RESULT $? 0 0 "Check openjade -help failed"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf error.* common/*.rtf common/*.fot common/*.xml common/error.*
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
