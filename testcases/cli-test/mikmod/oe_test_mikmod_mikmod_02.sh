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
    # Test the -y,-di[rectory] parameter
    echo "Q" | mikmod -y common > /dev/null && \
        cat ~/.mikmod_playlist | grep -q "common"
    CHECK_RESULT $? 0 0 "Check -y failed"
    rm -rf ~/.mikmod_playlist
    echo "Q" | mikmod -directory common > /dev/null && \
        cat ~/.mikmod_playlist | grep -q "common"
    CHECK_RESULT $? 0 0 "Check -di[rectory] failed"
    # Test the -q[uiet] parameter
    mikmod -q & ps | grep -q "mikmod" && kill -INT $!
    CHECK_RESULT $? 0 0 "Check -q[uiet] failed"
	mikmod -quiet & ps | grep -q "mikmod" && kill -INT $!
    CHECK_RESULT $? 0 0 "Check -quiet failed"
    # Test the -v[olume] parameter
    echo "Q" | mikmod -v 1 > /dev/null && \
        cat ~/.mikmodrc | grep -q "VOLUME = 1"
    CHECK_RESULT $? 0 0 "Check -v 1 failed"
	echo "Q" | mikmod -volume 1 > /dev/null && \
        cat ~/.mikmodrc | grep -q "VOLUME = 1"
    CHECK_RESULT $? 0 0 "Check -volume 1 failed"
    #Test the -o[utput] parameter
	echo "Q" | mikmod -o 8m > /dev/null && \
        cat ~/.mikmodrc | grep -qE "16BIT = no|STEREO = no"
    CHECK_RESULT $? 0 0 "Check -o[utput] 8m failed"
	echo "Q" | mikmod -o 8s > /dev/null && \
        cat ~/.mikmodrc | grep -qE "16BIT = no|STEREO = yes"
    CHECK_RESULT $? 0 0 "Check -o[utput] 8s failed"
	echo "Q" | mikmod -o 16m > /dev/null && \
        cat ~/.mikmodrc | grep -qE "16BIT = yes|STEREO = no"
    CHECK_RESULT $? 0 0 "Check -o[utput] 16m failed"
	echo "Q" | mikmod -o 16s > /dev/null && \
        cat ~/.mikmodrc | grep -qE "16BIT = yes|STEREO = yes"
    CHECK_RESULT $? 0 0 "Check -o[utput] 16s failed"
	echo "Q" | mikmod -output 8m > /dev/null && \
        cat ~/.mikmodrc | grep -qE "16BIT = no|STEREO = no"
    CHECK_RESULT $? 0 0 "Check -output 8m failed"
    #Test the -f[requency] parameter
	echo "Q" | mikmod -f 11025 > /dev/null && \
        cat ~/.mikmodrc | grep -q "FREQUENCY = 11025"
    CHECK_RESULT $? 0 0 "cCheck -f 11025 failed"
	echo "Q" | mikmod -frequency 11025 > /dev/null && \
        cat ~/.mikmodrc | grep -q "FREQUENCY = 11025"
    CHECK_RESULT $? 0 0 "cCheck -frequency 11025 failed"
    #Test the -r[everb] parameter
	echo "Q" | mikmod -r 0 > /dev/null && \
        cat ~/.mikmodrc | grep -q "REVERB = 0"
    CHECK_RESULT $? 0 0 "Check -r 0 failed"
	echo "Q" | mikmod -reverb 0 > /dev/null && \
        cat ~/.mikmodrc | grep -q "REVERB = 0"
    CHECK_RESULT $? 0 0 "Check -reverb 0 failed"
    # Test the -F|-fa[deout],-nofa[deout] parameter
	echo "Q" | mikmod -F > /dev/null && \
        cat ~/.mikmodrc | grep -q "FADEOUT = yes"
    CHECK_RESULT $? 0 0 "Check -F failed"
	echo "Q" | mikmod -nofa > /dev/null && \
        cat ~/.mikmodrc | grep -q "FADEOUT = no"
    CHECK_RESULT $? 0 0 "Check -nofa failed"
	echo "Q" | mikmod -fa > /dev/null && \
        cat ~/.mikmodrc | grep -q "FADEOUT = yes"
    CHECK_RESULT $? 0 0 "Check -fa failed"
	echo "Q" | mikmod -fadeout > /dev/null && \
        cat ~/.mikmodrc | grep -q "FADEOUT = yes"
    CHECK_RESULT $? 0 0 "Check -fadeout failed"
	echo "Q" | mikmod -nofadeout > /dev/null && \
        cat ~/.mikmodrc | grep -q "FADEOUT = no"
    CHECK_RESULT $? 0 0 "Check -nofadeout failed"
    # Test the -l[oops],-nol[oops] parameter
	echo "Q" | mikmod -l > /dev/null && \
        cat ~/.mikmodrc | grep -q "LOOP = yes"
    CHECK_RESULT $? 0 0 "Check -l failed"
	echo "Q" | mikmod -nol > /dev/null && \
        cat ~/.mikmodrc | grep -q "LOOP = no"
    CHECK_RESULT $? 0 0 "Check -nol failed"
	echo "Q" | mikmod -loops > /dev/null && \
        cat ~/.mikmodrc | grep -q "LOOP = yes"
    CHECK_RESULT $? 0 0 "Check -loops failed"
	echo "Q" | mikmod -noloops > /dev/null && \
        cat ~/.mikmodrc | grep -q "LOOP = no"
    CHECK_RESULT $? 0 0 "Check -noloops failed"
    # Test the -a|-pa[nning], parameter
	echo "Q" | mikmod -pa > /dev/null && \
        cat ~/.mikmodrc | grep -q "PANNING = yes"
    CHECK_RESULT $? 0 0 "Check -pa failed"
	echo "Q" | mikmod -nopa > /dev/null && \
        cat ~/.mikmodrc | grep -q "PANNING = no"
    CHECK_RESULT $? 0 0 "Check -nopa failed"
	echo "Q" | mikmod -a > /dev/null && \
        cat ~/.mikmodrc | grep -q "PANNING = yes"
    CHECK_RESULT $? 0 0 "Check -a failed"
	echo "Q" | mikmod -panning > /dev/null && \
        cat ~/.mikmodrc | grep -q "PANNING = yes"
    CHECK_RESULT $? 0 0 "Check -panning failed"
	echo "Q" | mikmod -nopanning > /dev/null && \
        cat ~/.mikmodrc | grep -q "PANNING = no"
    CHECK_RESULT $? 0 0 "Check -nopanning failed"
    # Test the -x|-pr[otracker],-nopr[otracker] parameter
	echo "Q" | mikmod -pr > /dev/null && \
        cat ~/.mikmodrc | grep -q "EXTSPD = no"
    CHECK_RESULT $? 0 0 "Check -pr failed"
	echo "Q" | mikmod -nopr > /dev/null && \
        cat ~/.mikmodrc | grep -q "EXTSPD = yes"
    CHECK_RESULT $? 0 0 "Check -nopr failed"
	echo "Q" | mikmod -x > /dev/null && \
        cat ~/.mikmodrc | grep -q "EXTSPD = no"
    CHECK_RESULT $? 0 0 "Check -x failed"
	echo "Q" | mikmod -protracker > /dev/null && \
        cat ~/.mikmodrc | grep -q "EXTSPD = no"
    CHECK_RESULT $? 0 0 "Check -protracker failed"
	echo "Q" | mikmod -noprotracker > /dev/null && \
        cat ~/.mikmodrc | grep -q "EXTSPD = yes"
    CHECK_RESULT $? 0 0 "Check -noprotracker failed"
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