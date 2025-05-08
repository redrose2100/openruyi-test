#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-08-22
#@License       :   Mulan PSL v2
#@Desc          :   Manage StratoVirt VM resources
#####################################
# shellcheck disable=SC1091,SC2154

source common/common_stratovirt.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    create_stratovirt_vm &
    SLEEP_WAIT 20
    grep -iE "root@StratoVirt" testlog
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 'Failed to create and start a stratovirt VM'
    expect <<-EOF
        log_file testlog1
        spawn ncat -U /tmp/stratovirt.socket
        expect "*QMP*"
        send "{\"execute\": \"blockdev-add\", \"arguments\": {\"node-name\": \"drive-0\", \"file\": {\"driver\": \"file\", \"filename\": \"vmlinux.bin\"}, \"cache\": {\"direct\": true}, \"read-only\": false}}\\n"
        expect "*return*"
        send "{\"execute\": \"device_add\", \"arguments\": {\"id\": \"drive-0\", \"driver\": \"virtio-blk-mmio\", \"addr\": \"0x1\"}}\\n"
        expect "*return*"
        send "{\"execute\": \"device_del\", \"arguments\": {\"id\":\"drive-0\"}}\\n"
        expect "*DEVICE_DELETED*"

        send "{\"execute\":\"netdev_add\", \"arguments\":{\"id\":\"net-0\", \"ifname\":\"tap0\"}}\\n"
        expect "*return*"
        send "{\"execute\":\"device_add\", \"arguments\":{\"id\":\"net-0\", \"driver\":\"virtio-net-mmio\", \"addr\":\"0x0\"}}\\n"
        expect "*return*" 
        send "{\"execute\": \"device_del\", \"arguments\": {\"id\": \"net-0\"}}\\n"
        expect "*DEVICE_DELETED*" 

        send "{\"execute\":\"stop\"}\\n"
        expect "*STOP*"
        send "{\"execute\":\"query-status\"}\\n"
        expect "*paused*"
        send "{\"execute\":\"migrate\", \"arguments\":{\"uri\":\"file:/tmp\"}}\\n"
        expect "*return*"
        send "{\"execute\":\"query-migrate\"}\\n"
        expect "*completed*"
        send "{\"execute\":\"quit\"}\\n"
    expect eof   
EOF
    grep "SHUTDOWN" testlog1
    CHECK_RESULT $? 0 0 'Failed to quit the stratovirt VM'
    stratovirt \
        -kernel vmlinux.bin \
        -append console=ttyS0 root=/dev/vda rw reboot=k panic=1 \
        -drive file="$openeulerversion"-stratovirt-"${NODE1_FRAME}".img,id=rootfs,readonly=false \
        -device virtio-blk-device,drive=rootfs,id=blk1 \
        -qmp unix:/tmp/another_stratovirt.socket,server,nowait \
        -serial stdio \
        -incoming file:/tmp &
    CHECK_RESULT $? 0 0 'Failed to restore the stratovirt VM using a snapshot'
    SLEEP_WAIT 10
    kill -9 "$(pgrep -f 'stratovirt -kernel')"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f vmlinux.bin "$openeulerversion"-stratovirt-"${NODE1_FRAME}".img testlog* /tmp/stratovirt.socket /tmp/another_stratovirt.socket /tmp/memory /tmp/state /tmp/tmp*
    LOG_INFO "End to restore the test environment."
}

main "$@"
