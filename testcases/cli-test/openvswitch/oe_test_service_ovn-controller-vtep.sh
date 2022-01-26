#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangdan
# @Contact   :   1743994506@qq.com
# @Date      :   2021/12/02
# @License   :   Mulan PSL v2
# @Desc      :   Test ovn-controller-vtep.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openvswitch-ovn-vtep
    service=ovn-controller-vtep.service
    log_time=$(date '+%Y-%m-%d %T')
    flag=false
    if [ $(getenforce | grep Enforcing) ]; then
        setenforce 0
        flag=true
    fi
    if ! grep 'openvswitch_ovn' /etc/passwd; then
        useradd openvswitch_ovn
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    su - openvswitch_ovn <<EOF
    expect <<-END
        spawn service ${service} restart 
        expect "Password:"
        send "${NODE1_PASSWORD}\n"
        expect eof
END
EOF
    CHECK_RESULT $? 0 0 "${service} restart failed"
    su - openvswitch_ovn <<EOF
    expect <<-END
        spawn service ${service} stop
        expect "Password:"
        send "${NODE1_PASSWORD}\n"
        expect eof
END
EOF
    CHECK_RESULT $? 0 0 "${service} stop failed"
    SLEEP_WAIT 10
    su - openvswitch_ovn <<EOF
    expect <<-END
        spawn service ${service} start
        expect "Password:"
        send "${NODE1_PASSWORD}\n"
        expect eof
END
EOF
    CHECK_RESULT $? 0 0 "${service} start failed"
    su - openvswitch_ovn -c "service ${service} status" | grep "Active" | grep "active (running)"
    CHECK_RESULT $? 0 0 "${service} start failed"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING" | grep -v -i "[FAILED]"
    CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
EOF
    reload_result=$( su - openvswitch_ovn <<EOF
    expect <<-END
        spawn service ${service} reload
        expect "Password:"
        send "${NODE1_PASSWORD}\n"
        expect eof
END
EOF
)
    echo $reload_result | grep "Job type reload is not applicable for unit ${service}"
    CHECK_RESULT $? 0 0 "${service} reload failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    su - openvswitch_ovn <<EOF
    expect <<-END
        spawn systemctl stop ${service}
        expect "Password:"
        send "${NODE1_PASSWORD}\n"
        expect eof
END
EOF
    userdel -rf openvswitch_ovn
    if [ ${flag} = 'true' ]; then
        setenforce 1
    fi
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
