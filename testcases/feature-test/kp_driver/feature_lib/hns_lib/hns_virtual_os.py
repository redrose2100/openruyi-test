#!/usr/bin/python3

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   Li Xiaodong
# @Contact   	:   lixiaodong67@huawei.com
# @Date      	:   2024-05-07 15:36:43
# @License   	:   Mulan PSL v2
# @Desc      	:   add lib for acc enviroment
#####################################



import re
import time
import os
import IPy
import random
import fileinput

from common_lib.testengine_lib.engine_utils import check_result
from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from common_lib.testengine_lib.engine_global import engine_global as eg
from test_config.global_config.global_config import lava_global
from kp_vm import VmVirsh
from feature_lib.hns_lib import hns_config_ethtool
from feature_lib.hns_lib import hns_config_basic
from test_config.feature_config.hns_config import hns_config
from feature_lib.hns_lib import hns_common
from feature_lib.hns_lib import hns_ko
from common_lib.base_lib.base_multi_mode_terminal import MultiModeTerminal


class VirtualMache(VmVirsh):
    """
    =====================================================================
    函数说明: 虚拟机操作
    修改时间: 2021/11/30 15:01:19
    作    者: lwx567203
    =====================================================================
    """
    def __init__(self, ifaces: list, terminal: str = "server", **kwargs):
        super().__init__(host_ip={"server": ssh.server_ip, "client": ssh.client_ip}.get(terminal), match=hns_config.VM_PROMPTER, timeout=300)
        self.keep_ssh_alive = True
        # 虚拟机业务口IP
        self.vm_ip = None
        # 虚拟机直通进去的网口IP
        self.vm_attch_ip = None
        self.vm_name = f"os_hns_vm{str(time.time()).split('.')[0][6:]}"
        # 需要直通的VF网口名
        self.attach_port = []
        self.bdf = []
        self.vm_exist = False
        self.information = ""
        self.ret_code = SUCCESS_CODE
        self.terminal.connect.use_write = False
        self.host_type = terminal
        self.match = hns_config.VM_PROMPTER
        # 适配OS，获取OS类型
        self.need_create_vm_list = []
        self.exist_vm_list = []
        self.vm_handler_list = []
        self.ssh_handle = None
        self.host_os_type = None
        self.virsh_start_time = None
        self.xml_path = hns_config.XML_PATCH
        self.img_path = hns_config.IMG_PATCH
        self.fd_path = hns_config.FD_PATCH
        self.aavmf_path = hns_config.AAVMF_PATCH
        self.vm_server_url = hns_config.VM_SERVER_URL
        self.vm_connect_status = False
        #scp用户密码
        self.scp_user = 'root'
        self.scp_pwd = 'root'
        for iface in ifaces:
            self.bdf.append(hns_config_ethtool.get_iface_bdf(iface, terminal))
        if kwargs.get("acc_bdfs"):
            self.bdf.extend(kwargs.get("acc_bdfs"))
        setattr(ssh, "vm_handler", self.terminal)

    def _keep_ssh_alive(self, terminal):
        """
        =====================================================================
        函数说明: 保持ssh链接活跃
        修改时间: 2021/11/30 15:30:19
        作    者: lwx567203
        =====================================================================
        """
        if hns_config.PLATFORM != hns_config.EnvPlatform.fpga:
            return SUCCESS_CODE

        while True:
            if int(time.time()) % 120 == 0:
                hns_common.exec_command(f"{terminal}_ftp", f"echo '{terminal} is starting vm...'")
            if not self.keep_ssh_alive:
                break
            time.sleep(1)

    def _mount_blank_volume(self):
        """
        =====================================================================
        修改时间: 2022/06/21 10:56:39
        作    者: lwx567203
        =====================================================================
        """
        self.virt_dir = f"/root/virt/volume/{int(time.time())}/"
        self.img_file = f"{self.virt_dir}/hns_mini.img"
        self.share_dir = f"/root/virt/share/{int(time.time())}"
        hns_common.exec_command(terminal=self.host_type, command=f"mkdir -p {self.virt_dir}")
        hns_common.exec_command(terminal=self.host_type, command=f"dd if=/dev/zero of={self.img_file} bs=1M count=50")
        hns_common.exec_command(terminal=self.host_type, command=f"mkfs.ext4 {self.img_file}")
        hns_common.exec_command(terminal=self.host_type, command=f"mkdir -p {self.share_dir}")
        hns_common.exec_command(terminal=self.host_type, command=f"mount -o loop {self.img_file} {self.share_dir}")
        info = hns_common.exec_command(terminal=self.host_type, command=f"mount | grep {self.share_dir}")
        if info in ("", b"", None):
            self._umount_volume()
            return FAILURE_CODE
        return SUCCESS_CODE

    def _umount_volume(self):
        """
        ============================================
        函数说明: 卸载卷
        修改时间: 2023-02-20 15:58:02
        作   者: lwx567203
        ============================================
        """
        if not self.volume_cmd:
            return SUCCESS_CODE

        hns_common.exec_command(terminal=self.host_type, command=f"umount {self.share_dir}")
        hns_common.exec_command(terminal=self.host_type, command=f"rm -rf {self.img_file}")
        hns_common.exec_command(terminal=self.host_type, command=f"rm -rf {self.share_dir}")
        hns_common.exec_command(terminal=self.host_type, command=f"rm -rf {self.virt_dir}")

    def is_ping_success(self, ip_addr: str) -> int:
        """
        ping某个ip校验是否能ping通
        :param ip_addr:目的ip地址
        :return:ping成功返回SUCCESS_CODE，ping失败返回FAILURE_CODE
        """
        ip_ping = {6: 'ping6', 4: 'ping'}
        ping = ip_ping.get(IPy.IP(ip_addr).version())
        command = f"{ping} {ip_addr} -c 5"
        info = self.send_command(command, expect=self.match)
        if "100% packet loss" in info or "Network is unreachable" in info:
            msg_center.error("ping %s fail" % ip_addr)
            return FAILURE_CODE
        return SUCCESS_CODE

    def install_tools(self, vm_name_list):
        """
        :param vm_name_list: 虚拟机名列表
        :return:
        """
        iperf_path = ssh.server.send_command("which iperf")
        check_result('no iperf in' not in iperf_path, True, fail_str="宿主机缺少iperf！")
        mz_path = ssh.server.send_command("which mz")
        check_result('no mz in' not in mz_path, True, fail_str="宿主机缺少mz！")
        mz_ldd = ssh.server.send_command("ldd `which mz`|grep libcli.so.1.9|awk '{print $3}'")
        busybox_path = ssh.server.send_command("which busybox")
        check_result('no busybox in' not in busybox_path, True, fail_str="宿主机缺少busybox！")
        sshpass_path = ssh.server.send_command("which sshpass")
        check_result('no sshpass in' not in sshpass_path, True, fail_str="宿主机缺少sshpass！")
        # 设置路由，从host向虚拟机拷贝工具
        if isinstance(vm_name_list, str):
            vm_name_list = [vm_name_list]
        # 设置虚拟机默认路由的命令，防止scp由于没有路由报错
        set_default = "ip route add default via 192.168.122.1"
        for vm_name in vm_name_list:
            self.send_command(set_default)
            hns_common.scp_to_remote("root", "root", self.vm_ip, iperf_path, iperf_path)
            hns_common.scp_to_remote("root", "root", self.vm_ip, mz_path, mz_path)
            hns_common.scp_to_remote("root", "root", self.vm_ip, mz_ldd, mz_ldd)
            hns_common.scp_to_remote("root", "root", self.vm_ip, busybox_path, busybox_path)
            hns_common.scp_to_remote("root", "root", self.vm_ip, sshpass_path, sshpass_path)
            self.send_command(f"chmod 777 {iperf_path}")
            self.send_command(f"chmod 777 {mz_path}")
            self.send_command(f"chmod 777 {busybox_path}")
            self.send_command(f"chmod 777 {sshpass_path}")



    def create(self):
        """
        =====================================================================
        函数说明: 启动虚拟机
        修改时间: 2021/11/30 15:26:42
        作    者: lwx567203
        =====================================================================
        """
        # 准备vfio驱动
        if hns_ko.insmod_vfio_ko(terminal=self.host_type) == FAILURE_CODE:
            return FAILURE_CODE
        # 创建虚拟机
        if self.create_vm(self.match, self.vm_name) == FAILURE_CODE:
            return FAILURE_CODE
        return SUCCESS_CODE

    def destroy(self, disable_vfs=True):
        """
        =====================================================================
        函数说明: 销毁虚拟机
        修改时间: 2021/11/30 15:44:29
        作    者: lwx567203
        =====================================================================
        """
        #判断虚拟机数量是否为0
        if ssh.server.send_command(cmd=f"virsh list |sed -n '3,$p' |awk '{{print $2}}'") == '':
            return SUCCESS_CODE
        # 先解绑VF直通
        self.os_detach_all_vf(self.bdf, self.match)
        # 再清理虚拟机
        self.os_delete_vm()
        # 默认清理VF
        if disable_vfs:
            hns_config_basic.delete_vf(list(hns_config.PF_MAP_VF.keys()), terminal=self.host_type)

    def prepare(self, iface, host_ip):
        """
        =====================================================================
        函数说明: 准备虚拟机
        修改时间: 2021/12/01 10:06:44
        作    者: lwx567203
        =====================================================================
        """
        if self.create() == FAILURE_CODE:
            return FAILURE_CODE
        self.send_command("uname -a")
        if hns_ko.insmod_hns_ko(terminal="vm_handler", roce_flage=0, check_dmesg=False) == FAILURE_CODE:
            return FAILURE_CODE
        # 直通前查询虚拟机当前网口总数
        vm_port_be = self.get_ifaces(self.match)
        # 做直通VF的操作
        if self.os_create_vm_hns_vf(self.vm_name, self.bdf) == FAILURE_CODE:
            return FAILURE_CODE
        time.sleep(5)
        # 加大串口输入字符限制
        self.send_command(cmd="stty rows 1000000 columns 1000", expect=self.match)
        # 修改日志打印级别
        self.send_command(cmd="echo 4 > /proc/sys/kernel/printk", expect=self.match)
        time.sleep(5)
        # 清理VM的dmesg打印，避免获取的网口信息有多余日志打印
        self.send_command(cmd="dmesg -C", expect=self.match)
        # 直通后再次查询网口总数，从而获取直通进去的网口名
        vm_port_af = self.get_ifaces(self.match)
        self.attach_port = [i for i in vm_port_af if i not in vm_port_be]
        # 给直通的IP配置和PF通网段的IP
        if self.ifconfig_iface_ip(iface=self.attach_port[0], host_ip=host_ip, match=self.match) == FAILURE_CODE:
            msg_center.info("直通的VF，配置与PF同网段IP失败")
            return FAILURE_CODE
        msg_center.info("虚拟机准备完毕，直通网口IP配置完成，通讯正常，可开始测试")

        self.vm_hot_key(hot_key="]")
        self.vm_connect_status = False
        return SUCCESS_CODE

    def send_command(self, cmd, **kwargs):
        """
        =====================================================================
        函数说明: 发送命令
        修改时间: 2021/12/06 14:05:28
        作    者: lwx567203
        =====================================================================
        """
        kwargs["result"] = False
        kwargs["expect"] = kwargs.get("expect", self.match)
        # 连接串口
        if self.vm_connect_status == False:
            self.console_vm()
            self.vm_connect_status = True
        self.information = super().send_command(cmd, wait_rsp_timeout=hns_config.VTIMEOUT, **kwargs)
        self.information = re.sub(".*init done", "", self.information)
        self.information = re.sub(f".*{cmd}", "", self.information)
        self.information = re.sub("\r.*\n", "\n", self.information)
        self.information = self.information.replace('\r\n', '\n').replace('\x1b[m', '').replace('\x1b[K', '').replace('\x1b[01;31m', '')
        msg_center.info(self.information.strip())
        return self.information.strip()

    def use_monitor(self, command="", into=False, close=False):
        """
        ============================================
        函数说明: 使用monitor界面
        修改时间: 2023-05-22 11:00:35
        作   者: lwx567203
        ============================================
        """
        if into:
            self.vm_handle.connect.control(hot_key="a")
            self.send_command("c", expect="(qemu).*?(qemu)")
            self.send_command("info pci", expect="(qemu)")
        if close:
            self.vm_handle.connect.control(hot_key="a")
            self.send_command("c")
            return ""
        result = self.send_command(command, expect=r"(qemu)")
        return result

    def scp_to_remote(self, host_ip, local_file, remote_file, timeout=20):
        """
        ============================================
        函数说明: scp拷贝文件到对端
        修改时间: 2023-05-09 15:16:29
        作   者: lwx567203
        ============================================
        """
        self.send_command(" sshpass -p  {} scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null {} {}@{}:{}".format(
            self.scp_pwd, local_file, self.scp_user, host_ip, remote_file))

    def scp_from_remote(self, host_ip, local_file, remote_file, timeout=20):
        """
        ============================================
        函数说明: 从对端scp文件到本端
        修改时间: 2023-05-09 15:25:46
        作   者: lwx567203
        ============================================
        """
        self.send_command(" sshpass -p  {} scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null {}@{}:{} {}".format(
            self.scp_pwd, self.scp_user, host_ip, remote_file, local_file))

    def create_vm(self, match: str = "estuary:", vm_name: str = "os_hns_vm"):
        """
        功能函数：OS 虚拟机配置IP等，完成创建后的准备工作
        :param match: expect需要捕捉的关键字
        :param vm_name: 需要创建虚拟机的名字
        :return: 返回Ture or Fail
        """
        if self.os_create_vm([vm_name]) == FAILURE_CODE:
            return FAILURE_CODE
        self.console_vm()
        self.vm_connect_status = True
        self.get_vm_os_type()
        host_ip = self.os_get_bridge_ip()
        # ubuntu vm启动完毕有ip地址，而centos vm启动完毕默认没有ip地址
        # vm有ip地址时直接获取vm ip，没有ip地址时配置随机ip
        vm_ip_info = self.send_command(cmd="ip a |grep -v '127.0.0.1'", expect=match)
        vm_ip_get = re.findall(r"(\d+.\d+.\d+.\d+)/\d+", vm_ip_info)
        if not vm_ip_get:
            host_ip_front = re.findall(r"(\d+.\d+.\d+.)", host_ip)[0]
            host_ip_last = host_ip.split(".")[-1]
            while (1):
                vm_ip_last = random.randint(1, 254)
                if vm_ip_last != int(host_ip_last):
                    break
            self.vm_ip = host_ip_front + str(vm_ip_last)
            vm_net_name = 'lo'
            while vm_net_name == 'lo':
                vm_net_str = self.send_command(cmd=f"ip a |grep UP |grep -v lo", expect=match)
                vm_net = vm_net_str.split(":")[1]
                vm_net_name = vm_net.strip()
                time.sleep(2)
            self.send_command(cmd=f"ip addr add {self.vm_ip}/24 dev {vm_net_name}", expect=match)
            self.send_command(cmd=f"ip link set {vm_net_name} up", expect=match)
            self.send_command(cmd=f"ifconfig {vm_net_name} hw ether 3c`echo $RANDOM|md5sum|sed 's/../&:/g'|cut -c 3-17`", expect=match)
        else:
            self.vm_ip = self.get_vm_ip()
        vm_kernel_ver = self.send_command(cmd="uname -r", expect=match)
        host_kernel_ver = ssh.server.send_command(cmd="uname -r")
        msg_center.info(f"虚拟机{vm_name} ip地址: {self.vm_ip}，宿主机ip地址: {host_ip}, "
                        f"虚拟机{vm_name} 内核版本: {vm_kernel_ver}， 宿主机内核版本: {host_kernel_ver}")
        # vm启动过程中可能有某些fail、error信息，清除掉以免影响用例测试结果的判断
        self.send_command(cmd="dmesg -c > /dev/null", expect=match)
        #安装iperf、mz等工具
        self.install_tools(self.vm_name)
        #关闭防火墙
        self.send_command('systemctl stop firewalld.service')
        # 新增文件路径
        self.send_command(f'mkdir -p {eg.project.base_dir_path}')
        if self.vm_ip:
            msg_center.info("！！！ 虚拟机VM环境准备OK ！！！")
            return SUCCESS_CODE
        else:
            return FAILURE_CODE

    def os_create_vm(self, vm_name_list):
        """
        商用OS项目创建虚拟机的函数
        :param vm_name_list: 想要创建虚拟机的名字列表
        :param expect: 虚拟机shell中的提示符
        :return: vm操作的句柄
        """
        self.host_os_type = lava_global.test_os
        if not isinstance(vm_name_list, list):
            msg_center.error("入参vm_name_list只支持list类型输入")
            return FAILURE_CODE
        # ubuntu使用自动化镜像制作的image，vm启动之后自动运行升级脚本，耗时较长
        # centos使用原生iso制作的image，vm启动较快
        if self.get_vm_os_type == "ubuntu":
            self.virsh_start_time = 240
        else:
            self.virsh_start_time = 200

        if len(ssh.server.send_command("lsmod | grep hclgevf")) == 0:
            ssh.server.send_command("modprobe hclgevf")
            check_result(ssh.server.ret_code, SUCCESS_CODE, pass_str="modprobe hclgevf 成功",
                         fail_str="modprobe hclgevf 失败")

        if self.host_os_type == "ubuntu" or self.host_os_type == "centos":
            ret_os = ssh.server.send_command(cmd="cat /etc/os-release |sed -n '2p'",
                                                        disable_show_and_log=True)
            os_version = ret_os.split('="')[1]
            os_version = os_version.split(' ')[0].strip()
            self.vm_os_type = self.host_os_type + "_" + os_version
            msg_center.info(f"**** hns vm支持宿主机和虚拟机 同OS 同kernel，当前OS:{self.vm_os_type} ****")
        else:
            check_result(FAILURE_CODE, SUCCESS_CODE, fail_str="尚未适配该OS！")

        # 创建前查询是否已经存在同名虚拟机，存在则不创建
        for vm_name in vm_name_list:
            self.os_check_vm_exist(vm_name)
        if self.exist_vm_list:
            msg_center.info(f"****** 无需新建的虚拟机有：{self.exist_vm_list} ******")
        if self.need_create_vm_list:
            msg_center.info(f"****** 待新建的虚拟机有：{self.need_create_vm_list} ******")
        # 创建虚拟机
        if self.need_create_vm_list:
            msg_center.info(f"开始创建虚拟机 {self.need_create_vm_list}")
            for vm_name in self.need_create_vm_list:
                self.os_vm_prepare()
                self.os_vm_xml_prepare(vm_name)
                msg_center.info(f"***** define & start 虚拟机，此步骤等待约{self.virsh_start_time}s，请勿中断！！ *****")
                ssh.server.send_command(f"virsh define {self.xml_path}{vm_name}.xml")
                ssh.server.send_command(f"virsh start {vm_name}")
                time.sleep(self.virsh_start_time)
                # 查询是否创建成功
                get_vm = self.list_vms()
                if get_vm[vm_name] == "running":
                    msg_center.info(f"***** !!! VM{vm_name} START OK !!! *****")
                else:
                    msg_center.info(f"***** !!! VM{vm_name} START FIAL !!! PLEASE CHECK *****")
                    return FAILURE_CODE
        return SUCCESS_CODE

    def os_check_vm_exist(self, vm_name):
        """
        检查虚拟机是否已经存在，不存在则创建
        """
        ssh.server.send_command("which virsh")
        if ssh.server.ret_code != 0:
            self.need_create_vm_list.append(vm_name)
            msg_center.info(f"当前环境virsh工具未安装，虚拟机 {vm_name} 待创建")

        ssh.server.send_command("systemctl status libvirtd |grep running")
        if ssh.server.ret_code != 0:
            msg_center.info("libvirtd.service not running, need active")
            ssh.server.send_command("systemctl start libvirtd.service")
            time.sleep(1)

        ssh.server.send_command(f"virsh list --all |grep -w {vm_name}")
        if ssh.server.ret_code == 0:
            vm_status_cmd = f"virsh list --all |grep -w {vm_name} |awk '{{print $(NF-1)\" \"$NF}}'"
            vm_status = ssh.server.send_command(vm_status_cmd)
            if "running" not in vm_status:
                if "shut off" not in vm_status:
                    ssh.server.send_command(f"virsh destroy {vm_name}")
                    time.sleep(3)
                msg_center.info(f"***** start 虚拟机，此步骤等待约{self.virsh_start_time}s，请勿中断！！ *****")
                ssh.server.send_command(f"virsh start {vm_name}")
                if ssh.server.ret_code == 0:
                    time.sleep(self.virsh_start_time)
                    self.exist_vm_list.append(vm_name)
                    msg_center.info(f"虚拟机 {vm_name} 已存在，已 start OK!")
                else:
                    ssh.server.send_command(f"virsh destroy {vm_name}")
                    ssh.server.send_command(f"virsh undefine --nvram {vm_name}")
                    self.need_create_vm_list.append(vm_name)
                    msg_center.info(f"虚拟机 {vm_name} 待创建")
            else:
                self.exist_vm_list.append(vm_name)
                msg_center.info(f"虚拟机 {vm_name} 已存在，且为 running 状态!")
        else:
            self.need_create_vm_list.append(vm_name)
            msg_center.info(f"虚拟机 {vm_name} 待创建")

    def os_vm_prepare(self):
        """
        安装虚拟机需要的工具等前置准备工作
        """
        if not os.path.exists(self.img_path):
            ssh.server.send_command(f"mkdir -p {self.img_path}")

        if not os.path.exists(self.aavmf_path):
            ssh.server.send_command(f"mkdir -p {self.aavmf_path}")
        # 源下载vm的依赖库
        if self.host_os_type == "ubuntu":
            kvm_install = ["qemu-kvm", "libvirt-clients", "libvirt-bin", "virtinst", "virt-viewer", "cpu-checker",
                           "virt-manager", "bridge-utils", "expect"]
        elif self.host_os_type == "centos":
            kvm_install = ["qemu-kvm", "libvirt", "libvirt-python", "virt-install", "libguestfs-tools",
                           "virt-manager", "bridge-utils", "expect"]
        else:
            check_result(SUCCESS_CODE, FAILURE_CODE, fail_str="尚未适配该分支")
        ret = self.os_install_pkg(kvm_install)
        check_result(ret, SUCCESS_CODE, pass_str="工具安装完毕！", fail_str="工具安装异常！")

        # centos环境下virsh define vm时上报Failed to connect socket to '/var/run/libvirt/libvirt-sock'错误的解决方法
        if self.host_os_type == "centos":
            ssh.server.send_command("groupadd libvirtd")
            ssh.server.send_command("sudo usermod -a -G libvirtd $USER")
            line_original = '#unix_sock_group = "libvirt"'
            line_to_replace = 'unix_sock_group = "libvirtd"'
            for line in fileinput.input("/etc/libvirt/libvirtd.conf", inplace=1):
                line = line.replace(f"{line_original}", f"{line_to_replace}")
                print(line, end="")
            ssh.server.send_command("cat /etc/libvirt/libvirtd.conf |grep unix_sock_group")

            file_to_write = "/etc/polkit-1/local
            data = ["[libvirtd group Management Access]", "Identity=unix-group:libvirtd",
                    "Action=org.libvirt.unix.manage", "ResultAny=yes", "ResultInactive=yes", "ResultActive=yes"]
            with open(f"{file_to_write}", "w") as f:
                for i in data:
                    i = i + "\n"
                    f.write(i)
            ssh.server.send_command(f"cat {file_to_write}")
            ssh.server.send_command("service libvirtd restart")

    def os_vm_xml_prepare(self, vm_name):
        """
        下载虚拟机的XML的配置文件以及修改对应的XML
        """
        # 从服务器下载vm启动所需的image、xml等文件
        wget_cmd = [
            f"wget -c -q -t 2 -T 5 --no-check-certificate -P {self.xml_path} {self.vm_server_url}{self.vm_os_type}.xml",
            f"wget -c -q -t 2 -T 5 --no-check-certificate -P {self.fd_path} {self.vm_server_url}{self.vm_os_type}.fd",
            f"wget -c -q -t 20 -T 5 --no-check-certificate -P {self.img_path} {self.vm_server_url}{self.vm_os_type}.img",
            f"wget -c -q -t 2 -T 5 --no-check-certificate -P {self.aavmf_path} {self.vm_server_url}AAVMF_VARS.fd",
            f"wget -c -q -t 2 -T 5 --no-check-certificate -P {self.aavmf_path} {self.vm_server_url}AAVMF_CODE.fd"
        ]
        for cmd in wget_cmd:
            ssh.server.send_command(cmd=cmd, disable_show_and_log=True)

        # 修改文件信息以便启动vm
        uuid = ssh.server.send_command("uuidgen")
        mac_cmd = r"dd if=/dev/urandom count=1 2>/dev/null | md5sum | sed 's/^\(.\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\\14:\\2:\\3:\\4:\\5:\\6/g'"
        vm_mac = ssh.server.send_command(cmd=mac_cmd, disable_show_and_log=True)
        ssh.server.send_command(cmd=f"cp {self.img_path}{self.vm_os_type}.img  {self.img_path}{vm_name}.img",
                                        disable_show_and_log=True)
        ssh.server.send_command(cmd=f"cp {self.xml_path}{self.vm_os_type}.xml {self.xml_path}{vm_name}.xml",
                                        disable_show_and_log=True)
        ssh.server.send_command(cmd=f"cp {self.fd_path}{self.vm_os_type}.fd {self.fd_path}{vm_name}_VARS.fd",
                                        disable_show_and_log=True)
        ssh.server.send_command(
            cmd=f"sed -i \"/<name>/{{s/>[^<]*</>{vm_name}</}}\" {self.xml_path}{vm_name}.xml",
            disable_show_and_log=True)
        ssh.server.send_command(
            cmd=f"sed -i \"/<uuid>/{{s/>[^<]*</>{uuid}</}}\" {self.xml_path}{vm_name}.xml",
            disable_show_and_log=True)
        ssh.server.send_command(
            cmd=f"sed -i \"/<mac/s/'[^']*'/'{vm_mac}'/\" {self.xml_path}{vm_name}.xml",
            disable_show_and_log=True)
        ssh.server.send_command(
            cmd=f"sed -i \"/<source file/s#'[^']*'#'{self.img_path}{vm_name}.img'#\" {self.xml_path}{vm_name}.xml",
            disable_show_and_log=True)
        ssh.server.send_command(
            cmd=f"sed -i \"/<nvram>/{{s/{self.host_os_type}_kvm_VARS.fd/{vm_name}_VARS.fd/}}\" {self.xml_path}{vm_name}.xml",
            disable_show_and_log=True)
        ssh.server.send_command(cmd=f"cat {self.xml_path}{vm_name}.xml", disable_show_and_log=True)

    @staticmethod
    def os_install_pkg(tool_packages, exec_times=1):
        """
        Discription: 商用OS项目下载源工具的命令
        :param tool_packages: 包名
        :param exec_times: 执行次数
        :return:
        """
        os_type = lava_global.test_os
        if os_type == "ubuntu":
            fe_cmd = "DEBIAN_FRONTEND=noninteractive apt-get install -q -y"
        elif os_type == "centos" or os_type == "openeuler" or os_type == "redhat":
            fe_cmd = "yum -e 0 -y install"
        elif os_type == "suse" or os_type == "opensuse":
            fe_cmd = "zypper install -y"
        elif os_type == "debian":
            ssh.server.send_command("apt remove libgcc-8-dev -y")
            fe_cmd = "DEBIAN_FRONTEND=noninteractive apt-get install -q -y"
        elif os_type == "fedora":
            fe_cmd = "dnf -e 0 -y install"
        else:
            check_result(FAILURE_CODE, SUCCESS_CODE, fail_str="尚未适配该OS！")

        for tool in tool_packages:
            ssh.server.send_command(cmd=f"which {tool}", disable_show_and_log=True)
            if ssh.server.ret_code != 0:
                install_cmd = fe_cmd + " " + tool
                for times in range(exec_times):
                    ssh.server.send_command(cmd=install_cmd, disable_show_and_log=True)
            else:
                msg_center.info(f"{tool} 已存在，无需安装")
        return SUCCESS_CODE

    @staticmethod
    def os_get_bridge_ip():
        """
        获取宿主机上网桥ip地址，虚拟机默认网口需配这个网桥段IP才可与宿主机通讯
        :return: 宿主机网桥网口ip地址
        """
        host_ip_info = ssh.server.send_command(f"ip a |grep virbr0")
        host_ip = re.findall(r"(\d+.\d+.\d+.\d+)/\d+", host_ip_info)
        return host_ip[0]

    @staticmethod
    def os_create_vm_hns_vf(vm_name, vf_pci_list):
        """
        商用OS项目 配置hns vf直通到vm中，函数内已有延时
        :param vm_name: 虚拟机名
        :param vf_pci_list: 待直通的vf的pci编号，list类型
        :return:
        """
        for index, vf_pci in enumerate(vf_pci_list):
            os_vf_xml_dir = f"/home/os_hns_vf_{vm_name}_{index}.xml"
            vf_pci = vf_pci[5:]
            msg_center.info(f"配置vf {vf_pci} 直通到虚拟机 {vm_name} 中")
            data = f"\"<hostdev mode='subsystem' type='pci' managed='yes'>,\\n        <source>,\\n        <address domain='0x0000' bus='0x{vf_pci[0:2]}' slot='0x{vf_pci[3:5]}' function='0x{vf_pci[-1]}'/>,\\n        </source>,\\n</hostdev>\""
            ssh.server.send_command(f"echo ${data} > {os_vf_xml_dir}")
            ssh.server.send_command(f"cat {os_vf_xml_dir}")

            ssh.server.send_command(f"virsh attach-device {vm_name} {os_vf_xml_dir}")
            if ssh.server.ret_code != 0:
                msg_center.info(f"配置vf {vf_pci} 直通到虚拟机 {vm_name} 失败。")
                return FAILURE_CODE
            else:
                msg_center.info(f"配置vf {vf_pci} 直通到虚拟机 {vm_name} 完毕。")
        # 延时一段时间，确保vm内直通vf设备生成OK
        time.sleep(15)

        return SUCCESS_CODE

    def os_detach_all_vf(self, vf_pci_list, match):
        """
        detach vf，函数内已有延时，能够确保detach OK
        :param vm: 虚拟机vm句柄
        :param vf_pci_list: 已直通的vf的pci编号，list类型
        :param match: vm内匹配的提示符
        :return:
        """
        for index in range(len(vf_pci_list)):
            os_vf_xml_dir = f"/home/os_hns_vf_{self.vm_name}_{index}.xml"
            ret_code = self.detach_device(os_vf_xml_dir)
            check_result(ret_code, SUCCESS_CODE, pass_str=f"取消vf {vf_pci_list[index]} 直通成功",
                         fail_str=f"取消vf {vf_pci_list[index]}直通失败")
        time.sleep(15)
        self.send_command(cmd="rm -rf /home/vf_cnt_after.log", expect=match)
        return SUCCESS_CODE

    @staticmethod
    def os_delete_vm():
        """
        商用OS项目 销毁虚拟机
        """
        vf_file_info = ssh.server.send_command("ls -l /home |grep 'os_hns_vf_' |awk '{{print $NF}}'")
        vf_file_list = vf_file_info.split()
        msg_center.info(f"待 detach 的 vf xml 文件有：{vf_file_list}")

        vm_to_destroy = []
        ssh.server.send_command(
            cmd=f"virsh list |sed -n '3,$p' |awk '{{print $2}}' > /home/vm_to_delete.log")
        info = ssh.server.send_command("cat /home/vm_to_delete.log")
        if info:
            vm_list = info.splitlines()
            for vm in vm_list:
                vm_tmp = vm.strip()
                vm_to_destroy.append(vm_tmp)
            msg_center.info(f"待销毁的虚拟机有: {vm_to_destroy}")

            for vm in vm_to_destroy:
                if vf_file_list:
                    for vf_file in vf_file_list:
                        vf_file = vf_file.strip()
                        ssh.server.send_command(f"virsh detach-device {vm} /home/{vf_file}",
                                                           disable_show_and_log=True)
                ssh.server.send_command(f"virsh destroy {vm}")
                ssh.server.send_command(f"virsh undefine --nvram {vm}")

        ssh.server.send_command("rm -rf /home/vm_to_delete.log")
        ssh.server.send_command("rm -rf /home/os_hns_vf_*")
        return

    def get_ifaces(self, match):
        """
        =====================================================================
        函数说明: 获取vm中网口名
        修改时间: 2021/12/01 15:39:24
        作    者: lwx567203
        =====================================================================
        """
        result = self.send_command(cmd="ls --color=never /sys/class/net", expect=match)
        result = re.sub(r" +", " ", result)
        return result.strip().split()

    def ifconfig_iface_ip(self, iface, host_ip, match):
        """
        =====================================================================
        函数说明: NA
        修改时间: 2021/11/30 15:46:58
        作    者: lwx567203
        =====================================================================
        """
        # 配置ip并检查
        if iface not in self.attach_port:
            msg_center.error(f"虚拟机中没有{iface}网口")
            return FAILURE_CODE
        self.vm_attch_ip = hns_config_basic.get_same_network_addr(address=host_ip, netmask=24)
        # 配置直通网口的IP与PF网口IP同网段
        self.send_command(cmd=f"ip addr add {self.vm_attch_ip}/24 dev {iface}", expect=match)
        self.send_command(cmd=f"ip link set {iface} up", expect=match)
        self.send_command(cmd=f"ifconfig {iface} hw ether 3c`echo $RANDOM|md5sum|sed 's/../&:/g'|cut -c 3-17`", expect=match)
        # ping检查是否能够正常通讯
        cmd = f"ping {host_ip} -c 3 |grep ' 0% packet loss'"
        self.send_command(cmd)
        if self.information != "":
            return SUCCESS_CODE
        else:
            return FAILURE_CODE
