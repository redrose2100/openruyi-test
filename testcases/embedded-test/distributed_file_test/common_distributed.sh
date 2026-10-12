#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   sevenjj
#@Contact   	:   2461603862@qq.com
#@Date      	:   2024-02-05
#@License   	:   Mulan PSL v2
#@Desc      	:   Public documents
#####################################
# shellcheck disable=SC1091,SC2034,SC2010

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_env() {
    if ! grep -qiE '(openharmony|harmonyos|harmony)' /etc/os-release; then
       LOG_INFO "当前系统非 OpenHarmony/HarmonyOS，跳过测试。"
       exit 255
    fi
    DNF_INSTALL "hmdfs filemanagement_dfs_service"
    if cd /root && insmod /root/hmdfs.ko; then
        echo "insmod sucess"
    else
        echo "insmod failed"
        exit 1
    fi

    SSH_SCP /root/hmdfs.ko "${NODE2_USER}"@"${NODE2_IPV4}":/root "${NODE2_PASSWORD}"
    DNF_INSTALL "hmdfs filemanagement_dfs_service -y" 2
    SSH_CMD "cd /root && insmod hmdfs.ko" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22

    mkdir -p /data/service/el2/100/non_account /mnt/hmdfs/100/non_account
    sudo mount -t hmdfs -o merge,local_dst="/mnt/hmdfs/100/non_account" "/data/service/el2/100/non_account" "/mnt/hmdfs/100/non_account"
    sh /system/bin/start_services.sh all

    SSH_CMD "mkdir -p /data/service/el2/100/non_account  /mnt/hmdfs/100/non_account" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22
    SSH_CMD "sudo mount -t hmdfs -o merge,local_dst=\"/mnt/hmdfs/100/non_account\" \"/data/service/el2/100/non_account\" \"/mnt/hmdfs/100/non_account\"" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22
    SSH_CMD "sh /system/bin/start_services.sh all" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22

    sleep 3
    com_path="/mnt/hmdfs/100/non_account"
    remoteIDa=$(cd "${com_path}"/device_view && ls | grep -v local)
    cd "${com_path}"/device_view/local && mkdir testfile_1w_1
    cd "${com_path}"/device_view/"${remoteIDa}" && mkdir testfile_1w_2
    cd "${com_path}"/merge_view && mkdir testfile_1w_3
    SSH_CMD "cd ${com_path}/merge_view && mkdir testfile_1w_4" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22
    SSH_CMD "echo \`ls ${com_path}/device_view | grep -v local\` > /remoteIDb.txt" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/remoteIDb.txt / "${NODE2_PASSWORD}"
}

function set_var() {
    com_path="/mnt/hmdfs/100/non_account"
    remoteIDa=$(cd "${com_path}"/device_view && ls | grep -v local)
    remoteIDb=$(cat /remoteIDb.txt)
}

function scp_txt() {
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/test_01.txt / "${NODE2_PASSWORD}"
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/test_02.txt / "${NODE2_PASSWORD}"
}

function clean_env() {
    sh /system/bin/stop_services.sh all
    SSH_CMD "sh /system/bin/stop_services.sh all" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22
    sudo umount "/data/service/el2/100/non_account" "/mnt/hmdfs/100/non_account"
    SSH_CMD "sudo umount  \"/data/service/el2/100/non_account\"  \"/mnt/hmdfs/100/non_account\"" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22

    DNF_REMOVE "$@"
    rm -rf /test_01.txt /test_02.txt /remoteIDb.txt /remote_env.txt
    rmmod hmdfs && rm -rf /data/service /mnt/hmdfs
    DNF_REMOVE "$@" 2
    SSH_CMD "rm -rf /test_01.txt /test_02.txt /remoteIDb.txt /remote_env.txt" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22
    SSH_CMD "rmmod hmdfs && rm -rf  /data/service /mnt/hmdfs" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" 300 22
}
