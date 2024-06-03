#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   saarloos
#@Contact   	:   9090-90-90-9090@163.com
#@Date      	:   2023-01-17 16:44:43
#@License   	:   Mulan PSL v2
#@Desc      	:   run posix test suite
#####################################
# shellcheck disable=SC1091

source ../../common_libs/comm_lib.sh

CUR_DATE=$(date +'%Y-%m-%d %H:%M:%S')

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

  #  EXECUTE_T="180m"

    MAKEDIR=$(cd .. && pwd)
    chmod 777 "${MAKEDIR}"/make
    MAKE=${MAKEDIR}/make

    timestap=$(stat -c %Y tmp_test/build.log)
    formart_date=$(date '+%Y-%m-%d %H:%M:%S' -d @"$timestap")
    date -s "$formart_date"

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd tmp_test/ || exit
    pushd posixtestsuite/ || exit
    POSIX_TARGET=./ ${MAKE} run-tests > ../run.log 2>&1
    popd || exit

    awk -F': ' '{if(($2=="build" && $3!="PASS") || ($2=="link" && $3!="PASS") || (($2=="execution" && $3=="PASS"))) print $1}' build.log >  skip.name
    cat ../ignore.out >> skip.name
    awk -F': ' '{if($2=="execution" && $3!="PASS") print $1}' run.log > fail.name

    while read -r line || [[ -n $line ]]; do
        grep -q "$line" skip.name
        if mycmd; then
            continue
        fi
        # 单独再执行一次
        ./posixtestsuite/"$line".test
        CHECK_RESULT $? 0 0 "run posix testcase fail case name: $line"
    done < fail.name

    popd || exit

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    date -s "$CUR_DATE"

    LOG_INFO "End to restore the test environment."
}

main "$@"
