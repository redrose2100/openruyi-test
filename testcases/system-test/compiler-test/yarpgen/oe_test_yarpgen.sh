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
# @Author    :   honghua
# @Contact   :   honghua@iscas.ac.cn
# @Date      :   2024/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Compiler yarpen
# ############################################


source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL "tar git wget cmake gcc gcc-g++ clang"
    if [ -d "./yarpgen_failure_log" ]; then
        rm -rf yarpgen_failure_log
    fi
    if [ -d "./testdir" ]; then
        rm -rf testdir
    fi
    mkdir yarpgen_failure_log
    compiler=g++
    git clone https://gitee.com/redrsoe2100/yarpgen.git
    cd yarpgen || exit 255
    mkdir build
    cd build || exit 255
    cmake ..
    make
    mkdir testdir && cd testdir || exit 255


    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 100)
    do
        string=$(../yarpgen)
        pattern='[0-9]+'
        dirname=seed_$(echo $string | grep -oE "$pattern")
        cat init.h func.cpp driver.cpp > test_random.cpp
        optlevel_array=(O0 O3)
        result_array=()
        touch log.txt
        for optlevel in "${optlevel_array[@]}"
        do
            g++ -"$optlevel" test_random.cpp -o gcc_"$optlevel"_out >> log.txt
            g++ -"$optlevel" test_random.cpp -o gcc_"$optlevel"_out &>> log.txt
            if [ ! -e gcc_"$optlevel"_out ]; then
                echo "${RED}Compilation Error${NONE} $dirname"
                echo "Compilation Error" >> log.txt
            else
                ./gcc_"$optlevel"_out >> log.txt
                if ./gcc_"$optlevel"_out &>> log.txt; then
                    result_array+=($(./gcc_"$optlevel"_out))
                    echo "./gcc_${optlevel}_out : \n" >> log.txt
                    ./gcc_"$optlevel"_out >> log.txt
                else
                    echo "${RED}Test Run Failed${NONE} $dirname"
                    echo "Test Run Failed" >> log.txt
                fi
            fi
        done

        if [ ${#result_array[@]} == 2 ]; then
            if [ ${result_array[0]} == ${result_array[1]} ]; then
                echo "${GREEN}Passed${NONE} $dirname"
                rm -rf ./*
                passed=$(($passed + 1))
            else
                echo "${RED}Output Mismatch${NONE} $dirname"
                echo "Output Mismatch" >> log.txt
                mkdir ../yarpgen_failure_log/$dirname/
                mv ./* ../yarpgen_failure_log/$dirname/
                failed=$(($failed + 1))
            fi
        else
            echo "${RED}Test Error${NONE} $dirname"
            echo "Test Error" >> log.txt
            mkdir ../yarpgen_failure_log/$dirname/
            mv ./* ../yarpgen_failure_log/$dirname/
            failed=$(($failed + 1))
        fi
        total=$(($total + 1))
        summary
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"