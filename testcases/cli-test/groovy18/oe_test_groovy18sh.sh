#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test groovy
# #############################################
# shellcheck disable=SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="60m"
    DNF_INSTALL "groovy18 tar"
    tar -xvf common/data.tar.gz >/dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    groovy18sh --help | grep "usage"
    CHECK_RESULT $? 0 0 "Check groovy18sh --help failed"
    groovy18sh -h | grep "usage"
    CHECK_RESULT $? 0 0 "Check groovy18sh -h failed"
    groovy18sh --version | grep "Groovy Shell"
    CHECK_RESULT $? 0 0 "Check groovy18sh --version failed"
    groovy18sh -V | grep "Groovy Shell"
    CHECK_RESULT $? 0 0 "Check groovy18sh -V failed"
    echo :exit | groovysh --terminal=none | grep ":help"
    CHECK_RESULT $? 0 0 "Check groovy18sh --terminal failed"
    echo :exit | groovysh -Tnone | grep ":help"
    CHECK_RESULT $? 0 0 "Check groovy18sh -T failed"
    message1=$(
        groovy18sh --color=ANSI <<EOF
    println "\u001B[31mI'm Red\u001B[0m Now not"
    :exit
EOF
    )
    echo "${message1}" | grep "I'm Red"
    CHECK_RESULT $? 0 0 "Check groovy18sh --color failed"
    message2=$(
        groovy18sh -C=ANSI <<EOF
    println "\u001B[31mI'm Red\u001B[0m Now not"
    :exit
EOF
    )
    echo "${message2}" | grep "I'm Red"
    CHECK_RESULT $? 0 0 "Check groovy18sh -C failed"
    message3=$(
        groovy18sh -D name="tonyWang" <<EOF
    println System.properties['name']
    :exit
EOF
    )
    echo "${message3}" | grep "tonyWang"
    CHECK_RESULT $? 0 0 "Check groovy18sh -D failed"
    message4=$(
        groovy18sh --define name="tonyZhang" <<EOF
    println System.properties['name']
    :exit
EOF
    )
    echo "${message4}" | grep "tonyZhang"
    CHECK_RESULT $? 0 0 "Check groovy18sh --define failed"
    echo ":q" | groovy18sh -d | grep DEBUG
    CHECK_RESULT $? 0 0 "Check groovy18sh -d failed"
    echo ":q" | groovy18sh --debug | grep DEBUG
    CHECK_RESULT $? 0 0 "Check groovy18sh --define failed"
    echo ":q" | groovy18sh -cp /usr/share/java/ | grep -i "Groovy Shell"
    CHECK_RESULT $? 0 0 "Check groovy18sh -cp failed"
    echo ":q" | groovy18sh --classpath /usr/share/java/ | grep -i "Groovy Shell"
    CHECK_RESULT $? 0 0 "Check groovy18sh --classpath failed"
    echo ":q" | groovy18sh -classpath /usr/share/java/ | grep -i "Groovy Shell"
    CHECK_RESULT $? 0 0 "Check groovy18sh -classpath failed"
    message7=$(
        groovy18sh -d -q <<EOF
    println "testdemo"
    :exit
EOF
    )
    echo "${message7}" | grep GREENDEBUG
    result_q1=$?
    echo "${message7}" | grep "testdemo"
    result_q2=$?
    if [[ ${result_q1} == 1 ]] && [[ ${result_q2} == 0 ]]; then
        echo "succ" | grep "succ"
    else
        echo "succ" | grep "faild"
    fi
    CHECK_RESULT $? 0 0 "Check groovy18sh -q failed"
    message8=$(
        groovy18sh -d --quiet <<EOF
    println "testdemo"
    :exit
EOF
    )
    echo "${message8}" | grep GREENDEBUG
    result_quiet1=$?
    echo "${message8}" | grep "testdemo"
    result_quiet2=$?
    if [[ ${result_quiet1} == 1 ]] && [[ ${result_quiet2} == 0 ]]; then
        echo "succ" | grep "succ"
    else
        echo "succ" | grep "faild"
    fi
    CHECK_RESULT $? 0 0 "Check groovy18sh --quiet failed"
    echo :exit | groovysh -v | grep ":help"
    CHECK_RESULT $? 0 0 "Check groovy18sh -v failed"
    echo :exit | groovysh --verbose | grep ":help"
    CHECK_RESULT $? 0 0 "Check groovy18sh --verbose failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
