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

from common_lib.testengine_lib.engine_msg_center import msg_center
from feature_lib.sata_lib.sata_util import SataLib as sutil
from test_config.feature_config.sata_config import sata_config as scfg
from test_config.feature_config.sata_config.sata_config import sata_global


def build(**args):
    """
    功能描述：修改fio配置
    """
    buffer = "[global]\n"
    params = {
        "rw": "read",
        "direct": "1",
        "ramp_time": "1",
        "ioengine": "psync",
        "iodepth": "128",
        "numjobs": "1",
        "bs": "4K",
        "size": "102400m",
        "zero_buffers": "1",
        "group_reporting": "1",
        "ioscheduler": "noop",
        "gtod_reduce": "1",
        "iodepth_batch": "2",
        "iodepth_batch_complete": "2",
        "runtime": "10",
        "loops": "10"
    }
    for key in params:
        if key not in args.keys():
            continue
        params[key] = args.get(key)

    for key in ["rw", "direct", "ramp_time", "ioengine", "iodepth", "numjobs"]:
        buffer += "{}={}\n".format(key, params.get(key))
    if "rwmixread" in args.keys() and args.get("rwmixread") is not None:
        buffer += "{}={}\n".format("rwmixread", args.get("rwmixread"))
    if "-" in params.get("bs"):
        params["bsrange"] = params.pop("bs")
        buffer += "{}={}\n".format("bsrange", params.get("bsrange"))
    else:
        buffer += "{}={}\n".format("bs", params.get("bs"))
    if "bssplit" in args.keys() and args.get("bssplit") is not None:
        buffer += "{}={}\n".format("bssplit", args.get("bssplit"))
    if "cpus_allowed" in args.keys() and args.get("cpus_allowed") is not None:
        buffer += "{}={}\n".format("cpus_allowed", args.get("cpus_allowed"))
    if "do_verify" in args.keys() and args.get("do_verify") is not None:
        buffer += "{}={}\n".format("do_verify", args.get("do_verify"))
    if "verify" in args.keys() and args.get("verify") is not None:
        buffer += "{}={}\n".format("verify", args.get("verify"))
    for key in ["size", "zero_buffers"]:
        buffer += ";{}={}\n".format(key, params.get(key))
    buffer += "{}={}\n".format("group_reporting", params.get("group_reporting"))
    for key in ["ioscheduler", "gtod_reduce", "iodepth_batch", "iodepth_batch_complete"]:
        buffer += ";{}={}\n".format(key, params.get(key))
    buffer += "{}={}\n;thread\n".format("runtime", params.get("runtime"))
    buffer += "{}={}\n".format("loops", params.get("loops"))
    return buffer


def init(disks=None, **args):
    """
    功能描述：生成FIO配置文件.
    disks : 指定跑FIO的盘（硬盘的跑盘符，例如sda）
    """
    if disks in (None, ""):
        disks = sutil.get_all_disks()
        if not disks:
            msg_center.error(f"can't get any disk")
            return False
    else:
        if not isinstance(disks, list):
            disks = [disks]
    # build message
    scfg.fio_parameter_list = build(**args)
    for (index, dev) in enumerate(disks):
        scfg.fio_parameter_list += "[job{}]\nfilename={}\n".format(index+1, dev)

    # write fio config to file
    msg_center.info("build fio config file module")
    return sata_global.server_ssh.create_file(filename=sata_global.fio_cfg, msg=scfg.fio_parameter_list)
