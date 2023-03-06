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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of apache-commons-daemon command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL apache-commons-daemon
    mkdir test
    cd test
    a=$(uname -i)
    b="x86_64"
    echo $a
    echo $b
    if test "$a" == $b; then
      echo '获取x86'
      cp ../common/x86/apache-commons-daemon.tar.gz ./
      tar -xvf apache-commons-daemon.tar.gz
    else
      echo '获取arm'
      cp ../common/arm/apache-commons-daemon.zip ./
      unzip apache-commons-daemon.zip
    fi
    cd apache-commons-daemon
    path=$(pwd)
    tar -xvf *.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    jsvc -help 2>&1 | grep "Usage: jsvc"
    CHECK_RESULT $? 0 0 "Check jsvc -help  failed"

    jsvc --help 2>&1 | grep "Usage: jsvc"
    CHECK_RESULT $? 0 0 "Check jsvc --help  failed"

    jsvc -? 2>&1 | grep "Usage: jsvc"
    CHECK_RESULT $? 0 0 "Check jsvc -?  failed"

    /usr/bin/jsvc -pidfile $path/springboot-demo.pid -stop demo
    /usr/bin/jsvc -jvm server -server -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion
    CHECK_RESULT $? 0 0 "Check  /usr/bin/jsvc -jvm server -server -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion  failed"

    /usr/bin/jsvc -pidfile $path/springboot-demo.pid -stop demo
    /usr/bin/jsvc -jvm server -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion
    CHECK_RESULT $? 0 0 "Check  /usr/bin/jsvc -jvm server -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion  failed"

    /usr/bin/jsvc -pidfile $path/springboot-demo.pid -stop demo
    /usr/bin/jsvc -jvm server -Xms1024m -Xmx1024m -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion
    CHECK_RESULT $? 0 0 "Check  /usr/bin/jsvc -jvm server -Xms1024m -Xmx1024m -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion  failed"

    /usr/bin/jsvc -pidfile $path/springboot-demo.pid -stop demo
    /usr/bin/jsvc -jvm server -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion -keepstdin
    CHECK_RESULT $? 0 0 "Check  /usr/bin/jsvc -jvm server -home $path/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd $path/config -java-home $path/jdk1.8.0_351 -wait 60 -pidfile $path/springboot-demo.pid -outfile $path/logs/out.log -errfile $path/logs/jsvc.log -cp $path/commons-daemon-1.0.15.jar:$path/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion -keepstdin  failed"

    /usr/bin/jsvc -pidfile $path/springboot-demo.pid -stop demo
    CHECK_RESULT $? 0 0 "Check  /usr/bin/jsvc -pidfile $path/springboot-demo.pid -stop demo  failed"

    /usr/bin/jsvc -pidfile $path/springboot-demo.pid -stop demo
    /usr/bin/jsvc -jvm client -client -home /opt/jdk1.8.0_351 -procname demo -Dserver.port=18888 -user daemon -cwd /opt/apache-commons-daemon/config -java-home /opt/apache-commons-daemon/jdk1.8.0_351 -wait 60 -pidfile /opt/apache-commons-daemon/springboot-demo.pid -outfile /opt/apache-commons-daemon/logs/out.log -errfile /opt/apache-commons-daemon/logs/jsvc.log -cp /opt/apache-commons-daemon/commons-daemon-1.0.15.jar:/opt/apache-commons-daemon/demo-1.0-SNAPSHOT.jar org.example.JsvcStart -debug -check -nodetach -verbose -version -showversion
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ../..
    rm -rf test
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
