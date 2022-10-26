#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   TEST mikmod options
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    modprobe snd-dummy
    DNF_INSTALL "mikmod"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    # Test the -c[urious],-noc[urious] parameter
	echo "Q" | mikmod -c > /dev/null && \
        cat ~/.mikmodrc | grep -q "CURIOUS = yes"
    CHECK_RESULT $? 0 0 "Check -c failed"
	echo "Q" | mikmod -noc > /dev/null && \
        cat ~/.mikmodrc | grep -q "CURIOUS = no"
    CHECK_RESULT $? 0 0 "Check -noc failed"
	echo "Q" | mikmod -curious > /dev/null && \
        cat ~/.mikmodrc | grep -q "CURIOUS = yes"
    CHECK_RESULT $? 0 0 "Check -curious failed"
	echo "Q" | mikmod -nocurious > /dev/null && \
        cat ~/.mikmodrc | grep -q "CURIOUS = no"
    CHECK_RESULT $? 0 0 "Check -nocurious failed"
    # Test the -p[laymode] parameter
	echo "Q" | mikmod -p 1 > /dev/null && \
        cat ~/.mikmodrc | grep -q "PM_MODULE = yes"
    CHECK_RESULT $? 0 0 "Check -p 1 failed"
	echo "Q" | mikmod -p 2 > /dev/null && \
        cat ~/.mikmodrc | grep -q "PM_MULTI = yes"
    CHECK_RESULT $? 0 0 "Check -p 2 failed"
	echo "Q" | mikmod -p 4 > /dev/null && \
        cat ~/.mikmodrc | grep -q "PM_SHUFFLE = yes"
    CHECK_RESULT $? 0 0 "Check -p 4 failed"
	echo "Q" | mikmod -p 8 > /dev/null && \
        cat ~/.mikmodrc | grep -q "PM_RANDOM = yes"
    CHECK_RESULT $? 0 0 "Check -p 8 failed"
	echo "Q" | mikmod -playmode 1 > /dev/null && \
        cat ~/.mikmodrc | grep -q "PM_MODULE = yes"
    CHECK_RESULT $? 0 0 "Check -playmode 1 failed"
    # Test the -t[olerant] parameter
	echo "Q" | mikmod -t > /dev/null && \
        cat ~/.mikmodrc | grep -q "TOLERANT = yes"
    CHECK_RESULT $? 0 0 "Check -t failed"	
	echo "Q" | mikmod -not > /dev/null && \
        cat ~/.mikmodrc | grep -q "TOLERANT = no"
    CHECK_RESULT $? 0 0 "Check -not failed"
	echo "Q" | mikmod -tolerant > /dev/null && \
        cat ~/.mikmodrc | grep -q "TOLERANT = yes"
    CHECK_RESULT $? 0 0 "Check -tolerant failed"	
	echo "Q" | mikmod -notolerant > /dev/null && \
        cat ~/.mikmodrc | grep -q "TOLERANT = no"
    CHECK_RESULT $? 0 0 "Check -tolerant failed"
    # Test the -s|-ren[ice],-noren[ice],-S|-rea[ltime],-norea[ltime] parameter
	echo "Q" | mikmod -ren > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_PRI"
    CHECK_RESULT $? 0 0 "Check -ren failed"
	echo "Q" | mikmod -renice > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_PRI"
    CHECK_RESULT $? 0 0 "Check -renice failed"
	echo "Q" | mikmod -norenice > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_NONE"
    CHECK_RESULT $? 0 0 "Check -norenice failed"
	echo "Q" | mikmod -s > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_PRI"
    CHECK_RESULT $? 0 0 "Check -s failed"
	echo "Q" | mikmod -rea > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_REAL"
    CHECK_RESULT $? 0 0 "Check -rea failed"
	echo "Q" | mikmod -norea > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_NONE"
    CHECK_RESULT $? 0 0 "Check -norea failed"
	echo "Q" | mikmod -realtime > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_REAL"
    CHECK_RESULT $? 0 0 "Check -realtime failed"
	echo "Q" | mikmod -norealtime > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_NONE"
    CHECK_RESULT $? 0 0 "Check -norealtime failed"
	echo "Q" | mikmod -S > /dev/null && \
        cat ~/.mikmodrc | grep -q "RENICE = RENICE_REAL"
    CHECK_RESULT $? 0 0 "Check -S failed"
    # Test the -i[nterpolate],-noi[nterpolate] parameter
	echo "Q" | mikmod -i > /dev/null && \
        cat ~/.mikmodrc | grep -q "INTERPOLATE = yes"
    CHECK_RESULT $? 0 0 "Check -i failed"
	echo "Q" | mikmod -noi > /dev/null && \
        cat ~/.mikmodrc | grep -q "INTERPOLATE = no"
    CHECK_RESULT $? 0 0 "Check -noi failed"
	echo "Q" | mikmod -interpolate > /dev/null && \
        cat ~/.mikmodrc | grep -q "INTERPOLATE = yes"
    CHECK_RESULT $? 0 0 "Check -interpolate failed"
	echo "Q" | mikmod -nointerpolate > /dev/null && \
        cat ~/.mikmodrc | grep -q "INTERPOLATE = no"
    CHECK_RESULT $? 0 0 "Check -nointerpolate failed"
    # Test the -hq[mixer],-nohq[mixer] parameter
	echo "Q" | mikmod -hq > /dev/null && \
        cat ~/.mikmodrc | grep -q "HQMIXER = yes"
    CHECK_RESULT $? 0 0 "Check -hq failed"
	echo "Q" | mikmod -nohq > /dev/null && \
        cat ~/.mikmodrc | grep -q "HQMIXER = no"
	CHECK_RESULT $? 0 0 "Check -nohq failed"
	echo "Q" | mikmod -hqmixer > /dev/null && \
        cat ~/.mikmodrc | grep -q "HQMIXER = yes"
    CHECK_RESULT $? 0 0 "Check -hqmixer failed"
	echo "Q" | mikmod -nohqmixer > /dev/null && \
        cat ~/.mikmodrc | grep -q "HQMIXER = no"
    CHECK_RESULT $? 0 0 "Check -nohqmixer failed"
    # Test the -su[rround],-nosu[rround] parameter
	echo "Q" | mikmod -su > /dev/null && \
        cat ~/.mikmodrc | grep -q "SURROUND = yes"
    CHECK_RESULT $? 0 0 "Check -su failed"
	echo "Q" | mikmod -nosu > /dev/null && \
        cat ~/.mikmodrc | grep -q "SURROUND = no"
    CHECK_RESULT $? 0 0 "Check -nosu failed"
	echo "Q" | mikmod -surround > /dev/null && \
        cat ~/.mikmodrc | grep -q "SURROUND = yes"
    CHECK_RESULT $? 0 0 "Check -surround failed"
	echo "Q" | mikmod -nosurround > /dev/null && \
        cat ~/.mikmodrc | grep -q "SURROUND = no"
    CHECK_RESULT $? 0 0 "Check -nosurround failed"
    # Test the -norc parameter
    echo "Q" | mikmod -norc | grep -q "empty" 
    CHECK_RESULT $? 0 0 "Check -norc failed"
    LOG_INFO "End to run test."
}

# Post-processing, restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    modprobe -r snd-dummy
    rm -rf ~/.mikmod*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"