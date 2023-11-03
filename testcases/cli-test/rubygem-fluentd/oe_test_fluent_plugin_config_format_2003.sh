#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test fluent-plugin-config-format
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rubygem-fluentd tar"
    extract_data
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    fluent-plugin-config-format -h | grep "Output plugin config definitions"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format -h failed"
    fluent-plugin-config-format output null | grep "#### chunk_keys"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format failed"
    fluent-plugin-config-format --verbose -f txt output null | grep "flush_at_shutdown: bool"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format --verbose failed"
    fluent-plugin-config-format -c output null | grep -e "\*\*flush_at_shutdown\*\*"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format -c failed"
    fluent-plugin-config-format --compact output null | grep -e "\*\*flush_at_shutdown\*\*"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format --compact failed"
    fluent-plugin-config-format -f json output null | grep '"chunk_keys": {'
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format -f failed"
    fluent-plugin-config-format --format json output null | grep '"chunk_keys": {'
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format --format failed"
    fluent-plugin-config-format output loki -p loki/gems/fluent-plugin-loki-0.3.0/lib/fluent/plugin/ | grep "Available values: yajl, json"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format -p failed"
    fluent-plugin-config-format output loki --plugin loki/gems/fluent-plugin-loki-0.3.0/lib/fluent/plugin/ | grep "Available values: yajl, json"
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format --plugin failed"
    fluent-plugin-config-format -I ./lib/gems/aws-eventstream-1.2.0/lib/ -r aws-eventstream output null
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format -I failed"
    fluent-plugin-config-format -I ./lib/gems/aws-eventstream-1.2.0/lib/ -r aws-eventstream output null
    CHECK_RESULT $? 0 0 "Check fluent-plugin-config-format -r failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
