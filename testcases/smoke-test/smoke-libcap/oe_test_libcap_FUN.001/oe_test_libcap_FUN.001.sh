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
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   command test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    DNF_INSTALL "libcap"
    touch libcap_testfile
    useradd -m testuser
}

function run_test() {
    # capsh命令测试
    capsh --help | grep 'usage'
    CHECK_RESULT $? 0 0
    capsh --print | grep -E 'Current|Bounding set' 
    CHECK_RESULT $? 0 0
    capsh --decode=0000001fffffffff | grep 'cap_wake_alarm,cap_block_suspend'
    CHECK_RESULT $? 0 0
    capsh --supports=cap_syslog
    CHECK_RESULT $? 0 0
    capsh --caps=cap_net_raw-ep -- -c "$(which ping) -q -c1 localhost" | grep -E 'transmitted|rtt'
    CHECK_RESULT $? 0 0
    capsh --inh="cap_chown" --print|grep 'Current: ='|grep -c "cap_chown" > libcap_tmp && grep '1' < libcap_tmp
    CHECK_RESULT $? 0 0
    capsh --secbits=0 --print|grep "secure-noroot"|awk '{print $2}' > libcap_tmp && grep 'no' < libcap_tmp
    CHECK_RESULT $? 0 0
    capsh --keep=0 --print|grep "secure-keep-caps"|awk '{print $2}' > libcap_tmp && grep 'no' < libcap_tmp
    CHECK_RESULT $? 0 0
    capsh_uid=$(id -u testuser) ; capsh --uid="${capsh_uid}" --print | grep uid=| awk -F"(" '{print $1}'|awk -F"=" '{print $NF}' | grep "${capsh_uid}" 
    CHECK_RESULT $? 0 0
    capsh_gid=$(id -g testuser); capsh --gid="${capsh_gid}" --print |grep gid=|awk -F"(" '{print $1}'|awk -F"=" '{print $NF}' | grep "${capsh_gid}"
    CHECK_RESULT $? 0 0
    capsh --groups=testuser --print |grep groups=|awk -F "(" '{print $2}'|awk -F ")" '{print $1}'| grep "testuser"
    CHECK_RESULT $? 0 0
    capsh --user=testuser --print |grep uid=|awk -F"(" '{print $2}'|awk -F")" '{print $1}' | grep "testuser"
    CHECK_RESULT $? 0 0
    capsh --user=testuser --print |grep gid=|awk -F"(" '{print $2}'|awk -F")" '{print $1}' | grep "testuser"
    CHECK_RESULT $? 0 0
    capsh --user=testuser --print |grep groups=|awk -F"(" '{print $2}'|awk -F")" '{print $1}'| grep "testuser"
    CHECK_RESULT $? 0 0
    # getcap命令测试
    getcap -h 2>&1 | grep 'usage:'
    CHECK_RESULT $? 0 0
    setcap cap_sys_time+eip libcap_testfile
    CHECK_RESULT $? 0 0
    getcap -v libcap_testfile| grep 'libcap_testfile cap_sys_time=eip' 
    CHECK_RESULT $? 0 0
    getcap -r ./ >libcap_tmp && grep 'libcap_testfile cap_sys_time=eip' < libcap_tmp
    CHECK_RESULT $? 0 0
    getpcaps "$(pgrep -f sshd | awk '{print $2}'|head -1)" 2>libcap_tmp | grep ': =ep'
    CHECK_RESULT $? 0 0
    # setcap命令测试
    setcap -q cap_net_raw+eip libcap_testfile && getcap libcap_testfile >libcap_tmp && grep 'libcap_testfile cap_net_raw=eip' < libcap_tmp
    CHECK_RESULT $? 0 0
    setcap -v cap_net_raw+eip libcap_testfile | grep 'libcap_testfile: OK'
    CHECK_RESULT $? 0 0
    setcap -r libcap_testfile && getcap -v libcap_testfile >libcap_tmp && grep 'libcap_testfile' < libcap_tmp 
    CHECK_RESULT $? 0 0
}

function post_test() {
    rm -f libcap_testfile
    userdel -r testuser
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
