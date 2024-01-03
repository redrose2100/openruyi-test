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
#@Author    	:   Li,Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-02-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Check logrotate performance
#####################################
# shellcheck disable=SC1091
# shellcheck disable=SC2034

source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	
    EXECUTE_T="60m"
    systemctl start pkgship
    cp -r /etc/pkgship/uwsgi_logrotate.sh /etc/pkgship/uwsgi_logrotate.sh_bk
    sed -i "s/yesterday/today/g" /etc/pkgship/uwsgi_logrotate.sh
    sed -i "s/sleep 1d/sleep 10m/g" /etc/pkgship/uwsgi_logrotate.sh
    sed -i "s/^UWSGI_LOG_FILE.*/UWSGI_LOG_FILE=\/var\/log\/pkgship-operation\/uwsgi.log/g" /etc/pkgship/uwsgi_logrotate.sh
    sed -i "/^while/d" /etc/pkgship/uwsgi_logrotate.sh
    sed -i "/^done/d" /etc/pkgship/uwsgi_logrotate.sh

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. "

    sh /etc/pkgship/uwsgi_logrotate.sh
    CHECK_RESULT $? 0 0 "Run uwsgi_logrotate failed."
    find /var/log/pkgship-operation/uwsgi.log
    CHECK_RESULT $? 0 0 "Check logrotate log failed."
	   
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /var/log/pkgship-operation/* /etc/pkgship/uwsgi_logrotate.sh
    mv /etc/pkgship/uwsgi_logrotate.sh_bk /etc/pkgship/uwsgi_logrotate.sh
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
