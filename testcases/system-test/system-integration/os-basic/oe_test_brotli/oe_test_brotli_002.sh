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
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023-07-28
# @License   :   Mulan PSL v2
# @Desc      :   Command test brotli -v -n
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    testdir=/tmp/oe_test-brotli002
    mkdir ${testdir}
    cd ${testdir} || return 
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    touch test.tar
    pre_sta=$(stat -c %a test.tar)
    brotli -n test.tar -o test-n.tar.br
    after_sta_n=$(stat -c %a test-n.tar.br)
    brotli --rm test.tar > log.brotli 2>&1
    test -e test.tar
    CHECK_RESULT $? 0 1 "check test.tar  delete faild"
    after_sta=$(stat -c %a test.tar.br)
    CHECK_RESULT "${pre_sta}" "${after_sta}" 0 "check test.tar attr without -n failed"
    CHECK_RESULT "${after_sta}" "${after_sta_n}" 1 "check test.tar attr with -n failed"
    grep "Compressed" log.brotli 
    CHECK_RESULT $? 1 0 "check brotli without -v failed"

    touch test2.tar 
    brotli -k -v test2.tar > log.brotli-v 2>&1
    test -e test2.tar && test -e test2.tar.br
    CHECK_RESULT $? 0 0 "check test.tar compression successful"
    grep "Compressed" log.brotli-v
    CHECK_RESULT $? 0 0 "check brotli -v failed"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf  ${testdir}
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
