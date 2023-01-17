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
    roqet -c -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -c failed."
    roqet -d none -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -d none failed."
    roqet -d debug -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -d debug failed."
    roqet -d structure -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -d structure failed."
    roqet -d sparql -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -d sparql failed."
    roqet -D http://dbpedia.org/sparql -e "SELECT * WHERE {?s ?p ?o} LIMIT 10" html -r xml 2>&1 | grep 'roqet: Running query'
    CHECK_RESULT $? 0 0 "Check roqet -D none failed."
    roqet -E -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -E failed."
    roqet -f noNet -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -f failed."
    roqet -F guess -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Query returned 0 results'
    CHECK_RESULT $? 0 0 "Check roqet -F failed."
    roqet -G http://dbpedia.org/sparql -e "SELECT * WHERE {?s ?p ?o} LIMIT 10" html -r xml 2>&1 | grep 'roqet: Running query'
    CHECK_RESULT $? 0 0 "Check roqet -G failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
