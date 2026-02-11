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
    SSH_CMD "rm -rf /root/.ssh;rm -rf /libs;ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ''"
    SSH_SCP "$OET_PATH"/libs/tools/sshcmd.sh "${REMOTE_USER}"@"${REMOTE_IP}":/root/ "${REMOTE_PASSWD}"
    SSH_SCP "$OET_PATH"/libs "${REMOTE_USER}"@"${REMOTE_IP}":/ "${REMOTE_PASSWD}"
    #服务端保存客户端的yes
    SSH_CMD "sh /root/sshcmd.sh -c 'ls' -m '$ETS_LOCAL_IP' -p '${ETS_LOCAL_PASSWD_ROOT}' -u 'root'"
    #服务端，客户端互相免密
    SSH_SCP "$REMOTE_USER"@"${REMOTE_IP}":/root/.ssh/id_rsa.pub /root/.ssh/authorized_keys "$REMOTE_PASSWD"
    SSH_SCP /root/.ssh/id_rsa.pub "${REMOTE_USER}"@"${REMOTE_IP}":/root/.ssh/authorized_keys "${REMOTE_PASSWD}"

}

function do_test() {
    # 客户端登服务端免密
    ssh "${REMOTE_USER}"@"${REMOTE_IP}" ip a | grep "${REMOTE_IP}"
    CHECK_RESULT $? 0 0
    # 服务端登客户端免密
    ssh "${REMOTE_USER}"@"${REMOTE_IP}" ssh root@"${ETS_LOCAL_IP}" ip a | grep "${ETS_LOCAL_IP}"
    CHECK_RESULT $? 0 0
    
    # 新增测试点1: 验证SSH密钥文件权限
    local ssh_dir_perm=$(stat -c %a /root/.ssh 2>/dev/null)
    CHECK_RESULT "$ssh_dir_perm" "700" 0 ".ssh目录权限不正确，应为700"
    local auth_keys_perm=$(stat -c %a /root/.ssh/authorized_keys 2>/dev/null)
    CHECK_RESULT "$auth_keys_perm" "600" 0 "authorized_keys文件权限不正确，应为600"
    
    # 新增测试点2: 测试SSH文件传输（scp）
    echo "test_content_$(date +%s)" > /tmp/ssh_test_file.txt
    scp /tmp/ssh_test_file.txt "${REMOTE_USER}"@"${REMOTE_IP}":/tmp/
    CHECK_RESULT $? 0 0 "scp上传文件失败"
    ssh "${REMOTE_USER}"@"${REMOTE_IP}" "test -f /tmp/ssh_test_file.txt && cat /tmp/ssh_test_file.txt" | grep -q "test_content"
    CHECK_RESULT $? 0 0 "远程文件内容验证失败"
    rm -f /tmp/ssh_test_file.txt
    SSH_CMD "rm -f /tmp/ssh_test_file.txt"
}

function post_test() {
    rm -rf /root/.ssh
    SSH_CMD "rm -rf /root/.ssh;rm -rf /root/sshcmd.sh;rm -rf /libs"
}

main "$@"
