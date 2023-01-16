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
    LOG_INFO "End of prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    roqet -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep "roqet: Query returned 0"
    CHECK_RESULT $? 0 0 "Check roqet -e failed."
    roqet -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" -p http://dbpedia.org/sparql html 2>&1 | grep 'Query has a variable bindings result'
    CHECK_RESULT $? 0 0 "Check roqet -p failed."
    roqet -i sparql10 -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep "roqet: Query returned 0"
    CHECK_RESULT $? 0 0 "Check roqet -i sparql10 failed."
    roqet -i sparql -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep "roqet: Query returned 0"
    CHECK_RESULT $? 0 0 "Check roqet -i sparql failed."
    roqet -i sparql11-query -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep "roqet: Query returned 0"
    CHECK_RESULT $? 0 0 "Check roqet -i sparql11-query failed."
    roqet -i laqrs -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep "roqet: Query returned 0"
    CHECK_RESULT $? 0 0 "Check roqet -i laqrs failed."
    roqet -r simple -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep "roqet: Query returned 0"
    CHECK_RESULT $? 0 0 "Check roqet -r simple failed."
    roqet -r xml -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'roqet: Running query'
    CHECK_RESULT $? 0 0 "Check roqet -r xml failed."
    roqet -r csv -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1  | grep 'Running'
    CHECK_RESULT $? 0 0 "Check roqet -r csv failed."
    roqet -r mkr -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'result is relation'
    CHECK_RESULT $? 0 0 "Check roqet -r mkr failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
