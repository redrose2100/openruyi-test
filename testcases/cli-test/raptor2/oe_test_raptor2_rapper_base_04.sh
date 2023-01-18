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
    rapper -r common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -r  failed"
    rapper -t common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -t  failed"
    rapper -w common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -w  failed"
    rapper -version 2>&1 | grep $(rpm -q raptor2 --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check rapper -version  failed"
    rapper -v 2>&1 | grep $(rpm -q raptor2 --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check rapper -v  failed"
    rapper -g common/rss.rdf
    CHECK_RESULT $? 0 0 "Check rapper -g failed"
    rapper -h 2>&1 | grep 'Raptor RDF syntax parsing'
    CHECK_RESULT $? 0 0 "Check rapper -h failed"
    rapper --help 2>&1 | grep 'Raptor RDF syntax parsing'
    CHECK_RESULT $? 0 0 "Check rapper --help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
