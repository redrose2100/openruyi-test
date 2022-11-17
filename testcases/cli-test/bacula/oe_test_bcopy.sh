#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test bcopy
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "bacula-client mysql5-server bacula-common"
    tar -zxvf test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    bcopy -v FileChgr2-Dev1 FileChgr2-Dev2 | grep 'Using device: "FileChgr2-Dev1" for reading.'
    CHECK_RESULT $? 0 0 "Failed option: -v"
    expect <<EOF > /tmp/1.txt
    spawn bcopy -b ./config/1.conf FileChgr2-Dev1 FileChgr2-Dev2 
    expect "press return when ready" {send "quit;\n"}
    expect "press return when ready" {send "quit;\n"}
EOF
    cat /tmp/1.txt | grep 'bcopy: butil.c:292-0 Using device: "FileChgr2-Dev1" for reading'
    CHECK_RESULT $? 0 0 "Failed option: -b"
    bcopy -c /etc/bacula/bacula-sd.conf FileChgr2-Dev1 FileChgr2-Dev2 | grep 'Using device: "FileChgr2-Dev1" for reading.'
    CHECK_RESULT $? 0 0 "Failed option: -c"
    bcopy -d 20 FileChgr2-Dev1 FileChgr2-Dev2 | grep 'bcopy: address_conf.c:274-0 Initaddr'
    CHECK_RESULT $? 0 0 "Failed option: -d"
    bcopy -d 20 -dt FileChgr2-Dev1 FileChgr2-Dev2 | grep '.*-.*-.* .*:.*:.* bcopy: '
    CHECK_RESULT $? 0 0 "Failed option: -dt"
    bcopy -p FileChgr2-Dev1 FileChgr2-Dev2 | grep 'error'
    CHECK_RESULT $? 0 0 "Failed option: -p"
    bcopy -w /tmp FileChgr2-Dev1 FileChgr2-Dev2 | grep 'Using device: "FileChgr2-Dev1" for reading'
    CHECK_RESULT $? 0 0 "Failed option: -w"
    bcopy -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: -?"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf config/ /tmp/*.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
