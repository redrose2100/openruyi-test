#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   20223/03/30
# @License   :   Mulan PSL v2
# @Desc      :   Test luajit print
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL luajit
    mkdir /tmp/test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /tmp/test
    mkdir haha
    cat << EOF > haha/module.lua
function ha()
print("haha")
end
EOF
    cat << EOF > require1.lua
ha()
EOF
    luajit -l "haha.module" require1.lua | grep 'haha' 
    CHECK_RESULT $? 0 0 "Execution require1 failure"
    cat << EOF > require2.lua
require("haha.module")
ha()
EOF
    luajit require2.lua | grep 'haha' 
    CHECK_RESULT $? 0 0 "Execution require2 failure"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /tmp/test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
