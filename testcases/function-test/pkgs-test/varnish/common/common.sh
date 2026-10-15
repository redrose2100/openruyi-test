#!/usr/bin/bash

# Copyright (c) 2024. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangxiaoya
# @Contact   :   1426570981@qq.com
# @Date      :   2024/03/19
# @License   :   Mulan PSL v2
# @Desc      :   varnish common prepare
# #############################################
# shellcheck disable=SC1091
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function common_pre() {
    DNF_INSTALL "varnish httpd"
    systemctl stop firewalld iptables
    setenforce 0
    SLEEP_WAIT 2
    echo "VARNISH_LISTEN_PORT=80" >/etc/sysconfig/varnish
    sed -i "s/127.0.0.1/$NODE1_IPV4/g" /etc/varnish/default.vcl
    sed -i "s/8080/80/g" /etc/varnish/default.vcl
    \cp /lib/systemd/system/varnish.service /etc/systemd/system/
    echo '<h1> Welcom to www.westos.org!</h1>' >/var/www/html/index.html
    cp /etc/hosts /etc/hosts.bak
    echo "${NODE1_IPV4} localhost www.westos.org" >>/etc/hosts
    systemctl daemon-reload
    systemctl start varnish
    systemctl start httpd
    SLEEP_WAIT 1
    curl -I www.westos.org
}

function common_post() {
    rm -rf /lib/systemd/system/varnish* /usr/lib/systemd/system/varnish* /etc/systemd/system/varnish.service /etc/varnish /var/www/html/index.html /tmp/log_varnishadm
    systemctl stop varnish httpd
    DNF_REMOVE "$@"
    mv /etc/hosts.bak /etc/hosts
}
