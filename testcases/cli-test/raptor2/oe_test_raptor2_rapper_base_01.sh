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
    rapper -i rss-tag-soup common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -i failed"
    rapper -i rdfxml common/rdf-schema.rdf
    CHECK_RESULT $? 0 0 "Check rapper -i rdfxml failed"
    rapper -i turtle common/example.turtle
    CHECK_RESULT $? 0 0 "Check rapper -i turtle failed"
    rapper -i trig common/example.trig
    CHECK_RESULT $? 0 0 "Check rapper -i trig failed"
    rapper -i grddl common/rdf-schema.rdf
    CHECK_RESULT $? 0 0 "Check rapper -i grddl failed"
    rapper -i guess common/rdf-schema.rdf
    CHECK_RESULT $? 0 0 "Check rapper -i guess failed"
    rapper -i rdfa common/rdf-schema.rdf
    CHECK_RESULT $? 0 0 "Check rapper -i rdfa failed"
    rapper -i json common/example.json
    CHECK_RESULT $? 0 0 "Check rapper -i json failed"
    rapper -i nquads common/example.nquads
    CHECK_RESULT $? 0 0 "Check rapper -i nquads failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
