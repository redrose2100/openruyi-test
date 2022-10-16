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
    echo "Q" | mikmod -y play_list > /dev/null && \
        cat ~/.mikmod_playlist | grep -q "play_list"
    CHECK_RESULT $? 0 0 "option: -y error"
    rm -rf ~/.mikmod_playlist
    echo "Q" | mikmod -directory play_list > /dev/null && \
        cat ~/.mikmod_playlist | grep -q "play_list"
    CHECK_RESULT $? 0 0 "option: -di[rectory] error"

    # Test the -q[uiet] parameter
    mikmod -q & ps | grep -q "mikmod" && kill -INT $!
    CHECK_RESULT $? 0 0 "option: -q[uiet] error"

    # Test the -v[olume] parameter
    for ((i=0; i<=100; i+=7))
    do
        echo "Q" | mikmod -v ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "VOLUME = ${i}"
        CHECK_RESULT $? 0 0 "option: -v[olume] ${i} error"
    done

    #Test the -o[utput] parameter
    declare -A RE=(["8"]="no" ["16"]="yes" ["m"]="no" ["s"]="yes")
    for i in "8" "16"
    do
        for j in "m" "s"
        do
            echo "Q" | mikmod -o ${i}${j} > /dev/null && \
                cat ~/.mikmodrc | grep -qE "16BIT = ${RE[${i}]}|STEREO = ${RE[${j}]}"
            CHECK_RESULT $? 0 0 "option: -o[utput] ${i}${j} error"
        done
    done

    #Test the -f[requency] parameter
    for i in 11025 22050 24000 44100 48000
    do 
        echo "Q" | mikmod -f ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "FREQUENCY = ${i}"
        CHECK_RESULT $? 0 0 "coption: -f[requency] ${i} error"
    done

    #Test the -r[everb] parameter
    for ((i=0; i<=15; i++))
    do 
        echo "Q" | mikmod -r ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "REVERB = ${i}"
        CHECK_RESULT $? 0 0 "option: -r[everb] ${i} error"
    done

    # Test the -F|-fa[deout],-nofa[deout] parameter
    declare -A RE=(["-F"]="yes" ["-fa"]="yes" ["-nofa"]="no")
    for i in "-F" "-nofa" "-fa"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "FADEOUT = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -l[oops],-nol[oops] parameter
    declare -A RE=(["-l"]="yes" ["-nol"]="no")
    for i in "-l" "-nol"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "LOOP = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -a|-pa[nning], parameter
    declare -A RE=(["-a"]="yes" ["-pa"]="yes" ["-nopa"]="no")
    for i in "-pa" "-nopa" "-a"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "PANNING = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -x|-pr[otracker],-nopr[otracker] parameter
    declare -A RE=(["-x"]="no" ["-pr"]="no" ["-nopr"]="yes")
    for i in "-pr" "-nopr" "-x"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "EXTSPD = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -c[urious],-noc[urious] parameter
    declare -A RE=(["-c"]="yes" ["-noc"]="no")
    for i in "-c" "-noc"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "CURIOUS = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -p[laymode] parameter
    declare -A RE=(["1"]="PM_MODULE" ["2"]="PM_MULTI" ["4"]="PM_SHUFFLE" ["8"]="PM_RANDOM")
    for i in 1 2 4 8
    do
        echo "Q" | mikmod -p ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "${RE[${i}]} = yes"
        CHECK_RESULT $? 0 0 "option: -p ${i} error"
    done

    # Test the -t[olerant] parameter
    declare -A RE=(["-t"]="yes" ["-not"]="no")
    for i in "-t" "-not"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "TOLERANT = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -s|-ren[ice],-noren[ice],-S|-rea[ltime],-norea[ltime] parameter
    declare -A RE=(
        ["-s"]="RENICE_PRI" ["-ren"]="RENICE_PRI" 
        ["-noren"]="RENICE_NONE" 
        ["-S"]="RENICE_REAL"  ["-rea"]="RENICE_REAL" 
        ["-norea"]="RENICE_NONE"
    )
    for i in "-ren" "-noren" "-s" "-rea" "-norea" "-S"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "RENICE = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -i[nterpolate],-noi[nterpolate] parameter
    declare -A RE=(["-i"]="yes" ["-noi"]="no")
    for i in "-i" "-noi"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "INTERPOLATE = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -hq[mixer],-nohq[mixer] parameter
    declare -A RE=(["-hq"]="yes" ["-nohq"]="no")
    for i in "-hq" "-nohq"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "HQMIXER = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -su[rround],-nosu[rround] parameter
    declare -A RE=(["-su"]="yes" ["-nosu"]="no")
    for i in "-su" "-nosu"
    do
        echo "Q" | mikmod ${i} > /dev/null && \
            cat ~/.mikmodrc | grep -q "SURROUND = ${RE[${i}]}"
        CHECK_RESULT $? 0 0 "option: ${i} error"
    done

    # Test the -norc parameter
    echo "Q" | mikmod -norc | grep -q "empty" 
    CHECK_RESULT $? 0 0 "option: -norc error"

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