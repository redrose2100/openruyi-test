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
    cat > ~/.antrc <<EOF
export test_value="ant using config antrc"
EOF
    cat > build.xml <<EOF
<?xml version="1.0"?>
<project name="HelloWorld" default="test" basedir="">
    <property environment="env" />
    <target name="test">
        <echo message="\${env.test_value}" />
    </target>
</project>
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ant --h | grep -F "[options] [target [target2 [target3] ...]]"
    CHECK_RESULT $? 0 0 "test failed with option --h"
    ant --help | grep -F "[options] [target [target2 [target3] ...]]"
    CHECK_RESULT $? 0 0 "test failed with option --help"
    ANT_HOME=/usr/share/ant ant --noconfig | grep "env.test_value"
    CHECK_RESULT $? 0 0 "test failed with option --noconfig"
    ant --usejikes | grep -Pz "ant using config antrc\n\nBUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option --usejikes"
    ant --execdebug | grep -Pz "exec [\S\s]*ant using config antrc\n\nBUILD SUCCESSFUL\nTotal time"
    CHECK_RESULT $? 0 0 "test failed with option --execdebug"
    ant -h | grep -F "[options] [target [target2 [target3] ...]]"
    CHECK_RESULT $? 0 0 "test failed with option -h"
    ant -help | grep -F "[options] [target [target2 [target3] ...]]"
    CHECK_RESULT $? 0 0 "test failed with option -help"
    ant -projecthelp | grep -Pz "Buildfile[\S\s]*Main targets:[\S\s]*Other targets:\n\s*test\nDefault target: test"
    CHECK_RESULT $? 0 0 "test failed with option -projecthelp"
    ant -p | grep -Pz "Buildfile[\S\s]*Main targets:[\S\s]*Other targets:\n\s*test\nDefault target: test"
    CHECK_RESULT $? 0 0 "test failed with option -p"
    ant -version | grep -Pz "Apache Ant\(TM\) version[\S\s]*compiled on[\S\s]*"
    CHECK_RESULT $? 0 0 "test failed with option -version"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf build.xml ~/.antrc
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
