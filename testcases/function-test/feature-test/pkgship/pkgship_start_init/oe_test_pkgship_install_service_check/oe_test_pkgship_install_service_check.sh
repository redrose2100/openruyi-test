#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2020-08-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Pkgship items normal function test
#####################################
# shellcheck disable=SC1091,SC2086
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    YUM_PATH=/etc/yum.repos.d
    test -f ${YUM_PATH}/pkgship_yum.repo && rm -rf ${YUM_PATH}/pkgship_yum.repo
    DNF_INSTALL "pkgship bc"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    grep pkgshipuser /etc/passwd
    CHECK_RESULT $? 0 0 "The admin pkgshipuser doesn't create."

    bash /etc/pkgship/auto_install_pkgship_requires.sh redis
    redis_pid=$(pgrep -f redis | wc -l)
    if [[ $redis_pid -lt 1 ]]; then
        CHECK_RESULT 1 1 0 "The redis service doesn't install or start by auto_install_pkgship_requires.sh"
    fi

    bash /etc/pkgship/auto_install_pkgship_requires.sh elasticsearch
    es_pid=$(pgrep -f  elastic | wc -l)
    if [[ $es_pid -lt 1 ]]; then
        CHECK_RESULT 1 1 0 "The elastic service doesn't install or start by auto_install_pkgship_requires.sh"
    fi

    systemctl start pkgship 
    CHECK_RESULT $? 0 0 "Start service failed."

    check_file_access /usr/bin/pkgship pkgshipuser pkgshipuser 755
    check_file_access /usr/bin/pkgshipd pkgshipuser pkgshipuser 755
    check_file_access /opt/pkgship pkgshipuser pkgshipuser 750
    check_file_access /etc/pkgship/package.ini pkgshipuser pkgshipuser 640
    check_file_access /etc/pkgship/conf.yaml pkgshipuser pkgshipuser 644
    python_version=$(python3 --version | awk '{print $2}' | awk -F'.' '{print $1"."$2}')
    check_file_access /usr/lib/python${python_version}/site-packages/packageship pkgshipuser pkgshipuser 755
    check_file_access /lib/systemd/system/pkgship.service pkgshipuser pkgshipuser 640
    check_file_access /var/log/pkgship pkgshipuser pkgshipuser 755
    check_file_access /var/log/pkgship/log_info.log pkgshipuser pkgshipuser 644
    check_file_access /var/log/pkgship-operation pkgshipuser pkgshipuser 700
    check_file_access /var/log/pkgship-operation/uwsgi.log pkgshipuser pkgshipuser 644
    check_file_access /etc/pkgship/uwsgi_logrotate.sh pkgshipuser pkgshipuser 750

    systemctl stop pkgship
    CHECK_RESULT $? 0 0 "Stop service failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE
    dnf remove elasticsearch redis -y
    for i in $(pgrep -f -a "pkgship|uwsgi|elasticsearch|redis" | grep -Ev "nohup|mugen.sh|oe_test|grep" | awk '{print $2}'); do
        kill -9 $i
    done
    LOG_INFO "End to restore the test environment."
}

main "$@"
