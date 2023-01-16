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
    roqet -help 2>&1 | grep 'Rasqal RDF query utilit'
    CHECK_RESULT $? 0 0 "Check roqet -help failed."
    roqet -n -e "SELECT * WHERE {?s ?p ?o} LIMIT 1" 2>&1 | grep 'Running'
    CHECK_RESULT $? 0 0 "Check roqet -n failed."
    roqet -q -e "SELECT * WHERE {?s ?p ?o} LIMIT 1"
    CHECK_RESULT $? 0 0 "Check roqet -q failed."
    roqet -s http://dbpedia.org/sparql -e "SELECT * WHERE {?s ?p ?o} LIMIT 10" html -r xml 2>&1 | grep 'Running'
    CHECK_RESULT $? 0 0 "Check roqet -s failed."
    roqet -v 2>&1 | grep $(rpm -q rasqal --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check roqet -v failed."
    roqet --store-results yes -e "SELECT * WHERE {?s ?p ?o} LIMIT 1"
    CHECK_RESULT $? 0 0 "Check roqet --store-results yes failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
