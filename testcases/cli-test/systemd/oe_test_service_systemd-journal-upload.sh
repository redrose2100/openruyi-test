#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/08/01
# @License   :   Mulan PSL v2
# @Desc      :   Test systemd-journal-upload.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "systemd-journal-remote httpd"
    if ! rpm -ql systemd-journal-remote | grep systemd-journal-upload.service;then
        exit 255
    fi
    setsebool nis_enabled=1
    systemctl start httpd
    echo "test data" >/var/www/html/upload
    echo -e "URL=http://localhost:80" >> /etc/systemd/journal-upload.conf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution systemd-journal-upload.service
    test_reload systemd-journal-upload.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environmental preparation."
    rm -rf /var/www/html/upload /etc/systemd/journal-upload.conf
    DNF_REMOVE "$@"
    setsebool nis_enabled=0
    LOG_INFO "End of environmental preparation!"
}

main "$@"
