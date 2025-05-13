#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   qinhaiqi
#@Contact   :   2683064908@qq.com
#@Date      :   2022/2/16
#@License   :   Mulan PSL v2
#@Desc      :   Test "cobbler mgmtclass" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    setenforce 0
    DNF_INSTALL "cobbler httpd"
    systemctl start httpd
    systemctl start cobblerd
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
        mkdir -p /etc/systemd/system/httpd.service.d
        echo -e "[Service]\nEnvironment=OPTIONS=" > "/etc/systemd/system/httpd.service.d/override.conf"
        mkdir -p /etc/pki/tls/certs /etc/pki/tls/private
        openssl req -x509 -nodes -days 365 -newkey rsa:2048   -keyout /etc/pki/tls/private/localhost.key   -out /etc/pki/tls/certs/localhost.crt   -subj "/CN=localhost"
        systemctl daemon-reexec
        systemctl daemon-reload
        systemctl restart httpd
        systemctl restart cobblerd
        cobbler sync
    fi
    SLEEP_WAIT 5
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase."
    cobbler mgmtclass add --name=OpenEuler1
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass add"
    cobbler mgmtclass copy --name=OpenEuler1 --newname=OpenEuler2
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass copy"
    cobbler mgmtclass list | grep "OpenEuler2"
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass copy"
    cobbler mgmtclass edit --name=openEuler1 --owners=tom
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass edit"
    cobbler mgmtclass report --name=openEuler1 | grep "tom"
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass edit"
    cobbler mgmtclass list | grep "OpenEuler"
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass list"
    cobbler mgmtclass find | grep "OpenEuler"
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass find"
    cobbler mgmtclass remove --name=OpenEuler1
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass remove"
    cobbler mgmtclass list | grep "OpenEuler1"
    CHECK_RESULT $? 0 1 "Failed option: mgmtclass remove"
    cobbler mgmtclass rename --name=OpenEuler2 --newname=OpenEuler3
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass rename"
    cobbler mgmtclass list | grep "OpenEuler3"
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass rename"
    cobbler mgmtclass report --name=OpenEuler3 | grep "Name"
    CHECK_RESULT $? 0 0 "Failed option: mgmtclass report"
    LOG_INFO "End to run testcase."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop httpd
    systemctl stop cobblerd
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
