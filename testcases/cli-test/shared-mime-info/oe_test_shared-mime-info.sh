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
# @Date      :   2023.12.11
# @License   :   Mulan PSL v2
# @Desc      :   shared-mime-info formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."    
    cat > /tmp/shared-mime-info.txt << EOF
1234
}
EOF

    DNF_INSTALL "shared-mime-info xdg-utils"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep shared-mime-info
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && xdg-mime query filetype shared-mime-info.txt > shared-mime-info.file
    test -f /tmp/shared-mime-info.file
    CHECK_RESULT $? 0 0 "shared-mime-info test fail"
    grep "plain" /tmp/shared-mime-info.file    
    CHECK_RESULT $? 0 0 "execute shared-mime-info.txt fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/shared-mime-info.file /tmp/shared-mime-info.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
