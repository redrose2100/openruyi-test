#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/10/28
# @License   :   Mulan PSL v2
# @Desc      :   测试samba包安装,服务启动/重启/关闭
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    DNF_INSTALL "samba samba-winbind"
    net -s /dev/null groupmap add sid=S-1-5-32-546 unixgroup=nobody type=builtin
}

function run_test() {
    for _ in $(seq 3); do
        sleep 5
        systemctl restart smb
        CHECK_RESULT $? 0 0
        sleep 5
        systemctl restart nmb
        CHECK_RESULT $? 0 0

        rpm -q samba-winbind || continue
        sleep 5
        systemctl restart winbind
        CHECK_RESULT $? 0 0
    done
}

function post_test() {
    DNF_REMOVE "$@"
}

main "$@"
