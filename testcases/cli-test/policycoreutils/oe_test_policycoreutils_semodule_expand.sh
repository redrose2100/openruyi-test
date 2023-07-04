#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/03/25
# @License   :   Mulan PSL v2
# @Desc      :   Test semodule_expand
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start to run test."
    semodule_expand -V -a -c 15 basemodpkg
    CHECK_RESULT $? 0 0 "failed to show version"
    semodule_expand -V 
    CHECK_RESULT $? 0 0 "failed to show version"
    semodule_expand -V -a
    CHECK_RESULT $? 0 0 "check assertions"
    semodule_expand -V -c 18
    CHECK_RESULT $? 0 0 "failed to policy version to create"
    LOG_INFO "End to run test."
}
main "$@"
