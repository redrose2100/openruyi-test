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
# @Desc      :   verify the uasge of tboot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL tboot
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    lcp2_crtpolelt --create --type mle --out pconf.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --create  failed"

    lcp2_crtpolelt --show pconf.elt 2>&1 | grep 'policy element'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --show  failed"

    lcp2_crtpolelt --show pconf.elt --verbose 2>&1 | grep 'policy element'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --verbose  failed"

    lcp2_crtpolelt --help 2>&1 | grep 'Usage'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --help  failed"

    rm -rf pconf.elt

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "Finish restoring the test environment."
}

main $@