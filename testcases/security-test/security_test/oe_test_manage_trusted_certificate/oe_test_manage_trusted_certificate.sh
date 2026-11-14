#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Modify    :   yang_lijin@qq.com
# @Date      :   2021/08/10
# @License   :   Mulan PSL v2
# @Desc      :   Manage trusted system certificates
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # trust 命令由 p11-kit 提供；生成测试证书需要 openssl。
    DNF_INSTALL "p11-kit openssl"
    if ! command -v trust >/dev/null 2>&1 || ! command -v openssl >/dev/null 2>&1; then
        LOG_WARN "trust/openssl is unavailable, cannot verify trusted certificate management."
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    trust --help
    CHECK_RESULT $? 0 0 "exec 'trust --help' failed"
    trust list
    CHECK_RESULT $? 0 0 "exec 'trust list' failed"
    # 原用例依赖 /etc/pki/ca-trust/source/*kit 与 /etc/pki/tls/certs/ca-bundle.trust.crt，
    # openRuyi 的 ca-certificates 两者都不提供（只有 source/anchors 目录），实测报错：
    #   p11-kit: couldn't open and map file: .../ca-bundle.trust.crt: Unknown error 2
    # 改成用 openssl 现场生成一个真实证书作为锚点，直接校验 anchors 目录的文件数变化。
    anchor_dir=/etc/pki/ca-trust/source/anchors
    mkdir -p "$anchor_dir"
    test_ca=/tmp/oa-trusted-cert-$$.pem
    test_key=/tmp/oa-trusted-key-$$.pem
    openssl req -x509 -newkey rsa:2048 -nodes -keyout "$test_key" -out "$test_ca" \
        -days 1 -subj "/CN=oa-trusted-cert" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "generate test certificate failed"
    old_cnt=$(find "$anchor_dir" -mindepth 1 -maxdepth 1 | wc -l)
    trust anchor "$test_ca"
    CHECK_RESULT $? 0 0 "exec 'trust anchor ${test_ca}' failed"
    new_cnt=$(find "$anchor_dir" -mindepth 1 -maxdepth 1 | wc -l)
    test "$new_cnt" -gt "$old_cnt"
    CHECK_RESULT $? 0 0 "anchor was not stored into ${anchor_dir}"
    # 落盘后的锚点位于 anchors 目录下（可能是符号链接，也可能是 *.p11-kit 元数据），
    # 删除时优先用该路径，两种形态都清掉才不会残留。
    anchor_copy="${anchor_dir}/$(basename "$test_ca")"
    if [ -e "$anchor_copy" ]; then
        trust anchor --remove "$anchor_copy"
    else
        trust anchor --remove "$test_ca"
    fi
    CHECK_RESULT $? 0 0 "exec 'trust anchor --remove ${anchor_copy}' failed"
    rm -f "${anchor_copy}" "${anchor_copy}.p11-kit"
    new_cnt2=$(find "$anchor_dir" -mindepth 1 -maxdepth 1 | wc -l)
    test "$new_cnt2" -lt "$new_cnt"
    CHECK_RESULT $? 0 0 "anchor was not removed from ${anchor_dir}"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f /tmp/oa-trusted-cert-*.pem /tmp/oa-trusted-key-*.pem
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
