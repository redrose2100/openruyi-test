#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022-09-15
# @License   :   Mulan PSL v2
# @Desc      :   jdk8 Compatible authentication
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "env configure"
    DNF_INSTALL java-1.8.0-openjdk*
    lsof -i:8080
    if [ $? == 0 ];then
      pid=$(lsof -i:8080 | head -n 2 | tail -n 1 | awk '{print $2}')
      kill -9 $pid
    fi
    DNF_INSTALL tomcat
    systemctl stop firewalld
}

function run_test() {
    systemctl start tomcat
    for i in $(seq 1  10);do
      lsof -i:8080--
      if [ $? == 0 ];then
        break
      else
        sleep 3
      fi
    done
    exit_code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} http://localhost:8080)
    CHECK_RESULT $exit_code 200 0 "exec 'exit_code' failed"
    systemctl stop tomcat
    mv /usr/share/java/tomcat  /usr/share/java/tomcat_bak
    systemctl start tomcat
    for i in $(seq 1  10);do
      lsof -i:8080
      if [ $? == 0 ];then
        break
      else
        sleep 3
      fi
    done
    exit_code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} http://localhost:8080)
    CHECK_RESULT $exit_code 200 1 "exec 'exit_code' failed"
    mv /usr/share/java/tomcat_bak  /usr/share/java/tomcat
    ls /usr/share/java
    systemctl restart tomcat
    for i in $(seq 1  10);do
      lsof -i:8080
      if [ $? == 0 ];then
        break
      else
        sleep 3
      fi
    done
    exit_code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} http://localhost:8080)
    CHECK_RESULT $exit_code 200 0 "exec 'exit_code' failed"
}

function post_test() {
    LOG_INFO "env recovery"
    systemctl stop tomcat
    rm -rf /usr/share/java/tomcat*
    DNF_REMOVE
    systemctl start firewalld
}
main "$@"