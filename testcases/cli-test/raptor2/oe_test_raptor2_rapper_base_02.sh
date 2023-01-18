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
    rapper -I INPUT-BASE-URI common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -I failed"
    rapper -o ntriples common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -o ntriples failed"
    rapper -O INPUT-BASE-URI common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -O INPUT-BASE-URI failed"
    rapper -o turtle common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -o turtle  failed"
    rapper -o rdfxml-xmp common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -o rdfxml-xmp failed"
    rapper -o rdfxml-abbrev common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -o rdfxml-abbrev failed"
    rapper -o rdfxml common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -o rdfxml failed"
    rapper -o rss-1.0 common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -o rss-1.0 failed"
    rapper -o atom common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -o atom failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
