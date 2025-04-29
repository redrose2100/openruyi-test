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
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-06-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Dump data by snapshot
#####################################

source "${OET_PATH}/testcases/system-test/fs-test/common_lib/fsio_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "dump xfsdump lvm2"
    IFS=' ' read -ra fs_args <<< "$FS_TYPE"
    read -ra point_list <<< "$(CREATE_FS "${fs_args[@]}")"
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        echo "test write file" >"${var}"/test_file
        mkdir "${var}"/test_dir
    done
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        fs_type=$(df -iT | grep "$var" | awk '{print $2}')
        if [[ $fs_type == "xfs" ]]; then
            xfsdump -f /tmp/test_dump.dump "${var}" -L test_xfs_dump -M test
            rm -rf "${var:?}"/*
            xfsrestore -rf /tmp/test_dump.dump "${var}"
            CHECK_RESULT $? 0 0 "Dump data failed."
            test -d "${var}"/xfsrestorehousekeepingdir
            CHECK_RESULT $? 0 0 "The xfsrestorehousekeepingdir doesn't exist."
        else
            dump -0f /tmp/test_dump.dump "${var}"
            rm -rf "${var:?}"/*
            cd "${var}" || exit
            restore -rf /tmp/test_dump.dump
            CHECK_RESULT $? 0 0 "Dump data failed."
            cd - || exit
            test -f "${var}"/restoresymtable
            CHECK_RESULT $? 0 0 "The file restoresymtable doesn't exist."
        fi
        grep -q "test" "${var}"/test_file
        CHECK_RESULT $? 0 0 "Check data failed."
        rm -rf /tmp/test_dump.dump
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list="${point_list[*]}"
    REMOVE_FS "$list"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

