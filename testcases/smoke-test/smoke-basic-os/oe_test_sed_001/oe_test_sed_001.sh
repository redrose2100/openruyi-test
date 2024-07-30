#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.1.28
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-sed
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/test_sed  <<EOF
aaaa
bbbb
cccc
dddd
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep sed
    CHECK_RESULT $? 0 0 "Return value error"
    sed --v
    CHECK_RESULT $? 0 0 "Version is error"
    sed --help | grep -iE "用法|Usage"
    CHECK_RESULT $? 0 0 "sed --help fail"
    sed -i '1i testline' /tmp/test_sed
    grep testline /tmp/test_sed
    CHECK_RESULT $? 0 0 "set testline fail"    
    sed -i '1d' /tmp/test_sed
    grep testline /tmp/test_sed
    CHECK_RESULT $? 1 0 "delete firstline fail"
    sed -n '1p' /tmp/test_sed
    CHECK_RESULT $? 0 0 "lookup firstline error"   
    sed -n '2,+3p' /tmp/test_sed
    CHECK_RESULT $? 0 0 "print 2~3 fail"
    sed -i 's/aaaa/eeee/' /tmp/test_sed
    grep eeee /tmp/test_sed
    CHECK_RESULT $? 0 0 "replace aaaa fail"
    sed '1,4d' /tmp/test_sed
    grep dddd /tmp/test_sed
    CHECK_RESULT $? 0 0 "sed '1,4d'execute fail"
    sed -i '4a\ffff' /tmp/test_sed
    grep ffff /tmp/test_sed
    CHECK_RESULT $? 0 0 "set ffff fail"
    sed -i '1c hello' /tmp/test_sed
    grep eeee /tmp/test_sed
    CHECK_RESULT $? 0 1 "set hello fail"
    sed -i '1,5d' /tmp/test_sed
    grep hello /tmp/testsed
    CHECK_RESULT $? 0 1 "sed -i '1,5d' execute fail"
    LOG_INFO "Finished test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test_sed
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
