#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   shangyingjie
# @Contact   :   yingjie@isrc.iscas.ac.cn
# @Date      :   2022/2/24
# @License   :   Mulan PSL v2
# @Desc      :   Test zerofree
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL zerofree
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    dd if=/dev/zero of=fs.img bs=1M count=1024
    mkfs.ext3 fs.img
    mkdir ./test
    mount ./fs.img ./test
    yes abcdefghijklmnopqrstuvwxyz0123456789 > ./test/largefile
    rm ./test/largefile
    umount ./test
    cp --sparse=always ./fs.img sparsed.img
    sparsed_size="$(du ./sparsed.img | awk '{print $1}')"
    zerofree -n ./fs.img
    cp --sparse=always ./fs.img zerofreed_n_sparsed.img
    zerofreed_n_sparsed_size="$(du ./zerofreed_n_sparsed.img | awk '{print $1}')"
    [ "$sparsed_size" -eq "$zerofreed_n_sparsed_size" ]
    CHECK_RESULT $? 0 0 "Failed to use option: -n"
    zerofree -v fs.img | grep '/'
    CHECK_RESULT $? 0 0 "Failed to use option: -v"
    cp --sparse=always ./fs.img zerofreed_sparsed.img
    zerofreed_sparsed_size="$(du ./zerofreed_sparsed.img | awk '{print $1}')"
    [ "$zerofreed_sparsed_size" -lt "$sparsed_size" ]
    CHECK_RESULT $? 0 0 "Failed to use basic funtion."
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./test ./fs.img ./zerofreed_n_sparsed.img ./zerofreed_sparsed.img ./sparsed.img
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
