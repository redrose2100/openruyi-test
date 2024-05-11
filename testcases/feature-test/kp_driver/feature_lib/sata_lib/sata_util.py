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
# @Date      	:   2024-05-06 15:36:43
# @License   	:   Mulan PSL v2
# @Desc      	:   add lib for acc enviroment
#####################################

import os
import re
import time
from kp_comm import CmdOs
from test_config.feature_config.sata_config.sata_config import sata_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.sata_config import sata_config as scfg

a = os.path.basename(__file__)
ROOTDIR = os.path.realpath(__file__).split(a)[0]


class SataLib:
    """
    SATA模块公共函数
    """
    @classmethod
    def get_devices_name(cls):
        """
        功能描述：get disk device name
        """
        devices = set()
        # 过滤sas驱动下的盘， -A 1 向下多取一行
        sata_global.server_ssh.send_command(
            f"{scfg.LSSCSI} -tv | grep 'sata' -A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1")
        for line in sata_global.server_ssh.stdout.splitlines():
            if len(line.split('/')) >= 5:
                devices.add(line.split("/")[4])
        # python中集合set主要利用其唯一性，及并集|、交集&等操作，但不可以直接通过下标进行访问，必须访问时可以将其转换成list再访问
        return list(devices)

    @classmethod
    def get_all_disks(cls, device="sata"):
        """
        功能描述：获取盘
        """
        # 获取系统盘
        sata_global.server_ssh.send_command(f"{scfg.LSSCSI} -t | grep '{device}'")
        disks = re.findall("/dev/sd[a-z]", sata_global.server_ssh.stdout)
        test_disks = list()
        for disk in disks:
            sata_global.server_ssh.send_command(f"lsblk | grep {disk}")
            if "efi" in sata_global.server_ssh.stdout:
                continue
            else:
                test_disks.append(disk)
        return test_disks

    @classmethod
    def get_init_path(cls, disk="sda"):
        """
        功能描述：获取对应的路径
        """
        sata_global.server_ssh.send_command(f"{scfg.LSSCSI} -tv | grep '{disk}' "
                                            f"-A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1")
        bpath = sata_global.server_ssh.stdout
        hostx = bpath.split("/")[-3]
        cpath = f"{bpath.split('/ata')[0]}"

        return hostx, cpath, bpath

    @classmethod
    def get_port_id(cls, disk="sda"):
        """
        功能描述：获取port id
        """
        port_id = None
        cmdos = CmdOs(terminal=sata_global.server_ssh)
        bpath = cls.get_init_path(disk=disk)[2]

        deviceid = re.findall("/(0000:[0-9a-z]+:[0-9a-z]+\.[0-9a-z]+)/", bpath)
        atax = re.findall("/(ata[0-9]+)/", bpath)
        if len(deviceid) == 0 or len(atax) == 0:
            msg_center.error("deviceid或atax获取异常")
            return port_id

        port_no = f"{scfg.PCI}/devices/{deviceid[0]}/{atax[0]}/ata_port/{atax[0]}/port_no"
        if cmdos.check_exist_file(f"{port_no}") is False:
            msg_center.error("port_no路径获取异常")
            return port_id

        sata_global.server_ssh.send_command(f"cat {port_no}")
        port_id = sata_global.server_ssh.stdout
        return port_id

    @classmethod
    def scan_disk(cls, host=None):
        """
        功能描述：扫描硬盘
        """
        if host in (None, ""):
            sata_global.server_ssh.send_command(f"ls {scfg.SCSI_HOST}")
            for host in sata_global.server_ssh.stdout.splitlines():
                sata_global.server_ssh.send_command(f"echo '- - -' > {scfg.SCSI_HOST}/{host}/scan")
        else:
            sata_global.server_ssh.send_command(f"echo '- - -' > {scfg.SCSI_HOST}/{host}/scan")

    @classmethod
    def get_disk_num(cls):
        """
        功能描述：获取硬盘个数
        """
        sata_global.server_ssh.send_command(f"{scfg.FDISK} -l | grep /dev/sd | wc -l")
        return int(sata_global.server_ssh.stdout)

    @classmethod
    def check_disk_num(cls, number=1, seconds=600):
        """
        功能描述：检查盘个数据，是否掉盘
        """
        while seconds > 0:
            if number <= cls.get_disk_num():
                break
            msg_center.info("type(number): %s, number= %s", type(number), number)
            time.sleep(1)
            msg_center.info("the disk num is not readly ,please wait.....")
            seconds -= 1
        else:
            msg_center.error("the number of disk is less")
            sata_global.server_ssh.send_command(f"{scfg.LSSCSI} -v")
            sata_global.server_ssh.send_command(f"{scfg.FDISK} -l | grep sd")
            return False
        return True

    @classmethod
    def check_dmesg_log(cls, **args):
        """
        功能描述：检查日志
        """
        loginfo = args.get("loginfo", scfg.CALLTRACE)
        ex_info = args.get("ex_info", "")
        sata_global.server_ssh.send_command(
            f"{scfg.DMESG} | egrep -i '{loginfo}' | egrep -iv 'hisi_sas_v3_hw 0000:30:04.0|{ex_info}'")
        return sata_global.server_ssh.stdout

    @classmethod
    def flr_reset(cls, device=None):
        """
        功能描述：FLR复位
        2023-09-05: 增加前后检查数量操作，兼容多次flr检查磁盘数量
        """
        disk_num = len(cls.get_all_disks())
        if device in (None, ""):
            device = cls.get_devices_name()[0]
        stopping_disk_cmd = f"{scfg.DMESG} | grep '{scfg.STOPPINGDISK}' | wc -l"
        attached_scsi_disk_cmd = f"{scfg.DMESG} | grep '{scfg.ATTACHEDDISK}' | wc -l"
        pre_stopping_disk_num = int(sata_global.server_ssh.send_command(stopping_disk_cmd))
        pre_attached_scsi_disk_num = int(sata_global.server_ssh.send_command(attached_scsi_disk_cmd))
        sata_global.server_ssh.send_command(f"echo 1 > {scfg.PCI}/devices/{device}/reset")
        sata_global.server_ssh.send_command(f"echo 1 > {scfg.PCI}/devices/{device}/remove")
        sata_global.server_ssh.send_command(f"echo 1 > {scfg.PCI}/rescan")
        time.sleep(2)
        post_send_stopping_disk_num = int(sata_global.server_ssh.send_command(stopping_disk_cmd))
        post_attached_scsi_disk_num = int(sata_global.server_ssh.send_command(attached_scsi_disk_cmd))
        stopping_disk_num = post_send_stopping_disk_num - pre_stopping_disk_num
        attached_scsi_disk_num = post_attached_scsi_disk_num - pre_attached_scsi_disk_num
        if stopping_disk_num != disk_num or attached_scsi_disk_num != disk_num:
            msg_center.error("FLR复位打印日志不符合预期")
            return False
        return True

    @classmethod
    def check_queue_depth(cls, disk_paths=None, queue_depth=32):
        """
        功能描述：检查队列深度
        """
        if disk_paths is None:
            disk_paths = list()
            sata_global.server_ssh.send_command(f"{scfg.LSSCSI} -tv | grep 'sata' "
                                                f"-A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1")
            for line in sata_global.server_ssh.stdout.splitlines():
                disk_paths.append(line)
        else:
            if not isinstance(disk_paths, list):
                disk_paths = [disk_paths]
        for disk_path in disk_paths:
            sata_global.server_ssh.send_command(f"cat {disk_path}/queue_depth")
            if int(sata_global.server_ssh.stdout) != queue_depth:
                msg_center.error(f"队列深度不符合预期，预期是{queue_depth}，"
                                 f"实际是{int(sata_global.server_ssh.stdout)}")
                return False
        return True

    @classmethod
    def set_queue_depth(cls, disk_paths=None, queue_depth=32):
        """
        功能描述：设置队列深度
        """
        if disk_paths is None:
            disk_paths = list()
            sata_global.server_ssh.send_command(f"{scfg.LSSCSI} -tv | grep 'sata' "
                                                f"-A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1")
            for line in sata_global.server_ssh.stdout.splitlines():
                disk_paths.append(line)
        else:
            if not isinstance(disk_paths, list):
                disk_paths = [disk_paths]
        for disk_path in disk_paths:
            sata_global.server_ssh.send_command(
                f"echo {queue_depth} > {disk_path}/queue_depth")

    @classmethod
    def get_base_address(cls, device=None):
        """
        功能描述：获取控制器基地址
        """
        if device in (None, ""):
            device = cls.get_devices_name()[0]

        sata_global.server_ssh.send_command(f"cat {scfg.IOMEM} | grep {device}")
        base_addr = f"0x{sata_global.server_ssh.stdout.strip().split('-')[0]}"
        return base_addr

    @classmethod
    def set_devmem(cls, reg_addrs=None, reg_value=None):
        """
        功能描述：通过devmem写寄存器
        """
        if reg_addrs is None:
            msg_center.error("reg_addrs is None，调用函数时需要传入一个寄存器地址")
            return False
        else:
            if not isinstance(reg_addrs, list):
                reg_addrs = [reg_addrs]
        for reg_addr in reg_addrs:
            if reg_value is None:
                # 这个分支一般使用于要给寄存器写的值不是固定是，而且寄存器当前的值。
                # 中断状态寄存器清零就是要写寄存器的值而不是0。
                sata_global.server_ssh.send_command(f"{scfg.DEVMEM} {reg_addr}")
                sata_global.server_ssh.send_command(
                    f"{scfg.DEVMEM} {reg_addr} 32 {sata_global.server_ssh.stdout}")
            else:
                sata_global.server_ssh.send_command(
                    f"{scfg.DEVMEM} {reg_addr} 32 {reg_value}")

        return True

    @classmethod
    def get_mdadm(cls, soft_raid="/dev/md0"):
        """
        功能描述：获取软raid信息
        """
        mdadm_info = dict()
        sata_global.server_ssh.send_command(f"{scfg.MDADM} -D {soft_raid}")
        msg_center.info(f"{sata_global.server_ssh.stdout}")

        for line in sata_global.server_ssh.stdout.splitlines():
            lists = line.strip().split(" : ")
            if len(lists) < 2:
                continue
            mdadm_info[lists[0]] = lists[1]
        return mdadm_info

    @classmethod
    def get_bindcpus(cls):
        """
        获取跨片测试绑核范围
        """
        cpus_allowed = None
        cmdos = CmdOs(terminal=sata_global.server_ssh)
        cpus = int(cmdos.get_cpu_info()['CPU(s)'])
        devices = cls.get_devices_name()

        if cpus == 96:
            if "b4" in devices[0]:
                cpus_allowed = "0-47"
            elif "74" in devices[0]:
                cpus_allowed = "48-95"
        if cpus == 128:
            if "b4" in devices[0]:
                cpus_allowed = "0-63"
            elif "74" in devices[0]:
                cpus_allowed = "64-127"

        return cpus_allowed

    @classmethod
    def set_disk_part(cls, disk="sdb", size="10G", count=1):
        """
        Function Description:
        set disk partitioning
        Parameters:
        @ disk  disk name
        @ size  size of partition
        """
        # check whether the disk exists
        sata_global.server_ssh.send_command("ls {}".format(disk))
        if sata_global.server_ssh.stdout in ("", b""):
            msg_center.error("The disk {} does not exist".format(disk))
            return False

        for i in range(count):
            # Disk partitioning
            command = "fdisk {} << EOF\nn\np\n\n\n+{}\nw\nEOF\n".format(disk, size)
            sata_global.server_ssh.send_command(command)
            if "The partition table has been altered" not in sata_global.server_ssh.stdout:
                msg_center.error("The disk %s create partition fail", disk)
                return False

        # check whether partitioning success
        sata_global.server_ssh.send_command("lsblk -l | grep {} | wc -l".format(disk.split('/')[-1]))
        if int(sata_global.server_ssh.stdout) <= count:
            msg_center.error("The disk %s not really partitioned", disk)
            return False
        return True

    @classmethod
    def get_disks_part(cls, disks="sd[a-z]"):
        """
        功能描述：获取磁盘分区
        """
        disks_part = list()

        # get mount infomation
        sata_global.server_ssh.send_command("mount | grep '/dev/[a-z]d[a-z]' | awk '{print $1}'")
        mount_info = sata_global.server_ssh.stdout.split("\n")

        # get all disk
        sata_global.server_ssh.send_command(f"fdisk -l | grep {disks}[1-9]")

        for line in sata_global.server_ssh.stdout.splitlines():
            # add disk part，if disk has been mount，skip
            disk = line.split(" ")[0]
            if disk in mount_info:
                continue
            disks_part.append(disk)
        return disks_part

    @classmethod
    def del_disk_part(cls, disks="sda"):
        """
        Function Description:
        delete disk partitioning
        Parameters:
        @ disk  disk name
        """
        if not isinstance(disks, list):
            disks = [disks]
        for disk in disks:
            # 如果盘正在做系统盘启动，则跳过不删除分区
            sata_global.server_ssh.send_command(f"lsblk | grep {disk}")
            if "efi" in sata_global.server_ssh.stdout:
                continue
            sata_global.server_ssh.send_command("lsblk -l | grep {} | wc -l".format(disk.split('/')[-1]))
            part_num = int(sata_global.server_ssh.stdout)

            # check whether the disk exists
            sata_global.server_ssh.send_command("ls {}".format(disk))
            if sata_global.server_ssh.stdout in ("", b""):
                msg_center.error("The disk {} does not exist".format(disk))
                return False

            for i in range(part_num - 1):
                # Disk partitioning
                command = "fdisk {} << EOF\nd\n\n\nw\nEOF\n".format(disk)
                sata_global.server_ssh.send_command(command)
                if "The partition table has been altered" not in sata_global.server_ssh.stdout:
                    msg_center.error("The disk %s delete partition fail", disk)
                    return False

            # check whether partitioning success
            sata_global.server_ssh.send_command("lsblk -l | grep {} | wc -l".format(disk))
            if int(sata_global.server_ssh.stdout) > 1:
                msg_center.error("The disk %s not really delete part", disk)
                return False
        return True

    @classmethod
    def format_disk(cls, disks="/dev/sdb", mkfs_ext="mkfs.ext4"):
        """
        format disk
        """
        if not isinstance(disks, list):
            disks = [disks]
        for disk in disks:
            # format disk
            sata_global.server_ssh.send_command('echo "y" | {} {} > /dev/null 2>&1'.format(mkfs_ext, disk))
            if sata_global.server_ssh.stdout not in ("", b"", None):
                msg_center.error("Format the disk %s failed", disk)
                return False
        return True

    @classmethod
    def mount_disk_part(cls, disks="/dev/sdb", path="/mnt"):
        """
        mount disk part
        """
        if not isinstance(disks, list):
            disks = [disks]
        for disk in disks:
            # check whether the disk in /dev/
            sata_global.server_ssh.send_command('find /dev/ -name {}'.format(disk.split("/")[-1]))
            disk_name = sata_global.server_ssh.stdout
            if disk_name in ("", b"", None):
                msg_center.error("can't find %s in /dev/", disk)
                return False

            # if the has been mount then umount
            sata_global.server_ssh.send_command('mount | grep -w "^{}"'.format(disk_name))
            if sata_global.server_ssh.stdout not in ("", b"", None):
                cls.umount_disk_part(disk=disk_name)

            # mount disk -t：指定档案系统的型态，通常不必指定。mount 会自动选择正确的型态。
            sata_global.server_ssh.send_command('mount {} {} > /dev/null 2>&1'.format(disk_name, path))

            # check whether the disk mount success
            sata_global.server_ssh.send_command('mount | grep -w "^{}"'.format(disk_name))
            if sata_global.server_ssh.stdout in ("", b"", None):
                cls.umount_disk_part(disks=disk_name)
                msg_center.error("mount the disk %s failed", disk_name)
                return False
        return True

    @classmethod
    def umount_disk_part(cls, disks="/dev/sdb"):
        """
        umount disk part
        """
        if not isinstance(disks, list):
            disks = [disks]
        for disk in disks:
            # check whether the disk in /dev/
            sata_global.server_ssh.send_command('find /dev/ -name {}'.format(disk.split("/")[-1]))
            disk_name = sata_global.server_ssh.stdout
            if disk_name in ("", b"", None):
                msg_center.error("can't find %s in /dev/", disk)
                return False
            sata_global.server_ssh.send_command('umount {}'.format(disk_name))
        return True

    @classmethod
    def check_cmdline(cls, paras="pci=nomsi"):
        """
        检查启动参数
        """
        if not isinstance(paras, list):
            paras = [paras]
        sata_global.server_ssh.send_command(f"cat {scfg.CMDLINE}")
        for para in paras:
            if para not in sata_global.server_ssh.stdout:
                msg_center.error(f"当前环境不是{para}模式，不满足测试环境需求")
                return False
        return True

    @classmethod
    def check_pagesize(cls, exp_pagesize=4):
        """
        检查pagesize
        """
        sata_global.server_ssh.send_command(f"getconf PAGESIZE")
        if "getconf: not found" not in sata_global.server_ssh.stdout:
            pagesize = int(sata_global.server_ssh.stdout.strip()) / 1024
            if pagesize != exp_pagesize:
                msg_center.error(f"当前环境不是{pagesize} = {exp_pagesize}模式，不满足测试环境需求")
                return False
        else:
            sata_global.server_ssh.send_command(f"cd /proc/1")
            sata_global.server_ssh.send_command(f"grep -i pagesize smaps")
            for line in sata_global.server_ssh.stdout.splitlines():
                pagesize = int(line.split(":")[-1].strip().split(" ")[0])
                if pagesize != exp_pagesize:
                    msg_center.error(f"当前环境不是{pagesize} = {exp_pagesize}模式，不满足测试环境需求")
                    return False
        return True

    @classmethod
    def zcat_config(cls, item="SMMU", exp_res="y"):
        """
        获取编译项
        """
        sata_global.server_ssh.send_command(f"zcat {scfg.CONFIGGZ} | grep {item}")
        for line in sata_global.server_ssh.stdout.splitlines():
            if "#" in line:
                continue
            else:
                res = line.split("=")[-1].strip()
                if res != exp_res:
                    msg_center.error(f"当前环境不是{item} = {exp_res}模式，不满足测试环境需求")
                    return False
        return True

    @classmethod
    def check_cp_tools(cls, tool_names=scfg.DISKTOOL):
        """
        检查拷贝工具
        """
        if not isinstance(tool_names, list):
            tool_names = [tool_names]
        cmdos = CmdOs(terminal=sata_global.server_ftp)
        for tool_name in tool_names:
            msg_center.info(f"检查{tool_name}工具是否存在")
            sata_global.server_ssh.send_command(f"{tool_name}")
            if sata_global.server_ssh.stdout in ("", None):
                msg_center.info(f"拷贝{tool_name}工具")
                local = os.path.join(ROOTDIR, "tools", scfg.DISKTOOL)
                cmdos.scp_push_file(local_path=local,
                                    remote_path=f"/usr/sbin/{tool_name}",
                                    chmod="755")

    @classmethod
    def check_fio_process(cls, number=1, seconds=90, process="fio.conf"):
        """
        function describe: 检查FIO是否已执行起来，主要是为了FPGA 低功耗用例设计；
        FPGA上下发FIO后真正有io需要一段时间，这样会导致唤醒比较慢，用例不容易判断，增加此方法确认IO执行起来后再检查
        number：FIO进程个数，一个终端下发进程+每个盘子进程（有多少块盘就有多少个子进程）
        seconds：循环检查的超时时间
        process：进程名称或路径
        """
        while seconds > 0:
            sata_global.server_ssh.send_command(f"ps -ef | grep '{process}' | grep -v grep | wc -l ")
            if int(sata_global.server_ssh.stdout) >= number:
                break
            msg_center.info(f"预期结果是： {number}, 但实际结果是：{int(sata_global.server_ssh.stdout)}")
            time.sleep(1)
            msg_center.info("FIO进程还没好，请等待.....")
            seconds -= 1
        else:
            msg_center.error("FIO进程个数不符合预期。")
            sata_global.server_ssh.send_command(f"ps -ef | grep 'fio'")
            return False
        return True

    @classmethod
    def sata_set_devmem(cls, offset='', setup="", value="", peh=False, port='', sata_base_addr=scfg.SATA_ADDR):
        '''
        function describe:修改寄存器
        offset ：寄存器偏移地址
        setup: 需要设置寄存器值时设置为32
        value : 要设置寄存器的值
        peh：使用sata peh基址计算
        return:(结果码，命令执行结果)
        结果码：0 结果正确； 1 结果错误;
        命令执行结果：返回一个str, 记录下发命令后的回显信息
        使用实例：retcode, type = SataLib.sata_set_devmem("0xa2002800","32","0x6")
        '''
        retcode = 1
        retstr = ""

        if peh is False:
            if port == '':
                addr_tmp = hex(int(sata_base_addr, 16) + int(offset, 16))
                addr = addr_tmp.split('L')[0]
            else:
                addr_tmp = hex(
                    int(sata_base_addr, 16) + int('0x100', 16) + int(port) * int('0x80', 16) + int(offset, 16))
                addr = addr_tmp.split('L')[0]
        else:
            addr_tmp = hex(int(scfg.SATA_PEH_BASE_ADDR, 16) + int(offset, 16))
            addr = addr_tmp.split('L')[0]
        cmd = f"{scfg.DEVMEM} %s %s %s" % (addr, setup, value)
        retstr_tmp = sata_global.server_ssh.send_command(cmd)
        retstr = retstr_tmp.replace(cmd.strip(), "").strip()
        if "not found" not in retstr:
            retcode = 0

        return retcode, retstr

    @classmethod
    def sata_set_dword_bit(cls, dword, bit, bits=1):
        '''
        function describe:设置十六进制字符内指定的bit位
        dword:十六进制字符；
        bit:指定的位
        bits:bits预期的值1
        return:(结果码，命令执行结果)
        结果码：0 结果正确； 1 结果错误;
        命令执行结果：返回一个str, 指定bit位的值
        使用实例：retcode, retstr = SataLib.sata_set_dword_bit("0x2","2")
        '''
        retcode = 1  # 默认是1
        retstr = ''
        word = dword
        if not dword or not bit:
            retcode = 1
            retstr = "参数错误"
            return retcode, retstr

        retstr_num = bin(int(dword, 16))[2:]
        retstr_bit = '0b' + (32 - len(retstr_num)) * '0' + retstr_num
        msg_center.info("...............retstr_bit")
        bit = int(bit)
        msg_center.info("retstr_bit:%s" % retstr_bit)
        bit += 1
        if bits == 1:
            msg_center.info(".....retstr")
            s = list(retstr_bit)
            s[-bit] = "1"
            retult = ''.join(s)
            msg_center.info(".....retult")
            if retult[-bit] == "1":
                retcode = 0
                msg_center.info("bit修改为%s" % retult)
                retstr = hex(int(retult, 2)).split('L')[0]
                msg_center.info(".....retstr")
                msg_center.info("addr_tmp为%s" % retstr)
        elif bits == 0:
            s = list(retstr_bit)
            s[-bit] = "0"
            retult = ''.join(s)
            msg_center.info(".....retult")
            if retult[-bit] == "0":
                retcode = 0
                msg_center.info("bit修改为%s" % retult)
                retstr = hex(int(retult, 2)).split('L')[0]
                msg_center.info(".....retstr")
                msg_center.info("addr_tmp为%s" % retstr)
            else:
                retcode = 1

                msg_center.info("bit%s为0" % bit)
                return retcode, retult

        return retcode, retstr

    @classmethod
    def sata_check_dword_bit(cls, dword, bit, bits=1):
        '''
        function describe:检查十六进制字符内指定的bit位
        dword:十六进制字符；
        bit:指定的位
        bits:bits预期的值1
        return:(结果码，命令执行结果)
        结果码：0 结果正确； 1 结果错误;
        命令执行结果：返回一个str, 指定bit位的值
        使用实例：retcode, retstr = SataLib.sata_check_dword_bit("0x2","2")
        '''
        retcode = 1  # 默认是1
        retstr = ''
        if dword is None or bit is None:
            retcode = 1
            retstr = "参数错误"
            return retcode, retstr

        retstr_num = bin(int(dword, 16))[2:]
        retstr_bit = '0b' + (32 - len(retstr_num)) * '0' + retstr_num
        msg_center.info("retstr_bit:%s" % retstr_bit)
        bit = int(bit)
        if bits == 1:
            if len(retstr_bit) >= bit:
                retstr = retstr_bit[-(bit + 1)]
                if str(retstr) == "1":
                    retcode = 0
                else:
                    retcode = 1
                    msg_center.info("bit%s为0" % bit)
            else:
                retcode = 1
                retstr = "该bit位为0"
                msg_center.info("bit%s为0,与预期值不符合" % bit)
        elif bits == 0:
            if len(retstr_bit) >= bit:
                retstr = retstr_bit[-(bit + 1)]
                if str(retstr) == "0":
                    retcode = 0
                else:
                    retcode = 1
                    msg_center.info("bit%s为1,与预期值不符合" % bit)
            else:
                retcode = 0
                retstr = "该bit位为0"
                msg_center.info("bit%s为0" % bit)

        return retcode, retstr
