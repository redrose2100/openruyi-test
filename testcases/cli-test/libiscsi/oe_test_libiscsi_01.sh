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
# @Author    :   yanglijin
# @Contact   :   yanglijin@huawei.com
# @Date      :   2025/02/06
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in libiscsi package
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libiscsi targetcli open-iscsi"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    [ -e /home/testfile ] || dd if=/dev/zero of=/home/testfile bs=1M count=10
    TARGET_IQN=$(echo -e "cd /iscsi\ncreate" | targetcli | grep "Created target iqn" | awk '{print $NF}' | sed "s/\.$//")
    echo -e "cd /backstores/fileio\n" | targetcli
    echo -e "create file_or_dev=/home/testfile name=filedisk0" | targetcli
    echo -e "cd /iscsi/${TARGET_IQN}/tpg1\nset attribute authentication=0 demo_mode_write_protect=0 generate_node_acls=1" | targetcli
    systemctl start iscsid
    iscsiadm --mode discovery --type st -p 127.0.0.1
    CHECK_RESULT $? 0 0 'iscsiadm test is success'
    iscsiadm --mode node -p 127.0.0.1 -l
    CHECK_RESULT $? 0 0 'iscsiadm test is success'
    iscsi-inq -e 0 iscsi://127.0.0.1/"${TARGET_IQN}"/0 -d 2
    CHECK_RESULT $? 0 0 'iscsiadm test is success'
    iscsi-ls iscsi://127.0.0.1/"${TARGET_IQN}"/0 -d -s -U
    CHECK_RESULT $? 0 0 'iscsiadm test is success'
    iscsi-perf iscsi://127.0.0.1/"${TARGET_IQN}"/0 -t 10
    CHECK_RESULT $? 0 0 'iscsiadm test is success'
    iscsi-readcapacity16 iscsi://127.0.0.1/"${TARGET_IQN}"/0 -s
    CHECK_RESULT $? 0 0 'iscsiadm test is success'
    LOG_INFO "End to run test." 
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    iscsiadm --mode node -u
    iscsiadm -m node --op delete ALL
    echo -e "cd /\nclearconfig confirm=true\n" | targetcli
    rm -rf /home/testfile
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
