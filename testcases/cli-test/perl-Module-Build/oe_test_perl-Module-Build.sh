#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.


# #############################################
# @Author    :   cuikeyu
# @Contact   :   cky2536184321@163.com
# @Date      :   2023/08/10
# @License   :   Mulan PSL v2
# @Desc      :   Test perl-Module-Build
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "perl-Module-Build"
    systemctl restart sshd.service
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_perl-Module-Build."
    config_data --module Module::Build --config
    CHECK_RESULT $? 0 0 "L$LINENO: --config No Pass"
    
    config_data --module Module::Build --set_config testValue="'a' . 'b'" --eval
    CHECK_RESULT $? 0 0 "L$LINENO: --eval No Pass"
    
    config_data --module Module::Build --feature
    CHECK_RESULT $? 0 0 "L$LINENO: --feature No Pass"
    
    config_data --help | grep -E "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    
    config_data --module Module::Build --config
    CHECK_RESULT $? 0 0 "L$LINENO: --module No Pass"
    
    config_data --module Module::Build --set_config testValue=a
    CHECK_RESULT $? 0 0 "L$LINENO: --set_config No Pass"
    
    config_data --module Module::Build --set_feature testFeature=1
    CHECK_RESULT $? 0 0 "L$LINENO: --set_feature No Pass"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"