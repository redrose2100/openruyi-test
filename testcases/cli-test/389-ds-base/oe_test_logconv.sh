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
# @Desc      :   Test "logconv" command
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
    logconv.pl -h | grep "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    logconv.pl -d "dc=example,dc=com" /var/log/dirsrv/slapd-localhost | grep "Done."
    CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
    logconv.pl -s 10 /var/log/dirsrv/slapd-localhost | grep "Done."
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    logconv.pl -v | grep "Access"
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    logconv.pl -S "[28/Mar/2002:13:14:22 -0800]" /var/log/dirsrv/slapd-localhost | grep "Done"
    CHECK_RESULT $? 0 0 "L$LINENO: -S No Pass"
    logconv.pl -E "[28/Mar/2002:13:14:22 -0800]" /var/log/dirsrv/slapd-localhost | grep "Done"
    CHECK_RESULT $? 0 0 "L$LINENO: -E No Pass"
    logconv.pl -m log-second-stats-csv.out /var/log/dirsrv/slapd-localhost
    find "log-second-stats-csv.out"
    CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
    logconv.pl -M log-minute-stats-csv.out /var/log/dirsrv/slapd-localhost
    find "log-minute-stats-csv.out"
    CHECK_RESULT $? 0 0 "L$LINENO: -M No Pass"
    logconv.pl -B ANONYMOUS /var/log/dirsrv/slapd-localhost | grep "Done"
    CHECK_RESULT $? 0 0 "L$LINENO: -B No Pass"
    logconv.pl -B ANONYMOUS -V /var/log/dirsrv/slapd-localhost | grep "Done"
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf instance.inf log-second-stats-csv.out log-minute-stats-csv.out /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"