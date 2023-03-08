#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of rasqal command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL rasqal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    roqet -R mkr -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -R mkr failed."
    roqet -R tsv -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -R tsv failed."
    roqet -R turtle -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -R turtle failed."
    roqet -R rdfxml -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -R rdfxml failed."
    roqet -r turtle -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Running'
    CHECK_RESULT $? 0 0 "Check roqet -r turtle failed."
     roqet -r rdfxml -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Running'
    CHECK_RESULT $? 0 0 "Check roqet -r rdfxml failed."
    roqet -p http://dbpedia.org/sparql -e "SELECT * WHERE {?s ?p ?o} LIMIT 10" html -r xml >result.srx
    test -f result.srx
    CHECK_RESULT $? 0 0 "Check roqet -p rdfxml failed."
    roqet -t result.srx -r xml 2>&1 | grep 'roqet: Reading results'
    CHECK_RESULT $? 0 0 "Check roqet -t rdfxml failed."
    roqet -R xml -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -R xml rdfxml failed."
    roqet -R csv -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -R csv failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf result*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
