#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.4.6
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-atune-collection
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/common_lib.sh"

file_name="atuneTest"
min_interval=1
min_duration=10
output_path=$(pwd)
sys_disk=$(lsblk |awk 'NR==2' |awk '{print $1}')
sys_network=${NODE1_NIC}
function pre_test(){
    LOG_INFO "Start environment preparation."
    deploy_autund
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    atune-adm collection -h |grep OPTIONS
    CHECK_RESULT $? 0 0 "atune-adm collection -h failure"
    atune-adm collection -f $file_name -i $min_interval -d $min_duration -o $output_path -b $sys_disk -n $sys_network -t default
    CHECK_RESULT $? 0 0 "atune-adm collection failure"
}
function post_test() {
    clean_autund
}

main $@

