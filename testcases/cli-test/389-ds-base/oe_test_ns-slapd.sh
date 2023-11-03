#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   shang jiwei
# @Contact   :   1065099936@qq.com
# @Date      :   2023/08/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "ns-slapd" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    cat <<EOF > instance.inf
[general]
config_version = 2

[slapd]
root_password = 12345678

[backend-userroot]
sample_entries = yes
suffix = dc=example,dc=com
EOF
    dscreate from-file instance.inf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ns-slapd -D /etc/dirsrv/slapd-localhost > test1.log 2>&1
    grep "Local Network address is in use" test1.log
    CHECK_RESULT $? 0 0 "L$LINENO: -D No Pass"
    ns-slapd -D /etc/dirsrv/slapd-localhost -d 1 > test2.log 2>&1
    grep "send_ldap_result_ext" test2.log
    CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
    ns-slapd -v | grep "389 Project"
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    ns-slapd -V -D /etc/dirsrv/slapd-localhost
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    ns-slapd -i 1 -D /etc/dirsrv/slapd-localhost > test3.log 2>&1
    grep "Local Network address is in use" test3.log
    CHECK_RESULT $? 0 0 "L$LINENO: -i No Pass"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf instance.inf test1.log test2.log test3.log /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"