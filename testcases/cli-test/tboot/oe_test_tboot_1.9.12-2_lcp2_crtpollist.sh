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
# @Desc      :   verify the uasge of tboot command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    if [ "${NODE1_FRAME}" != "x86_64" ]; then
        # 非 x86 架构跳过测试
        LOG_WARN "Testing cannot be performed if NODE1_FRAME not x86_64."
        exit 255
    fi
    DNF_INSTALL "util-linux"
    # 非 intel cpu 跳过测试
    lscpu | grep -i intel || exit 255
    DNF_INSTALL tboot
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    lcp2_crtpollist --create --out common/list_unsig.lst common/mle.elt common/vl.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --out failed"
    lcp2_crtpollist --sign --sigalg rsa --pub common/tboot.pub --priv common/tboot.priv --out common/list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --sign --sigalg --pub --priv --out failed"
    lcp2_crtpollist --sign --pub common/pubkey.pem --nosig --out common/list_sig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --nosig failed"
    openssl dgst -sha1 -sign common/privkey.pem -out common/list.sig common/list_sig.lst
    lcp2_crtpollist --addsig --sig common/list.sig --out common/list_sig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --addsig --sig --out failed"
    lcp2_crtpollist --show common/list_unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show  failed"
    lcp2_crtpollist --help 2>&1 | grep 'Usage: lcp_crtpollist'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --help  failed"
    LOG_INFO "End to run  test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Een to restore the test environment."
}

main "$@"
