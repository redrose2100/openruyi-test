#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2025-03-25
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################
# shellcheck disable=SC2010,SC2143,SC2046

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_nginx() {
    LOG_INFO "Start to prepare the test environment."
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    DNF_INSTALL "oeAware-manager nginx wrk libnl3-devel patchelf gcc perl tar unzip"
    systemctl start oeaware
    expect <<EOF
        spawn openssl genrsa -des3 -out server.key 2048
        expect "pass" { send "${NODE1_PASSWORD}\r" }
        expect "pass" { send "${NODE1_PASSWORD}\r" }
        expect eof
EOF
    expect <<EOF
        spawn openssl rsa -in server.key -out server.key
        expect "pass" { send "${NODE1_PASSWORD}\r" }
        expect eof
EOF
    echo -e '\n\n\n\n\n\n\n\n\n\n\n' | openssl req -new -key server.key -out server.csr
    openssl rsa -in server.key -out server.key
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf_bak
    echo "user  root;
worker_processes  4;
worker_cpu_affinity auto;
worker_rlimit_nofile 1024000;
events {
    use epoll; # new add
    worker_connections  32768; #default 1024
    accept_mutex off; #default on
    multi_accept off;
}
http {
include       /etc/nginx/mime.types;
default_type  application/octet-stream;
access_log off; # default on
sendfile        on;#default
tcp_nopush     on;
keepalive_timeout  65;

open_file_cache max=102400 inactive=40s;
open_file_cache_valid 50s;
open_file_cache_min_uses 1;
open_file_cache_errors on;
server {
    listen       10000;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
    # HTTPS server
server {
    listen       20000 ssl;
    server_name  localhost;
    ssl_certificate      $(pwd)/server.crt;
    ssl_certificate_key  $(pwd)/server.key;
    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    }
}" > /etc/nginx/nginx.conf
    flag=false
    if [ $(getenforce | grep Enforcing) ]; then
        setenforce 0
        flag=true
    fi
    unzip common/smc-tools-main.zip
    cd smc-tools-main || exit 1
    make -j
    cd - || exit 1
    cp /etc/oeAware/preload.yaml /etc/oeAware/preload.yaml_bak
    echo ' - apppath: "/usr/sbin/nginx"
   sopath:
     - "'$(pwd)'/smc-tools-main/libsmc-preload.so"
 - apppath: "/usr/bin/wrk"
   sopath:
     - "'$(pwd)'/smc-tools-main/libsmc-preload.so"' > /etc/oeAware/preload.yaml
    LOG_INFO "End to prepare the test environment."
}

function post_nginx() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $(ls | grep -E "smc-tools-main|server")
    mv -f /etc/nginx/nginx.conf_bak /etc/nginx/nginx.conf
    mv -f /etc/oeAware/preload.yaml_bak /etc/oeAware/preload.yaml
    if [ ${flag} = 'true' ]; then
        setenforce 1
    fi
    export LANG="${LANG_OLD}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
