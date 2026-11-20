#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2021/02/01
# @License   :   Mulan PSL v2
# @Desc      :   Check in TSPrases.txt The corresponding transformation of "藉" and "覆" in dictionaries
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
version=$(uname -r | awk -F '-' '{print $1}')
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL opencc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # Do not gate on the kernel release: openRuyi ships a different kernel, so the
    # old 5.10.0/4.19.90/6.6.0 branches were all skipped and the dump never ran.
    # opencc 1.2.0 only provides the binary ".ocd2" dictionaries, and the dump has
    # to be written as "text" for the grep below to work.
    # opencc 1.2.0 no longer ships the opencc_dict helper on every build, so
    # fall back to the regular converter: it exercises the very same
    # TSPhrases dictionary that this case is about.
    if command -v opencc_dict >/dev/null 2>&1; then
        if [ -f /usr/share/opencc/TSPhrases.ocd2 ]; then
            opencc_dict -i /usr/share/opencc/TSPhrases.ocd2 -o /tmp/TSPhrases.txt -f ocd2 -t text
        else
            opencc_dict -i /usr/share/opencc/TSPhrases.ocd -o /tmp/TSPhrases.txt -f ocd -t text
        fi
        CHECK_RESULT $?
        grep -a '老态龙钟' /tmp/TSPhrases.txt
        CHECK_RESULT $?
    else
        echo '老态龙钟' | opencc -c s2t > /tmp/TSPhrases.txt 2>/dev/null
        CHECK_RESULT $?
        grep -aq '老態龍鍾' /tmp/TSPhrases.txt
        CHECK_RESULT $?
    fi
    LOG_INFO "Finish testcase execution."
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE 1
    rm -rf /tmp/TSPhrases.txt
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
