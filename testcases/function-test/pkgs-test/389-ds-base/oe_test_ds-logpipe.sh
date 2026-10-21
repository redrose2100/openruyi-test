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
    LOG_INFO "Start to prepare the test environment"
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
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    Time=3
    ds-logpipe.py -h | grep "Usage"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    timeout "$Time"  ds-logpipe.py test1.pipe
    find test1.pipe
    CHECK_RESULT $? 0 0 "L$LINENO: ds-logpipe No Pass"
    timeout "$Time" ds-logpipe.py -m 1 test2.pipe
    find test2.pipe
    CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
    timeout "$Time" ds-logpipe.py -d test3.pipe
    find test3.pipe
    CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
    timeout "$Time" ds-logpipe.py --serverpid=1 test4.pipe 
    find test4.pipe
    CHECK_RESULT $? 0 0 "L$LINENO: --serverpid No Pass"
    timeout "$Time" ds-logpipe.py -i 1 test5.pipe 
    find test5.pipe
    CHECK_RESULT $? 0 0 "L$LINENO: -i No Pass"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf test1.pipe test2.pipe test3.pipe test4.pipe test5.pipe instance.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
