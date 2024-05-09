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
import concurrent.futures

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from common_lib.testengine_lib.engine_global import engine_global as eg
from test_config.global_config import global_config
from kp_vm import VmQemu
from feature_lib.hns_lib import hns_config_ethtool
from feature_lib.hns_lib import hns_config_basic
from test_config.feature_config.hns_config import hns_config
from feature_lib.hns_lib import hns_common
from feature_lib.hns_lib import hns_ko


class VirtualMache(VmQemu):
    """
    =====================================================================
    函数说明: 虚拟机操作
    修改时间: 2021/11/30 15:01:19
    作    者: lwx567203
    =====================================================================
    """
    img_num = 1

    def __init__(self, ifaces: list, terminal: str = "server", **kwargs):
        super().__init__(bdf=[], host_ip={"server": ssh.server_ip, "client": ssh.client_ip}.get(terminal), timeout=300, host_match=hns_config.HOST_PROMPTER)
        self.keep_ssh_alive = True
        self.vm_ip = None
        self.ifaces = []
        self.vm_exist = False
        self.information = ""
        self.vm_handle.connect.use_write = False
        self.host_type = terminal
        self.match = hns_config.VM_PROMPTER
        self._image_version = hns_config.PLINTH_NAME
        for iface in ifaces:
            self.bdf.append(hns_config_ethtool.get_iface_bdf(iface, terminal))
        if kwargs.get("acc_bdfs"):
            self.bdf.extend(kwargs.get("acc_bdfs"))

    def _keep_ssh_alive(self, terminal):
        """
        =====================================================================
        函数说明: 保持ssh链接活跃
        修改时间: 2021/11/30 15:30:19
        作    者: lwx567203
        =====================================================================
        """
        if global_config.lava_global.run_env_type == global_config.project_global.d06:
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
        # D06环境
        if global_config.lava_global.run_env_type == global_config.project_global.d06:
            return SUCCESS_CODE
        # 非5.10内核环境
        if hns_config.IMAGE_VERSION.get(self.host_type) != hns_config.BIGDIPPER_NAME:
            return SUCCESS_CODE

        hns_common.exec_command(terminal=self.host_type, command=f"umount {self.share_dir}")
        hns_common.exec_command(terminal=self.host_type, command=f"rm -rf {self.img_file}")
        hns_common.exec_command(terminal=self.host_type, command=f"rm -rf {self.share_dir}")
        hns_common.exec_command(terminal=self.host_type, command=f"rm -rf {self.virt_dir}")

    def prepare_fpga_510_env(self):
        """
        ============================================
        函数说明: 准备5.10版本的配置
        修改时间: 2023-02-20 15:40:36
        作   者: lwx567203
        ============================================
        """
        self.volume_cmd = ""
        # D06环境
        if global_config.lava_global.run_env_type == global_config.project_global.d06:
            return SUCCESS_CODE
        # 非5.10内核环境
        if hns_config.IMAGE_VERSION.get(self.host_type) != hns_config.BIGDIPPER_NAME:
            return SUCCESS_CODE

        # 挂载空白卷
        if self._mount_blank_volume() == FAILURE_CODE:
            return FAILURE_CODE

        # 拷贝增量包到空白卷中
        for pkg in hns_config.tar_pkg:
            hns_common.exec_command(terminal=self.host_type, command=f"cp -a {pkg} {self.share_dir}")

        self.volume_cmd = f"-drive file={self.img_file},if=virtio"
        VirtualMache.match = self.match
        return SUCCESS_CODE


    def create_command(self, start_cmd: str = None, mem: str = '2G', smp: str = '1', open_iommu: bool = False):
        """
        =====================================================================
        修改时间: 2021/12/07 15:05:42
        作    者: lwx567203
        =====================================================================
        """
        super().create_command(start_cmd, mem, smp, open_iommu)
        if self.start_cmd.count("-bus=root_port") > 0:
            self.start_cmd = f"{self.start_cmd} {self.volume_cmd}"
            return SUCCESS_CODE

        self.start_cmd = self.start_cmd.split("-device")[0]
        for index, bdf in enumerate(self.bdf):
            bdf = bdf.replace("0000:", "")
            self.start_cmd += f" -device ioh3420,id=root_port{index},chassis={index} -device vfio-pci,host={bdf},id=net{index},bus=root_port{index}"
        self.start_cmd  = f"{self.start_cmd} -net none {self.volume_cmd}"

    def create(self, start_cmd: str = None, mem: str = '2G', smp: str = '1', open_iommu: bool = False):
        """
        =====================================================================
        函数说明: 启动虚拟机
        修改时间: 2021/11/30 15:26:42
        作    者: lwx567203
        =====================================================================
        """
        # FPGA上5.10内核需要使用增量包
        if self.prepare_fpga_510_env() == FAILURE_CODE:
            return FAILURE_CODE

        # FPGA起vm较慢，保持ssh连接活跃
        threads = concurrent.futures.ThreadPoolExecutor(max_workers=1)
        server_init = threads.submit(self._keep_ssh_alive, "server")

        self.create_command(start_cmd=start_cmd, mem=mem, smp=smp, open_iommu=open_iommu)

        if global_config.lava_global.run_env_type != global_config.project_global.d06:
            hns_config.vtimeout = 2700

        self.create_vm(timeout=hns_config.vtimeout, disable_show_and_log=False)
        self.keep_ssh_alive = False
        concurrent.futures.wait([server_init])

        # 检查vm是否真的启动成功
        result = self.send_command(f"lspci -s {self.bdf[0]}")
        if result not in ("", None):
            msg_center.error("create virtual machine fail")
            self._umount_volume()
            return FAILURE_CODE
        self.vm_exist = True

        # 放大窗口，防止命令行太长换行导致无法清除命令
        self.send_command("stty rows 1000000 columns 1000")
        return SUCCESS_CODE

    def insmod_hns_driver(self):
        """
        =====================================================================
        函数说明: NA
        修改时间: 2021/11/30 16:51:46
        作    者: lwx567203
        =====================================================================
        """
        ko_names = [hns_config.HNAE3_KO, hns_config.HCLGE_KO, hns_config.HCLGEVF_KO, hns_config.HNS3_KO]
        drivers = []
        for ko_name in ko_names:
            drivers.append(f"{hns_config.KO_PAYH}/{ko_name}.ko")
        if self.insmod_ko(drivers) == FAILURE_CODE:
            msg_center.error("虚拟机中加载内核驱动失败")
            return FAILURE_CODE
        self.get_ifaces()
        return SUCCESS_CODE

    def get_ifaces(self):
        """
        =====================================================================
        函数说明: 获取vm中网口名
        修改时间: 2021/12/01 15:39:24
        作    者: lwx567203
        =====================================================================
        """
        result = self.send_command("ls --color=never /sys/class/net", result=False)
        result = re.sub(r" +", " ", result)
        self.ifaces = result.strip().split()

    def ifconfig_iface_ip(self, iface="lo", host_ip="127.0.0.1", **kwargs):
        """
        =====================================================================
        函数说明: NA
        修改时间: 2021/11/30 15:46:58
        作    者: lwx567203
        =====================================================================
        """
        # 配置ip并检查
        if iface not in self.ifaces:
            msg_center.error(f"虚拟机中没有{iface}网口")
            return FAILURE_CODE
        self.vm_ip = kwargs.get("vm_ip", self.vm_ip)
        if self.vm_ip is None:
            self.vm_ip = hns_config_basic.get_same_network_addr(address=host_ip, netmask=24)
            if self.vm_ip == FAILURE_CODE:
                msg_center.error("无法获得有效的ip地址")
                return FAILURE_CODE
        if self.set_vm_ip(eth_port=iface, ip_addr=self.vm_ip) == FAILURE_CODE:
            msg_center.error(f"虚拟机中网口{iface}配置ip失败")
            return FAILURE_CODE
        if self.is_ping_success(ip_addr=host_ip) == FAILURE_CODE:
            msg_center.error(f"虚拟机中网口{iface} ping 宿主机ip失败")
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
        if self.send_command(f"ls {eg.project.base_dir_path}"):
            hns_common.scp_to_local("root", "root", self.vm_ip, eg.project.base_dir_path, eg.project.base_dir_path,
                                    terminal=self.host_type)
        if self.vm_exist is True:
            if disable_vfs:
                hns_config_basic.delete_vf(list(hns_config.PF_MAP_VF.keys()), terminal=self.host_type)
            self.vm_handle.connect.control(hot_key="a")
            self.send_command("x")
            self.vm_exist = False

        keys = [key for key in hns_config.OBJECTS if key.count("vm_")]
        for key in keys:
            del hns_config.OBJECTS[key]

        hns_config.IMAGE_VERSION.pop(f"vm_{self.host_type}", "nothing to do")

        self._umount_volume()

    def tar_pkg_file(self):
        """
        =====================================================================
        函数说明: 解压文件
        修改时间: 2022/06/14 09:32:07
        作    者: lwx567203
        =====================================================================
        """
        if hns_config.IMAGE_VERSION.get(self.host_type) != hns_config.BIGDIPPER_NAME:
            return SUCCESS_CODE
        if global_config.lava_global.run_env_type == global_config.project_global.d06:
            return SUCCESS_CODE
        self.send_command(f"mkdir -p {self.share_dir}")
        self.send_command(f"mount /dev/vda {self.share_dir}")
        for pkg in hns_config.tar_pkg:
            self.send_command(f"tar -zxvf {self.share_dir}/{pkg} -C /")
        self.send_command(f"umount {self.share_dir}")
        self.send_command(f"rm -rf {self.share_dir}")

    def prepare(self, iface, host_ip, start_cmd: str = None, mem: str = '2G', smp: str = '1', open_iommu: bool = False):
        """
        =====================================================================
        函数说明: 准备虚拟机
        修改时间: 2021/12/01 10:06:44
        作    者: lwx567203
        =====================================================================
        """
        if self.create(start_cmd=start_cmd, mem=mem, smp=smp, open_iommu=open_iommu) == FAILURE_CODE:
            return FAILURE_CODE
        version = self.send_command("uname -r")
        if version in hns_config.BIGDIPPER:
            self._image_version = hns_config.BIGDIPPER_NAME
            hns_config.IMAGE_VERSION.update({f"vm_{self.host_type}": hns_config.BIGDIPPER_NAME})
            self.tar_pkg_file()
        if self.insmod_hns_driver() == FAILURE_CODE:
            self.destroy()
            return FAILURE_CODE
        if self.ifconfig_iface_ip(iface=iface, host_ip=host_ip) == FAILURE_CODE:
            self.destroy()
            return FAILURE_CODE
        self.send_command(f"mkdir -p {eg.project.base_dir_path}")
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
        self.information = super().send_command(cmd, wait_rsp_timeout=hns_config.vtimeout, **kwargs)
        self.information = re.sub(".*init done", "", self.information)
        self.information = re.sub(f".*{cmd}", "", self.information)
        self.information = re.sub("\r.*\n", "\n", self.information)
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

    def scp_to_remote(self, host_ip, local_file, remote_file):
        """
        ============================================
        函数说明: scp拷贝文件到对端
        修改时间: 2023-05-09 15:16:29
        作   者: lwx567203
        ============================================
        """
        self.vm_handle.connect.pexpect_scp_file(local_file=local_file, remote_dir=remote_file, service_ip=host_ip,
                                                pull=False)

    def scp_from_remote(self, host_ip, local_file, remote_file):
        """
        ============================================
        函数说明: 从对端scp文件到本端
        修改时间: 2023-05-09 15:25:46
        作   者: lwx567203
        ============================================
        """
        self.vm_handle.connect.pexpect_scp_file(local_file=local_file, remote_dir=remote_file, service_ip=host_ip,
                                                pull=True)
