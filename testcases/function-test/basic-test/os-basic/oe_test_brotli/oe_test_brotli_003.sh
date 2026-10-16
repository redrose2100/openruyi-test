#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023-11-15
# @License   :   Mulan PSL v2
# @Desc      :   Command test brotli
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    testdir=/tmp/test1
    mkdir ${testdir}
    cd ${testdir} || return 
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    touch test
    brotli -o test.br test
    test -e test.br
    CHECK_RESULT $? 0 0 "check test.br  delete faild"
    brotli -S .custom  test 
    test -e test.custom
    CHECK_RESULT $? 0 0 "check test.custom  delete faild"
    brotli -c test.br  > output.br
    test -e output.br
    CHECK_RESULT $? 0 0 "check output.br  delete faild"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf  ${testdir}
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
