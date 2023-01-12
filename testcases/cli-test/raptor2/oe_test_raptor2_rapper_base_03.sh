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
# @Desc      :   verify the uasge of raptor2 command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL raptor2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rapper -o dot common/rss.rdf 2>&1 | grep 'serializer dot'
    CHECK_RESULT $? 0 0 "Check rapper -O failed"
    rapper -i json common/example.json -o json-triples
    CHECK_RESULT $? 0 0 "Check rapper -O failed"
    rapper -i json common/example.json -o json
    CHECK_RESULT $? 0 0 "Check rapper -O failed"
    rapper -o html common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -O failed"
    rapper -o nquads common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -O failed"
    rapper --count common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper --count failed"
    rapper -c common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -c failed"
    rapper --ignore-errors common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper --ignore-errors failed"
    rapper -f 'xmlns:rss="example.json"' -i json common/example.json -i json
    CHECK_RESULT $? 0 0 "Check rapper -f failed"
    rapper --feature 'xmlns:rss="example.json"' -i json common/example.json -i json
    CHECK_RESULT $? 0 0 "Check rapper --feature failed"
    rapper -q -o rdfxml -f 'xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"' common/rdf-schema.rdf 'http://www.w3.org/2000/01/rdf-schema#'
    CHECK_RESULT $? 0 0 "Check rapper -q -o -f failed"
    rapper -q  common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -q failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
