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

from feature_lib.hns_lib import hns_common


class DevLink(object):
    """
    ============================================
    函数说明: devlink工具操作集合
    修改时间: 2022-07-01 16:47:52
    作   者: lwx567203
    ============================================
    """

    def __init__(self):
        """
        ============================================
        函数说明: 初始化操作
        修改时间: 2022-07-01 16:48:47
        作   者: lwx567203
        ============================================
        """
        pass

    @staticmethod
    def set_cca_params(bdf: str, algorithm: str, **kwargs):
        """
        ============================================
        函数说明: 配置拥塞控制算法参数
        参数说明：
            :bdf        设备号
            :algorithm  算法名称
            :params     算法参数
        修改时间: 2022-07-01 16:50:43
        作   者: lwx567203
        ============================================
        """
        terminal = kwargs.get("terminal", "server")
        params = kwargs.get("params", {})

        keywords = f"type@{algorithm}"
        for key, value in params.items():
            keywords = f"{keywords}_{key}@{value}"
        command = f"devlink dev param set pci/{bdf} name algo_param value '{keywords}' cmode runtime"
        return hns_common.exec_command(terminal=terminal, command=command)

    @staticmethod
    def get_cca_params(bdf: str, return_str=False, **kwargs):
        """
        ============================================
        函数说明: 查询拥塞控制算法信息
        参数说明：
            :bdf    设备号
        修改时间: 2022-07-01 17:46:39
        作   者: lwx567203
        ============================================
        """
        terminal = kwargs.get("terminal", "server")
        info = hns_common.exec_command(terminal, f"devlink dev param show pci/{bdf} name algo_param")
        algorithm = re.findall("type@(\\w+)_", info)
        algo = None if not algorithm else algorithm[0]
        params = dict(re.findall("_(\\w+)@(\\d+)", info))
        result = {False: dict(algorithm=algo, params=params), True: info}
        return result.get(return_str)
