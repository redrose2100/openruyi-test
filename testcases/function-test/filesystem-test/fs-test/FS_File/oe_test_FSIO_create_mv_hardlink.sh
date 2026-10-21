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
#@Contact   	:   244349477@qq.com
#@Date      	:   2020-12-01
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test create and mv hard link file
#####################################
# shellcheck disable=SC1091

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    mapfile -t point_list < <(CREATE_FS)
    ext3_point=$(echo "${point_list[@]}" | awk '{print $2}')
    ext4_point=$(echo "${point_list[@]}" | awk '{print $3}')
    xfs_point=$(echo "${point_list[@]}" | awk '{print $4}')
    echo "test ext3" >"$ext3_point"/testFile
    ln "$ext3_point"/testFile "$ext3_point"/testLink
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ori_inode=$(stat "$ext3_point"/testLink | grep Inode | cut -d : -f 3 | awk '{print $1}')
    mv "$ext3_point"/testLink "$ext3_point"/testLink1
    inode1=$(stat "$ext3_point"/testLink1 | grep Inode | cut -d : -f 3 | awk '{print $1}')
    [[ "$ori_inode" == "$inode1" ]]
    CHECK_RESULT $? 0 0 "The hard link inode is changed unexpectly when mv on ext3"
    mv "$ext3_point"/testLink1 "$ext4_point"/testLink
    inode2=$(stat "$ext4_point"/testLink | grep Inode | cut -d : -f 3 | awk '{print $1}')
    [[ "$ori_inode"x == "$inode2"x ]]
    CHECK_RESULT $? 0 0 "The hard link inode change when mv from ext3 to ext4"
    mv "$ext4_point"/testLink "$xfs_point"/testLink
    inode3=$(stat "$xfs_point"/testLink | grep Inode | cut -d : -f 3 | awk '{print $1}')
    [[ "$ori_inode"x != "$inode3"x ]]
    CHECK_RESULT $? 0 0 "The hard link inode doesn't change when mv from ext3 to xfs"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=${point_list[*]}
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main "$@"
