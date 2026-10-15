#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test oech-server.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/function-test/pkgs-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "oec-hardware-server python3-uWSGI"
    pip3 install Flask Flask-bootstrap
    flag=false
    if [ -f /usr/local/bin/uwsgi ]; then
        ln -sf /usr/bin/uwsgi /usr/local/bin/uwsgi
        flag=true
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution oech-server.service
    test_reload oech-server.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop oech-server.service
    pip3 uninstall Flask Flask-bootstrap uwsgi -y
    DNF_REMOVE
    if [ "${flag}" = "true" ]; then
        rm -rf /usr/local/bin/uwsgi
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
