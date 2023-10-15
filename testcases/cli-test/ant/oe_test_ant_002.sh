#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

####################################
#@Author    	:   songliying
#@Contact   	:   liying@isrc.iscas.ac.cn
#@Date      	:   2022-09-27
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Test ant
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ant
    cat > build.xml <<EOF
<?xml version="1.0"?>
<project name="HelloWorld" default="test" basedir="">
    <target name="test">
        <echo message="ant test" />
    </target>
</project>
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ant -diagnostics  | grep "Ant diagnostics report"
    CHECK_RESULT $? 0 0 "test failed with option -diagnostics"
    ant -quiet | grep -Pz "\S*\[echo\] ant test[\S\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -quiet"
    ant -q | grep -Pz "\S*\[echo\] ant test[\S\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -q"
    ant -silent | grep -Pz "Buildfile[\S\s]*ant test"
    CHECK_RESULT $? 0 0 "test failed with option -silent"
    ant -S | grep -Pz "Buildfile[\S\s]*ant test"
    CHECK_RESULT $? 0 0 "test failed with option -S"
    ant -verbose | grep -Pz "Apache[\S\s]*Buildfile[\S\s]*test:[\S\s]*ant test[\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -verbose"
    ant -v | grep -Pz "Apache[\S\s]*Buildfile[\S\s]*test:[\S\s]*ant test[\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -v"
    ant -debug | grep -Pz "Apache Ant\(TM\)[\S\s]*(Setting|Adding)[\S\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -debug"
    ant -d | grep -Pz "Apache Ant\(TM\)[\S\s]*(Setting|Adding)[\S\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -d"
    ant -e | grep -Pz "Buildfile:[\S\s]*test:\nant test\s+BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -e"
    ant -emacs | grep -Pz "Buildfile:[\S\s]*test:\nant test\s+BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -emacs"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf build.xml
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
