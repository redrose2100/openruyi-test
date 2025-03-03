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
# @Author    :   xionglinhui
# @Contact   :   xionglinhui@uniontech.com
# @Date      :   2024-05-29
# @License   :   Mulan PSL v2
# @Desc      :   test lsipc
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    lsipc
    CHECK_RESULT $? 0 0 "lsipc execute fail"
    ## set lang to en, make shm (shared memory segment)
    local ipcid
    ipcid=$(LANG="" ipcmk -M 1m | awk '{print $NF}')
    CHECK_RESULT $? 0 0 "failed to make shm segment" 1
    lsipc -m | grep "SIZE"
    CHECK_RESULT $? 0 0 "lsipc --shmems execute fail"
    lsipc -n | grep "RESOURCE"
    CHECK_RESULT $? 0 0 "lsipc --newline execute fail"
    lsipc -q 
    CHECK_RESULT $? 0 0 "lsipc --quene execute fail"
    lsipc -J | grep "ipclimits"
    CHECK_RESULT $? 0 0 "lsipc --Json execute fail"
    lsipc -s
    CHECK_RESULT $? 0 0 "lsipc --semaphores execute fail"
    lsipc -h | grep "help"
    CHECK_RESULT $? 0 0 "lsipc --help execute fail"
    lsipc -b | grep "USED"
    CHECK_RESULT $? 0 0 "lsipc --byte execute fail"
    lsipc -V | grep "lsipc"
    CHECK_RESULT $? 0 0 "lsipc --version execute fail"
    lsipc -l 
    CHECK_RESULT $? 0 0 "lsipc --list execute fail"
    lsipc -r
    CHECK_RESULT $? 0 0 "lsipc --raw execute fail"
    lsipc -m -P | grep PERMS
    CHECK_RESULT $? 0 0 "-m -p --numeric-perms execute fail"
    lsipc -m -c | grep OWNER
    CHECK_RESULT $? 0 0 "-m -c --creator execute fail"
    lsipc -m -e | grep KEY
    CHECK_RESULT $? 0 0 "-m -e --export execute fail"
    lsipc -m -t | grep CTIME
    CHECK_RESULT $? 0 0 "-m -t --time execute fail"
    lsipc -g | grep MSGMNI
    CHECK_RESULT $? 0 0 "-g --global execute fail"
    lsipc -g -s | grep LIMIT
    CHECK_RESULT $? 0 0 "-g -s --semaphores execute fail"
    lsipc -g -o RESOURCE | grep "SEMOPM"
    CHECK_RESULT $? 0 0 "-g -o --output[=<ап╠М>] execute fail"
    ipcrm -m "$ipcid"
    LOG_INFO "Finish test!"
}

main "$@"
