#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   blackgaryc
# @Contact   :   blackgaryc@gmail.com
# @Date      :   2022/8/23
# @License   :   Mulan PSL v2
# @Desc      :   Test ant
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL ant
    cat > build.xml <<EOF
<?xml version="1.0"?>
<project name="HelloWorld" default="test" basedir="">
    <target name="test">
        <echo message="HelloWorld" />
    </target>
</project>
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    ant --h | grep -F "[options] [target [target2 [target3] ...]]"
    CHECK_RESULT $? 0 0 "test failed with option --h"
    ant --help | grep -F "[options] [target [target2 [target3] ...]]"
    CHECK_RESULT $? 0 0 "test failed with option --help"
    ant --noconfig 2>&1 | grep "Error: Could not find or load main class"
    CHECK_RESULT $? 0 0 "test failed with option --noconfig"
    ant --usejikes | grep -Pz "HelloWorld\n\nBUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option --usejikes"
    ant --execdebug | grep -Pz "exec [\S\s]*HelloWorld\n\nBUILD SUCCESSFUL\nTotal time"
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
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf build.xml
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
