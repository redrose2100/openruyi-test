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

import time
import os
import requests


THIS_FILE_PATH = os.path.dirname(os.path.realpath(__file__))


from test_config.feature_config.sys_config import sys_config
from test_config.feature_config.hns_config import hns_config
from feature_lib.sys_lib.sys_util import SysUtil as sys_base_info
from feature_lib.sys_lib.sys_clean import SysClean as sys_env_clean
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.global_config.global_config import lava_global


class SysInit:
    """
    环境初始化相关公共函数库
    """

    @staticmethod
    def fn_create_log_path(lava_job_id, project_name):
        """
        生成对应项目的日志文件所在的路径
        :param lava_job_id: 带有lava_jobid的  比如/lava-1241420
        :param project_name: 测试项目的名字
        :return: 项目日志存储的路径
        """
        log_dir = "/home/cilog/{}/{}".format(project_name, lava_job_id)
        if not lava_job_id:
            now = time.strftime("%Y%m%d%H%M%S", time.localtime(int(time.time())))
            log_path = "%s/%s" % (log_dir, now)
        else:
            log_path = "%s" % (log_dir)
        if not os.path.exists(log_dir):
            lava_global.feature_global.server_ssh.send_command("mkdir -p %s" % log_dir)
        return log_path

    @staticmethod
    def fn_download_pkg(src_path, dst_path, pkg_md5sum=""):
        """
        下载工具包
        :param src_path:
        :param dst_path:
        :param pkg_md5sum:
        :return:
        """
        ### 判断目的地址是否存在，若不存在则新建目录
        dst_abs = os.path.abspath(dst_path)
        dst_dir = os.path.dirname(dst_abs)
        if not os.path.isdir(dst_dir):
            lava_global.feature_global.server_ssh.send_command("mkdir -p {}".format(dst_dir))

        # 下载文件
        msg_center.info("begin to download file {} to {}".format(src_path, dst_path))
        f_p = requests.get(src_path)
        with open(dst_path, "wb") as down_file:
            down_file.write(f_p.content)

        # 判断md5值
        # 添加判断点
        check_point = 0
        if os.path.isfile(dst_path):
            msg_center.info("{} download succeed".format(dst_path))
            if pkg_md5sum != "":
                get_md5 = sys_base_info.fn_get_md5sum(dst_path)
                if get_md5 == pkg_md5sum:
                    msg_center.info("{} md5 check succeed".format(dst_path))
                else:
                    msg_center.error("{} md5 check failed".format(dst_path))
                    check_point += 1
        else:
            msg_center.error("{} download failed".format(dst_path))
            check_point += 1

        if check_point == 0:
            return True
        else:
            return False

    @staticmethod
    def fn_install_fio(fio_url="", ins_path=""):
        """
        Discription:下载和安装fio
        :param src_path:下载的url，可以不配置
        :param dst_path:目的地址，可以不配置
        :return:安装成功返回True，失败返回False
        """
        if lava_global.feature_global.server_ssh.send_command("which fio"):
            msg_center.info("fio is already installed")
            return True
        if fio_url == "":
            fio_url = sys_config.DEPENDENT_URL + "fio"
        if ins_path == "":
            ins_path = "/usr/bin/fio"
        ins_rst = SysInit.fn_download_pkg(fio_url, ins_path)
        if ins_rst:
            lava_global.feature_global.server_ssh.send_command("chmod 755 {}".format(ins_path))
        return ins_rst

    @staticmethod
    def fn_install_netperf(netperf_url="", ins_path=""):
        """
        Discription:下载和安装netperf
        :param src_path:下载的url，可以不配置
        :param dst_path:目的地址，可以不配置
        :return:安装成功返回True，失败返回False
        """
        if lava_global.feature_global.server_ssh.send_command("which netperf"):
            msg_center.info("netperf is already installed")
            return True
        if netperf_url == "":
            netperf_url = sys_config.DEPENDENT_URL + "netperf.tar.gz"
        down_path = "/tmp/netperf.tar.gz"
        ins_rst = SysInit.fn_download_pkg(netperf_url, down_path)
        if not ins_rst:
            return False
        dst_dir = os.path.dirname(down_path)
        os.chdir(dst_dir)
        if lava_global.feature_global.server_ssh.send_command("tar -xzvf netperf.tar.gz"):
            msg_center.error("tar -xzvf netperf.tar.gz failed")
            return False
        lava_global.feature_global.server_ssh.send_command("rm -rf netperf.tar.gz")
        lava_global.feature_global.server_ssh.send_command("cd netperf; ./install_netperf.sh")
        if lava_global.feature_global.server_ssh.send_command("which netperf"):
            msg_center.info("netperf install succed")
            return True
        else:
            msg_center.error("netperf install failed")
            return False

    @staticmethod
    def fn_install_iperf(iperf_url="", ins_path=""):
        """
        Discription:下载和安装iperf
        :param src_path:下载的url，可以不配置
        :param dst_path:目的地址，可以不配置
        :return:安装成功返回True，失败返回False
        """
        if lava_global.feature_global.server_ssh.send_command("which iperf"):
            msg_center.info("iperf is already installed")
            return True
        iperf_pkg = "iperf-2.0.5.tar.gz"
        if iperf_url == "":
            iperf_url = sys_config.DEPENDENT_URL + iperf_pkg
        if ins_path == "":
            ins_path = "/usr/bin/iperf"
        down_path = os.path.join("/tmp/", iperf_pkg)
        ins_rst = SysInit.fn_download_pkg(iperf_url, down_path)
        if not ins_rst:
            return False
        dst_dir = os.path.dirname(down_path)
        os.chdir(dst_dir)
        if "iperf-2.0.5/" not in lava_global.feature_global.server_ssh.send_command("tar -xzvf {0}".format(iperf_pkg)):
            msg_center.error("tar -xzvf {0} failed".format(iperf_pkg))
            return False
        lava_global.feature_global.server_ssh.send_command("rm -rf {0}".format(iperf_pkg))
        cmd = "cd iperf-2.0.5; sed -i 's/DAST_CHECK_BOOL/ /g' configure.ac; ./install.sh"
        lava_global.feature_global.server_ssh.send_command(cmd)
        msg_center.info(lava_global.feature_global.server_ssh.send_command("which iperf"))
        cmd = "cp /tmp/iperf-2.0.5/src/iperf /usr/bin/iperf; chmod 755 {}".format(ins_path)
        lava_global.feature_global.server_ssh.send_command(cmd)
        if lava_global.feature_global.server_ssh.send_command("which iperf"):
            msg_center.error("iperf install success")
            return True
        else:
            msg_center.info("iperf install success")
            return False

    @staticmethod
    def fn_install_iperf3(iperf3_url="", ins_path=""):
        """
        Discription:下载和安装perf3
        :param src_path:下载的url，可以不配置
        :param dst_path:目的地址，可以不配置
        :return:安装成功返回True，失败返回False
        """
        if lava_global.feature_global.server_ssh.send_command("which iperf3"):
            msg_center.info("iperf3 is already installed")
            return True
        iperf3_pkg = "iperf-3.7.tar.gz"
        if iperf3_url == "":
            iperf3_url = sys_config.DEPENDENT_URL + iperf3_pkg
        down_path = os.path.join("/tmp/", iperf3_pkg)
        ins_rst = SysInit.fn_download_pkg(iperf3_url, down_path)
        if not ins_rst:
            return False
        dst_dir = os.path.dirname(down_path)
        os.chdir(dst_dir)
        if "iperf-3.7/" not in lava_global.feature_global.server_ssh.send_command("tar -xzvf {0}".format(iperf3_pkg)):
            msg_center.error("tar -xzvf {0} failed".format(iperf3_pkg))
            return False
        lava_global.feature_global.server_ssh.send_command("rm -rf {0}".format(iperf3_pkg))
        lava_global.feature_global.server_ssh.send_command("cd iperf-3.7; ./install.sh")
        if not lava_global.feature_global.server_ssh.send_command("which iperf3"):
            msg_center.error("iperf3 install failed")
        else:
            msg_center.info("iperf3 install success")
            return True
        return False

    @staticmethod
    def fn_install_qperf(qperf_url="", ins_path=""):
        """
        Discription:下载和安装qperf
        :param src_path:下载的url，可以不配置
        :param dst_path:目的地址，可以不配置
        :return:安装成功返回True，失败返回False
        """
        if lava_global.feature_global.server_ssh.send_command("which qperf"):
            msg_center.info("qperf is already installed")
            return True
        qperf_pkg = "qperf-0.4.9.tar.gz"
        if qperf_url == "":
            qperf_url = sys_config.DEPENDENT_URL + qperf_pkg
        if ins_path == "":
            ins_path = "/usr/bin/qperf"
        down_path = os.path.join("/tmp/", qperf_pkg)
        ins_rst = SysInit.fn_download_pkg(qperf_url, down_path)
        if not ins_rst:
            return False
        dst_dir = os.path.dirname(down_path)
        os.chdir(dst_dir)
        if "qperf-0.4.9/" not in lava_global.feature_global.server_ssh.send_command("tar -xzvf {0}".format(qperf_pkg)):
            msg_center.error("tar -xzvf {0} filed".format(qperf_pkg))
            return False
        lava_global.feature_global.server_ssh.send_command("rm -rf {0}".format(qperf_pkg))
        lava_global.feature_global.server_ssh.send_command("cd qperf-0.4.9;./install.sh")
        lava_global.feature_global.server_ssh.send_command("cp /tmp/build.qperf/src/qperf /usr/bin/")
        lava_global.feature_global.server_ssh.send_command("chmod 755 {}".format(ins_path))
        if lava_global.feature_global.server_ssh.send_command("which qperf"):
            msg_center.info("install qwperf success")
        else:
            msg_center.error("install qperf failed")
            return False
        return True

    @staticmethod
    def fn_install_sshpass(sshpass_url="", ins_path=""):
        """
        Discription:下载和安装sshpass
        :param sshpass_url:下载的url，可以不配置
        :param ins_path:目的地址，可以不配置
        :return:安装成功返回True，失败返回False
        """
        if lava_global.feature_global.server_ssh.send_command("which sshpass"):
            msg_center.info("sshpass is already installed")
            return True
        sshpass_pkg = "sshpass-1.06.tar.gz"
        if sshpass_url == "":
            sshpass_url = sys_config.DEPENDENT_URL + sshpass_pkg
        if ins_path == "":
            ins_path = "/usr/local/bin/sshpass"
        down_path = os.path.join("/tmp/", sshpass_pkg)
        if not SysInit.fn_download_pkg(sshpass_url, down_path):
            return False
        dst_dir = os.path.dirname(down_path)
        os.chdir(dst_dir)
        msg_center.info(lava_global.feature_global.server_ssh.send_command("tar -xzvf {0}".format(sshpass_pkg)))
        if "sshpass-1.06/" not in lava_global.feature_global.server_ssh.send_command("tar -xzvf {0}".format(sshpass_pkg)):
            msg_center.error("tar -xzvf {0} filed".format(sshpass_pkg))
            return False
        lava_global.feature_global.server_ssh.send_command("rm -rf {0}".format(sshpass_pkg))
        lava_global.feature_global.server_ssh.send_command("cd sshpass-1.06; bash install.sh")
        if not lava_global.feature_global.server_ssh.send_command("which sshpass"):
            msg_center.error("install sshpass failed")
            return False
        lava_global.feature_global.server_ssh.send_command("chmod 755 {}".format(ins_path))
        msg_center.info("install sshpass succeed")
        return True

    @staticmethod
    def fn_install_hioadm(hioadm_url="", ins_path=""):
        """
        Discription:下载和安装hioadm
        :param src_path:下载的url，可以不配置
        :param dst_path:目的地址，可以不配置
        :return:安装成功返回True，失败返回False
        """
        if lava_global.feature_global.server_ssh.send_command("which hioadm"):
            msg_center.info("hioadm is already installed")
            return True
        os_name = sys_base_info.fn_get_os_name().split(" ")[0].lower()
        if os_name in ["redhat", "centos", "suse"]:
            hioadm_path = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "tools/hioadm")
            if ins_path == "":
                ins_path = "/usr/local/bin/hioadm"
            lava_global.feature_global.server_ssh.send_command("cp {0} {1}".format(hioadm_path, ins_path))
            lava_global.feature_global.server_ssh.send_command("chmod +x {0}".format(ins_path))
        else:
            hioadm_deb = "hioadm-4.0.2.6-1.arm64.deb"
            if hioadm_url == "":
                hioadm_url = sys_config.DEPENDENT_URL + hioadm_deb
            down_path = os.path.join("/tmp/", hioadm_deb)
            if not SysInit.fn_download_pkg(hioadm_url, down_path):
                return False
            dst_dir = os.path.dirname(down_path)
            os.chdir(dst_dir)
            lava_global.feature_global.server_ssh.send_command("dpkg -i {0}".format(hioadm_deb))
        if lava_global.feature_global.server_ssh.send_command("which hioadm"):
            msg_center.info("install hioadm success")
            return True
        else:
            msg_center.error("install hioadm failed")
            return False

    @staticmethod
    def fn_install_ifenslave():
        """
        Discription:安装ifenslave (ubuntu系统组bond需安装)
        :return:
        """
        if lava_global.feature_global.server_ssh.send_command("which ifenslave"):
            msg_center.info("ifenslave is already installed")
            return True
        else:
            # ubutu系统需要安装
            os_name = sys_base_info.fn_get_os_name()
            if os_name in ["ubuntu", "debian"]:
                lava_global.feature_global.server_ssh.send_command("apt install -y ifenslave")
                if lava_global.feature_global.server_ssh.send_command("which ifenslave"):
                    msg_center.info("ifenslave is install pass")
                    return True
                else:
                    msg_center.error("ifenslave install fail")
                    return False

    @staticmethod
    def fn_load_driver(ko_name):
        if ko_name in sys_config.DRIVER_NAME_LIST.keys():
            ko_list = sys_config.DRIVER_NAME_LIST.get(ko_name).reverse()
            for i in ko_list:
                lava_global.feature_global.server_ssh.send_command("rmmod {0}.ko".format(i))
        else:
            lava_global.feature_global.server_ssh.send_command("rmmod {0}.ko".format(ko_name))

    @staticmethod
    def fn_unload_driver(ko_name):
        if ko_name in sys_config.DRIVER_NAME_LIST.keys():
            ko_list = sys_config.DRIVER_NAME_LIST.get(ko_name)
            for i in ko_list:
                lava_global.feature_global.server_ssh.send_command("modprobe {0}".format(i))
        else:
            lava_global.feature_global.server_ssh.send_command("modprobe {0}".format(ko_name))

    @staticmethod
    def fn_load_unload_driver(ko_name, load_type=1, times=0):
        """
        加卸载驱动
        :param ko_name: 不带.ko后缀的驱动名
        :param load_type: 1加载，-1卸载，其他数字频繁加卸载驱动
        :param times: 频繁执行加卸载操作的次数，非必填参数
        :return: 无返回，由其他函数检查dmesg即可
        """
        if load_type == 1:
            SysInit.fn_load_driver(ko_name)
            time.sleep(hns_config.NETWORK_RESTART_TIME)
        elif load_type == -1:
            SysInit.fn_unload_driver(ko_name)
            time.sleep(hns_config.NETWORK_RESTART_TIME)
        else:
            for i in range(times):
                SysInit.fn_unload_driver(ko_name)
                time.sleep(hns_config.NETWORK_RESTART_TIME)
                SysInit.fn_load_driver(ko_name)
                time.sleep(hns_config.NETWORK_RESTART_TIME)

    @staticmethod
    def fn_install_pkg(packages, exec_times=1):
        """
        Discription:下载工具
        :param packages:包名
        :param exec_times:执行次数
        :return:
        """
        os_type = sys_base_info.fn_get_os_name().lower()
        # 判断系统类型
        if os_type == "ubuntu":
            fe_cmd = "DEBIAN_FRONTEND=noninteractive apt-get install -q -y"
        elif os_type == "debian":
            lava_global.feature_global.server_ssh.send_command("apt remove libgcc-8-dev -y")
            fe_cmd = "DEBIAN_FRONTEND=noninteractive apt-get install -q -y"
        elif os_type == "centos" or os_type == "redhat" or os_type == "openeuler":
            fe_cmd = "yum -e 0 -y install"
        elif os_type == "fedora":
            fe_cmd = "dnf -e 0 -y install"
        elif os_type == "opensuse" or os_type == "suse":
            fe_cmd = "zypper install -y"
        else:
            msg_center.error("WARN Types of systems not supported")
            return False
        for i in packages:
            # 判断工具是否存在，不存在则执行下载的步骤
            lava_global.feature_global.server_ssh.send_command("which {}".format(i))
            if lava_global.feature_global.server_ssh.ret_code != 0:
                msg_center.info("{} does not install yet, now get it...".format(i))
                install_cmd = fe_cmd + " " + i
                for j in range(exec_times):
                    lava_global.feature_global.server_ssh.send_command(install_cmd)
                    lava_global.feature_global.server_ssh.send_command("which {}".format(i))
                    if lava_global.feature_global.server_ssh.ret_code == 0:
                        msg_center.info("{} install passs".format(i))
                        break
                    else:
                        msg_center.error("{} install failed,please check your environment".format(i))
            else:
                msg_center.info("{} is already exist, needn't install.".format(i))
        return True

    @staticmethod
    def fn_init():
        """
        Discription:初始化安装必要的测试工具
        """
        this_room_path = os.path.realpath(__file__).split("comm_lib")[0]
        lava_global.feature_global.server_ssh.send_command("ntpdate 10.3.23.46")
        # 初始化安装测试工具
        os_type = sys_base_info.fn_get_os_name()
        SysInit.fn_install_pkg(["gcc", "make", "python", "numactl", "unzip"], 3)
        if "ubuntu" in os_type or "debian" in os_type:
            SysInit.fn_install_pkg(["libnuma-dev"], 3)
        elif "redhat" in os_type or "fedora" in os_type or "centos" in os_type:
            SysInit.fn_install_pkg(["numactl-devel"], 3)
        else:
            msg_center.error("Miss operation system type!")
        if os_type == "debian" or os_type == "ubuntu" or os_type == "uos":
            pkgs = sys_config.PKG_NAEMS_UBUNTU_DEBIAN
            SysInit.fn_init_debian_ubuntu()
        elif os_type == "centos" or os_type == "redhat" or os_type == "openeuler":
            SysInit.fn_install_iperf()
            pkgs = sys_config.PKG_NAEMS_CENTOS_REDHAT
        elif os_type == "opensuse" or os_type == "suse":
            pkgs = sys_config.PKG_NAEMS_SUSE
            SysInit.fn_init_opensuse_suse()
        else:
            msg_center.error("WARN Unsupported OS")
            return False
        if lava_global.feature_global.server_ssh.send_command("ip a|grep '172.26.101'"):
            if lava_global.feature_global.server_ssh.send_command("lsmod|grep hinic"):
                lava_global.feature_global.server_ssh.send_command("rmmod hinic")
        msg_center.info("fn_init:change MSG level to 7")
        lava_global.feature_global.server_ssh.send_command("echo 7 > /proc/sys/kernel/printk")
        # 判断sit0网口
        ip_info_tmp = lava_global.feature_global.server_ssh.send_command("ip a | grep sit0")
        if "sit0" in ip_info_tmp:
            lava_global.feature_global.server_ssh.send_command("ip a flush dev sit0")
            msg_center.info("flush sit0!")

        # roce 5.12内核态
        kernel_info = lava_global.feature_global.server_ssh.send_command("uname -a")
        if "5.12" in kernel_info and os_type == "ubuntu":
            lava_global.feature_global.server_ssh.send_command(f"insmod {this_room_path}/tools/kernel_5_12/rdma_test.ko")

        # 判断是否有/root/flag目录
        flag_path = "/root/flag"
        if os.path.exists(flag_path):
            msg_center.info("exist dir")
        else:
            os.makedirs(flag_path)
        msg_center.info("fn_init:begin to exec fn_install_pkg")
        # 安装pkg包，判断是否有.flag文件，没有就安装该flag文件的工具
        SysInit.fn_install_pkg(pkgs)
        SysInit.fn_install_iperf3()
        sut_ip_a = lava_global.feature_global.server_ssh.send_command("ip a")
        if "192.168.40.11" not in sut_ip_a:
            lava_global.feature_global.server_ssh.send_command(f"rm -f {flag_path}/rdma.flag")
        if os.path.exists(f"{flag_path}/rdma.flag") or " 0% packet loss" not in lava_global.feature_global.server_ssh.\
                send_command(f"ping {hns_config.SUT_WORK_IP} -c 3"):
            msg_center.info("exist dir")
        else:
            #ROCE升级包 roce_rdma_core_upgrade
            lava_global.feature_global.server_ssh.send_command(f"touch {flag_path}/rdma.flag")
        check_list = ["fio.flag", "iperf.flag", "netperf.flag", "qperf.flag", "sshpass.flag", "hioadm.flag"]
        for i in check_list:
            tool_name = i.split(".")[0]
            if os.path.exists(flag_path + "/{}".format(i)):
                msg_center.info("{} had been installed,ignore it".format(tool_name))
            else:
                msg_center.info(tool_name)
                msg_center.info("fn_init:begin to exec fn_install_{}".format(tool_name))
                func_name = "fn_install_" + tool_name
                eval(func_name)()
                os.mknod(flag_path + "/{}".format(i))
        if not os.path.exists("/root/flag/startup_dmesg.log"):
            lava_global.feature_global.server_ssh.send_command("dmesg > /root/flag/startup_dmesg.log")
        # ubuntu18.04.5系统安装perf工具
        os_name = sys_base_info.fn_get_os_name()
        if os_name == 'ubuntu' and lava_global.feature_global.server_ssh.send_command("which perf") != 0:
            msg_center.info("The perf tool is not installed,start to install the tool......")

            perf_path = os.path.join(this_room_path, "tools/perf_tools/")
            perf_tool = perf_path + 'perf'
            lava_global.feature_global.server_ssh.send_command(f"cp {perf_tool} /usr/bin/")
            lava_global.feature_global.server_ssh.send_command("chmod 777 /usr/bin/perf")
            lava_global.feature_global.server_ssh.send_command(f"cp {perf_path}*.so* /usr/lib/")
            if lava_global.feature_global.server_ssh.send_command("which perf") == 0:
                msg_center.info("The perf tool is successfully installed")
            else:
                msg_center.info("Failed to install the perf tool")
        # ubuntu安装可以进行CM建链的perftest工具
        if os_name == 'ubuntu' and lava_global.feature_global.server_ssh.send_command("ib_send_bw --version|tr -cd '[0-9]'") != "560":
            lava_global.feature_global.server_ssh.send_command("apt install dpkg -y")
            lava_global.feature_global.server_ssh.send_command("apt remove perftest -y")
            cmd = "wget -c -q -t 3 -T 5 --no-check-certificate -P /root http://10.90.31.79:8083/test_dependents/perftest_4.4+0.5-1_arm64.deb"
            lava_global.feature_global.server_ssh.send_command(cmd)
            lava_global.feature_global.server_ssh.send_command("dpkg -i /root/perftest_4.4+0.5-1_arm64.deb")
            lava_global.feature_global.server_ssh.send_command("apt --fix-broken install -y")
        sut_ip_a = lava_global.feature_global.server_ssh.send_command("ip a")
        msg_center.info(f"sut_ip_a:{sut_ip_a}")
        tc_ip_a = lava_global.feature_global.client_ssh.send_command("ip a")
        msg_center.info(f"tc_ip_a:{tc_ip_a}")
        SysInit.fn_init_env_choce()
        # openeuler系统安装mz工具
        if os_name == "openeuler":
            check_mz = lava_global.feature_global.server_ssh.send_command("which mz")
            if check_mz == "":
                lava_global.feature_global.server_ssh.send_command(f"cp {THIS_FILE_PATH}/../tools/nic_tools/mz /usr/sbin/")
                lava_global.feature_global.server_ssh.send_command(f"cp {THIS_FILE_PATH}/../tools/nic_tools/libnet.so.1.7.0 /usr/lib64/")
                lava_global.feature_global.server_ssh.send_command(f"cp {THIS_FILE_PATH}/../tools/nic_tools/libcli.so.1.9.7 /usr/lib64/")
                lava_global.feature_global.server_ssh.send_command(f"chmod -R 777 /usr/sbin/mz")
                lava_global.feature_global.server_ssh.send_command(f"ln -s /usr/lib64/libnet.so.1.7.0 /usr/lib64/libnet.so.1")
                lava_global.feature_global.server_ssh.send_command(f"ln -s /usr/lib64/libcli.so.1.9.7 /usr/lib64/libcli.so.1.9")

    @staticmethod
    def fn_init_debian_ubuntu():
        name_ip = "10.72.55.82"
        name_str = "source-directory /etc/network/interfaces.d"
        result_ip = lava_global.feature_global.server_ssh.send_command("cat /etc/resolv.conf |grep -v '#'|grep {}".format(name_ip))
        if name_ip in result_ip:
            msg_center.info("DNS already exist!")
        else:
            sys_base_info.fn_write_file("/etc/resolv.conf", 3, "nameserver 10.72.55.82")
            msg_center.info("set DNS!")

        result_str = lava_global.feature_global.server_ssh.send_command("/etc/network/interfaces |grep {}".format(name_str))
        if name_str in result_str:
            msg_center.info("network is OK!")
        else:
            lava_global.feature_global.server_ssh.send_command("echo {} > /etc/network/interfaces".format(name_str))
            sys_env_clean.fn_restart_network()

    @staticmethod
    def fn_init_opensuse_suse():
        # 网络状态的函数
        network_ports = lava_global.feature_global.server_ssh.send_command("ip a | grep 'state UP' | wc -l")
        ip_values = lava_global.feature_global.server_ssh.send_command("ip a | grep '192.168' | grep -v '192.168.122' | wc -l")
        network_port = int(network_ports) - 1
        if network_port == ip_values:
            msg_center.info("network ip set is OK")
        else:
            src_path = sys_config.DEPENDENT_URL + "config_other_static_ip.sh"
            dst_path = "/root/config_other_static_ip.sh"
            SysInit.fn_download_pkg(src_path, dst_path)
            time.sleep(2)
            lava_global.feature_global.server_ssh.send_command("bash /root/config_other_static_ip.sh")
            time.sleep(2)

    @staticmethod
    def fn_init_env_choce():
        # 判断当前环境
        cmd = "modinfo hisi_sas_v3_hw |grep updates|awk -F '/' '{print $5}'"
        sas_mod_info = lava_global.feature_global.server_ssh.send_command(cmd)
        if lava_global.feature_global.server_ssh.send_command("modinfo hnae3|grep updates") or sas_mod_info == "updates":
            device_type = "polestar"
            # polestar需要清除多余ipv6路由，添加ipv4缺少的路由
            all_ip = ["192.168.10", "192.168.20", "192.168.30", "192.168.40", "192.168.50", "192.168.60", "192.168.70",
                      "192.168.80", "192.168.90"]
            for i in all_ip:
                if not lava_global.feature_global.server_ssh.send_command(f"ip route|grep {i}"):
                    port_name_temp = lava_global.feature_global.server_ssh.send_command(f"ip a|grep {i}|awk '{{print $NF}}'")
                    lava_global.feature_global.server_ssh.send_command(f"ip route add dev {port_name_temp} {i}.0/24")
            cmd = "ip -6 route show|egrep -v 'lo|fe' | awk '{print $3}'|uniq"
            route_6 = lava_global.feature_global.server_ssh.send_command(cmd).split("\n")
            if len(route_6) > 1:
                msg_center.info(len(route_6))
                for polestar_port in route_6:
                    lava_global.feature_global.server_ssh.send_command(f"ifdown {polestar_port}")
                    lava_global.feature_global.server_ssh.send_command(f"ifup {polestar_port}")
        else:
            device_type = "other_type"
        return device_type
