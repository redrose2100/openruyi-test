#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linjianbo
# @Contact   :   jianbo.lin@outlook.com
# @Date      :   2023/07/28
# @License   :   Mulan PSL v2
# @Desc      :   test psutils
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL psutils
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing... "

    # # test psbook
    LOG_INFO "Start testing psbook."
    psbook -v 2>&1 | grep -i "psbook"
    CHECK_RESULT $? 0 0 "psbook -h execution failed."
    psbook -s4 a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 0 "psbook -s4 a4-1.ps execution failed."
    psbook -q -s8 a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 1 "psbook -q -s8 a4-1.ps execution failed."

    # # test pstops
    LOG_INFO "Start testing pstops." 
    pstops -v 2>&1 | grep -i -a "pstops"
    CHECK_RESULT $? 0 0 "pstops -v execution failed."
    pstops -q '2:0L@.7(21cm,0)+1L@.7(21cm,14.85cm)' a4-11.ps 2>&1 | grep -a -i "wrote"
    CHECK_RESULT $? 0 1 "pstops '2:0L@.7(21cm,0)+1L@.7(21cm,14.85cm)' a4-11.ps execution failed."
    pstops -pA4 '2:-0' a4-11.ps 2>&1 | grep -a -i "A4"
    CHECK_RESULT $? 0 0 "pstops '2:-0' a4-11.ps execution failed."
    pstops -h11in -w8.5in '4:-3L@.7(21cm,0)+0L@.7(21cm,14.85cm)' a4-11.ps 2>&1 | grep -a -i "wrote"
    CHECK_RESULT $? 0 0 "pstops '4:-3L@.7(21cm,0)+0L@.7(21cm,14.85cm)' a4-11.ps execution failed."


    # test extractres
    LOG_INFO "Start testing extractres."
    extractres -v 2>&1 | grep -i "extractres"
    CHECK_RESULT $? 0 0 "extractres -v execution failed."
    extractres -m a4-1.ps 2>&1
    find . -name ISO-8859-1Encoding.enc | grep ISO-8859-1Encoding.enc
    CHECK_RESULT $? 0 0 "extractres -m a4-1.ps execution failed."
    rm ISO-8859-1Encoding.enc
    rm a2ps*
    

    # test epsffit
    LOG_INFO "Start testing epsffit."
    epsffit -v 2>&1| grep -i "epsffit"
    CHECK_RESULT $? 0 0 "epsffit -v execution failed."
    epsffit -c 0 0 500 800 a4-1.ps 2>&1 | grep -i -a "BoundingBox"
    CHECK_RESULT $? 0 0 "epsffit -c 0 0 500 800 a4-1.ps execution failed."
    epsffit -a 0 0 500 800 a4-1.ps 2>&1 | grep "BeginProcSet: epsffit"
    CHECK_RESULT $? 0 0 "epsffit -a 0 0 500 800 a4-1.ps execution failed."
    epsffit -r 0 0 500 800 a4-1.ps 2>&1 | grep "90 rotate"
    CHECK_RESULT $? 0 0 "epsffit -r 0 0 500 800 a4-1.ps execution failed."
    epsffit -m 0 0 500 800 a4-1.ps 2>&1 | grep "BeginProcSet: epsffit"
    CHECK_RESULT $? 0 0 "epsffit -m 0 0 500 800 a4-1.ps execution failed."

    # test includeres
    LOG_INFO "Start testing includeres."
    includeres a4-1.ps 2>&1 | grep "includeres: resource"
    CHECK_RESULT $? 0 0 "includeres a4-1.ps execution failed."

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
