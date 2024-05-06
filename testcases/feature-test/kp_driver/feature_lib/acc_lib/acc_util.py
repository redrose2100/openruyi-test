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

# new
from typing import Union

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center

from test_config.feature_config.acc_config.acc_config import acc_global, acc_config
from test_config.feature_config.sys_config import sys_config
from test_config.feature_config.hns_config.hns_config import file_server_url
from feature_lib.sys_lib.sys_util import SysUtil
from kp_comm.drive import CmdDrive
from kp_comm.base import CmdOs
from common_lib.testengine_lib.engine_utils import check_result


class AccUtil:
    """
    ACC模块公共函数
    """

    def __init__(self):
        self.FILE_NAME = 'kp_kernel-master'
        self.PROTOCOL = ['hisi-tfm-req-do-openssl', 'hisi-tfm-req-do-file', 'hisi-tfm-req-do-random']
        self.KERNEL_MODULES = acc_global.server_ssh.send_command("uname -r")
        self.THIS_ROOM_PATH = '/lib/modules/{}/'.format(self.KERNEL_MODULES)
        self.os_name = SysUtil.fn_get_os_name().lower()
        if self.os_name.find('centos-7.6') != -1:
            self.ACC_TOOLS_PATH = f'/usr/lib/modules/{self.KERNEL_MODULES}/'
        else:
            self.ACC_TOOLS_PATH = "/lib/modules/{}/kernel/drivers/crypto/hisilicon/".format(self.KERNEL_MODULES)
            self.ACC_TOOLS_PATH_VM = "/lib/modules/linux-headers-{}".format(self.KERNEL_MODULES)
        self.ko_path = "/lib/modules/%s/acc_test.ko" % self.KERNEL_MODULES

    @staticmethod
    def insmod_driver_ko(ko_names: Union[str, list], **kwargs):
        """
        功能描述: 通过过find方式查找驱动路径,insmod方式加载ko, 如果ko传入多个，参数必须都相同
        :param driver_ko: 驱动名字.如 hisi_zip或者hisi_zip.ko
        :param pf_q_num:  驱动队列配置PF(v1 2-4096, v2 2-1024)
        :param vfs_num:   驱动起VF配置VFs to enable(1-63), 0(default)
        :param uacce_mode:驱动模式, UACCE can be 0(default), 1, 2
        :eg: insmod_driver_ko(hisi_zip, uacce_mode=1, pf_q_num=2)
        :return:成功返回SUCCESS_CODE，失败返回FAILURE_CODE
        """
        os_name = SysUtil.fn_get_os_name()
        driver_param = ''
        kernel_version = acc_global.server_ssh.send_command('uname -r')
        if isinstance(ko_names, str):
            ko_names = [ko_names]
        for index, ko_name in enumerate(ko_names):
            if '.ko' in ko_name:
                ko_name = ko_name.split('.')[0]
                ko_names[index] = ko_name
        if kwargs:
            for key, value in kwargs.items():
                driver_param += key + '=' + str(value) + ' '
        for ko_name in ko_names:
            if 'centos' in os_name:
                ko_dir = "/usr/lib"
            elif 'euler' in os_name:
                ko_dir = "/OSM/modules"
            else:
                ko_dir = "/lib"
            find_ko_path = 'find %s -name %s.ko*' % (ko_dir, ko_name)

            ko_paths = acc_global.server_ssh.send_command(find_ko_path)
            if acc_global.server_ssh.ret_code:
                msg_center.error('找不到驱动 %s.ko' % ko_name)
                return FAILURE_CODE
            # 系统在对应路径下可能查找多个驱动ko, 取内核路径+kernel关键字
            for ko_path in ko_paths.split('\n'):
                if kernel_version in ko_path and 'kernel' in ko_path:
                    driver_path = ko_path
                    break
            else:
                driver_path = ko_paths.split('\n')[0]
            cmd = 'insmod {} {}'.format(driver_path, driver_param)
            acc_global.server_ssh.send_command(cmd)
            if acc_global.server_ssh.ret_code:
                msg_center.error('加载驱动 %s 失败' % (ko_name))
                return FAILURE_CODE
        msg_center.info('加载驱动 %s 成功' % ko_names)
        return SUCCESS_CODE

    @staticmethod
    def insmod_uacce_qm():
        """
        安装ACC驱动前需要先安装这个两个驱动
        """
        ko_list = [acc_config.HISI_UACCE_KO, acc_config.HISI_QM_KO]
        for ko in ko_list:
            AccUtil.insmod_driver_ko(ko)

    @staticmethod
    def acc_ko_rmmod(ko_list: list) -> None:
        """
        判断驱动是否存在，存在就删除
        """
        for item in ko_list:
            if item.endswith(".ko"):
                item = item[:-3]
            acc_global.server_ssh.send_command("rmmod %s" % item)
            retstr = acc_global.server_ssh.send_command("lsmod | grep %s" % item)
            if item in retstr:
                msg_center.error("驱动卸载失败")
                return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def rmmod_ko(ko_names: Union[list, str] = None, wait_time: int = None):
        """
        删除ko
        @param ko_names:需要删除的ko列表,请根据ko的删除顺序排序
        @return:成功返回SUCCESS_CODE，任意一个失败返回FAILURE_CODE
        :param wait_time: 等待时间
        """
        if ko_names is not None:
            ko_list = ko_names
        else:
            ko_list = acc_config.ACC_KO
        if wait_time is not None:
            waiting = wait_time
        else:
            waiting = 1
        if isinstance(ko_names, str):
            ko_list = [ko_names]
        for ko_name in ko_list:
            ko_name = ko_name.split(".")[0]
            if ko_name == acc_config.HISI_TRNG_KO.split(".")[0]:
                ko_name = 'hisi_trng_v2'
            if ko_name == acc_config.RNG_CORE_KO.split(".")[0]:
                ko_name = 'rng_core'
            acc_global.server_ssh.send_command('lsmod | egrep %s' % ko_name)
            ret_code = acc_global.server_ssh.ret_code
            if not ret_code:
                acc_global.server_ssh.send_command('rmmod %s' % ko_name)
                ret_code = acc_global.server_ssh.ret_code
                time.sleep(waiting)
                if ret_code:
                    msg_center.error('rmmod %s failed' % ko_name)
                    return FAILURE_CODE
                # 检查ko是否真的被删除
                acc_global.server_ssh.send_command('lsmod | egrep %s' % ko_name)
                ret_code = acc_global.server_ssh.ret_code
                if not ret_code:
                    msg_center.error('after exec rmmod %s, ko is still in system' % ko_name)
                    return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def get_md5(filename: str) -> str:
        """
        获取MD5的值
        :param filename:
        :return: md5值
        """
        md5_result = CmdOs(terminal=acc_global.server_ssh).get_md5sum(filename)
        return md5_result

    @staticmethod
    def gen_random_file(filename: str, bs: str, count: int = 1):
        """
        生成随机文件
        @return:
        """
        cmd = "dd if=/dev/urandom of={} bs={} count={}".format(filename, bs, count)
        acc_global.server_ssh.send_command(cmd)
        ret_code = acc_global.server_ssh.ret_code
        return SUCCESS_CODE if ret_code == 0 else FAILURE_CODE

    @staticmethod
    def cp_file(source_file: str, target_path: str) -> int:
        """
        cp文件
        """
        cp_cmd = 'cp {} {}'.format(source_file, target_path)
        acc_global.server_ssh.send_command(cp_cmd)
        ret_code = acc_global.server_ssh.ret_code
        return ret_code

    @staticmethod
    def write_data_to_file(size, file_name, path):
        """
        写文件内容
        """
        acc_global.server_scp.send_command(f"cd {path}")
        cmd = f"dd if=/dev/zero of={file_name} bs={size} count=1"
        acc_global.server_scp.send_command(cmd)
        retstr = acc_global.server_scp.send_command("ls -l | awk {'print$5,$9'}")
        pattern = "([0-9a-f]+)\s%s" % file_name
        tmpsize = re.findall(pattern, retstr)
        if str(size) != tmpsize[0]:
            msg_center.error(f"命令执行失败, size={str(size)},tmpsize={tmpsize[0]}")
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def umount_disk(disk_path):
        """
        卸载磁盘
        """
        acc_global.server_scp.send_command("cd /home/")
        retstr = acc_global.server_scp.send_command(f"umount {disk_path}")

        if "target is busy" in retstr.lower():
            msg_center.error("命令执行失败, retstr=%s" % retstr)
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def mount_disk(map_path, disk_path, ):
        """
        挂载磁盘
        """
        # 先清理日志
        cmd = "dmesg -c > /dev/null"
        acc_global.server_ssh.send_command(cmd)

        cmd = "mount %s %s" % (map_path, disk_path,)
        retstr = acc_global.server_ssh.send_command(cmd)

        if "fail" in retstr:
            msg_center.error("mounting命令执行失败, cmd=%s, retstr=%s" % (cmd, retstr))
            return FAILURE_CODE
        retstr = acc_global.server_ssh.send_command("dmesg")
        if "Ending clean mount" not in retstr:
            msg_center.error("dmesg 中未获取到mounting命令执行信息, cmd=%s, retstr=%s" % (cmd, retstr))
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def cipher_openssl_encrypt(sync_mode, alg_mode, check_mode, key=16, iv=16, input_size=16, thread_num=2, pool_num=0,
                               arg=''):
        """
        执行sec cipher业务，仅 encrypt 操作
        """
        task_cmd = 'acc_test hisi-do-openssl cipher {}-{}-{} {} {} encrypt-{}-{} {} {} -vv > {} 2>&1' \
            .format(key, iv, input_size, thread_num, pool_num, sync_mode, alg_mode, check_mode, arg,
                    acc_config.DRIVER_JOB_LOG)
        acc_global.server_ssh.send_command(task_cmd)
        retstr = acc_global.server_ssh.send_command(f"cat {acc_config.DRIVER_JOB_LOG}")
        if "failed" in retstr.lower() or (
                "error" in retstr.lower() or 'fail' in retstr.lower() and "not currently loaded" not in retstr.lower()):
            msg_center.error("命令执行失败, cmd=%s, retstr=%s", task_cmd, retstr)
            return FAILURE_CODE
        return SUCCESS_CODE

    def cipher_openssl(sync_mode, alg_mode, check_mode, key=16, iv=16, input_size=16, thread_num=2, pool_num=0,
                       arg=''):
        """
        执行sec cipher业务，包括 encrypt 和 decrypt 操作
        """
        task_cmd = f'acc_test hisi-do-openssl cipher {key}-{iv}-{input_size} {thread_num} {pool_num} ' \
                   f'encrypt-{sync_mode}-{alg_mode} {check_mode} {arg} -vv > {acc_config.DRIVER_JOB_LOG} 2>&1'
        acc_global.server_ssh.send_command(task_cmd)
        retstr = acc_global.server_ssh.send_command(f"cat {acc_config.DRIVER_JOB_LOG}")
        if "failed" in retstr.lower() or (
                "error" in retstr.lower() or 'fail' in retstr.lower() and "not currently loaded" not in retstr.lower()):
            msg_center.error("命令执行失败, cmd=%s, retstr=%s", task_cmd, retstr)
            return FAILURE_CODE

        task_cmd = f'acc_test hisi-do-openssl cipher {key}-{iv}-{input_size} {thread_num} {pool_num} ' \
                   f'decrypt-{sync_mode}-{alg_mode} {check_mode} {arg} -vv > {acc_config.DRIVER_JOB_LOG} 2>&1'
        acc_global.server_ssh.send_command(task_cmd)
        retstr = acc_global.server_ssh.send_command(f"cat {acc_config.DRIVER_JOB_LOG}")
        if "failed" in retstr.lower() or (
                "error" in retstr.lower() or 'fail' in retstr.lower() and "not currently loaded" not in retstr.lower()):
            msg_center.error("命令执行失败, cmd=%s, retstr=%s", task_cmd, retstr)
            return FAILURE_CODE
        msg_center.info("命令执行成功!!")
        return SUCCESS_CODE

    @staticmethod
    def acc_excute_ccm_testcase(file_mode, key_size, len_add, len_mac, input_size, thread, crypt_mode, alg_sync,
                                comp_mode):
        """
        执行sec aead业务
        """
        task_cmd = f'acc_test hisi-do-{file_mode} aead {key_size}-16-{len_add}-{len_mac}-{input_size} {thread} 0 ' \
                   f'{crypt_mode}-{alg_sync} {comp_mode} none -vv > {acc_config.DRIVER_JOB_LOG} 2>&1'
        acc_global.server_ssh.send_command(task_cmd)
        retstr = acc_global.server_ssh.send_command(f"cat {acc_config.DRIVER_JOB_LOG}")
        if "failed" in retstr.lower() or (
                "error" in retstr.lower() or 'fail' in retstr.lower() and "not currently loaded" not in retstr.lower()):
            msg_center.error("命令执行失败, cmd=%s, retstr=%s", task_cmd, retstr)
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def acc_excute_sha1_testcase(alg_sync, q_num="none"):
        """
        执行sec digest业务
        """
        task_cmd = 'acc_test hisi-do-openssl digest 16-16-16 2 0 {} none {} -vv > {} 2>&1'.format(alg_sync, q_num,
                                                                                                  acc_config.DRIVER_JOB_LOG)
        acc_global.server_ssh.send_command(task_cmd)
        retstr = acc_global.server_ssh.send_command(f"cat {acc_config.DRIVER_JOB_LOG}")
        if "failed" in retstr.lower() or (
                "error" in retstr.lower() or "fail" in retstr.lower() and "not currently loaded" not in retstr.lower()):
            msg_center.error("命令执行失败, cmd=%s, retstr=%s", task_cmd, retstr)
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def excecute_job_with_no_file(timeout=5, is_bak=False, **kwargs):
        """
        函数说明：执行hpre测试用例
        参数说明： timeout 超时时间
        is_bak 是否放后台
        time_len 隔多少秒检查一次
        **kwargs xxx 等参数字典
        返  回  值：retcode -1 失败, 0 成功;
        """
        cmd = "cd /home/"
        acc_global.server_ssh.send_command(cmd)
        kwargs.setdefault("log_path", acc_config.DRIVER_JOB_LOG)
        cmd = f"echo '' > {acc_config.DRIVER_JOB_LOG}"
        acc_global.server_ssh.send_command(cmd)
        cmd = "acc_test {options} {alg} {key_size} {thread} {poll_num} {op_type} {check} {other} -vv " \
              ">> {log_path} 2>&1 &".format(**kwargs)
        acc_global.server_ssh.send_command(cmd)
        if is_bak:
            msg_center.info("命令下发成功！！")
            return SUCCESS_CODE
        # 判断业务是否执行结束
        cmd = "ps -ef | grep acc_test"
        while timeout > 0:
            retstr = acc_global.server_ssh.send_command(cmd)
            if timeout <= 0:
                msg_center.error('业务执行超时, cmd=%s, retstr=%s' % (cmd, retstr))
                acc_global.server_ssh.send_command("pkill -9 acc_test")
                return FAILURE_CODE
            if kwargs.get("alg") not in retstr:
                msg_center.info('业务执行结束, cmd=%s, retstr=%s' % (cmd, retstr))
                break
            time.sleep(1)
            timeout -= 1
        # 判断业务是否执行成功，存在 "error|fail|Segmentation fault" 返回FAILURE_CODE，否则返回SUCCESS_CODE
        ret_code = AccUtil.check_job_log()
        return ret_code

    @staticmethod
    def check_job_log(log_path=acc_config.DRIVER_JOB_LOG, key_words="error|fail|Segmentation fault"):
        """
        检查业务日志是否执行成功
        @param key_words:特定关键字
        @return:存在返回FAILURE_CODE，不存在返回SUCCESS_CODE
        """
        cmd = "cat %s | grep -iE '%s'" % (log_path, key_words)
        retstr = acc_global.server_ssh.send_command(cmd)
        acc_global.server_ssh.send_command("rm -rf %s" % log_path)
        for key in key_words.split("|"):
            if key in retstr.lower():
                msg_center.error("业务执行失败, retstr: %s" % retstr)
                return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def flr_reset(driver_pci_dir_path: str, pf_pci_id: str) -> int:
        """
        做flr复位
        """
        cmd = 'echo 1 > {0}/{1}/device/reset'.format(driver_pci_dir_path, pf_pci_id)
        acc_global.server_ssh.send_command(cmd, status_code=True)
        time.sleep(1)
        acc_global.server_ssh.send_command('dmesg | grep -iE "FLR reset complete"')
        ret_code = acc_global.server_ssh.ret_code
        return ret_code

    @staticmethod
    def bind_device(pci_id, dev_name, action):
        """
        解绑/绑定设备接口
        @param pci_id:
        @param dev_name:设备名称，如hisi_hpre、hisi_zip、hisi_sec2
        @param action:bind/unbind
        @return:
        """
        actions = ["bind", "unbind"]
        dev_name = dev_name.split("-")[0]
        if action not in actions:
            raise ValueError("not support action:%s" % action)
        if not pci_id.startswith("0000:"):
            pci_id += "0000:"
        bind_dir = "/sys/bus/pci/drivers/%s/%s" % (dev_name, action)
        cmd = "echo %s > %s" % (pci_id, bind_dir)
        acc_global.server_ssh.send_command(cmd)
        # 查看action是否生效
        cmd = "ls /sys/bus/pci/drivers/%s" % dev_name
        retstr = acc_global.server_ssh.send_command(cmd)
        if (action == "unbind" and pci_id in retstr) or (action == "bind" and pci_id not in retstr):
            msg_center.error(f"execute action {action} fail")
            return FAILURE_CODE
        msg_center.info(f"execute action {action} success!!")
        return SUCCESS_CODE

    @staticmethod
    def wait_process_finish(process=None, time_out=180, time_len=1):
        """
        等待进程结束
        :param process: 进程名
        :return:
        """
        times = 0
        if not process:
            return FAILURE_CODE
        command = 'ps -ef | grep "{}" | grep -v grep'.format(process)
        while True:
            if not acc_global.server_ssh.send_command(command):
                break
            if times == time_out:
                message = 'FAIL, {} exit failed,' \
                          'command {} fail'.format(process, command)
                msg_center.error(message)
                return FAILURE_CODE
            time.sleep(time_len)
            times += time_len
        return SUCCESS_CODE

    @staticmethod
    def kill_process(process_name: str):
        """
        杀掉进程
        @param process:进程名
        @return:成功返回SUCCESS_CODE，失败返回FAILURE_CODE
        """

        # 检查进程是否存在，存在就删除
        task_cmd = "ps -ef | grep %s | grep -v grep | awk -F ' ' '{print $2}'" % process_name
        proce_id = acc_global.server_ssh.send_command(task_cmd).split()
        if proce_id:
            for pro in proce_id:
                acc_global.server_ssh.send_command('kill -9 {}'.format(pro))
            ret_code = AccUtil.wait_process_finish(process_name)
            if ret_code != 0:
                msg_center.error("kill process:%s fail" % process_name)
                return FAILURE_CODE
            return SUCCESS_CODE
        else:
            msg_center.error("The kill %s process does not exist." % process_name)
            return FAILURE_CODE

    @staticmethod
    def process_exists(ps_name):
        """
        判断进程是否存在
        """
        cmd = "ps -ef | grep %s | grep -v grep" % (ps_name)
        retstr = acc_global.server_ssh.send_command(cmd)
        patt_ps = "root\s+([0-9]+)\s"
        pid_list = re.findall(patt_ps, retstr)
        if len(pid_list) != 0:
            msg_center.info("%s进程存在", retstr)
            return SUCCESS_CODE
        msg_center.error("%s进程不存在", retstr)
        return FAILURE_CODE

    @staticmethod
    def test_kernel_function_execute(task_cmd: str, test_ko: str):
        """
        函数功能：执行内核态业务
        task_cmd ：测试算法执行命令；
        test_ko : 内核态测试工具；
        :return:
        """
        if 'ko' in test_ko:
            test_ko = test_ko.split('.')[0]
        msg_center.info(task_cmd)
        acc_global.server_ssh.send_command("lsmod |grep -w '%s'" % test_ko)
        if acc_global.server_ssh.ret_code == 0:
            acc_global.server_ssh.send_command("rmmod %s" % test_ko)
        # 执行业务
        acc_global.server_ssh.send_command(task_cmd)
        if acc_global.server_ssh.ret_code != 0:
            msg_center.error("Failed to execute kernel-mode services.")
            return FAILURE_CODE
        acc_global.server_ssh.send_command("lsmod |grep -w '%s'" % test_ko)
        if acc_global.server_ssh.ret_code != 0:
            msg_center.error("Kernel-mode test KO loading failure.")
            return FAILURE_CODE
        time.sleep(10)
        acc_global.server_ssh.send_command("rmmod %s" % test_ko)

        return SUCCESS_CODE

    @staticmethod
    def wait_kernel_finish(device_name: str, wait_times: int = 120):
        """
        等待内核态业务结束
        @param device_name:设备名称，如hisi_hpre、hisi_zip、hisi_sec2
        @param wait_times: 等待时间
        @return: 成功返回SUCCESS_CODE，任意一个失败返回FAILURE_CODE
        """
        times = 0
        while True:
            cmd = "lsmod | grep %s | grep -v %s | awk '{print $3}'" % (
                device_name, acc_global.ACC_KO.get('QM').split('.')[0])
            acc_global.server_ssh.send_command(cmd)
            q_num = acc_global.server_ssh.stdout
            if q_num == '0' or q_num == '':
                break
            if times == wait_times:
                return FAILURE_CODE
            time.sleep(1)
            times += 1
        return SUCCESS_CODE

    @staticmethod
    def run_cmd(cmd: str, disable_show_and_log=True):
        """
        函数功能：并发测试函数
        :param cmd：测试任务
        """
        acc_global.server_ssh.send_command(cmd=cmd, disable_show_and_log=disable_show_and_log)
        return acc_global.server_ssh.ret_code

    @staticmethod
    def check_info_finish(cmd, check, wait_times: int = 120):
        """
        等待需要检查的信息出现或没有后结束进程
        @param cmd: 要执行的命令
        @param check: 需要检查到信息还是检查不到信息
        @param wait_times: 等待时间
        """
        times = 0
        while True:
            acc_global.server_ssh.send_command(cmd)
            info = acc_global.server_ssh.stdout
            if check == 'none':
                if not info:
                    break
            elif check == 'get':
                if info:
                    break
            if times == wait_times:
                return FAILURE_CODE
            time.sleep(1)
            times += 1
        return SUCCESS_CODE

    @staticmethod
    def acc_get_available_devices(ko_name: str, dev_path=acc_config.HISI_UACCE_DIR_PATH):
        """
        获取可用设备，仅支持用户态调用
        @param ko_name: 驱动名称
        @param dev_path: 设备路径
        """
        if "ko" in ko_name:
            ko_name = ko_name.split(".")[0]

        acc_global.server_ssh.send_command(f"cd {dev_path};ls | grep {ko_name} --color=never")
        ret_str = acc_global.server_ssh.stdout
        pattern = f"({ko_name}-\S+)"
        tmp_list = re.findall(pattern, ret_str)
        for num in range(len(tmp_list)):
            if tmp_list[num] == " ":
                tmp_list.pop(num)
        if len(tmp_list) == 0:
            msg_center.error(f"无可用的设备")
            return FAILURE_CODE, tmp_list
        msg_center.error(f"获取到设备列表:{tmp_list}")
        return SUCCESS_CODE, tmp_list

    @staticmethod
    def acc_get_available_devices_pci(ko_name, dev_path=acc_config.DEBUG_PATH):
        """
        =====================================================================
        函数说明: 获取可用设备信息，返回设备的pcie编号，内核态、用户态都支持
        @param ko_name: 驱动名称
        @param dev_path: 设备路径
        @return:成功返回SUCCESS_CODE，任意一个失败返回FAILURE_CODE
        =====================================================================
        """
        if ".ko" in ko_name:
            ko_name = ko_name.split(".")[0]

        acc_global.server_ssh.send_command(f'ls {dev_path}/{ko_name}')
        ret_info = acc_global.server_ssh.stdout
        tmp_pattern = "0000:..:..\.."
        pcie_list = re.findall(tmp_pattern, ret_info)
        if len(pcie_list) == 0:
            msg_center.error(f"获取pcie地址失败：{pcie_list}")
            return FAILURE_CODE, pcie_list
        msg_center.info(f"获取pcie地址成功：{pcie_list}")
        return SUCCESS_CODE, pcie_list

    @staticmethod
    def echo_value_to_file(file_name, value, is_check=True, is_root=True, user_name="none"):
        """
        =====================================================================
        函数说明: 写文件
        @param file_name: 文件名
        @param value: 待写入的参数
        @param is_check: 是否校验写结果
        @param is_root: 是否为root账户操作
        @param user_name: 其他账户的名称
        @return:retcode -1 失败, 0 成功;
        =====================================================================
        """
        cmd = f'echo {value} > {file_name}'
        if is_root == False:
            cmd = f'su - {user_name} -c echo {value} > {file_name}'
        acc_global.server_ssh.send_command(cmd)
        # 某些情况不需要判断是否写入成功，比如复位开关，移除设备，这些通过其他手段进行判断是否成功
        if not is_check:
            return SUCCESS_CODE
        acc_global.server_ssh.send_command(f'cat {file_name}')
        ret_info = acc_global.server_ssh.stdout
        if str(value) not in ret_info:
            msg_center.error(f"echo {value} to {file_name} fail!, ret_info: {ret_info}")
            return FAILURE_CODE
        msg_center.info(f"echo {value} to {file_name} success!")
        return SUCCESS_CODE

    @staticmethod
    def get_pci_base_addr(dev_name, offset_address, uacce_mode=2):
        """
        获取注错中断地址
        @param dev_name: 驱动设备名称
        @param offset_address: 需要注错的偏移地址
        @param uacce_mode: 驱动加载模式
        """
        acc_global.server_ssh.send_command("")
        # 获取 PCI设备ID
        pci_id = dev_name
        if uacce_mode != 0:
            cmd = "ls -l /sys/class/uacce/%s/device | awk -F '/' '{print $NF}'" % dev_name
            pci_id = acc_global.server_ssh.send_command(cmd)
        # 获取设备PCI基地址
        cmd = "lspci -vv -s %s | grep 'Region 2' | awk -F ' ' '{print $5}' | sed -n '1p'" % pci_id
        retstr = acc_global.server_ssh.send_command(cmd)
        base_addr = int(retstr, 16)
        if base_addr == 0:
            msg_center.info(f"获取设备PCI基地址失败，item={retstr}")
            return FAILURE_CODE
        # 得到需要注错的地址
        base_addr = hex(base_addr + int(offset_address, 16))
        if base_addr.endswith("L"):
            base_addr = base_addr[:-1]
        return base_addr

    @staticmethod
    def get_devmem_dir():
        """
        获取devmem运行目录
        """
        ret = acc_global.server_ssh.send_command("dmidecode -t bios |grep -i pangea")
        if len(ret) != 0:
            devmem_dir = "/OSM/modules/devmem"
        else:
            devmem_dir = "devmem"

        return devmem_dir

    @staticmethod
    def register_handle(dev_name, offset_addr, bit):
        """
        对设备寄存器操作
        """
        # 获取寄存器地址并注错
        devmem_dir = AccUtil.get_devmem_dir()
        register_addr = AccUtil.get_pci_base_addr(dev_name, offset_addr)
        task_cmd = "{} {} 32 {}".format(devmem_dir, register_addr, bit)
        acc_global.server_ssh.send_command(task_cmd)
        return acc_global.server_ssh.ret_code

    @staticmethod
    def injection_error(dev_name, bit, ras_bit_dict):
        """
        注错功能
        """
        # 获取 PCI设备ID
        task_cmd = "ls -l /sys/class/uacce/%s/device | awk -F '/' '{print $NF}'" % dev_name
        ret_str = acc_global.server_ssh.send_command(task_cmd)
        dev_pci = re.findall(r"0000:.*?:\d+.\d", ret_str)[0]

        # 获取寄存器地址并注错
        devmem_dir = AccUtil.get_devmem_dir()
        offset_addr = ras_bit_dict.get(bit)[2]
        register_addr = AccUtil.get_pci_base_addr(dev_name, offset_addr)
        task_cmd = "{} {} 32 {}".format(devmem_dir, register_addr, bit)
        acc_global.server_ssh.send_command(task_cmd)
        time.sleep(3)

        # 查询dmesg日志
        if ras_bit_dict.get(bit)[1] == "nfe":
            cmd1 = 'dmesg | grep "%s"' % acc_config.REGISTER_LOG.get('NFE')
            cmd2 = 'dmesg | grep "%s"' % acc_config.REGISTER_LOG.get('NFE_RESET')
            ret1 = acc_global.server_ssh.send_command(cmd1)
            ret2 = acc_global.server_ssh.send_command(cmd2)
            if acc_config.REGISTER_LOG.get('NFE') not in ret1 and acc_config.REGISTER_LOG.get('NFE_RESET') not in ret2:
                msg_center.error('check inject nfe info fail')
                return FAILURE_CODE
            cmd3 = "dmesg |grep -w '{}: {}'".format(dev_pci, ras_bit_dict.get(bit)[0])
            ret3 = acc_global.server_ssh.send_command(cmd3)
            if ras_bit_dict.get(bit)[0] not in ret3:
                msg_center.error('check inject nfe name fail')
                return FAILURE_CODE
        elif ras_bit_dict.get(bit)[1] == "ce":
            cmd = 'dmesg | grep "%s"' % acc_config.REGISTER_LOG.get('CE')
            ret = acc_global.server_ssh.send_command(cmd)
            if acc_config.REGISTER_LOG.get('CE') not in ret:
                msg_center.error('check inject ce info fail')
                return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def acc_check_state_log(expect_ret=0, expect_state=1, log_path=acc_config.DRIVER_STATE_LOG):
        """
        函数功能：获取空闲/非空闲设备状态
        """
        cmd = "cat %s" % log_path
        retstr = acc_global.server_ssh.send_command(cmd)
        cmd = "rm -rf %s" % log_path
        acc_global.server_ssh.send_command(cmd)
        match_val = list(map(int, re.findall("(?:\sret:|\sdev_state:).*?(\d+)", retstr)))
        if len(match_val) == 2:
            if expect_ret == match_val[0] and expect_state == match_val[1]:
                msg_center.info("test success！ret：%s, dev_state：%s", match_val[0], match_val[1])
                return SUCCESS_CODE
        elif len(match_val) == 1:
            if expect_ret == match_val[0]:
                msg_center.info("test success！ret：%s", match_val[0])
                return SUCCESS_CODE
        else:
            msg_center.error("test fail！retstr：%s", retstr)
            return FAILURE_CODE

    @staticmethod
    def acc_get_dev_state(alg_type, expect_ret=0, expect_state=1, is_bak=False, log_path=acc_config.DRIVER_STATE_LOG,
                          is_root=True, user_name="none"):
        """
        函数功能：获取空闲/非空闲设备状态
        """
        if alg_type not in ["ACC_ALG_ZLIB", "ACC_ALG_GZIP", "ACC_ALG_HMAC_SHA1"]:
            msg_center.error("alg_type value error!")
            return FAILURE_CODE

        cmd = f"echo '' > {log_path}"
        acc_global.server_ssh.send_command(cmd)
        cmd = f"acc_test hisi-dev_state {alg_type} {expect_state} -v >> {log_path} 2>&1 &"
        if is_root == False:
            cmd = f"sudo -u {user_name} acc_test hisi-dev_state {alg_type} {expect_state} -v >> {log_path} 2>&1 &"
        acc_global.server_ssh.send_command(cmd)
        if is_bak:
            msg_center.info("命令执行成功！")
            return SUCCESS_CODE

        time.sleep(3)
        ret_code = AccUtil.acc_check_state_log(expect_ret, expect_state, log_path=log_path)
        return ret_code
