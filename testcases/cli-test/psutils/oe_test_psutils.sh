#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   gaoyue
#@Contact   :   2829807379@qq.com
#@Date      :   2022/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "tuna" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "tuna"
    systemctl restart sshd.service
    touch savefile
    LOG_INFO "End to prepare the test environment"
}
##########################################################

# psbook 1.23
# (c) Reuben Thomas <rrt@sc3d.org> 2014
# (c) Angus J. C. Duggan 1991-1997
# See file LICENSE for details.
# Usage: psbook [-q] [-sSIGNATURE] [INFILE [OUTFILE]]
#        SIGNATURE must be positive and divisible by 4

# psselect 1.23
# (c) Reuben Thomas <rrt@sc3d.org> 2014
# (c) Angus J. C. Duggan 1991-1997
# See file LICENSE for details.
# Usage: psselect [-q] [-e] [-o] [-r] [-pPAGES] [INFILE [OUTFILE]]

# pstops 1.23
# (c) Reuben Thomas <rrt@sc3d.org> 2014
# (c) Angus J. C. Duggan 1991-1997
# See file LICENSE for details.
# Usage: pstops [-q] [-b] [-wWIDTH] [-hHEIGHT] [-dLWIDTH] [-pPAPER] PAGESPECS [INFILE [OUTFILE]]

# psnup 1.23
# (c) Reuben Thomas <rrt@sc3d.org> 2014
# (c) Angus J. C. Duggan 1991-1997
# See file LICENSE for details.
# Usage: psnup [-q] [-wWIDTH] [-hHEIGHT] [-pPAPER] [-WWIDTH] [-HHEIGHT] [-PPAPER] [-l] [-r] [-c] [-f] [-mMARGIN] [-bBORDER] [-dLWIDTH] [-sSCALE] [-NUP] [INFILE [OUTFILE]]

# psresize 1.23
# (c) Reuben Thomas <rrt@sc3d.org> 2014
# (c) Angus J. C. Duggan 1991-1997
# See file LICENSE for details.
# Usage: psresize [-q] [-wWIDTH] [-hHEIGHT] [-pPAPER] [-WWIDTH] [-HHEIGHT] [-PPAPER] [INFILE [OUTFILE]]

# epsffit 1.23
# (c) Reuben Thomas <rrt@sc3d.org> 2014
# (c) Angus J. C. Duggan 1991-1997
# See file LICENSE for details.
# Usage: epsffit [-c] [-r] [-a] [-m] [-s] LLX LLY URX URY [INFILE [OUTFILE]]

##########################################################
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_tuna."
    ### psbook ###
    psbook -h | grep -E "psbook: invalid option -- \'h\'"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### psselect ###
    psselect | grep -E "psselect"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### pstops ###
    pstops | grep -E "pstops"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### psnup ###
    psnup -h | grep -E "psnup"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### psresize ###
    psresize -h | grep -E "psresize"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### epsffit ###
    epsffit | grep -E "epsffit"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf savefile result example.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
