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
import time
import re
import random
from kp_comm import CmdOs
from kp_comm.drive import CmdDrive
THIS_FILE_PATH = os.path.dirname(os.path.realpath(__file__))

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_global import engine_global
from test_config.feature_config.sas_config import sas_config as scfg
from test_config.feature_config.sas_config.sas_config import sas_global, sas_config
from kp_devinfo.debugfs.sas import SasDebugfs as SasDfx
from kp_devinfo.device.sas import SasDevice


class SasUtil:
    """
    SAS模块公共库函数
    """

    @staticmethod
    def sas_insmod_ko(**kwargs):
        """
        加载sas驱动
        ：param main_param：main驱动的参数,例如 debugfs_enable=1
        ：param v3_param: v3驱动的参数, 例如: prot_mask=0x77
        :return: 失败返回False，成功返回True
        """
        main_para = kwargs.get("main_param", None)
        v3_para = kwargs.get("v3_param", None)
        # 实例化
        cmd_dri = CmdDrive(terminal=sas_global.server_ssh)
        # 如果检测到v3驱动，则卸载驱动
        if cmd_dri.lsmod_ko(sas_config.sas_v3)[0] == SUCCESS_CODE:
            # 检查v3驱动是否被占用
            if SasUtil.check_mod_used(check_name="hisi_sas_v3_hw", check_num=0, check_time=60) is False:
                return False
            if cmd_dri.rmmod_ko([sas_config.sas_v3, sas_config.sas_main]) != SUCCESS_CODE:
                return False

        msg_center.info('开始加载hisi_sas_main.ko')
        main_ko = ["{}/{}".format(sas_global.modules, sas_config.sas_main_ko)]
        if main_para:
            # main驱动有参数分支
            sas_global.server_ssh.send_command('insmod {} {}'.format(main_ko[0], main_para))
            if cmd_dri.lsmod_ko(sas_config.sas_main) == FAILURE_CODE:
                return False
        else:
            if cmd_dri.insmod_ko(main_ko) != SUCCESS_CODE:
                return False

        msg_center.info('开始加载hisi_sas_v3_hw.ko')
        v3_ko = ["{}/{}".format(sas_global.modules, sas_config.sas_v3_ko)]
        if v3_para:
            # v3驱动有参数分支
            sas_global.server_ssh.send_command('insmod {} {}'.format(v3_ko[0], v3_para))
            if cmd_dri.lsmod_ko(sas_config.sas_v3) == FAILURE_CODE:
                return False
        else:
            if cmd_dri.insmod_ko(v3_ko) != SUCCESS_CODE:
                return False

        # 检查v3驱动是否被占用
        if SasUtil.check_mod_used(check_name="hisi_sas_v3_hw", check_num=0, check_time=60) is True:
            return True
        else:
            return False

    @staticmethod
    def get_disk_numb():
        """
        获取磁盘数量,不包含es3000
        :return:int(ret),type:int
        """
        cmd = 'lsscsi -p | grep -v "nvme" | grep disk | wc -l'
        ret_str = sas_global.server_ssh.send_command(cmd)
        msg_center.info('disk numb is {0}'.format(ret_str))
        return int(ret_str)

    @staticmethod
    def check_disk_num(number=12, seconds=200):
        """
        check disk number,规定时间内检查磁盘有没有全部加载完成,一般用在驱动加载完成后
        number：检查盘的数量
        seconds：超时秒数
        """
        while seconds > 0:
            # 磁盘数量判断
            cmd = 'lsscsi -t | grep disk | grep sas | wc -l'
            disk_sas = sas_global.server_ssh.send_command(cmd)
            if number == int(disk_sas):
                break
            msg_center.info("type(number): %s, number= %s", type(number), number)
            time.sleep(1)
            msg_center.info("the disk num is not readly ,please wait.....")
            seconds -= 1
        else:
            msg_center.error("the number of disk is less")
            return False
        # 数量检查正确则返回True
        return True

    @staticmethod
    def clean_dif(**kwargs):
        """
        清理DIF盘
        :disk: disk=["sda"]则清除指定盘,支持多个盘，disk=["all"]则清除所有DIF盘
        :return:成功返回True，失败返回False,没有DIF盘则返回2
        例如: clean_dif(disk=["sda"])
        """
        disk = kwargs.get("disk", ["all"])
        # 判断是否有DIF盘
        cmd1 = 'lsscsi -p | grep "DIF/Type"'
        ret_str = sas_global.server_ssh.send_command(cmd1)
        if ret_str:
            msg_center.info("DIF exists")
            if disk[0] == "all":
                cmd = "lsscsi -p | grep 'DIF/Type' |awk '{{print $6}}' |awk -F '/' '{{print $3}}'"
                dif_list = sas_global.server_ssh.send_command(cmd).split()
            else:
                dif_list = disk
            # 格式化DIF盘
            for i in dif_list:
                msg_center.info(f'start to format DIF {i}')
                sas_global.server_ssh.send_command(f'sg_format -F -s 512 /dev/{i}')
                time.sleep(2)
            # 判断DIF是否清理完成
            ret_str = sas_global.server_ssh.send_command(cmd1)
            if not ret_str:
                msg_center.error("DIF is cleaned")
                return True
            else:
                msg_center.error("DIF clear failed")
                return False
        else:
            msg_center.info('No DIF')
            return True

    @staticmethod
    def open_dfx(controller='', run_dfx=1):
        """
        :Description：打开DFX，内核比较旧的参数是参数是main驱动里打开'debugfs_enable=1'，新的是在run_dfx打开
        :param controller: 控制器bus号,没有则默认全部控制器
        :param run_dfx: run_dfx要设置的值
        """
        # 判断是否有控制器bus输入，没有则默认全部控制器
        if controller and not isinstance(controller, list):
            controller_list = [controller]
        else:
            controller_list = sas_config.con_bus
        # dfx打开或者关闭
        for bdf in controller_list:
            sasdfx = SasDfx(bdf, terminal=sas_global.server_ssh)
            msg_center.info("The run_dfx status is {}".format(sasdfx.run_dfx))
            sasdfx.run_dfx = run_dfx

    @staticmethod
    def check_dfx(controller='', run_dfx=1, check_time=10):
        """
        :Description：检查dfx打开的情况
        :param controller: 控制器bus号,没有则默认全部控制器
        :param run_dfx: run_dfx的值
        :param check_time:检查时间
        """
        # 检查时间
        i = check_time
        # 判断是否有控制器bus输入，没有则默认全部控制器
        if controller and not isinstance(controller, list):
            controller_list = [controller]
        else:
            controller_list = sas_config.con_bus
        # dfx打开或者关闭
        for bdf in controller_list:
            sasdfx = SasDfx(bdf, terminal=sas_global.server_ssh)
            while i > 0:
                if sasdfx.run_dfx == str(run_dfx):
                    break
                else:
                    i -= 1
                    time.sleep(1)
            # 超时返回False
            else:
                msg_center.error("Opening run_dfx is failed")
                return False

    @staticmethod
    def make_trigger_dump(controller, dump_time: int):
        """
        使用trigger_dump
        controller: 控制器bus号
        dump_time: dump次数
        """
        # 实例化
        sasdfx = SasDfx(controller, terminal=sas_global.server_ssh)
        for i in range(dump_time):
            sasdfx.trigger_dump = "1"
            time.sleep(1)

    @staticmethod
    def check_trigger_dump(controller) -> int:
        """
        根据传进去的控制器返回dump次数
        """
        # 检查dump目录下文件数，从0开始，每个目录表示一次dump
        cmd = "ls {}/{}/dump".format(sas_config.bus_path, controller)
        ret_str = sas_global.server_ssh.send_command(cmd)
        return int(ret_str)

    @staticmethod
    def make_host_reset(controller, dump_time: int, check_time=30):
        """
        host_reset为控制器复位,带有检查host_reset成功
        :param controller: 控制器bus号
        :param dump_time: dump次数
        :param check_time:检查时间
        :return 成功返回True，失败返回False
        """
        for i in range(dump_time):
            # 获取控制器复位前复位成功次数
            cmd1 = 'dmesg | grep "controller reset complete" | wc -l'
            reset_time1 = sas_global.server_ssh.send_command(cmd1)
            # 寻找控制器复位地址
            cmd2 = "find /sys/devices -name host_reset | grep {}".format(controller)
            host_reset = sas_global.server_ssh.send_command(cmd2)
            # 控制器复位操作
            cmd3 = "echo adapter > {}".format(host_reset)
            sas_global.server_ssh.send_command(cmd3)

            # 检查复位是否成功
            j = check_time
            while j > 0:
                # 获取控制器复位后复位成功次数
                reset_time2 = sas_global.server_ssh.send_command(cmd1)
                # 控制器复位后complete次数-控制器复位前complete次数=1
                turn = int(reset_time2) - int(reset_time1)
                if turn == 1:
                    msg_center.info('host_reset check success')
                    continue
                else:
                    msg_center.info('Host_reset is checking, please wait')
                    time.sleep(1)
                    j -= 0
            else:
                # 超时判断失败
                msg_center.error('host_reset check fail')
                return False
        # 全部dump成功后返回True
        return True

    @staticmethod
    def get_path(disk, get_phy=False, num="", seconds=30, **kwargs):
        """
        根据硬盘获取路径
        bpath -> disk path 硬盘所在完整路径,例如：
        /sys/devices/pci0000:b4/0000:b4:02.0/host6/port-6:0/end_device-6:0/target6:0:0/6:0:0:0
        cpath -> controller path,例如：
        /sys/devices/pci0000:b4/0000:b4:02.0
        hostx -> host number,例如：host6
        cppath -> controller power path,例如:/sys/devices/pci0000:b4/0000:b4:02.0/power
        chpath -> controller host path,例如：/sys/devices/pci0000:b4/0000:b4:02.0/host6
        cfpath -> controller flr path,例如：/sys/bus/pci/devices/0000:b4:02.0
        ppaths -> 所有硬盘的power所在路径完整路径，type:list, 例如
        [/sys/devices/pci0000:b4/0000:b4:02.0/host6/port-6:0/end_device-6:0/target6:0:0/6:0:0:0/power]
        ：param disk : type str, 硬盘，例如：sda
        ：param get_phy: type bool, 是否要获取盘的phy，默认不获取
        ：param num: type str, all 表示获取所有盘的完整路径
        ：param seconds，type int, 超时秒数
        ：return path_dict : type dict, 根据键值储存的各种路径,支持expander背板，例如
        {'bpath': '/sys/devices/pci0000:74/0000:74:02.0/host4/port-4:0/expander-4:0/port-4:0:0/end_device-4:0:0/
        target4:0:0/4:0:0:0',
        'cpath': '/sys/devices/pci0000:74/0000:74:02.0',
        'hostx': 'host4',
        'cppath': '/sys/devices/pci0000:74/0000:74:02.0/power',
        'cppaths': ['0000:74:02.0', '0000:74:04.0', '0000:b4:02.0', '0000:b4:04.0'],
        'chpath': '/sys/devices/pci0000:74/0000:74:02.0/host4', 'cfpath': '/sys/bus/pci/devices/0000:74:02.0',
        'ppaths': ['/sys/devices/pci0000:74/0000:74:02.0/host4/port-4:0/expander-4:0/port-4:0:0/end_device-4:0:0/
        target4:0:0/4:0:0:0/power'],
        'disk_phy': 'phy-4:0:0',
        'sysfs_phy_path': '/sys/class/sas_phy/phy-4:0:0',
        'phy': '0'}

        """
        bpath = ''
        ppaths = list()
        path_dict = dict()
        disk_phy = ''
        sysfs_phy_path = ''
        phy = ''

        # 获取单个硬盘的完整路径
        cmd = "lsscsi -v | grep '/dev/{}' -A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1".format(disk)
        while int(seconds) > 0:
            ret_str = sas_global.server_ssh.send_command(cmd)
            if ret_str not in ("", b"", None) and len(ret_str.split('/')) >= 10:
                bpath = ret_str
                break
            time.sleep(1)
            seconds -= 1
        cpath = "/sys/devices/{}/{}".format(bpath.split("/")[3], bpath.split("/")[4])
        hostx = bpath.split("/")[5]
        cppath = "{}/{}".format(cpath, "power")
        cppaths = sas_config.con_bus
        chpath = "{}/{}".format(cpath, hostx)
        cfpath = "{}/{}".format("/sys/bus/pci/devices", bpath.split("/")[4])

        # 获取磁盘的power路径
        if num == "all":
            # 获取全部磁盘的power路径
            disk = "sd[a-z]"
        if num == "one":
            # 获取单个磁盘的power路径
            disk = disk
        # 获取磁盘power路径开关
        if num:
            cmd = "lsscsi -v | grep '/dev/{}' -A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1".format(disk)
            ret_str = sas_global.server_ssh.send_command(cmd)
            for line in ret_str.splitlines():
                line = "{}/power".format(line)
                ppaths.append(line.strip())

        # 获取磁盘所在的phy开关
        if get_phy:
            disk_phy = sas_global.server_ssh.send_command("ls {}/../../../ | grep phy".format(bpath))
            sysfs_phy_path = "/sys/class/sas_phy/phy-%s" % (disk_phy.split("-")[1])
            phy = disk_phy.split("-")[1].split(":")[-1]

        # 存入字典
        path_dict["bpath"] = bpath
        path_dict["cpath"] = cpath
        path_dict["hostx"] = hostx
        path_dict["cppath"] = cppath
        path_dict["cppaths"] = cppaths
        path_dict["chpath"] = chpath
        path_dict["cfpath"] = cfpath
        path_dict["ppaths"] = ppaths
        path_dict["disk_phy"] = disk_phy
        path_dict["sysfs_phy_path"] = sysfs_phy_path
        path_dict["phy"] = phy

        return path_dict

    @staticmethod
    def check_rate(phy_id: str, rate_type: str):
        """
        :Description：用于查看phy的速率,可查看maximum_linkrate，minimum_linkrate，negotiated_linkrate
        :param phy_id:例如
        :param rate_type: maximum_linkrate，minimum_linkrate，negotiated_linkrate
        """
        # 传入句柄
        sasdev = SasDevice(phy_id, terminal=sas_global.server_ssh)
        if rate_type == "maximum_linkrate":
            rate = sasdev.maximum_linkrate
        elif rate_type == "minimum_linkrate":
            rate = sasdev.minimum_linkrate
        elif rate_type == "negotiated_linkrate":
            rate = sasdev.negotiated_linkrate
        else:
            msg_center.error("Wrong rate. Please check input")
            return False

        return rate

    @staticmethod
    def set_rate(phy_id: str, rate_type: str, rate_set: str):
        """
        :Description：用于设置phy的速率
        :param phy_id:例如：phy-4:0
        :param rate_type:maximum_linkrate，minimum_linkrate
        """
        # 传入句柄
        sasdev = SasDevice(phy_id, terminal=sas_global.server_ssh)
        if rate_type == "maximum_linkrate":
            sasdev.maximum_linkrate = rate_set
            return True
        elif rate_type == "minimum_linkrate":
            sasdev.minimum_linkrate = rate_set
            return True
        else:
            msg_center.error("Wrong rate. Please check input")
            return False

    @staticmethod
    def get_disk(disk_type) -> list:
        """
        :Description：获取os中需要测试的硬盘,sas,sata和dif盘
        :disk type:sas,sata和dif
        :return 盘符列表
        """
        cmd = ""
        # 获取SATA盘
        if disk_type == "sata":
            cmd = "lsscsi -p | grep ATA | grep disk | awk -F '/' '{{print $3}}'| awk '{{print $1}}'"
        # 获取不是DIF盘的SAS盘
        elif disk_type == "sas":
            cmd = "lsscsi -p | grep -Eiv 'ATA|nvme|DIF/Type' | grep disk | awk -F '/' '{{print $3}}'| \
                    awk '{{print $1}}'"
        # 获取DIF盘
        elif disk_type == "dif":
            # 获取可测试的sas硬盘
            cmd = "lsscsi -p | grep DIF/Type | awk -F '/' '{{print $3}}'| awk '{{print $1}}'"
        ret_list = sas_global.server_ssh.send_command(cmd).split()
        # 排除sata控制器下的SATA盘
        sata_list = sas_global.server_ssh.send_command("lsscsi -t | grep sata | awk -F '/' '{{print $3}}'").split()
        for disk in sata_list:
            if disk in ret_list:
                ret_list.remove(disk)
        msg_center.info("{} list is {}".format(disk_type, ret_list))
        return ret_list

    @staticmethod
    def get_controller_register_value(controller, phy_id: int, controller_value: str):
        """
        :Description：获取phy寄存器的地址的值
        :controller：控制器bug号
        :phy_id：phy的identity，数值为0-7
        :controller_value：phy寄存器的地址
        :return: addr_value，返回十六进制的控制器寄存器地址值
        """
        cmd = "lspci -vvv -s %s | grep Memory | sed -n p | awk -F' ' '{print $5}'" % controller
        addr_hex_str = sas_global.server_ssh.send_command(cmd)
        addr_int = int(addr_hex_str, 16) + (int('2000', 16) + int('400', 16) * phy_id) + int(controller_value, 16)
        addr_hex = hex(addr_int)
        cmd = 'busybox devmem {0}'.format(addr_hex)
        addr_value_hex_str = sas_global.server_ssh.send_command(cmd)
        addr_value = hex(int(addr_value_hex_str, 16))
        msg_center.info('success: The register address value of controller:{0} is {1}'.format(controller, addr_value))

        return addr_value

    @staticmethod
    def check_fifo_status(controller, phy_num: int, conf_file: list = None, expect_dir: dir = None):
        """
        检查fifo配置文件预期值和实际值是否相等，传入相等的键才能判断成功
        controller: 控制器
        phy_num:例如 0
        conf_file: fifo配置文件,列表例如 ['signal_sel', 'dump_msk', 'dump_mode']
        expect_dir: 配置文件预期值
        """
        sasdfx = SasDfx(controller, terminal=sas_global.server_ssh)
        # 获取fifo配置文件的实际值
        real_value = sasdfx.get_fifo_attr(phy_num, conf_file)
        # 字典形式
        real_dir = dict(zip(conf_file, real_value))
        # 16进制转换
        for key in real_dir:
            real_dir[key] = hex(int(real_dir[key], 16))
        # 预期值
        for key in expect_dir:
            expect_dir[key] = hex(int(expect_dir[key], 16))
        # 判断是否相等
        differ = set(expect_dir.items()) ^ set(real_dir.items())
        return True if not differ else False

    @staticmethod
    def switch_controller_bind(controller, status):
        """
        bind或者unbind控制器
        controller: 控制器bus号
        status: bind 或者 unbind
        """
        cmd = "echo {} > /sys/bus/pci/drivers/hisi_sas_v3_hw/{}".format(controller, status)
        sas_global.server_ssh.send_command(cmd)
        msg_center.info("{} success: The controller {] is {}ed successfully".format(status, controller, status))
        # 检查控制器是否存在
        cmd = "ls /sys/kernel/debug/hisi_sas/ | grep {0}".format(controller)
        result = sas_global.server_ssh.send_command(cmd)
        # unbind分支：预期结果控制器不存在
        if status == "unbind":
            if not result:
                msg_center.info("{} check success".format(status))
                return True
            else:
                msg_center.error("{} check fail".format(status))
                return False
        # bind分支：预期结果控制器存在
        elif status == "bind":
            if result:
                msg_center.info("{} check success".format(status))
                return True
            else:
                msg_center.error("{} check fail".format(status))
                return False

    @staticmethod
    def get_reg_info(devices):
        """
        功能描述：get sas controller and resgiter
        """

        if "0000:74:02.0" in devices:
            return "0xa2000000", "0x140090008"
        if "0000:74:04.0" in devices:
            return "0xa2008000", "0x140090008"
        if "0000:b4:02.0" in devices:
            return "0xa3000000", "0x200140090008"
        if "0000:b4:04.0" in devices:
            return "0xa3008000", "0x200140090008"
        if "0000:30:04.0" in devices:
            return "0xa0200000", "0x0"

    @staticmethod
    def format_dif(disk: str, enable_dif=False, **kwargs):
        """
        格式化DIF盘
        :eg kwargs = {"main_param": "debugfs_enable=1", "v3_param": "prot_mask=0x77"}
        :disk: 格式化指定盘
        :return:成功返回True，失败返回False
        """
        # 卸载驱动前获取磁盘数
        disk_numb = SasUtil.get_disk_numb()
        # 格式化dif盘
        cmd = "sg_format --format --fmtpinfo=3 --pfu=1 /dev/{}".format(disk)
        sas_global.server_ssh.send_command(cmd)
        ret_code = sas_global.server_ssh.ret_code
        if not ret_code:
            if not enable_dif:
                msg_center.info("{} format success.".format(disk))
                return True
            else:
                # dif盘格式化后驱动被占用，需wait 5s等待驱动被释放
                time.sleep(5)
                # 加载驱动
                SasUtil.sas_insmod_ko(**kwargs)
                # 检查磁盘全部在位
                SasUtil.check_disk_num(disk_numb)
                # 检查DIF使能正确
                ret_code = SasUtil.check_dif_enable()
                if ret_code:
                    msg_center.info("dif enable CRC success")
                    return True
                else:
                    msg_center.error("dif enable CRC fail")
                    return False
        else:
            msg_center.error("{} format fail.".format(disk))
            return False

    @staticmethod
    def check_dif_enable(seconds=30):
        """
        check dif enable CRC,规定时间内检查dif磁盘有没有使能CRC,一般用在驱动加载完成后
        seconds：超时秒数
        """
        while seconds > 0:
            # 磁盘数量判断
            cmd = "lsscsi -p | grep CRC"
            sas_global.server_ssh.send_command(cmd)
            ret_code = sas_global.server_ssh.ret_code
            if not ret_code:
                break
            time.sleep(1)
            msg_center.info("the disk enable_dif is not readly ,please wait.....")
            seconds -= 1
        else:
            msg_center.error("the disk enable_dif is fail")
            return False
        return True

    @staticmethod
    def init_tools():
        """
        sas工具准备，从仓库拷贝到板子上
        """
        tools = ["disktool"]
        # 句柄封装
        handle = sas_global.server_ssh.send_command
        # 日志目录封装
        log_path = engine_global.project.base_dir_path
        # 拷贝工具
        sas_global.server_scp.push(local=sas_config.disktool_path, remote=log_path, chmod=755)
        sas_global.disktool = f"{log_path}/disktool"
        result = handle(f"ls {log_path}")
        # 检查目录
        for i in tools:
            if i in result:
                msg_center.info(f"{i} check SUCCESS!")
                continue
            else:
                msg_center.info(f"{i} check Fail! Please check environment.")
                return False

    @staticmethod
    def check_mod_used(check_name: str, check_num: int, check_time: int):
        """
        功能呢描述：检查驱动模块被占用情况，主要用于驱动加载成功后硬盘加载完成不占用驱动
        check_name：驱动名
        check_num：占用数
        check_time：检查时间
        """
        cmd = f"lsmod | grep -m1  {check_name}  | awk -F ' ' '{{print $3}}'"
        ret_str = ""
        while check_time > 0:
            ret_str = sas_global.server_ssh.send_command(cmd)
            # 检查成功后退出循环
            if f"{check_num}" == ret_str:
                break
            time.sleep(1)
            check_time -= 1
        else:
            msg_center.error(f"The used of {check_name} is {ret_str}. But expected {check_num}. Check failed.")
            return False
        # 检查成功
        return True

    @classmethod
    def get_disk_num(cls):
        """
        get disk number
        """
        sas_global.server_ssh.send_command("fdisk -l | grep 'Disk /dev/sd' | wc -l")
        all_disk_num = int(sas_global.server_ssh.stdout)
        sas_global.server_ssh.send_command(f"{scfg.lsscsi_tool} -t | grep -v 'sas'")
        sata_controller_disk = re.findall(r'/dev/(sd[a-z])', sas_global.server_ssh.stdout)
        sata_disk_num = len(sata_controller_disk)
        disk_num = all_disk_num - sata_disk_num
        return disk_num

    @classmethod
    def check_inter_storm_suppress(cls, device):
        """
        function describe:检查中断风暴抑制，如果当前处于抑制状态，echo解除
        """
        # FPGA没有中断风暴抑制
        if 'fpga' in sas_global.bios_version.lower():
            msg_center.info("当前测试环境，无中断风暴抑制，注错之前无需检查中断风暴抑制状态......")
        else:
            msg_center.info("检查中断风暴抑制状态......")
            for addr in scfg.sas_rasstorm.get(device).get('reg_addrs'):
                msg_center.info(f"查询{addr}中断使能是否中断风暴抑制，如果抑制了设置寄存器取消抑制")
                sas_global.server_ssh.send_command(f"{scfg.devmem} {addr}")
                if sas_global.server_ssh.stdout != scfg.sas_rasstorm.get(device).get('defvalue'):
                    sas_global.server_ssh.send_command(
                        f"{scfg.devmem} {addr} 32 {scfg.sas_rasstorm.get(device).get('defvalue')}")

    @classmethod
    def check_fio_process(cls, number=1, seconds=90, process="fio.conf"):
        """
        function describe: 检查FIO是否已执行起来，主要是为了FPGA 低功耗用例设计；
        FPGA上下发FIO后真正有io需要一段时间，这样会导致唤醒比较慢，用例不容易判断，增加此方法确认IO执行起来后再检查
        number：FIO进程个数，一个终端下发进程+每个盘子进程（有多少块盘就有多少个子进程）
        seconds：循环检查的超时时间
        process：进程名称或路径
        """
        if sas_global.kasan_cfg in ("", " ", None):
            while seconds > 0:
                sas_global.server_ssh.send_command(f"ps -ef | grep '{process}' | grep -v grep | wc -l ")
                if int(sas_global.server_ssh.stdout) >= number:
                    break
                msg_center.info(f"预期结果是： {number}, 但实际结果是：{int(sas_global.server_ssh.stdout)}")
                time.sleep(1)
                msg_center.info("FIO进程还没好，请等待.....")
                seconds -= 1
            else:
                msg_center.error("FIO进程个数不符合预期。")
                sas_global.server_ssh.send_command(f"ps -ef | grep 'fio'")
                return False
        else:
            msg_center.info("当前是kasan版本，ps -ef命令卡住查询进程跳过")
        return True

    @classmethod
    def sas_kill_process(cls, cmd_os, process="fio"):
        """
        杀进程，主要是调了cmdos下的kill_process方法，且对kasan版本做规避
        """
        if sas_global.kasan_cfg in ("", " ", None):
            cmd_os.kill_process(process)
        else:
            sas_global.server_ssh.send_command(f"killall {process}")

    @classmethod
    def check_dmesg_log(cls, **args):
        """
        check log
        """
        disk = args.get("disk", "sda")
        switch = args.get("switch", None)
        logtype = args.get("logtype", "dmesglog")
        loginfo = args.get("loginfo", scfg.calltrace)

        excludelog = "NOHZ tick-stop error|EXT4-fs|usbhid"
        if logtype == "dmesglog":
            sas_global.server_ssh.send_command("dmesg | egrep -i '{}' | egrep -iv '{}'".format(loginfo, excludelog))
        elif logtype == "intrcoal":
            # egrep是grep的扩展和grep -e 是一样的
            # egrep可以支持元字符。'^'：指匹配的字符串在行首，'$'：指匹配的字符串在行尾，
            sas_global.server_ssh.send_command("dmesg | grep -ie '{}' | egrep -iv '{}'".format(loginfo, excludelog))
        else:
            sas_global.server_ssh.send_command("dmesg | grep -F '[{}] {} disk' | wc -l".format(disk, switch))
        return sas_global.server_ssh.stdout

    @classmethod
    def get_base_addr(cls, device):
        """
        功能描述：获取基地址
        """
        sas_global.server_ssh.send_command(f"cat /proc/iomem | grep '{device}'")
        try:
            sas_global.server_ssh.stdout.strip().split('-')[0]
        except IndexError:
            msg_center.error("基地址获取异常")
            return scfg.addr_default_value
        else:
            return sas_global.server_ssh.stdout.strip().split('-')[0]
        finally:
            pass

    @classmethod
    def get_test_device(cls):
        """
        功能：获取测试的SAS控制器设备
        """
        sas_global.test_device = sas_global.devices[0]
        # 适配OS组网（直连接2个控制器，一个接8盘一个接4盘组网），下面用例是对8个通道注错，需要获取接8盘的控制器
        sas_global.server_ssh.send_command(
            f"lsscsi -v | grep {sas_global.test_device} | wc -l")
        if int(sas_global.server_ssh.stdout) < 8 and len(sas_global.devices) == 2:
            sas_global.test_device = sas_global.devices[1]

        sas_global.base_addr = cls.get_base_addr(sas_global.test_device)

        if sas_global.base_addr == scfg.addr_default_value:
            return False
        return True

    @classmethod
    def get_devices_name(cls):
        """
        功能描述：获取当前盘接的控制器设备号
        """
        devices = set()
        # 过滤sas驱动下的盘， -A 1 向下多取一行
        sas_global.server_ssh.send_command(
            "lsscsi -tv | grep 'sas' -A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1")
        for line in sas_global.server_ssh.stdout.splitlines():
            if len(line.split('/')) >= 10:
                devices.add(line.split("/")[4])
        # python中集合set主要利用其唯一性，及并集|、交集&等操作，但不可以直接通过下标进行访问，必须访问时可以将其转换成list再访问
        return list(devices)

    @classmethod
    def get_all_disks(cls):
        """
        功能描述：Obtain the drive letter of the disk.
        """
        disks = dict(sas=list(), sata=list())
        # get sata disk
        sas_global.server_ssh.send_command("lsscsi -p | grep 'ATA'")
        lines = sas_global.server_ssh.stdout.splitlines()
        for line in lines:
            disk = line.split("/dev/")[-1].split()[0]
            sas_global.server_ssh.send_command(f"lsscsi -t | grep '{disk}'")
            # 硬盘挂载sas驱动下才需要
            if "sas" in sas_global.server_ssh.stdout:
                disks.get("sata").append(disk)

        # get sas disk
        sas_global.server_ssh.send_command("lsscsi -p | egrep -v 'ATA|Expander' | grep '/dev/sd[a-z]'")
        lines = sas_global.server_ssh.stdout.splitlines()
        for line in lines:
            disk = line.split("/dev/")[-1].split()[0]
            sas_global.server_ssh.send_command(f"lsscsi -t | grep '{disk}'")
            # 硬盘挂载sas驱动下才需要
            if "sas" in sas_global.server_ssh.stdout:
                disks.get("sas").append(line.split("/dev/")[-1].split()[0])
        return disks

    @classmethod
    def get_disks_part(cls):
        """
        功能描述：获取磁盘分区
        """
        disks_part = list()

        # get mount infomation
        sas_global.server_ssh.send_command("mount | grep '/dev/[a-z]d[a-z]' | awk '{print $1}'")
        mount_info = sas_global.server_ssh.stdout.split("\n")

        # get system disk
        sas_global.server_ssh.send_command("lsblk | grep efi")
        system_disk = sas_global.server_ssh.stdout.split(" ")[0][-4:-1]

        # get all disk
        sas_global.server_ssh.send_command("fdisk -l | grep sd[a-z][1-9]")

        for line in sas_global.server_ssh.stdout.splitlines():
            # add disk part，if disk has been mount，skip
            disk = line.split(" ")[0]
            if disk in mount_info or system_disk in disk:
                continue
            disks_part.append(disk.split("/")[-1])
        return disks_part

    @classmethod
    def check_reset_log(cls, reset_complete_time=60):
        """
        function describe: 检查复位完成的打印
        reset_complete_time: 注错后到复位完成的时间，单位是s
        """
        # 开发复位流程修改之后复位时间会比之前长一点，而且有触发错误处理的话时间会更长，对齐1分钟之内能复位完成都算正常
        for i in range(reset_complete_time):
            sas_global.server_ssh.send_command("dmesg | grep '{}' | wc -l".format(scfg.controller_reset))
            if int(sas_global.server_ssh.stdout) > 0:
                break
            time.sleep(1)
        return int(sas_global.server_ssh.stdout)

    @classmethod
    def get_init_path(cls, seconds=30, device=None):
        """
        功能描述：get bpath, cpath and host num
        """
        # get bpath
        while int(seconds) > 0:
            if device is None:
                sas_global.server_ssh.send_command(
                    "lsscsi -tv | grep 'sas' -A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1 | head -n 1")
            else:
                sas_global.server_ssh.send_command(
                    f"lsscsi -tv | grep {device} | cut -d '[' -f2 | cut -d ']' -f1 | head -n 1")

            if sas_global.server_ssh.stdout not in ("", b"", None) and len(
                    sas_global.server_ssh.stdout.split('/')) >= 10:
                bpath = sas_global.server_ssh.stdout
                break

            time.sleep(1)
            seconds -= 1
        # get ctrl path
        cpath = "/sys/devices/{}/{}".format(bpath.split("/")[3], bpath.split("/")[4])
        # get host number
        hostx = bpath.split("/")[5]
        return bpath, cpath, hostx

    @classmethod
    def get_sysfs_phy(cls, **args):
        """
        function describe:获取phy
        """
        # Parsing Parameters
        phynums = args.get("phynums", list())
        disk = args.get("disk", "sda")
        phytype = args.get("phytype", "near-end")
        device = args.get("device", None)

        phys = set()
        bpath, cpath, hostx = cls.get_init_path(device=device)

        if disk == "sd[a-z]":
            if phytype == "near-end":
                # 获取所有近端phy（直连和expander组网都可以调用）
                sas_global.server_ssh.send_command("ls {}/{} | grep phy".format(cpath, hostx))
                for line in sas_global.server_ssh.stdout.splitlines():
                    phys.add(line)
            elif phytype == "far-end":
                # 获取所有远端phy（expander组网调用）
                sas_global.server_ssh.send_command("ls {}/../../../../ | grep phy".format(bpath))
                for line in sas_global.server_ssh.stdout.splitlines():
                    if int(line.split(":")[-1]) < 12:
                        phys.add(line)
        elif disk == "all":
            sas_global.server_ssh.send_command(f"ls {scfg.phy_path}")
            for line in sas_global.server_ssh.stdout.splitlines():
                phys.add(line.strip())
        else:
            if phynums:
                # 获取单块盘近端phy（直连和expander组网都可以调用）根据phy num来获取
                for num in phynums:
                    phys.add("phy-{}:{}".format(hostx[4:], num))
            else:
                # 获取单块盘phy（直连和expander组网都可以调用）根据盘符来获取
                if not isinstance(disk, list):
                    disk = [disk]
                msg_center.info(f"the type of disk is {type(disk)}")
                msg_center.info(f"disk is {disk}")
                for drive in disk:
                    sas_global.server_ssh.send_command(
                        f"lsscsi -tv | grep '{drive}' -A 1 | grep 'dir:' | cut -d '[' -f2 | cut -d ']' -f1")
                    sas_global.server_ssh.send_command("ls {}/../../../ | grep phy".format(sas_global.server_ssh.stdout))
                    phys.add(sas_global.server_ssh.stdout)
        return phys

    @classmethod
    def set_phy_enable(cls, **args):
        """
        function describe:
        value: 1代表开Phy,0代表关phy,10代表关开phy
        """
        phys = args.get("phys", set())
        value = args.get("value", 0)
        sleeptime = args.get("sleeptime", None)

        if value == 10:
            for phy in phys:
                sas_dev = SasDevice(phyid=phy, terminal=sas_global.server_ssh)
                sas_dev.enable = 0
                time.sleep(1)
                sas_dev.enable = 1
        else:
            for phy in phys:
                sas_dev = SasDevice(phyid=phy, terminal=sas_global.server_ssh)
                sas_dev.enable = value
                if sleeptime:
                    time.sleep(sleeptime)
        return True

    @classmethod
    def sas_check_process(cls, cmd_os, process="fio", seconds=3):
        """
        杀进程，主要是调了cmdos下的check_process方法，且对kasan版本做规避
        """
        if sas_global.kasan_cfg in ("", " ", None):
            if cmd_os.check_process(process, seconds) is False:
                return False
        else:
            time.sleep(seconds)
            return False
        return True

    @classmethod
    def check_phy_enable(cls):
        """
        function describe: 检查phy开关状态
        """
        phys = cls.get_sysfs_phy(disk="all")
        for phy in phys:
            sas_dev = SasDevice(phyid=phy, terminal=sas_global.server_ssh)
            if sas_dev.enable == 0:
                sas_dev.enable = 1
            else:
                continue

    @classmethod
    def get_bindcpus(cls):
        """
        获取跨片测试绑核范围
        """
        cpus_allowed = None
        cmdos = CmdOs(terminal=sas_global.server_ssh)
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
    def mount_disk_part(cls, disk="/dev/sdb", path="/mnt", mkfs_ext="mkfs.ext4"):
        """
        mount disk part
        """
        # check whether the disk in /dev/
        sas_global.server_ssh.send_command('find /dev/ -name {}'.format(disk.split("/")[-1]))
        disk_name = sas_global.server_ssh.stdout
        if disk_name in ("", b"", None):
            msg_center.error("can't find %s in /dev/", disk)
            return False

        # if the has been mount then umount
        sas_global.server_ssh.send_command('mount | grep -w "^{}"'.format(disk_name))
        if sas_global.server_ssh.stdout not in ("", b"", None):
            cls.umount_disk_part(disk=disk_name)

        # format disk
        sas_global.server_ssh.send_command('echo "y" | {} {} > /dev/null 2>&1'.format(mkfs_ext, disk_name))
        if sas_global.server_ssh.stdout not in ("", b"", None):
            msg_center.error("Format the disk %s failed", disk_name)
            return False

        # mount disk -t：指定档案系统的型态，通常不必指定。mount 会自动选择正确的型态。
        sas_global.server_ssh.send_command('mount {} {} > /dev/null 2>&1'.format(disk_name, path))

        # check whether the disk mount success
        sas_global.server_ssh.send_command('mount | grep -w "^{}"'.format(disk_name))
        if sas_global.server_ssh.stdout in ("", b"", None):
            cls.umount_disk_part(disk=disk_name)
            msg_center.error("mount the disk %s failed", disk_name)
            return False

        return True

    @classmethod
    def umount_disk_part(cls, disk="/dev/sdb"):
        """
        umount disk part
        """
        if not isinstance(disk, list):
            disk = [disk]
        for dev in disk:
            # check whether the disk in /dev/
            sas_global.server_ssh.send_command('find /dev/ -name {}'.format(dev.split("/")[-1]))
            disk_name = sas_global.server_ssh.stdout
            if disk_name in ("", b"", None):
                msg_center.error("can't find %s in /dev/", dev)
                return False
            sas_global.server_ssh.send_command('umount {}'.format(disk_name))
        return True

    @classmethod
    def check_cp_tools(cls):
        """
        检查拷贝工具
        """
        cmdos = CmdOs(terminal=sas_global.server_scp)
        msg_center.info("检查工具，拷贝sas的相关工具到被测单板上")
        for tool in scfg.tool_list:
            msg_center.info(f"执行工具{tool}检查文件是否存在，避免覆盖系统原有工具")
            sas_global.server_ssh.send_command(f'{tool}')

            if "command not found" in sas_global.server_ssh.information \
                    or "No such file or directory" in sas_global.server_ssh.information:
                # 文件的拷贝路径
                local = os.path.join(THIS_FILE_PATH, "tools", tool)
                # 系统中文件的存在路径
                tool_path = f"{scfg.sbin_path}/{tool}"
                msg_center.info(f"\n文件的拷贝路径为{local}；"
                                f"\n系统中文件的存在路径为{tool_path}；")
                msg_center.info(f"上传工具{tool}并附权限")
                if tool == scfg.smp_discover:
                    # 判断是否是expander背板,expander组网才需要拷贝该工具
                    ret_exp = sas_global.server_ssh.send_command(
                        f'ls {scfg.bsg_path} | grep expander')
                    if ret_exp != "":
                        # 针对smp_discover工具，还需要关联相应的libsmputils1.so.1库
                        local_ko = os.path.join(THIS_FILE_PATH, "tools", scfg.libsmputils1)
                        # 系统中库文件的存在路径
                        ko_path = f"{scfg.lib64_path}/{scfg.libsmputils1}"
                        if not cmdos.check_exist_file(ko_path):
                            msg_center.info(f"上传库文件{scfg.libsmputils1}并附权限")
                            cmdos.scp_push_file(local_path=local_ko,
                                                remote_path=ko_path, chmod="755")
                    else:
                        msg_center.info(f"非expander背板环境无需安装{tool}工具")
                        continue
                cmdos.scp_push_file(local_path=local, remote_path=tool_path, chmod="755")
            else:
                msg_center.info(f"系统已存在{tool}工具，无需安装")

    @classmethod
    def set_phy_ops(cls, **args):
        """
        function describe:寄存器开关phy
        switch: 0x7代表开Phy,0x6代表关phy,all代表关开phy
        """
        switch = args.get("switch", None)
        phyids = args.get("phyids", None)
        devices = args.get("devices", None)

        # 获取控制器基地址
        if devices in (None, ""):
            devices = sas_global.test_device
        sas_global.base_addr = cls.get_base_addr(devices)
        if sas_global.base_addr == scfg.addr_default_value:
            msg_center.error("can't get register's basic addr")
            return False
        # 取测试phy的偏移地址
        phy_offset_addrs = list()
        if phyids:
            for phyid in phyids:
                phy_offset_addrs.append(scfg.phy_addr_value[phyid])
        else:
            phy_offset_addrs = scfg.phy_addr_value
        # 通过基地址+偏移地址计算出phy地址
        phy_addrs = list()
        for offset in phy_offset_addrs:
            phy_addrs.append(hex(int(sas_global.base_addr, 16) + int(offset, 16)))

        if switch == "all":
            # write value to register
            for addr in phy_addrs:
                sas_global.server_ssh.send_command("{} {} 32 0x6".format(scfg.devmem, addr))
                time.sleep(1)
                sas_global.server_ssh.send_command("{} {} 32 0x7".format(scfg.devmem, addr))
        else:
            # write value to register
            for addr in phy_addrs:
                sas_global.server_ssh.send_command("{} {} 32 {}".format(scfg.devmem, addr, switch))
        return True

    @classmethod
    def set_hard_reset(cls, phys=None):
        """
        function describe:hard_reset
        """
        if phys in (None, ""):
            phys = cls.get_sysfs_phy(disk="sd[a-z]", phytype="near-end")
        for phy in phys:
            sas_dev = SasDevice(phyid=phy, terminal=sas_global.server_ssh)
            sas_dev.hard_reset = 1

    @classmethod
    def set_link_reset(cls, phys=None):
        """
        function describe:link_reset
        """
        if phys in (None, ""):
            phys = cls.get_sysfs_phy(disk="sd[a-z]", phytype="near-end")
        for phy in phys:
            sas_dev = SasDevice(phyid=phy, terminal=sas_global.server_ssh)
            sas_dev.link_reset = 1

    @classmethod
    def get_ctrl_path(cls, value, device=None):
        """
        function describe:
        get ctrl path
        parameters:
        @ disk      disk name
        @ value     the value to return
        @ backplane the backplance of env
        """

        bpath, cpath, hostx = cls.get_init_path(device=device)

        # get ctrl power path
        if value == "cppath":
            return "{}/{}".format(cpath, "power")

        # get host ctrl path
        if value == "chpath":
            return "{}/{}".format(cpath, hostx)

        # get ctrl flr path
        if value == "cfpath":
            return "{}/{}".format(scfg.device_root, bpath.split("/")[4])

        # get scsi_host/hostx path
        if value == "shpath":
            return "{0}/{1}/scsi_host/{1}".format(cpath, hostx)

    @classmethod
    def del_disk_part(cls, disk="sda"):
        """
        Function Description:
        delete disk partitioning
        Parameters:
        @ disk  disk name
        """
        if not isinstance(disk, list):
            disk = [disk]
        for dev in disk:
            # 如果盘正在做系统盘启动，则跳过不删除分区
            sas_global.server_ssh.send_command(f"lsblk | grep {dev}")
            if "efi" in sas_global.server_ssh.stdout:
                continue
            sas_global.server_ssh.send_command("lsblk -l | grep {} | wc -l".format(dev))
            part_num = int(sas_global.server_ssh.stdout)

            # check whether the disk exists
            sas_global.server_ssh.send_command("ls /dev/{}".format(dev))
            if sas_global.server_ssh.stdout in ("", b""):
                msg_center.error("The disk {} does not exist".format(dev))
                return False

            for i in range(part_num-1):
                # Disk partitioning
                command = "fdisk /dev/{} << EOF\nd\n\n\nw\nEOF\n".format(dev)
                sas_global.server_ssh.send_command(command)
                if "The partition table has been altered" not in sas_global.server_ssh.stdout:
                    msg_center.error("The disk %s delete partition fail", dev)
                    return False

            # check whether partitioning success
            sas_global.server_ssh.send_command("lsblk -l | grep {} | wc -l".format(dev))
            if int(sas_global.server_ssh.stdout) > 1:
                msg_center.error("The disk %s not really delete part", dev)
                return False
        return True

    @classmethod
    def set_disk_part(cls, disk="sdb", size="100G", count=1):
        """
        Function Description:
        set disk partitioning
        Parameters:
        @ disk  disk name
        @ size  size of partition
        """
        # check whether the disk exists
        sas_global.server_ssh.send_command("ls /dev/{}".format(disk))
        if sas_global.server_ssh.stdout in ("", b""):
            msg_center.error("The disk {} does not exist".format(disk))
            return False

        for i in range(count):
            # Disk partitioning
            command = "fdisk /dev/{} << EOF\nn\np\n\n\n+{}\nw\nEOF\n".format(disk, size)
            sas_global.server_ssh.send_command(command)
            if "The partition table has been altered" not in sas_global.server_ssh.stdout:
                msg_center.error("The disk %s create partition fail", disk)
                return False

        # check whether partitioning success
        sas_global.server_ssh.send_command("lsblk -l | grep {} | wc -l".format(disk))
        if int(sas_global.server_ssh.stdout) <= count:
            msg_center.error("The disk %s not really partitioned", disk)
            return False
        return True


if __name__ == '__main__':
    pass
