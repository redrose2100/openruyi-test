#!/usr/bin/bash
# Copyright (c) 2023. xFusion Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   liyongqiang
# @Contact   :   liyongqiang@xfusion.com
# @Date      :   2023/11/26
# @License   :   Mulan PSL v2
# @Desc      :   thrift generate ruby code test
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    DNF_INSTALL thrift
    cp ./common/test.thrift .
}

function run_test() {
    thrift --gen rb test.thrift
    CHECK_RESULT $? 0
    ls -l gen-rb
    CHECK_RESULT $? 0
    ls gen-rb/hello_service.rb
    CHECK_RESULT $? 0
}

function post_test() {
    DNF_REMOVE
    rm -rf gen-*
    rm -f test.thrift
}

main "$@"
