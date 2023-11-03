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
#@Date      	:   2020-11-30
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test rename file on fs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    point_list=($(CREATE_FS))
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        echo "test" >$var/testfile1
        inode1=$(stat $var/testfile1 | grep Inode | cut -d : -f 3 | awk '{print $1}')
        mv $var/testfile1 $var/testfile2
        inode2=$(stat $var/testfile2 | grep Inode | cut -d : -f 3 | awk '{print $1}')
        [[ $inode1 -eq $inode2 ]]
         CHECK_RESULT $? 0 0 "Check inode failed."
        grep -q "test" $var/testfile2
        CHECK_RESULT $? 0 0 "The file info of $var/testfile2 is false."
        mkdir $var/test_dir
        mv $var/testfile2 $var/test_dir
        inode3=$(stat $var/test_dir/testfile2 | grep Inode | cut -d : -f 3 | awk '{print $1}')
        [[ $inode1 -eq $inode3 ]]
         CHECK_RESULT $? 0 0 "Check inode failed."
        grep -q "test" $var/test_dir/testfile2
        CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile2 is false."
        touch $var/test_dir/testfile3
        echo "cover" >$var/test_dir/testfile3
        grep -q "cover" $var/test_dir/testfile3
        CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile3 is false."
        mv -f $var/test_dir/testfile2 $var/test_dir/testfile3
        grep -q "test" $var/test_dir/testfile3
        CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile3 is false."
        touch $var/test_dir/testfile4
        echo "new" >$var/test_dir/testfile4
        grep -q "new" $var/test_dir/testfile4
        CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile4 is false."
        mv -u $var/test_dir/testfile3 $var/test_dir/testfile4
        grep -q "new" $var/test_dir/testfile4
        CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile4 is false."
        mv -fb $var/test_dir/testfile3 $var/test_dir/testfile4
        grep -q "new" $var/test_dir/testfile4~
        CHECK_RESULT $? 0 0 "The file info of -fb $var/test_dir/testfile4 is false."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main $@

