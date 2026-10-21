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
        <echo message="yourclasspath:\${java.class.path}" />
    </target>
</project>
EOF
    cat > build_for_input.xml <<EOF
<?xml version="1.0"?>
<project name="HelloWorld" default="test" basedir="">
    <target name="test">
        <input message="input:" addproperty="user_input" defaultvalue="null" />
        <echo message="your input is:\${user_input}"></echo>
    </target>
</project>
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ant -lib /test_added_lib_path | grep /test_added_lib_path
    CHECK_RESULT $? 0 0 "test failed with option -lib"
    ant -logfile ant.1.log && grep "yourclasspath" ant.1.log
    CHECK_RESULT $? 0 0 "test failed with option -logfile"
    ant -l ant.2.log && grep "yourclasspath" ant.2.log
    CHECK_RESULT $? 0 0 "test failed with option -l"
    ant -logger org.apache.tools.ant.NoBannerLogger | grep "yourclasspath"
    CHECK_RESULT $? 0 0 "test failed with option -logger"
    ant -listener org.apache.tools.ant.XmlLogger | grep "yourclasspath"
    CHECK_RESULT $? 0 0 "test failed with option -listener"
    echo -e "hello\n" | ant -f build_for_input.xml | grep -F "[echo] your input is:hello"
    CHECK_RESULT $? 0 0 "test failed with option -f"
    echo -e "hello\n" | ant -file build_for_input.xml | grep -F "[echo] your input is:hello"
    CHECK_RESULT $? 0 0 "test failed with option -file"
    echo -e "hello\n" | ant -buildfile build_for_input.xml | grep -F "[echo] your input is:hello"
    CHECK_RESULT $? 0 0 "test failed with option -buildfile"
    ant -noinput -f build_for_input.xml 2>&1 | grep -Pz "BUILD FAILED[\S\s]*Failed to read input from Console."
    CHECK_RESULT $? 0 0 "test failed with option -noinput"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf *.xml *.log
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
