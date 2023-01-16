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
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL tboot
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lcp2_crtpollist --create --listver 0x100 --out common/list_unsig.lst common/mle.elt common/vl.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --listver --out failed"
    lcp2_crtpollist --create --listver 0x200 --sigalg rsa --out common/list_unsig.lst common/mle.elt common/vl.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create ==listver --sigalg --out failed"
    lcp2_crtpollist --sign --sigalg rsa --pub common/tboot.pub --priv common/tboot.priv --out common/list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist -sign --sigalg --pub --priv --out failed"
    openssl dgst -sha1 -sign common/privkey.pem -out common/list.sig common/list_unsig.lst
    lcp2_crtpollist --addsig --sig common/list.sig --out common/list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --addsig --sig --out failed"
    lcp2_crtpollist --show common/list.sig
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show  failed"
    lcp2_crtpollist --version 2>&1 | grep 'lcp2_crtpollist version'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --version  failed"
    lcp2_crtpollist --help 2>&1 | grep 'Usage: lcp2_crtpollist'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --help  failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
