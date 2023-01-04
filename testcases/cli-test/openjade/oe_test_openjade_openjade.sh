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
    openjade -b utf-8 -f ./error.log -c ./ -C -D ./ -R -s ./common/null.sgml
    CHECK_RESULT "$(test -f ./error.log)" 1 0 "Check jade -b -f -c -C -D -R -s failed "
    openjade -b utf-8 -f ./error.log -c ./ -C -D ./ -R -a test -A TEST -e -g -n -x -i INCLUDE -w xml -t fot -G -2 -d text -V 10 -s ./common/null.sgml -o abc.fot
    CHECK_RESULT "$(test -f ./error.log)" 1 0 "Check jade -b -f -c -C -D -R -s -a -A -e -g -n -x -i -w -t -G -2 -d -V -s -o failed "
    openjade --help 2>&1 | grep 'Usage: openjade'
    CHECK_RESULT $? 0 0 "Check jade --help failed"
    openjade -h 2>&1 | grep 'Usage: openjade'
    CHECK_RESULT $? 0 0 "Check jade -h failed"
    openjade -v -f -c ./ 2>&1 | grep 'jade'
    CHECK_RESULT $? 0 0 "Check jade -v -f -c failed"
    openjade --version -f -c ./ 2>&1 | grep 'jade'
    CHECK_RESULT $? 0 0 "Check jade -v -f -c failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
