 #!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2021-01-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Inject: create non-format file on fs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=($(CREATE_FS))
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mnt_point=${point_list[$i]}
        max_name_len=$(getconf NAME_MAX $mnt_point)
        fileName=$(GET_RANDOMNAME $max_name_len)
        cpfile=$(find / -name ls 2>&1)
        file=$mnt_point/$fileName
        cp $cpfile $file
        size=$(ls -l $file | awk '{print $5}')
        i=0
        while [[ $i -lt 100 ]]; do
            cat $cpfile >> $file
            echo "test" >> $file
            i=$(($i+1))
        done
        cat $file >/dev/null
        CHECK_RESULT $? 0 0 "Cat file failed."
        rm -f $file
        CHECK_RESULT $? 0 0 "Remove file failed."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main "$@"
