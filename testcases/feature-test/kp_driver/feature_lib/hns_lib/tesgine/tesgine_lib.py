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


import IPy
import re
import time
import random
from kp_tesgine import tesgine
from common_lib.testengine_lib.engine_msg_center import msg_center


class TesGine(tesgine.Tsg):
    """
    =====================================================================
    类说明: tesgine类，调用tesgine的python脚本
    修改时间: 2021/12/17 14:24:54
    作    者: lwx567203
    =====================================================================
    """
    def __init__(self, tsg_ip="127.0.0.1", tsg_type="TESGINE_8_10GE"):
        super().__init__(tsg_ip=tsg_ip, tsg_type=tsg_type)
        self.speed = {}
        self.src_ip = {}

    def set_arp(self, port:int=0, **kwargs):
        """
        =====================================================================
        函数说明: 重写set_arp方法，arp的参数分开传递
        修改时间: 2021/12/30 09:15:18
        作    者: lwx567203
        =====================================================================
        """
        # tsg脚本对linux必须要字符串类型的
        params = {'TsuId': self.tsuid,
                  'PortId': port,
                  "ArpReply": kwargs.get("arpreply", "TRUE"),
                  "ArpKeepalive": kwargs.get("arpkeepalive", "FALSE")
        }

        # ipv4地址
        if kwargs.get("dut_ip"):
            params["DutIpAddr"] = kwargs.get("dut_ip")
        if kwargs.get("local_ip"):
            params["LocalIpAddr"] = kwargs.get("local_ip")
            params["LocalIpMask"] = kwargs.get("mask", "24")

        # ipv6地址配置
        if kwargs.get("dut_ipv6"):
            params["DutIpv6"] = IPy.IP(kwargs.get("dut_ipv6")).strNormal()
        if kwargs.get("local_ipv6"):
            params["LocalIpv6Addr"] = IPy.IP(kwargs.get("local_ipv6")).strNormal()
            params["LocalIpv6Enable"] = kwargs.get("ipv6_enable", "TRUE")
            params["LocalIpv6Num"] = kwargs.get("ipv6_num", "1")
            params["LocalIpv6ModBit"] = kwargs.get("ipv6_modbit", "128")
            params["LocalIpv6ModStep"] = kwargs.get("ipv6_modstep", "1")

        # mac配置
        if kwargs.get("src_mac"):
            params["MacAddress"] = kwargs.get("src_mac")

        # vlan配置
        if kwargs.get("vlan"):
            params["VlanId1"] = kwargs.get("vlan", "0")
            params["VlanUserPri1"] = kwargs.get("pri", "0")
            params.update({"VlanEnable": "TRUE", "VlanNumber": "TRUE"})

        print(params)
        result = self._tsu.EditEthernetLinkData(params)
        if result != "TG_OK":
            msg_center.error(result)
            return False

        return True

    def get_stats(self, port:int, stream_name:str=None, clear_flag:bool=True, **kwargs):
        """
        =====================================================================
        函数说明: 重写get_stats方法
        :param NA
        函数返回: tesgine的统计项字典
        应用举例: NA
        修改时间: 2021/12/17 14:30:45
        作    者: lwx567203
        =====================================================================
        """
        statis_filed = {
            "rx_pkts": "PS_RX_STREAM_PACKETS",
            "tx_pkts": "PS_TX_STREAM_PACKETS",
            "rx_pps": "PS_RX_PPS",
            "tx_pps": "PS_TX_PPS",
            "rx_bps": "P_RX_LINE_BPS",
            "tx_bps": "P_TX_LINE_BPS",
            "rx_ipv4_csum_error": "PS_RX_IPV4_CHECKSUM_ERRORS",
            "rx_tcp_csum_error": "PS_RX_TCP_CHECKSUM_ERRORS",
            "rx_udp_csum_error": "PS_RX_UDP_CHECKSUM_ERRORS"
        }
        result_key_list, statis_list = [], []

        for key in kwargs.get("statis_filed", []):
            if key not in statis_filed:
                continue
            statis_list.append(statis_filed.get(key))
            result_key_list.append(key)
        if not statis_list:
            statis_list = [statis_filed.get("tx_pkts")]
        statis_dict = dict(Stat=statis_list)

        # 指定查询流统计
        params = {'TsuId': self.tsuid, 'PortId': port}
        select_function = self._sta.SelectPort
        if stream_name is not None:
            params['StreamName'] = stream_name
            select_function = self._sta.SelectStream
        if select_function(params) != "TG_OK":
            return {}

        if self._sta.SelectStatisticsItems(statis_dict) != "TG_OK":
            return {}

        result = self._sta.GetStatisticsData({})
        if "ERROR" in result:
            return {}

        if clear_flag is True:
            self._sta.RemoveAllSelectedPorts({})
        return dict([(key, int(value)) for key, value in zip(result_key_list, re.findall("\\d+", result))])

    def set_speed(self, port: int, speed: int):
        """
        =====================================================================
        函数说明: 重写set_speed方法，校验speed参数范围
        修改时间: 2021/12/21 09:58:11
        作    者: lwx567203
        =====================================================================
        """
        if self.speed.get(port) == float(speed):
            return True
        if float(speed) < 0.00001:
            msg_center.waring("速率百分比小于最小值，重置为最小值0.00001%")
            self.speed[port] = 0.00001
        elif float(speed) > 100:
            msg_center.waring("速率百分比大于最大值，重置为最大值100%")
            self.speed[port] = 100
        else:
            self.speed[port] = float(speed)
        self._gen.SetSpeedMode({'TsuId': self.tsuid, 'PortId': port, "Mode": "PortControl"})
        return super().set_speed(port, self.speed.get(port, 1))

    def ethernet2(self):
        self.flow['Header'] = ['ETHERNET2']
        
    def pause(self):
        self.ethernet2()
        self.add_field(key='EthernetII.dstMac', value='01:80:c2:00:00:01')
        self.add_field(key='EthernetII.etherType', value='8808')
        self.add_custom("0001ffff")

    def pfc(self):
        self.ethernet2()
        self.add_field(key='EthernetII.dstMac', value='01:80:c2:00:00:01')
        self.add_field(key='EthernetII.etherType', value='8808')
        self.add_custom("0101000fffffffffffffffffffffffffffffffff")


    def dhcp(self):
        self.flow['Header'] = ['ETHERNET2', 'IPv4', 'UDP', "DHCP"]

    def create_stream(self, port:int, pkt_type:str, stream_name:str=None, size:int=256, **kwargs):
        """
        =====================================================================
        函数说明: 重写create_stream方法
        修改时间: 2021/12/17 16:48:10
        作    者: lwx567203
        =====================================================================
        """
        self.reload_flow_dict()

        time.sleep(1)
        if stream_name is None:
            stream_name = f"port{port}_{pkt_type}_{int(time.time())}"

        self.flow['Name'] = stream_name
        self.flow['PortId'] = port
        self.flow['RxPortId'] = port
        self.flow['MinLen'] = size

        name = pkt_type.replace('-', '_')
        try:
            function = self.__getattribute__(name)
        except AttributeError as error:
            msg_center.error(error)
        else:
            function()
        finally:
            pass

        if kwargs.get("custom", None):
            self.add_custom(kwargs.get("custom"))

        # vlan设置
        if kwargs.get("vlan", None):
            self.add_vlans(kwargs.get("vlan"))

        # 步进字段设置
        if kwargs.get("step", None):
            self.add_stepper(kwargs.get("step"))

        # 设置隧道报文内层
        inner_type = kwargs.get("inner_type", None)
        if inner_type is not None:
            ires = self.add_inner(inner_type=inner_type)
            if ires is not True:
                return False

        # ip报文option设置
        opt_name = kwargs.get("opt_name", None)
        opt_value = kwargs.get("opt_value", None)
        tunnel_inner = kwargs.get("opt_tunnel", False)
        if opt_name is not None:
            if "ipv6opt" in opt_name:
                self.add_ipv6_option(opt_value, tunnel_inner)
            else:
                self.add_ipv4_option(opt_name, opt_value, tunnel_inner)

        four_tuple_and_mac = {
            "dst_mac": "EthernetII.dstMac",
            "src_mac": "EthernetII.srcMac"
        }
        # 设置外层四元组
        if self.flow['Header'].count("IPv4") == 1:
            four_tuple_and_mac["src_ip"] = "IPv4.sourceAddr"
            four_tuple_and_mac["dst_ip"] = "IPv4.destAddr"
            four_tuple_and_mac["tos"] = "IPv4.tosDiffserv"
        if self.flow['Header'].count("IPv6") == 1:
            four_tuple_and_mac["src_ip"] = "IPv6.sourceAddr"
            four_tuple_and_mac["dst_ip"] = "IPv6.destAddr"
            four_tuple_and_mac["tclass"] = "IPv6.trafficClass"
        if self.flow['Header'].count("TCP") == 1:
            four_tuple_and_mac["src_port"] = "Tcp.sourcePort"
            four_tuple_and_mac["dst_port"] = "Tcp.destPort"
        if self.flow['Header'].count("UDP") == 1:
            four_tuple_and_mac["src_port"] = "Udp.sourcePort"
            four_tuple_and_mac["dst_port"] = "Udp.destPort"

        for key, value in four_tuple_and_mac.items():
            if not kwargs.get(key):
                continue
            self.add_field(value, kwargs.get(key))

        # 设置SetFieldValueKey
        if kwargs.get("field_value", None):
            for key, value in kwargs.get("field_value").items():
                self.add_field(key, value)

        # 设置err
        if kwargs.get("err_type", None):
            self.set_error(kwargs.get("err_type"))

        # 设置auto length fill
        if kwargs.get("auto_length", None):
            self.set_length_auto(kwargs.get("auto_length"))

        # 设置测试域
        test_block = kwargs.get("test_block", None)
        if test_block is not None:
            self.flow['TestBlock'] = test_block

        return self.add_stream()

    def enable_stream(self, port=None, name=None, flag=True, atport=False, sendenable=False):
        """
        =====================================================================
        函数说明: 是否使能流
        :param port     端口
        :param name     流名称
        :param flag     使能状态
        :param atport   应用到所有端口
        函数返回: None
        应用举例: NA
        修改时间: 2022/01/29 10:54:18
        作    者: lwx567203
        =====================================================================
        """
        params = dict(Flag=str(flag).upper(), ApplyToPort=str(atport).upper(), SendEnable=str(sendenable).upper())
        if name:
            params.update(dict(StreamName=name))
        elif port:
            params.update(dict(PortTsuId=self.tsuid, PortPortId=port))
        result = self._gen.EnableStream(params)
        if result != "TG_OK":
            return False
        return True

    def modify_raw_stream(self, name, **kwargs):
        """
        =====================================================================
        函数说明: 修改报文参数
        修改时间: 2022/02/07 18:14:36
        作    者: lwx567203
        =====================================================================
        """
        params = {"StreamName": name, "LenTypeType": "STREAM_FIXED", "SetFieldValueKey": [], "SetFieldValueValue": []}
        for key, value in kwargs.items():
            if key == "LenTypeMinLen":
                params["LenTypeMinLen"] = value
                continue
            if key == "modifier":
                self.set_field_modifier(params, value)
            else:
                params.get("SetFieldValueKey", []).append(key)
                params.get("SetFieldValueValue", []).append(value)
        if params.get("SetFieldValueKey", []) == []:
            del params["SetFieldValueKey"]
        if params.get("SetFieldValueValue", []) == []:
            del params["SetFieldValueValue"]
        result = self._gen.ModifyRawStream(params)
        if result != "TG_OK":
            return False
        return True

    @staticmethod
    def set_field_modifier(params:dict, values):
        """
        #!!=====================================================================
        # 过  程  名： set_field_modifier
        # 函数说明： 设置step递增递减
        # 参数说明：
        #         params    :  流初始配置
        #         values  :  流预期配置
        # 返  回  值：正确时返回(0, TG_OK)，错误时返回(1,错误类型)
        # 注意事项：无
        # 使用实例：tesgine.send_mode_multiburst(1, 100, 1)
        # 对应命令：无
        #
        # 
        # 生成时间： 2022-05-18
        # 生成时间： 2022-05-18
        #!!=====================================================================
        """
        params["SetFieldModifierKey"] = values.get("key", "IPv4.sourceAddr")
        params["SetFieldModifierNum"] = values.get("num", "100")
        params["SetFieldModifierStep"] = values.get("step", "1")
        params["SetFieldModifierModBit"] = values.get("modbit", "32")
        params["SetFieldModifierStepType"] = values.get("steptype", "INCREASE")
        params["SetFieldModifierUseMode"] = "FALSE"
        params["SetFieldModifierMode"] = "STREAM_BLOCK"
        params["SetRepeatModifierRepeat"] = values.get("repeat", "0")
        name = str(random.randint(1000, 9999))
        params["SetFieldModifierName"] = name
        params["SetRepeatModifierModifierName"] = name

    def send_mode_multiburst(self, port: int, **kwargs: dict):
        """
        #!!=====================================================================
        # 过  程  名： send_mode_single
        # 函数说明： 设置发包数和发包速率
        # 参数说明：
        #         port    :  tesgine port id
        #         kwargs  :  burstgapvalue、burstgapunit、 burst、 packet
        # 返  回  值：正确时返回(0, TG_OK)，错误时返回(1,错误类型)
        # 注意事项：无
        # 使用实例：tesgine.send_mode_multiburst(1, 100, 1)
        # 对应命令：无
        #
        # 
        # 生成时间： 2022-05-18
        # 生成时间： 2022-05-18
        #!!=====================================================================
        """
        parm_dict = dict({'TsuId': self.tsuid, 'SendModeType': 'MULTI_BURST', 'PortId': port,
                          'PortStreamMode': 'GEN_NORMAL'})
        parm_dict['BurstGapValue'] = kwargs.get('BurstGapValue'.lower(), '100')
        parm_dict['BurstGapUnit'] = kwargs.get('BurstGapUnit'.lower(), 'nSec')
        parm_dict['Burst'] = kwargs.get('Burst'.lower(), '1')
        parm_dict['Packet'] = kwargs.get('Packet'.lower(), '1')
        ret = self._gen.SetPortStreamMode(parm_dict)
        if ret != "TG_OK":
            msg_center.error("SetPortStreamMode failed")
            return False
        return True

    def save_config(self, file: str):
        """
        #!!=====================================================================
        # 函数说明：将配置好的tsgine信息保存到指定路径的文件中
        # 参数说明：
        #   file 带绝对路径的文件名
        # 返  回  值：True 保存成功 False 保存失败
        # 使用实例：tsg.save_config(file="/home/lixuan/tsg123.tes")
        # 对应命令：无
        #
        # 
        # 生成时间：20220323
        # 修改纪录：================================================================
        """
        ret = self._tsu.SaveConfigFile({'ConfigFile': file})
        if ret != "TG_OK":
            msg_center.error(ret)
            return False
        return True

    def get_ethernet_link_data(self, port, param):
        """
        ============================================
        函数说明: 获取tesgine的链路信息
        修改时间: 2023-02-28 16:10:44
        作   者: lwx567203
        ============================================
        """
        return self._tsu.GetEthernetLinkData({'TsuId': self.tsuid, 'PortId': port, 'Parameter': param})

