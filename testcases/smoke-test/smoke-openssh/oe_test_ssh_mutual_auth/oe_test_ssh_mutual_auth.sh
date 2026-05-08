#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/07/27
# @License   :   Mulan PSL v2
# @Desc      :   ssh双向认证测试
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    rm -rf /root/.ssh
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ''
    SSH_CMD "rm -rf /root/.ssh;rm -rf /libs;ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ''" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_SCP "$OET_PATH"/libs/locallibs/sshcmd.sh "${NODE2_USER}"@"${NODE2_IPV4}":/root/ "${NODE2_PASSWORD}"
    SSH_SCP "$OET_PATH"/libs "${NODE2_USER}"@"${NODE2_IPV4}":/ "${NODE2_PASSWORD}"
    #服务端保存客户端的host key
    SSH_CMD "ssh-keyscan -H ${NODE1_IPV4} >> /root/.ssh/known_hosts 2>/dev/null" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    #服务端，客户端互相免密
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":/root/.ssh/id_rsa.pub /root/.ssh/authorized_keys "${NODE2_PASSWORD}"
    chmod 600 /root/.ssh/authorized_keys
    SSH_SCP /root/.ssh/id_rsa.pub "${NODE2_USER}"@"${NODE2_IPV4}":/root/.ssh/authorized_keys "${NODE2_PASSWORD}"
    SSH_CMD "chmod 600 /root/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

}

function run_test() {
    # 客户端登服务端免密
    ssh "${NODE2_USER}"@"${NODE2_IPV4}" ip a | grep "${NODE2_IPV4}"
    CHECK_RESULT $? 0 0
    # 服务端登客户端免密
    ssh "${NODE2_USER}"@"${NODE2_IPV4}" ssh root@"${NODE1_IPV4}" ip a | grep "${NODE1_IPV4}"
    CHECK_RESULT $? 0 0
    
    # 新增测试点1: 验证SSH密钥文件权限
    local ssh_dir_perm
    ssh_dir_perm=$(stat -c %a /root/.ssh 2>/dev/null)
    CHECK_RESULT "$ssh_dir_perm" "700" 0 ".ssh目录权限不正确，应为700"
    local auth_keys_perm
    auth_keys_perm=$(stat -c %a /root/.ssh/authorized_keys 2>/dev/null)
    CHECK_RESULT "$auth_keys_perm" "600" 0 "authorized_keys文件权限不正确，应为600"
    
    # 新增测试点2: 测试SSH文件传输（scp）
    echo "test_content_$(date +%s)" > /tmp/ssh_test_file.txt
    scp /tmp/ssh_test_file.txt "${NODE2_USER}"@"${NODE2_IPV4}":/tmp/
    CHECK_RESULT $? 0 0 "scp上传文件失败"
    ssh "${NODE2_USER}"@"${NODE2_IPV4}" "test -f /tmp/ssh_test_file.txt && cat /tmp/ssh_test_file.txt" | grep -q "test_content"
    CHECK_RESULT $? 0 0 "远程文件内容验证失败"
    rm -f /tmp/ssh_test_file.txt
    SSH_CMD "rm -f /tmp/ssh_test_file.txt" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

function post_test() {
    rm -rf /root/.ssh
    SSH_CMD "rm -rf /root/.ssh;rm -rf /root/sshcmd.sh;rm -rf /libs" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
}

main "$@"
