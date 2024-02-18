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
# @Desc      :   Test "dbscan" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
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
    dbscan -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "id"
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    dbscan -R -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "rdn"
    CHECK_RESULT $? 0 0 "L$LINENO: -R No Pass"
    dbscan -t 1024 -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "rdn"
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    dbscan -K 14 -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "entryid"
    CHECK_RESULT $? 0 0 "L$LINENO: -K No Pass"
    dbscan -l 4 id -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "id"
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    dbscan -G 10 -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "id"
    CHECK_RESULT $? 0 0 "L$LINENO: -G No Pass"
    dbscan -r -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "id"
    CHECK_RESULT $? 0 0 "L$LINENO: -r No Pass"
    dbscan -s -f /var/lib/dirsrv/slapd-localhost/db/userroot/id2entry.db | grep "id"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf instance.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"