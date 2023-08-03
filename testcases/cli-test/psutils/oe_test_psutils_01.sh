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

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL psutils
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing... "
    # test psjoin
    LOG_INFO "Start testing psjoin."
    psjoin -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "psjoin -h execution failed."
    psjoin -V | grep -i "version"
    CHECK_RESULT $? 0 0 "psjoin -V execution failed."
    psjoin a4-1.ps a4-1.ps | grep -i -a "Pages: 2"
    CHECK_RESULT $? 0 0 "psjoin a4-1.ps a4-1.ps execution failed."
    psjoin --strip | grep -i -a "don't strip"
    CHECK_RESULT $? 0 0 "psjoin --strip execution failed."
    psjoin --even a4-1.ps | grep -a -i -E "pages: [1-9]*[02468]$"
    CHECK_RESULT $? 0 0 "psjoin --even a4-1.ps execution failed."

    # # test psselect
    LOG_INFO "Start testing psselect."
    psselect -v 2>&1| grep -i "psselect"
    CHECK_RESULT $? 0 0 "psselect -v execution failed."
    psselect 2>&1 | grep -i -a "usage"
    CHECK_RESULT $? 0 0 "psselect execution failed."
    psselect -o a4-11.ps | rep -a -i -E "%%Page: \(\d*[02468]\)"
    CHECK_RESULT $? 0 1 "psselect -o a4-11.ps execution failed."
    psselect -e a4-11.ps | grep -a -i -E "%%Page: \(\d*[13579]\)"
    CHECK_RESULT $? 0 1 "psselect -e a4-11.ps execution failed."
    psselect -p1 -p2 -p4 a4-11.ps 2>&1 | grep -a -i "\[1\] \[2\] \[4\] Wrote 3 pages"
    CHECK_RESULT $? 0 0 "psselect -p1 -p2 -p4 a4-11.ps execution failed."
    psselect -r a4-2.ps 2>&1 | grep -i -a "\[2\] \[1\] Wrote 2 pages"
    CHECK_RESULT $? 0 0 "psselect -r a4-2.ps execution failed."
    psselect -r -q a4-11.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 1 "psselect -r -q a4-11.ps execution failed." 

    # # test psresize
    LOG_INFO "Start testing psresize."
    psresize -PA4 -pA5 a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 0 "psresize -PA4 -pA5 a4-1.ps execution failed."
    psresize -W595 -H842 -w600 -h800 a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 0 "psresize -W595 -H842 -w600 -h800 a4-1.ps execution failed."
    psresize -PA4 -pA5 -q a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 1 "psresize -PA4 -pA5 -q a4-1.ps execution failed."

    # test psnup
    LOG_INFO "Start testing psnup."
    psnup -v 2>&1| grep -i "psnup"
    CHECK_RESULT $? 0 0 "psnup -v execution failed."
    psnup -2 a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 0 "psnup -2 a4-1.ps  execution failed."
    psnup -4 a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 0 "psnup -4 a4-1.ps execution failed."
    psnup -q a4-1.ps 2>&1 | grep -i -a "wrote"
    CHECK_RESULT $? 0 1 "psnup -q a4-1.ps execution failed."
    psnup -l a4-1.ps | grep -i -a "PStoPSxform"
    CHECK_RESULT $? 0 0 "psnup -l a4-1.ps execution failed."
    psnup -r a4-1.ps | grep -i -a "PStoPSxform"
    CHECK_RESULT $? 0 0 "psnup -r a4-1.ps execution failed."
    psnup -f a4-1.ps | grep -i -a "PStoPSxform"
    CHECK_RESULT $? 0 0 "psnup -f a4-1.ps execution failed."
    psnup -c a4-1.ps | grep -i -a "PStoPSxform"
    CHECK_RESULT $? 0 0 "psnup -c a4-1.ps execution failed."
    psnup -m42 a4-1.ps | grep -i -a "PStoPSxform"
    CHECK_RESULT $? 0 0 "psnup -m42 a4-1.ps execution failed."
    psnup -b20 a4-1.ps | grep -i -a "PStoPSxform"
    CHECK_RESULT $? 0 0 "psnup -b20 a4-1.ps execution failed."
    psnup -d a4-1.ps | grep -i -a "PStoPSxform"
    CHECK_RESULT $? 0 0 "psnup -d a4-1.ps execution failed."
    psnup -pA4 -Pletter a4-1.ps | grep -i -a "plain 612 792"
    CHECK_RESULT $? 0 0 "psnup -pA4 -Pletter a4-1.ps execution failed."
    psnup -q a4-1.ps |grep "wrote"
    CHECK_RESULT $? 0 1 "psnup -q a4-1.ps execution failed."

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
