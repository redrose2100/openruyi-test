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
    lcp2_crtpol --create --alg sha256 --type any --polver 3.2 --minver 1 --max_sinit_min --ctrl 0x00 sha1 --auxalg --data list.data --sign rsa-2048-sha1 list.lst --pol list.pol
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol --create --alg --type --polver --minver --max_sinit_min --ctrl --mask --auxalg --data --sign --pol failed"
    lcp2_crtpol --show list.pol --brief 2>&1 | grep 'version' 2>&1 | grep 'version'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol --show  failed"
    lcp2_crtpol --help 2>&1 | grep 'Usage: lcp2_crtpol'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol -h  failed"
    lcp2_crtpol --create --alg sha1 --verbose --type list 2>&1 | grep 'pol_ver'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpol --create --alg --verbose --type failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf list.*
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main $@
