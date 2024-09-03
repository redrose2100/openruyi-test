#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2024/09/10
# @License   :   Mulan PSL v2
# @Desc      :   Setsid backend execution program
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    cat > test.sh << EOF
#!/bin/bash
while true
do
echo 'hi,uos'
sleep 3s
done
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    setsid sh test.sh >> test.log &
    CHECK_RESULT $? 0 0 "Setsid backend execution of test.sh failed"
    numstart=$(wc -l < test.log)
    sleep 30
    numend=$(wc -l < test.log)
    [ "$numend" -gt "$numstart" ]
    CHECK_RESULT $? 0 0 "Numend is less than numstart"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    pgrep -f "sh test.sh" | xargs kill -9
    rm -rf test.sh test.log
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
