#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-12-11
# @License   :   Mulan PSL v2
# @Desc      :   fastcgi server basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fcgi fcgi-devel spawn-fcgi nginx lsof gcc-c++"
    setenforce 0
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > fastcgi_demo.cpp << EOF
#include "fcgi_stdio.h"
#include <stdlib.h>
int main(void)
{
int count = 0;
while (FCGI_Accept() >= 0)
{
printf("Content-type: text/html\\r\\n"
"\\r\\n"
"<title>Hello World</title>"
"<h1>Hello World from FastCGI!</h1>"
"Request number is: %d\\n",
++count);
}
return 0;
}
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    g++ -o fastcgi_demo fastcgi_demo.cpp -lfcgi
    CHECK_RESULT $? 0 0 "Compilation failed"
    spawn-fcgi -a 127.0.0.1 -p 8081 -f "${PWD}"/fastcgi_demo
    lsof -i:8081 | grep -i "fastcgi_d" |grep -i "LISTEN"
    CHECK_RESULT $? 0 0 "The FastCGI program is not listening to port 8081"
    mkdir /usr/share/nginx/html_test
    cp fastcgi_demo /usr/share/nginx/html_test
    CHECK_RESULT $? 0 0 "Command execution failed"
    systemctl stop firewalld.service
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    sed -i '0,/html/s/html/html_test/' /etc/nginx/nginx.conf
    awk '/include \/etc\/nginx\/default\.d\/\*\.conf;/ && !x {print; print "        location /fastcgi_demo.cgi {\n                fastcgi_pass 127.0.0.1:8081;\n                fastcgi_index index.cgi;\n                include fastcgi.conf;\n        }"; x=1; next} 1' /etc/nginx/nginx.conf > temp && mv -f temp /etc/nginx/nginx.conf
    CHECK_RESULT $? 0 0 "File modification failed"
    systemctl restart nginx
    systemctl status nginx
    CHECK_RESULT $? 0 0 "Nginx service restart failed"
    curl 127.0.0.1/fastcgi_demo.cgi |grep "Hello World from FastCGI!"
    CHECK_RESULT $? 0 0 "FastCGI service access failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cp /etc/nginx/nginx.conf ~
    rm -rf fastcgi_demo.cpp fastcgi_demo /usr/share/nginx/html_test /etc/nginx/nginx.conf
    mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
    systemctl restart nginx
    setenforce 1
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
