#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   lufei
#@Contact   	:   lufei@uniontech.com
#@Date      	:   2023-11-15
#@License   	:   Mulan PSL v2
#@Desc      	:   file command, detect file types.
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare test requirements."
    DNF_INSTALL tar
    arch=$(uname -m)
    case "$arch" in
	x86_64) 
            arch="x86-64"
            endian="LSB"
            ;;
        ppc64*) endian="MSB" ;;
	*) endian="LSB" ;;
    esac
    root_blk=$(mount | grep "/ " | cut -d " " -f 1)
    root_fs=$(mount | grep "/ " | cut -d " " -f 5)
    echo "hello world" > hello.txt
    tar czf hello.tar.gz hello.txt
    LOG_INFO "Test preparation finished."
}

function run_test() {
    LOG_INFO "Start to run test."
    file -sL "$root_blk" | grep -i "$root_fs"
    CHECK_RESULT $? 0 0 "file cannot determin $root_blk file system type."
    file -b hello.txt | grep "ASCII text"
    CHECK_RESULT $? 0 0 "file cannot determin hello.txt file type."
    file -b hello.tar.gz | grep "gzip"
    CHECK_RESULT $? 0 0 "file cannot determin hello.tar.gz file type."
    file -b "$(whereis ls | cut -d ' ' -f 2)" | grep -P "$endian.*$arch"
    CHECK_RESULT $? 0 0 "file cannot determin $(whereis ls | cut -d ' ' -f 2) file type."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf hello.txt hello.tar.gz
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
