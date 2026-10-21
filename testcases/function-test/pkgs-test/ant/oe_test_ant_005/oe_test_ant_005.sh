#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

####################################
#@Author    	:   geyaning
#@Contact   	:   geyaning@uniontech.com
#@Date      	:   2023-04-17
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   ant run java
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ant
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
        cat > /tmp/build.xml << \EOF
<?xml version="1.0"?>
<project name="sample" basedir="." default="notify">
<target name="notify">
<java fork="true" failonerror="yes" classname="NotifyAdministrator">
<arg line="admin@test.com"/>
</java>
</target>
</project>
EOF
       cat > /tmp/NotifyAdministrator.java << \EOF
public class NotifyAdministrator
{
public static void main(String[] args)
{
String email = args[0];
notifyAdministratorviaEmail(email);
System.out.println("Administrator "+email+" has been notified");
}
public static void notifyAdministratorviaEmail(String email)
{
//......
}
}
EOF
    cd /tmp
    javac NotifyAdministrator.java
    test -e NotifyAdministrator.class
    CHECK_RESULT $? 0 0 "Ant failed to execute javac and could not generate the class file"
    ant | grep "BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "ant run fails"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/build.xml /tmp/NotifyAdministrator*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
