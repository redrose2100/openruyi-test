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
# @Date      :   2024.4.29
# @License   :   Mulan PSL v2
# @Desc      :   libdwarf Command Test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "libdwarf libdwarf-devel libdwarf-help libdwarf-tools"
    default_pwd=$(pwd)
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /usr/bin || exit
    dwarfdump -a ls |grep -i debug
    CHECK_RESULT $? 0 0 "Debug information viewing failed"
    dwarfdump -b ls |grep -i abbrev
    CHECK_RESULT $? 0 0 " abbrev information viewing failed"
    dwarfdump -s ls |grep -i debug_str
    CHECK_RESULT $? 0 0 "Debug information viewing failed"
    dwarfdump -r ls |grep -i debug_aranges
    CHECK_RESULT $? 0 0 "debug_aranges information viewing failed"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd "$default_pwd" || exit
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"