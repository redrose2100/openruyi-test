#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test pam_namespace.service restart
# #############################################

source "../common/common_lib.sh"
function run_test() {
    LOG_INFO "Start testing..."
    pam_timestamp_check -k
    CHECK_RESULT $? 0 0 "failed to remove"
    pam_timestamp_check target
    CHECK_RESULT $? 7 0 "failed to chek target"
    nohup pam_timestamp_check -d >name.log 2>&1 &
    SLEEP_WAIT 10 "grep '7' "name.log"
    CHECK_RESULT $? 0 0 "failed to print the status on standard output" 
    pam_timestamp_check -h |grep pam_timestamp_check
    CHECK_RESULT $? 0 0 "failed to show Usage"
    LOG_INFO "Finish test!"
}
main "$@"
