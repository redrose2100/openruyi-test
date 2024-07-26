#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024.06.18
# @License   :   Mulan PSL v2
# @Desc      :   mapfile using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    utshell -c "echo test > /tmp/test.log"
    utshell -c "mapfile < /tmp/test.log -d $'\t' target_array"
    CHECK_RESULT $? 0 0 "Execution failed"
    cat >/tmp/test.sh <<EOF
inputfile="/tmp/test.log"
exec {fd}<"\$inputfile"
mapfile -u \${fd} -d',' abc
echo \${abc[*]}
EOF
    utshell -c "sh /tmp/test.sh" |grep -i test
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"