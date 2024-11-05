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
# @Desc      :   检查samba的依赖关系
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    DNF_INSTALL "samba" "samba-client" || exit 1
}

function run_test() {
    current_version=$(rpm -qp --queryformat '%{VERSION}-%{RELEASE}' samba-client*.rpm)
    rpm -qp --obsoletes samba*.rpm | grep -v python2-samba &> t1.log
    while read line; do
        echo "$line" | grep samba | grep -E '<|=|>' | grep "$current_version"
        CHECK_RESULT $? 0 0 || cat t1.log
    done < t1.log
    rpm -qp --provides samba*.rpm | grep -v lib &> t2.log
    while read line; do
        echo "$line" | grep samba | grep -E '<|=|>' | grep "$current_version"
        CHECK_RESULT $? 0 0 || cat t2.log
    done < t2.log
}

function post_test() {
    DNF_REMOVE "samba" "samba-client"
    rm -rf samba*.rpm t*.log
}

main "$@"
