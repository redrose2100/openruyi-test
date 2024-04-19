#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-07-17
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    cp ../common/* . 
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    javadoc -help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "javadoc -help failed"
    javadoc -public Hello1.java -d public
    CHECK_RESULT $? 0 0 "javad -public failed"
    find public
    CHECK_RESULT $? 0 0 "find  public failed"
    javadoc -protected Hello1.java -d protected
    CHECK_RESULT $? 0 0 "javadoc -protected failed"
    find protected
    CHECK_RESULT $? 0 0 "find protected failed"
    javadoc -private Hello1.java -d private
    CHECK_RESULT $? 0 0 "javadoc -private"
    find private
    CHECK_RESULT $? 0 0 "find private failed"
    javadoc -package Hello1.java -d package
    CHECK_RESULT $? 0 0 "javadoc -package failed"
    find package
    CHECK_RESULT $? 0 0 "find package failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf Hello* public protected private package
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
