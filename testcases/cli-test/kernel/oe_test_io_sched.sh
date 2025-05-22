#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   临时切换IO SCHED策略
# #############################################
# shellcheck disable=SC2120

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    disks=$(TEST_DISK "$@")
    disk_list=("$disks")
    local_disk=${disk_list[0]}
    default=$(< /sys/block/"${local_disk}"/queue/scheduler awk -F "[" '{print $2}' | awk -F "]" '{print $1}')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_name=(none mq-deadline bfq kyber)
    for i in "${test_name[@]}"
    do
      echo "$i" > /sys/block/"${local_disk}"/queue/scheduler
      model=$(grep "$i" /sys/block/"${local_disk}"/queue/scheduler | awk -F "[" '{print $2}' | awk -F "]" '{print $1}')
      CHECK_RESULT "$model" "$i" 0 "Switching failed"
    done
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    echo "${default}" > /sys/block/"${local_disk}"/queue/scheduler
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
