#!/usr/bin/bash
# Copyright (c),2019-2021,Huawei Tech. Co.,Ltd.
# Description:差异性测试
# Author:duxiao  <duxiao13@h-partners.com >
# Create:2024-10-22
source ${OET_PATH}/libs/locallibs/common_lib.sh
set +e

function pre_test() {
    yum -y install libcap
    LOG_INFO "No pkgs need to install."
    touch libcap_testfile
    useradd -m testuser
    
}

function run_test() {
    LOG_INFO "Start to run test."
#    VerDiffTest libcap
    capsh --help | grep 'usage' || re_tmp=1
    capsh --print | egrep 'Current|Bounding set' || re_tmp="$re_tmp 2"
    capsh --decode=0000001fffffffff | grep '35,36' || re_tmp="$re_tmp 3"
    capsh --supports=cap_syslog || re_tmp="$re_tmp 4"
    capsh --caps=cap_net_raw-ep -- -c "$(which ping) -q -c1 localhost" | egrep 'transmitted|rtt' || re_tmp="$re_tmp 5"
    capsh --inh="cap_chown" --print|grep 'Current: ='|grep "cap_chown"|wc -l > libcap_tmp && cat libcap_tmp | grep '1' || re_tmp="$re_tmp 6"
    capsh --secbits=0 --print|grep "secure-noroot"|awk '{print $2}' > libcap_tmp && cat libcap_tmp | grep 'no' || re_tmp="$re_tmp 7"
    capsh --keep=0 --print|grep "secure-keep-caps"|awk '{print $2}' > libcap_tmp && cat libcap_tmp | grep 'no' || re_tmp="$re_tmp 8"
    capsh_uid=$(id -u testuser) ; capsh --uid=${capsh_uid} --print | grep uid=| awk -F"(" '{print $1}'|awk -F"=" '{print $NF}' | grep "${capsh_uid}" || re_tmp="$re_tmp 9"
    capsh_gid=$(id -g testuser); capsh --gid=${capsh_gid} --print |grep gid=|awk -F"(" '{print $1}'|awk -F"=" '{print $NF}' | grep "${capsh_gid}" || re_tmp="$re_tmp 10"
    capsh --groups=testuser --print |grep groups=|awk -F "(" '{print $2}'|awk -F ")" '{print $1}'| grep "testuser" || re_tmp="$re_tmp 11"
    capsh --user=testuser --print |grep uid=|awk -F"(" '{print $2}'|awk -F")" '{print $1}' | grep "testuser" || re_tmp="$re_tmp 12"
    capsh --user=testuser --print |grep gid=|awk -F"(" '{print $2}'|awk -F")" '{print $1}' | grep "testuser" || re_tmp="$re_tmp 13"
    capsh --user=testuser --print |grep groups=|awk -F"(" '{print $2}'|awk -F")" '{print $1}'| grep "testuser" || re_tmp="$re_tmp 14"

    getcap -h 2>&1 | grep 'usage:' || re_tmp=15
    setcap cap_sys_time+eip libcap_testfile || re_tmp="$re_tmp 16"
    getcap -v libcap_testfile >libcap_tmp && cat libcap_tmp | grep 'libcap_testfile = cap_sys_time+eip' || re_tmp="$re_tmp 17"
    getcap -r ./ >libcap_tmp && cat libcap_tmp | grep 'libcap_testfile = cap_sys_time+eip' || re_tmp="$re_tmp 18"

    getpcaps $(ps -ef|grep sshd|grep -v grep|awk '{print $2}'|head -1) 2>libcap_tmp && cat libcap_tmp | grep 'cap_kill' || re_tmp=18

    setcap -q cap_net_raw+eip libcap_testfile && getcap libcap_testfile >libcap_tmp && cat libcap_tmp | grep 'libcap_testfile = cap_net_raw+eip' || re_tmp=19
    setcap -v cap_net_raw+eip libcap_testfile | grep 'libcap_testfile: OK' || re_tmp="$re_tmp 20"
    setcap -r libcap_testfile && getcap -v libcap_testfile >libcap_tmp && cat libcap_tmp | grep 'libcap_testfile' || re_tmp="$re_tmp 21"

}

function post_test() {
    rm -f libcap_testfile
    userdel -r testuser
    LOG_INFO "End to restore the test environment."
}

main "$@"