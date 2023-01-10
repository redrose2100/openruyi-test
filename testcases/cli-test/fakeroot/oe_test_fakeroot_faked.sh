# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of fakeroot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL fakeroot
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    echo | faked --port 10000 --debug --unknown-is-real --load | grep "10000:"
    CHECK_RESULT $? 0 0 "Check faked --port --debug --unknown-is-real --load failed"

    nohup faked --foreground >./info1.log 2>&1 &
    SLEEP_WAIT 2
    grep "$(ps -ef | grep "faked --foreground" | grep -v grep | awk '{print $2}')" ./info1.log
    CHECK_RESULT $? 0 0 "Check faked --foreground failed"

    faked --cleanup --key --save-file ./info.log |grep "$(ps -ef | grep "faked --cleanup" | grep -v grep | awk '{print $2}')"
    CHECK_RESULT $? 0 0 "Check faked --cleanup --key --save-file failed"

    fakeroot -v 2>&1 | grep "fakeroot version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check fakeroot -v failed"

    fakeroot --version 2>&1 | grep "fakeroot version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check fakeroot --version failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    ps -ef | grep "faked --port 10000" | grep -v grep | awk '{print $2}' | xargs kill -9
    ps -ef | grep "faked --cleanup --key" | grep -v grep | awk '{print $2}' | xargs kill -9
    ps -ef | grep "faked --foreground" | grep -v grep | awk '{print $2}' | xargs kill -9
    LOG_INFO "Finish restore the test environment."
}

main "$@"
