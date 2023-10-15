#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-12-21
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test modfiy file on overlayfs
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    cur_date=$(date +%Y%m%d%H%M%S)
    lower="/tmp/low"$cur_date
    upper="/tmp/upper"$cur_date
    work="/tmp/work"$cur_date
    point="/mnt/point"$cur_date
    mkdir -p $lower/testDir $upper $work $point
    touch $lower/testFile
    mount -t overlay overlay -o lowerdir=$lower,upperdir=$upper,workdir=$work $point
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    mv $point/testFile $point/testFile2
    mv $point/testDir $point/testDir2
    test -f $lower/testFile
    CHECK_RESULT $? 0 0 "There is no file on $lower."
    test -d $lower/testDir
    CHECK_RESULT $? 0 0 "There is no directory on $lower."
    ls -l $upper | grep testFile | grep "c---------"
    CHECK_RESULT $? 0 0 "There is no whiteout file testFile in $upper failed."
    ls -l $upper | grep testDir | grep "c---------"
    CHECK_RESULT $? 0 0 "There is no whiteout file testDir in $upper failed."
    test -f $upper/testFile2
    CHECK_RESULT $? 0 0 "Modify file in $upper failed."
    test -d $upper/testDir2
    CHECK_RESULT $? 0 0 "Modify directory in $upper failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount $point
    rm -rf $lower $upper $work $point
    LOG_INFO "End to restore the test environment."
}

main $@
