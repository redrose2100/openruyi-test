#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   doraemon2020
#@Contact   	:   xcl_job@163.com
#@Date      	:   2020-11-20
#@License   	:   Mulan PSL v2
#@Desc      	:   command test openmpi cluster
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # 本用例必须把节点主机名改成 node1/node2：MPI_Get_processor_name() 返回的正是主机名，
    # run_test 里 "processor node1/node2" 的断言完全依赖它，所以不能像其它用例那样迁到 NODE2。
    # 但这些改动一旦残留，NODE1 的主机名/SSH 凭据/防火墙规则/防火墙服务状态都会与测试前不一致，
    # 直接影响同一轮中的其它用例。因此这里全部改成“先备份、后还原”。
    ORIG_HOSTNAME=$(hostname)
    ORIG_FIREWALLD_ACTIVE=$(systemctl is-active firewalld 2>/dev/null)
    BAK_DIR="/tmp/openmpi_bak"
    rm -rf "${BAK_DIR}"
    mkdir -p "${BAK_DIR}"
    # 用 iptables-save 备份、iptables-restore 还原，替代原来不可逆的 iptables -F
    iptables-save >"${BAK_DIR}/iptables.bak" 2>/dev/null
    cp -a /etc/hosts "${BAK_DIR}/hosts.bak"
    [ -f /etc/exports ] && cp -a /etc/exports "${BAK_DIR}/exports.bak"
    # 备份本机 SSH 凭据（含既有密钥与 known_hosts），用例结束原样恢复
    [ -d /root/.ssh ] && cp -a /root/.ssh "${BAK_DIR}/ssh.bak"
    # NODE2 侧做同样的备份；主机名写入 NODE2 本地文件，post_test 用 $(cat ...) 让远端自行求值，
    # 避免在 NODE1 侧解析 SSH 输出（输出里可能混有 spawn/登录提示等噪声）。
    SSH_CMD "mkdir -p ${BAK_DIR};
    cp -a /etc/hosts ${BAK_DIR}/hosts.bak;
    [ -d /root/.ssh ] && cp -a /root/.ssh ${BAK_DIR}/ssh.bak;
    hostname > ${BAK_DIR}/hostname" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    # 备份已落地就能安全还原，后续即使中途 exit 也要走完整恢复流程
    PREPARE_DONE=1
    DNF_INSTALL "openmpi openmpi-devel nfs-utils nfs-utils-devel hostname"
    SSH_CMD "dnf -y install openmpi openmpi-devel nfs-utils nfs-utils-devel hostname" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    hostname node1
    {
        echo "${NODE1_IPV4} node1"
        echo "${NODE2_IPV4} node2"
    } >>/etc/hosts
    SSH_CMD "
    hostname node2;
    echo '${NODE1_IPV4} node1\n${NODE2_IPV4} node2' >> /etc/hosts;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    ping -c 3 node2 || exit 1
    SSH_CMD "ping -c 3 node1;rm -rf ~/.ssh/*;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" || exit 1
    rm -rf ~/.ssh/*
    ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa
    test -f ~/.ssh/id_rsa.pub || LOG_ERROR "'~/.ssh/id_rsa.pub': No such file"
    expect -c"
        log_file testlog
        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub node2
        expect {
                \"*)?\"  {
                        send \"yes\\r\"
                        exp_continue
                }
                \"*assword:*\"  {
                        send \"${NODE2_PASSWORD}\\r\"
                        exp_continue
                }
    }
    "
    rm -rf /home/mpi_volumn && mkdir -p /home/mpi_volumn
    # 追加而非覆盖 /etc/exports，避免冲掉环境上已有的共享配置（原内容已在 pre_test 备份）
    grep -q "/home/mpi_volumn" /etc/exports || echo "/home/mpi_volumn *(rw,sync,no_root_squash,no_subtree_check,insecure)" >>/etc/exports
    exportfs -avr
    systemctl start nfs
    # stop 只是临时关闭，post_test 会按备份的 active 状态恢复；
    # 原来直接 stop 后不恢复，会让后续用例面对一个与初始状态不同的 NODE1。
    systemctl stop firewalld
    # 不再使用 iptables -F：那会清空环境上所有既有规则且无法恢复。
    # MPI 跨节点只需放通本机与 NODE2 之间的流量，因此改为按需放行。
    iptables -I INPUT -s "${NODE2_IPV4}" -j ACCEPT 2>/dev/null
    iptables -I OUTPUT -d "${NODE2_IPV4}" -j ACCEPT 2>/dev/null
    SLEEP_WAIT 3
    SSH_CMD "
    rm -rf /home/mpi_volumn && mkdir -p /home/mpi_volumn;
    systemctl stop firewalld;
    mount -t nfs ${NODE1_IPV4}:/home/mpi_volumn /home/mpi_volumn;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    touch /home/mpi_volumn/hello_world
    SSH_CMD "test -f /home/mpi_volumn/hello_world || exit 1;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    cp -rf ./test.c /home/mpi_volumn/
    casepath=$(
        cd "$(dirname "$0")" || exit 1
        pwd
    )
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /home/mpi_volumn/ || exit 1
    mpicc test.c -o testfile
    test -f testfile
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root -np 2 -host node1,node2 ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    printf "node1 slots=2\nnode2 slots=2" >./myhostfile
    test "$(mpirun --allow-run-as-root --oversubscribe -np 4 -hostfile myhostfile ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 4
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --oversubscribe -np 2 -H node1,node2 -npersocket 1 ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --oversubscribe -np 2 -H node1,node2 -npernode 1 ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --oversubscribe -np 2 -H node1,node2 -pernode ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --oversubscribe -np 4 --byslot --hostfile myhostfile ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 4
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --oversubscribe --mca rmaps_base_schedule_policy slot -np 4 ./testfile 2>&1 |
        grep -c "processor node1")" -eq 4
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --oversubscribe -np 4 --bynode --hostfile myhostfile ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 4
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --oversubscribe --mca rmaps_base_schedule_policy node -np 4 \
        ./testfile 2>&1 | grep -c "processor node1")" -eq 4
    CHECK_RESULT $?
    mkdir /tmp/bak_mpi_volumn
    cp -r /home/mpi_volumn/testfile /tmp/bak_mpi_volumn
    test "$(mpirun --allow-run-as-root --oversubscribe -np 4 --wdir /tmp/bak_mpi_volumn \
        ./testfile 2>&1 | grep -c "processor node1")" -eq 4
    CHECK_RESULT $?
    mpirun --allow-run-as-root -d ./testfile 2>&1 | grep "MPIR_debug_state"
    CHECK_RESULT $?
    mpirun --allow-run-as-root -np 4 --report-bindings --map-by core --bind-to core ./testfile 2>&1 | grep -i "core"
    CHECK_RESULT $?
    printf "rank 0=node1 slot=0\nrank 1=node2 slot=0" >./myrankfile
    test "$(mpirun --allow-run-as-root --oversubscribe -H node1,node2 -rf myrankfile ./testfile 2>&1 |
        grep -c -e "processor node1" -e "processor node2")" -eq 2
    CHECK_RESULT $?
    test "$(mpirun --allow-run-as-root --prefix /usr -H node2 ./testfile 2>&1 |
        grep -c "processor node2")" -eq 1
    CHECK_RESULT $?
    if [ -n "$PMIX_SERVER_URI" ]; then
        LOG_INFO "PMIX_SERVER_URI is set: $PMIX_SERVER_URI"
        ompi-clean -v 2>&1 | grep "cleaning session"
        CHECK_RESULT $?
        ompi-clean -d 2>&1 | grep 'user(pid)=0'
        CHECK_RESULT $?
    else
        LOG_INFO "PMIX_SERVER_URI not set, skipping ompi-clean test."
    fi
    if rpm -ql openmpi | grep bin | grep "ompi-dvm"; then
        ompi-dvm --allow-run-as-root -report-uri dvm_uri >result 2>&1 &
        SLEEP_WAIT 1
        grep "${NODE1_IPV4}" dvm_uri
        CHECK_RESULT $?
    fi
    ompi-server -d >./ompi-server.result 2>&1 &
    SLEEP_WAIT 1
    grep "up and running" ./ompi-server.result
    CHECK_RESULT $?
    ompi-server -r server_uri
    SLEEP_WAIT 1
    grep "${NODE1_IPV4}" server_uri
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -9 ompi
    # casepath 在 pre_test 末尾才赋值，pre_test 提前退出时它是空的；
    # 直接 cd "" 会让 post_test 在这里就中断，后面的恢复全部不执行。
    [ -n "${casepath}" ] && cd "${casepath}"
    # 准备阶段就没走完时，BAK_DIR 里可能没有可用备份，此时只做无条件的清理不做事后恢复，
    # 避免用空值覆盖环境（post_test 由 trap 保证一定执行，不能假设 pre_test 已成功）。
    if [ "${PREPARE_DONE:-0}" != "1" ]; then
        LOG_WARN "Test environment was not prepared, skip state restore."
        rm -rf /home/mpi_volumn /tmp/bak_mpi_volumn
        DNF_REMOVE "$@"
        LOG_INFO "Finish restoring the test environment."
        return 0
    fi
    # NODE2 侧恢复：主机名写回、/etc/hosts 回滚、取消 NFS 挂载、还原 SSH 凭据、清理备份
    SSH_CMD "umount -f /home/mpi_volumn 2>/dev/null;
    [ -f ${BAK_DIR}/hostname ] && hostname \$(cat ${BAK_DIR}/hostname);
    [ -f ${BAK_DIR}/hosts.bak ] && cp -a ${BAK_DIR}/hosts.bak /etc/hosts;
    if [ -d ${BAK_DIR}/ssh.bak ]; then rm -rf /root/.ssh && cp -a ${BAK_DIR}/ssh.bak /root/.ssh; fi;
    rm -rf /home/mpi_volumn ${BAK_DIR}
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    # NODE1 侧恢复主机名：不改回去会让后续用例看到错误的主机名
    [ -n "${ORIG_HOSTNAME}" ] && hostname "${ORIG_HOSTNAME}"
    # 只在确实备份成功时才回滚，避免用不存在/空文件覆盖
    [ -f "${BAK_DIR}/hosts.bak" ] && cp -a "${BAK_DIR}/hosts.bak" /etc/hosts
    if [ -f "${BAK_DIR}/exports.bak" ]; then
        cp -a "${BAK_DIR}/exports.bak" /etc/exports
        exportfs -ra
    else
        sed -i '\#^/home/mpi_volumn #d' /etc/exports 2>/dev/null
        exportfs -ra
    fi
    # 恢复 SSH 凭据：原来直接 rm 掉，等于把环境上原本的密钥删了。
    # 只有备份确实存在时才先删再还原，避免备份缺失时把 /root/.ssh 删成空的。
    if [ -d "${BAK_DIR}/ssh.bak" ]; then
        rm -rf /root/.ssh
        cp -a "${BAK_DIR}/ssh.bak" /root/.ssh
    fi
    # 用备份整体还原 iptables，替代不可逆的 iptables -F
    if [ -s "${BAK_DIR}/iptables.bak" ]; then
        iptables-restore <"${BAK_DIR}/iptables.bak" 2>/dev/null ||
            LOG_WARN "Failed to restore iptables rules from backup."
    else
        # 备份没拿到时（环境上可能没有 iptables-save），退化为按原参数删除本次新增的规则
        LOG_WARN "No iptables backup found, remove the rules added by this testcase instead."
        iptables -D INPUT -s "${NODE2_IPV4}" -j ACCEPT 2>/dev/null
        iptables -D OUTPUT -d "${NODE2_IPV4}" -j ACCEPT 2>/dev/null
    fi
    # 恢复 firewalld 的原始 active 状态（原来 stop 之后从不恢复）
    if [ "${ORIG_FIREWALLD_ACTIVE}" = "active" ]; then
        systemctl start firewalld ||
            LOG_WARN "Failed to restart firewalld to its original state."
    fi
    rm -rf /home/mpi_volumn ./*log /tmp/bak_mpi_volumn "${BAK_DIR}"
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
