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
# @Desc      :   verify the uasge of fakechroot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL fakechroot
    cp ./common/hello.sh ./
    chmod 777 hello.sh
    mkdir test
    cp ./common/hello.sh ./test
    chmod 777 ./test/hello.sh
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    env -i ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check env -i failed"

    env --ignore-environment ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check env --ignore-environment failed"

    env -0
    CHECK_RESULT $? 0 0 "Check env.fakechroot -0 failed"

    env --null
    CHECK_RESULT $? 0 0 "Check env.fakechroot --null failed"

    env -u OLDPWD | grep "USER"
    CHECK_RESULT $? 0 0 "Check env -u OLDPWD failed"

    env --unset=OLDPWD | grep "USER"
    CHECK_RESULT $? 0 0 "Check env --unset=OLDPWD failed"

    env -C ./test ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check env -C  failed"

    env --chdir=./test ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check env --chdir failed"

    env -S ./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check env -S failed"

    env --split-string=./hello.sh | grep "hello world!"
    CHECK_RESULT $? 0 0 "Check env --split-string failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf hello.sh test
    LOG_INFO "Finish restore the test environment."
}

main "$@"
