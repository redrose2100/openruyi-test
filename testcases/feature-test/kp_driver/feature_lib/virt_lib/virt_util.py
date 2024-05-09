#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
#====================================================================================
# @
# @
# @Create time : 2022/1/27 14:53
# @FileName    : virt_util.py
# @Description : VIRT模块公共函数
#====================================================================================
"""
import os
import time



#new
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.virt_config.virt_config import virt_global
from feature_lib.hns_lib.hns_util import Hns3Util
from feature_lib.sys_lib.sys_util import SysUtil
from feature_lib.sys_lib.sys_init import SysInit
from test_config.feature_config.dpdk_config.dpdk_config import dpdk_config
from common_lib.base_lib.base_multi_mode_terminal import MultiModeTerminal


class VirtUtil:
    """
    虚拟机公共函数
    """
    def __init__(self, **kwargs):
        """
        句柄调用，默认传virt模块句柄，跨模块调用传入对应模块的句柄
        """
        self.terminal_server = kwargs.get("terminal_server", virt_global.server_ssh)
        self.terminal_client = kwargs.get("terminal_client", virt_global.client_ssh)
        self.terminal_exp = kwargs.get("terminal_exp", virt_global.server_exp)

    def fn_create_vm(self, vm_name_list):
        """
        本端创建虚拟机
        :param vm_name_list: 想要创建虚拟机的名字列表
        :return: bool
        """
        exist_vm_list = []
        need_create_vm_list = []
        current_os = SysUtil().fn_get_os_name()
        xml_path = '/etc/libvirt/qemu/'
        disk_path = '/home/kvm/'
        nvrampath = '/var/lib/libvirt/qemu/nvram/'
        # 前置条件，判断vfio驱动是否已加载
        if self.terminal_server.send_command("lsmod | grep vfio_pci") != 0 and self.terminal_server.send_command(
                "lsmod | grep vfio_iommu_type1") != 0 and self.terminal_server.send_command("lsmod | grep hclgevf") != 0:
            self.terminal_server.send_command("modprobe vfio && modprobe vfio-pci && modprobe hclgevf")
            if self.terminal_server.ret_code != 0:
                msg_center.error("lsmod vfio fail")
                return False
        # 区分OS类型
        if current_os == 'openeuler':
            os_type = "openEulerVM"
            # 关闭防火墙
            self.terminal_server.send_command("systemctl stop firewalld.service")
            self.terminal_server.send_command("systemctl disable firewalld.service")
        else:
            os_type = "ubuntu_20.04.1"
        msg_center.info(f"***********************{os_type}")
        # 创建前查询是否已经存在虚拟机， 存在则不创建
        for vm_name in vm_name_list:
            # virsh判断工具有没有
            self.terminal_server.send_command("which virsh")
            if self.terminal_server.ret_code != 0:
                msg_center.info("virsh not found, need install and create VM")
                break
            self.terminal_server.send_command(f"virsh list --all |grep {vm_name}")
            if self.terminal_server.ret_code == 0:
                vm_status = self.terminal_server.send_command(f"virsh list --all|grep {vm_name}|awk '{{print $(NF-1)\" \"$NF}}'")
                # 判断已存在的虚拟机的状态
                if vm_status == "shut off":
                    self.terminal_server.send_command(f"virsh start {vm_name}")
                    if self.terminal_server.ret_code == 0:
                        time.sleep(35)
                        exist_vm_list.append(vm_name)
                        msg_center.info(f"{vm_name} is exist, dont need create new vm")
                    else:
                        self.terminal_server.send_command(f"virsh destroy {vm_name}")
                        self.terminal_server.send_command(f"virsh undefine --nvram {vm_name}")
                        need_create_vm_list.append(vm_name)
                        msg_center.info(f"{vm_name} need create new vm")
                elif vm_status == f"{vm_name} running":
                    msg_center.info(f"{vm_name} is running")
                    exist_vm_list.append(vm_name)
                    msg_center.info(f"{vm_name} is exist, dont need create new vm")
                else:
                    self.terminal_server.send_command(f"virsh destroy {vm_name}")
                    self.terminal_server.send_command(f"virsh start {vm_name}")
                    if self.terminal_server.ret_code == 0:
                        time.sleep(35)
                        exist_vm_list.append(vm_name)
                        msg_center.info(f"{vm_name} is exist, dont need create new vm")
                    else:
                        self.terminal_server.send_command(f"virsh destroy {vm_name}")
                        self.terminal_server.send_command(f"virsh undefine --nvram {vm_name}")
                        need_create_vm_list.append(vm_name)
                        msg_center.info(f"{vm_name} need create new vm")
        if len(exist_vm_list) == len(vm_name_list):
            msg_center.info(f"All vm is exist, dont need create new vm")
            return True
        # 需要创建虚拟机
        else:
            msg_center.info(f"{need_create_vm_list} need create new vm, begin create")
            if not os.path.exists(disk_path):
                self.terminal_server.send_command(f"mkdir -p {disk_path}")
            if current_os == 'openeuler':
                # 安装所需工具
                kvm_install = ["qemu", "libvirt", "qemu-img", "bridge-utils", "edk2-aarch64", "expect"]
                SysInit.fn_install_pkg(kvm_install)
                # 下载所需文件
                self.terminal_server.send_command("systemctl start libvirtd")
                wget_cmd = [
                    f"wget -c -q -t 1 -T 5 --no-check-certificate -P {disk_path} http://172.19.20.15:8083/platform/VM/libvirt_libs/{os_type}.xml",
                    f"wget -c -q -t 10 -T 5 --no-check-certificate -P {disk_path} http://172.19.20.15:8083/platform/VM/libvirt_libs/{os_type}.qcow2"
                ]
            else:
                if not os.path.exists("/usr/share/AAVMF"):
                    self.terminal_server.send_command("mkdir -p /usr/share/AAVMF")
                kvm_install = ["qemu-kvm", "libvirt-bin", "virtinst", "bridge-utils", "cpu-checker", "virt-manager", "virt-viewer", "expect"]
                assert SysInit.fn_install_pkg(kvm_install)
                wget_cmd = [
                            f"wget -c -q -t 1 -T 5 --no-check-certificate -P /etc/libvirt/qemu  http://172.19.20.15:8083/platform/VM/libvirt_libs/{os_type}.xml",
                            f"wget -c -q -t 1 -T 5 --no-check-certificate -P /var/lib/libvirt/qemu/nvram/  http://172.19.20.15:8083/platform/VM/libvirt_libs/{os_type}.fd",
                            f"wget -c -q -t 1 -T 5 --no-check-certificate -P /home/kvm  http://172.19.20.15:8083/platform/VM/libvirt_libs/{os_type}.img",
                            "wget -c -q -t 1 -T 5 --no-check-certificate -P /usr/share/AAVMF  http://172.19.20.15:8083/platform/VM/libvirt_libs/AAVMF_VARS.fd",
                            "wget -c -q -t 1 -T 5 --no-check-certificate -P /usr/share/AAVMF  http://172.19.20.15:8083/platform/VM/libvirt_libs/AAVMF_CODE.fd"
                            ]
            for i in wget_cmd:
                self.terminal_server.send_command(i)
            # 循环配置每个虚拟机的xml文件以及拷贝image
            for vm_name in need_create_vm_list:
                uuid = self.terminal_server.send_command("uuidgen")
                mac_cmd = "dd if=/dev/urandom count=1 2>/dev/null | md5sum | sed 's/^\(.\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\\14:\\2:\\3:\\4:\\5:\\6/g'"
                vm_mac = self.terminal_server.send_command(mac_cmd)
                msg_center.info(f"MAC地址：{vm_mac}")
                if current_os == 'openeuler':
                    # 生成xml文件
                    self.terminal_server.send_command(f"mv {disk_path}{os_type}.xml  {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"mv {disk_path}{os_type}.qcow2  {disk_path}{vm_name}.qcow2")
                    self.terminal_server.send_command(f"sed -i \"/<name>/{{s/>[^<]*</>{vm_name}</}}\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<nvram>/{{s#openEulerVM#{vm_name}#}}\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<source file/s#'[^']*'#'{disk_path}{vm_name}.qcow2'#\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<uuid>/{{s/>[^<]*</>{uuid}</}}\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<mac/s/'[^']*'/'{vm_mac}'/\" {xml_path}{vm_name}.xml")
                else:
                    self.terminal_server.send_command(f"mv {disk_path}{os_type}.img  {disk_path}{vm_name}.img")
                    self.terminal_server.send_command(f"mv {xml_path}{os_type}.xml {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"mv {nvrampath}{os_type}.fd {nvrampath}{vm_name}_VARS.fd")
                    self.terminal_server.send_command(f"sed -i \"/<name>/{{s/>[^<]*</>{vm_name}</}}\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<uuid>/{{s/>[^<]*</>{uuid}</}}\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<mac/s/'[^']*'/'{vm_mac}'/\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<source file/s#'[^']*'#'{disk_path}{vm_name}.img'#\" {xml_path}{vm_name}.xml")
                    self.terminal_server.send_command(f"sed -i \"/<nvram>/{{s/ubun_VARS.fd/{vm_name}_VARS.fd/}}\" {xml_path}{vm_name}.xml ")
                # 生成虚拟机并启动
                self.terminal_server.send_command(f"virsh define {xml_path}{vm_name}.xml")
                self.terminal_server.send_command(f"virsh start {vm_name}")
                time.sleep(45)
                if self.terminal_server.send_command(f"virsh list --all |grep {vm_name}"):
                    msg_center.info(f"{vm_name} creat success")
                else:
                    msg_center.error(f"{vm_name} 创建虚拟机失败")
                    return False
            return True

    def fn_vm_create_vf(self, vm_name, port_list, vf_num=1, vf_passthrough=1):
        """
        给虚拟机创建VF并直通
        :param vm_name: 虚拟机的名字
        :param port_list: 需要创建的VF的PF列表
        :param vf_num: 需要创建的VF个数
        :param vf_passthrough:需要直通VF的个数
        :return:
        """
        for net_port in port_list:
            # 清除PF的VF
            check_ret = Hns3Util(terminal_server=self.terminal_server).nic_del_vf([net_port])
            if not check_ret:
                msg_center.error("vf clean fail")
                return False
            self.terminal_server.send_command("lspci | grep -i \"Virtual Function\" > VF_status1.txt")
            # 创建VF
            check_ret = Hns3Util(terminal_server=self.terminal_server).nic_create_vf_sut([net_port], vf_num)
            if not check_ret:
                msg_center.error("vf create fail")
                return False
            self.terminal_server.send_command("lspci | grep -i \"Virtual Function\" > VF_status2.txt")
            vf_pcis = self.terminal_server.send_command("comm -3 VF_status2.txt VF_status1.txt |grep -e '..:..\..'|awk '{print $1}'").split("\n")
            # 清理临时文件
            self.terminal_server.send_command("rm -f VF_status1.txt VF_status2.txt vf_tmp.xml")
            vf_pcis = vf_pcis[0:vf_passthrough]
            kvm_ssh_ip_list = []
            for i in range(len(vf_pcis)):
                self.terminal_server.send_command(f"echo vfio-pci > /sys/bus/pci/devices/0000:{vf_pcis[i]}/driver_override")
                self.terminal_server.send_command(f"echo 0000:{vf_pcis[i]} > /sys/bus/pci/drivers_probe")
                vf_pci_bus = vf_pcis[i][0:2]
                vf_pci_slot = vf_pcis[i][3:5]
                vf_pci_fc = vf_pcis[i][-1]
                data = ["<hostdev mode='subsystem' type='pci' managed='yes'>",
                        "        <source>",
                        f"        <address domain='0x0000' bus='0x{vf_pci_bus}' slot='0x{vf_pci_slot}' function='0x{vf_pci_fc}'/>",
                        "        </source>",
                        "</hostdev>"]
                for line in data:
                    self.terminal_server.send_command(f"echo '{line}' |tee -a vf_tmp.xml")
                msg_center.info("vf_tmp.xml:")
                msg_center.info(self.terminal_server.send_command("cat vf_tmp.xml"))
                vm_port_before = self.get_vm_port_info(vm_name).keys()
                if len(vm_port_before) == 0:
                    msg_center.error("get vm port fail, please check VM status")
                    return False
                self.terminal_server.send_command(f"virsh attach-device {vm_name} ./vf_tmp.xml")
                net_port_ip = self.terminal_server.send_command(f"ip a|grep {net_port}|awk 'NR==2{{print $2}}'|awk -F'/' '{{print $1}}'").split(".")
                net_port_ip_1_3 = net_port_ip[0] + "." + net_port_ip[1] + "." + net_port_ip[2]
                # 构造直通VF的IP与PF同网段，第四位网段从21开始递增
                vm_vf_ip = net_port_ip_1_3 + "." + str(21+i)
                vm_port_after = self.get_vm_port_info(vm_name).keys()
                vm_vf_port_list = list(vm_port_after - vm_port_before)
                if len(vm_vf_port_list) == 0:
                    msg_center.error("vm vf create fail!")
                    return False
                else:
                    vm_vf_port = vm_vf_port_list[0]
                    self.terminal_exp.create_vm_by_password(f"virsh console {vm_name};")
                    self.terminal_exp.send_command(f"ip a add dev {vm_vf_port} {vm_vf_ip}/24")
                    self.terminal_exp.send_command(f"ip link set {vm_vf_port} up")
                    self.terminal_exp.send_command(f"ip a")
                self.terminal_exp.send_command("dmesg -c > /dev/null")
                msg_center.info(f"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!kvm_ssh_ip_list:{kvm_ssh_ip_list}")
        return True

    def fn_delete_vm(self, vm_name_list, pf_port_list=None):
        """
        删除虚拟机
        :param vm_name_list:需要删除的虚拟机列表
        :param pf_port_list: 已经直通VF的PF的列表，清理vf
        :return:
        """
        if isinstance(pf_port_list, str):
            pf_port_list = list(pf_port_list)
        if isinstance(vm_name_list, str):
            vm_name_list = [vm_name_list]
        for vm_name in vm_name_list:
            for i in range(4):
                if self.terminal_server.send_command(f"virsh list --all |grep -w {vm_name}") == 0:
                    self.terminal_server.send_command(f"virsh destroy {vm_name}")
                    self.terminal_server.send_command(f"virsh undefine --nvram {vm_name}")
                    time.sleep(2)
                else:
                    msg_center.info(f"当前机器已不存在{vm_name}")
                    break
            if self.terminal_server.send_command(f"virsh list --all |grep -w {vm_name}") != 0:
                self.terminal_server.send_command("rm -f /usr/share/AAVMF/AAVMF_VARS.fd")
                self.terminal_server.send_command("rm -f /usr/share/AAVMF/AAVMF_CODE.fd")
                self.terminal_server.send_command(f"rm -f /home/kvm/{vm_name}.img")
                self.terminal_server.send_command(f"rm -f /home/kvm/{vm_name}.qcow2")
                self.terminal_server.send_command(f"rm -f /etc/libvirt/qemu/{vm_name}.xml")
                self.terminal_server.send_command(f"rm -f rm -rf /var/lib/libvirt/qemu/nvram/{vm_name}_VARS.fd")
                if pf_port_list is not None:
                    for pf_port in pf_port_list:
                        self.terminal_server.send_command(f"echo 0 > /sys/class/net/{pf_port}/device/sriov_numvfs")
                if os.path.exists("/usr/share/AAVMF/AAVMF_VARS.fd") or os.path.exists("/usr/share/AAVMF/AAVMF_CODE.fd") or \
                        os.path.exists(f"/home/kvm/{vm_name}.img") or os.path.exists(f"/etc/libvirt/qemu/{vm_name}.xml") \
                        or os.path.exists(f"rm -f rm -rf /var/lib/libvirt/qemu/nvram/{vm_name}_VARS.fd"):
                    msg_center.error("虚拟机文件删除失败")
                    return False
                else:
                    msg_center.info("虚拟机文件删除成功")
            else:
                msg_center.error("虚拟机删除失败")
                return False

    def fn_vm_create_acc_vf(self, dev_name, vm_name, pf_pci, kvm_ssh_ip):
        """
        acc的VF直通
        :param dev_name: ACC设备名
        :param vm_name: 虚拟机名
        :param pf_pci: pci号
        :param kvm_ssh_ip:
        :return:
        """
        #使能vf
        self.terminal_server.send_command("echo 1 > /sys/bus/pci/drivers/hisi_{0}/{1}/sriov_numvfs".format(dev_name, pf_pci))
        vf_pci = self.terminal_server.send_command("lspci | grep -i '{} Engine(Virtual Function)'".format(dev_name.upper())).split(' ')[0]
        data = ["<hostdev mode='subsystem' type='pci' managed='yes'>",\
                "        <source>",\
                f"        <address domain='0x0000' bus='0x{vf_pci[0:2]}' slot='0x{vf_pci[3:5]}' function='0x{vf_pci[-1]}'/>",\
                "        </source>",\
                "</hostdev>"]
        with open("vf_acc.xml", "w") as f:
            for i in data:
                i = i + "\n"
                f.write(i)
        msg_center.info(self.terminal_server.send_command("cat vf_acc.xml"))
        self.terminal_server.send_command(f"virsh attach-device {vm_name} ./vf_acc.xml")
        time.sleep(3)
        self.terminal_exp.create_vm_by_password(f"virsh console {vm_name}")
        check_vf = self.terminal_exp.send_command(f"lspci | grep -i '{dev_name} Engine(Virtual Function)'")
        if len(check_vf) == 0:
            msg_center.error("Failed to create the VF")
            return False
        else:
            msg_center.info("The VF is created successfully")
        self.terminal_server.send_command("rm -f VF_status1.txt VF_status2.txt vf_acc.xml")
        return True

    def fn_vm_prepare_dpdk(self, vm_name):
        """
        虚拟机DPDK环境准备，包括：
        1、从host侧拷贝dpdk目录到虚拟机VM上
        2、宿主机和虚拟机都插入vfio-pci驱动
        3、虚拟机上设置大页内存
        4、虚拟机上绑定vfio-pci驱动
        return value：虚拟机上VF网口名字，VF bus-info
        :param vm_name:
        :return:
        """
        lib_path = "/usr/lib/aarch64-linux-gnu"
        lib_so_list = ["libmlx5.so.1", "libibverbs.so.1", "libmlx4.so.1", "libnl-route-3.so.200"]
        lib_dict = {}
        self.terminal_exp.create_vm_by_password(f"virsh console {vm_name}")
        for i in lib_so_list:
            lib_so_info = self.terminal_server.send_command(f"ls -la {lib_path}/{i}")
            lib_so_vm = lib_so_info.split()[-1]
            lib_dict[lib_so_vm] = i
        msg_center.info(f"lib_dict={lib_dict}")
        # 从host侧拷贝源文件到虚拟机VM上
        self.terminal_exp.send_command("rm -rf /etc/apt/sources.list")
        source_file = "/etc/apt/sources.list"
        self.terminal_exp.fn_double_scp(source_file, source_file)
    
        self.terminal_exp.send_command("rm -rf /etc/resolv.conf")
        dns_file = "/etc/resolv.conf"
        self.terminal_exp.fn_double_scp(dns_file, dns_file)
    
        self.terminal_exp.send_command("rm -rf /etc/hosts")
        ip_file = "/etc/hosts"
        self.terminal_exp.fn_double_scp(ip_file, ip_file)
    
        # 安装ethtool工具，用于后续获取网口bus info。默认ubuntu系统，如果是其他系统，此处需要适配
        self.terminal_exp.send_command("apt update -y")
        self.terminal_exp.send_command("apt install ethtool")
    
        # 从host侧拷贝dpdk目录到虚拟机VM上
        self.terminal_exp.send_command("mkdir /opt/dpdk")
        self.terminal_exp.fn_double_scp(dpdk_config.dpdk_dir, dpdk_config.dpdk_dir)
        # 判断拷贝是否成功：vm dpdk目录下是否有dpdk-devbind.py和testpmd文件
        res = self.terminal_exp.send_command(f"ls -l {dpdk_config.dpdk_devbind}")
        if "dpdk-devbind.py" not in res:
            msg_center.error("VM doesn't have dpdk-devbind.py!")
            assert False
        res = self.terminal_exp.send_command(f"ls -l {dpdk_config.testpmd_path}")
        if "testpmd" not in res:
            msg_center.error("VM doesn't have testpmd!")
            assert False
        self.terminal_exp.send_command(f"chmod -R 777 {dpdk_config.dpdk_dir}")
        msg_center.info("scp dpdk dir to VM success!")
    
        # 虚拟机中插入vfio-pci驱动，应先查找驱动所在的目录，然后再安装
        vm_kernel_ver = self.terminal_exp.send_command("uname -r")
        msg_center.info(f"vm_kernel_ver: {vm_kernel_ver}")
    
        cmd = "find / -name %s |grep %s |awk 'NR==1{print}'"
        vfio_dir = self.terminal_exp.send_command(cmd % ('vfio.ko', vm_kernel_ver))
        self.terminal_exp.send_command(f"insmod {vfio_dir} enable_unsafe_noiommu_mode=1")
    
        virqfd_dir = self.terminal_exp.send_command(cmd % ('vfio_virqfd.ko', vm_kernel_ver))
        self.terminal_exp.send_command(f"insmod {virqfd_dir}")
    
        pci_dir = self.terminal_exp.send_command(cmd % ('vfio-pci.ko', vm_kernel_ver))
        self.terminal_exp.send_command(f"insmod {pci_dir}")
    
        type1_dir = self.terminal_exp.send_command(cmd % ('vfio_iommu_type1.ko', vm_kernel_ver))
        self.terminal_exp.send_command(f"insmod {type1_dir}")
        # 判断插入是否成功
        res = self.terminal_exp.send_command("lsmod |grep vfio_pci")
        if "vfio_pci" not in res:
            msg_center.error("VM insmod vfio-pci failed!")
            assert False
        else:
            msg_center.info(res)
            assert True
        #创建DPDK20.11所需的软链接
        for lib_name in lib_dict.keys():
            self.terminal_exp.fn_double_scp(f"{lib_path}/{lib_name}", f"{lib_path}/{lib_name}")
            self.terminal_exp.send_command(f"cd {lib_path}")
            self.terminal_exp.send_command(f"ln -sv {lib_path}/{lib_name} {lib_path}/{lib_dict.get(lib_name)}")
            self.terminal_exp.send_command("cd /root")
        # 虚拟机上设置大页内存
        self.terminal_exp.send_command("mkdir -p /mnt/huge")
        self.terminal_exp.send_command("mount -t hugetlbfs nodev /mnt/huge")
        self.terminal_exp.send_command("echo 512 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages")
        res = self.terminal_exp.send_command("grep Hugepagesize /proc/meminfo")
        if "2048" not in res:
            msg_center.error("VM hugepagesize not 2048!")
            assert False
        res = self.terminal_exp.send_command("cat /proc/meminfo |grep -i huge")
        msg_center.info(res)
    
        # 获取虚拟机中VF网口名字和bus info
        vm_nic_name = self.terminal_exp.send_command("ip a |grep state |grep -v lo |grep -v enp1s0 |awk -F':' '{print $2}' |head -1")
        vm_nic_bus_info = self.terminal_exp.send_command("ethtool -i %s | grep \"bus-info\" | awk '{print $NF}' | sed 's/ //g'"
                                            % vm_nic_name)
        msg_center.info(f"vm_nic_name:{vm_nic_name}, vm_nic_bus_info:{vm_nic_bus_info}")
        if len(vm_nic_bus_info) == 0:
            assert False
    
        # 虚拟机上绑定vfio-pci驱动
        self.terminal_exp.send_command(f"ip link set dev {vm_nic_name} down")
        cmd = f"python3 {dpdk_config.dpdk_devbind} -b vfio-pci {vm_nic_bus_info}"
        msg_center.info(cmd)
        self.terminal_exp.send_command(cmd)
        cmd = f"python3 {dpdk_config.dpdk_devbind} -s"
        res = self.terminal_exp.send_command(cmd)
        msg_center.info(res)
        return vm_nic_name, vm_nic_bus_info

    def get_vm_port_info(self, vm_name):
        """
        获取虚拟机所有网口信息，返回网口名为键，网口IP为值的字典
        :param vm_name: 查询的虚拟机名字
        :return:info_dict={'enps4': '192.168.112.152'}
        """
        info_dict = dict()
        cmd = "ip a |grep -v 'lo' |grep state |awk '{print$2}' |tr -d ':'"
        self.terminal_exp.create_vm_by_password(f"virsh console {vm_name}", disable_cmd_show=True)
        # 获取所有网口
        port_list = self.terminal_exp.send_command(cmd).split()
        # 遍历网口获取IP
        for port in port_list:
            cmd = f"ip a show {port}|grep -w inet |awk '{{print$2}}' |awk -F'/' '{{print$1}}'"
            port_ip = self.terminal_exp.send_command(cmd)
            info_dict[port] = port_ip
        return info_dict

    @staticmethod
    def create_handle(vm_ssh_ip, port="22", username="root", password="root", **kwargs):
        """
        封装讯虚拟机用的命令发送句柄
        :param vm_ssh_ip:需要封装的连接终端的IP
        :param password: 虚拟机的用户名，默认root
        :param username: 虚拟机的密码，默认root
        :param port: 虚拟机的连接端口，默认22
        :return:返回连接句柄
        """
        handler = MultiModeTerminal(vm_ssh_ip, port, username, password, MultiModeTerminal.TYPE_SSH, **kwargs)
        handler.open_connect()
        # 返回句柄
        return handler




