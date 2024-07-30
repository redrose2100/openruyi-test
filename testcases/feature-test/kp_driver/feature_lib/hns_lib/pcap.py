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


import os
import struct
import sys
import ipaddress
from base_lib import base_global_var


class Pcap:
    def __init__(self, file_path=""):
        self.cap_file = file_path
        self.packets = None
        if sys.byteorder == "little":
            self.byte_mode = ">"
        else:
            self.byte_mode = "<"
        self._file_hander()

    def _bit_int(self, bit_val):
        # 1 字节
        return struct.unpack('%sB' % self.byte_mode, bit_val)[0]

    def _short_int(self, bit_val):
        # 2 字节
        return struct.unpack('%sH' % self.byte_mode, bit_val)[0]

    @staticmethod
    def _long_int(bit_val):
        # 4 字节
        return struct.unpack('I', bit_val)[0]

    @staticmethod
    def _char(bit_val):
        # string
        return repr(bit_val).replace('\\x', '')[2:-1]

    @staticmethod
    def _int_bin(int_val):
        return str(bin(int_val))[2:]

    @staticmethod
    def _byte(byte_val, byte_tag):
        # 0001 0100 0000 0101, 需要拆分为三段0~2、3~5、6~15, 入参[3, 2, 11]
        byte_len = sum(byte_tag)
        if len(byte_val) < byte_len:
            byte_val = "0" * (byte_len - len(byte_val)) + byte_val
        cur_pos = 0
        byte_list = []
        for i in byte_tag:
            byte_list.append(byte_val[cur_pos: cur_pos + i])
            cur_pos += i
        return byte_list

    @staticmethod
    def _get_mac_from_str(mac):
        rst_mac = ""
        for i in mac:
            tmp = str(hex(i))[2:]
            if len(tmp) == 1:
                tmp = "0" + tmp
            rst_mac += tmp + ":"
        rst_mac = rst_mac[:-1]
        base_global_var.ci_logger.debug("mac: %s" % rst_mac)
        return rst_mac

    @staticmethod
    def _get_ip_from_str(ip):
        ret_ip = ''
        for num in range(4):
            ret_ip += str(ip[num]) + "."
        ret_ip = ret_ip[:-1]
        base_global_var.ci_logger.debug("ip: %s" % ret_ip)
        return ret_ip

    def _get_ipv6_from_str(self, ipv6):
        ipv6_list = []
        for num in range(8):
            ipv6_list.append(hex(self._short_int(ipv6[num * 2:(num + 1) * 2]))[2:])
        tmp_ipv6 = ":".join(ipv6_list)
        ret_ipv6 = str(ipaddress.ip_address(tmp_ipv6))
        return ret_ipv6

    @staticmethod
    def _get_file_header(header):
        '''
        from header as a string, return a tuple
        :param header:
        :return: a tuple like below
            magic_number:'\xd4\xc3\xb2\xa1'
            version_major:'\x02\x00'
            version_minor:'\x04\x00'
            thiszone:'\x00\x00\x00\x00'
            sigfigs:'\x00\x00\x00\x00'
            snaplen:'\x00\x00\x04\x00'
            linktype:'\x01\x00\x00\x00'
        '''
        file_header = {
            'magic_number': header[0:4],
            'version_major': header[4:6],
            'version_minor': header[6:8],
            'thiszone': header[8:12],
            'sigfigs': header[12:16],
            'snaplen': header[16:20],
            'linktype': header[20:24]
        }
        base_global_var.ci_logger.debug("pcap file head: %s" % file_header)
        return file_header

    def _get_frame(self, pack, pack_dict):
        frame_data = {
            'GMTtime': pack[: 4],
            'MicroTime': pack[4: 8],
            'caplen': self._long_int(pack[8: 12]),
            'length': self._long_int(pack[12: 16])
        }
        pack_dict["frame_data"] = frame_data
        base_global_var.ci_logger.debug("this packet frame data: %s" % frame_data)
        return frame_data.get('length')

    def _get_eth(self, pack, pack_dict):
        eth_data = {
            'dst_mac': self._get_mac_from_str(pack[0:6]),
            'src_mac': self._get_mac_from_str(pack[6:12]),
            'protocol': self._char(pack[12:14])
        }
        pack_dict["eth_data"] = eth_data
        base_global_var.ci_logger.debug("this packet ethernet data: %s" % eth_data)
        return eth_data.get('protocol')

    def _get_tcp(self, pack, pack_dict):
        offset_flags = self._short_int(pack[12:14])
        offset_flags = self._int_bin(offset_flags)
        offset_flags = self._byte(offset_flags, [4, 6, 1, 1, 1, 1, 1, 1])
        tcp_data = {
            'cur_protocol': "tcp",
            'src_port': self._short_int(pack[:2]),
            'dst_port': self._short_int(pack[2:4]),
            'seq_num': self._long_int(pack[4:8]),

            'ack_num': self._long_int(pack[8:12]),
            'offset': int(int(offset_flags[0], 2)) * 4,
            'csum': self._short_int(pack[16:18]),
        }
        tcp_data['length'] = len(pack) - tcp_data.get('offset')
        base_global_var.ci_logger.debug("this packet tcp data: %s" % tcp_data)
        pack_dict["tcp_data"] = tcp_data

    def _get_tcpv6(self, pack, pack_dict):
        tcpv6_data = {
            'cur_protocol': "tcpv6",
            'src_port': self._short_int(pack[:2]),
            'dst_port': self._short_int(pack[2:4]),
            'seq_num': self._long_int(pack[4:8]),
            'ack_num': self._long_int(pack[8:12]),
            'csum': self._short_int(pack[16:18]),
        }
        base_global_var.ci_logger.debug("this packet tcpv6 data: %s" % tcpv6_data)
        pack_dict["tcpv6_data"] = tcpv6_data

    def _get_udp(self, pack, pack_dict):
        udp_data = {
            'cur_protocol': "udp",
            'src_port': self._short_int(pack[:2]),
            'dst_port': self._short_int(pack[2:4]),
            'csum': self._short_int(pack[6:8]),
        }
        base_global_var.ci_logger.debug("this packet udp data: %s" % udp_data)
        pack_dict["udp_data"] = udp_data

    def _get_udpv6(self, pack, pack_dict):
        udpv6_data = {
            'cur_protocol': "udpv6",
            'src_port': self._short_int(pack[:2]),
            'dst_port': self._short_int(pack[2:4]),
            'csum': self._short_int(pack[6:8]),
        }
        base_global_var.ci_logger.debug("this packet udpv6 data: %s" % udpv6_data)
        pack_dict["udpv6_data"] = udpv6_data

    def _get_ip(self, pack, pack_dict):
        # handle IP data
        header = self._bit_int(pack[:1])
        header = self._int_bin(header)
        header = self._byte(header, [4, 4])

        offset_tag = self._short_int(pack[6:8])
        offset_tag = self._int_bin(offset_tag)
        offset_tag = self._byte(offset_tag, [3, 13])

        ip_data = {
            'cur_protocol': "ip",
            'version': int(int(header[0], 2)),
            'length_header': int(int(header[1], 2)) * 4,
            'length': self._short_int(pack[2:4]),
            'id': self._short_int(pack[4:6]),
            'src_ip': self._get_ip_from_str(pack[12:16]),
            'dst_ip': self._get_ip_from_str(pack[16:20]),
            "flags": offset_tag[0],
            "offset": offset_tag[1],
            'protocol': self._char(pack[9:10])
        }
        pack_dict["ip_data"] = ip_data
        base_global_var.ci_logger.debug("this packet ip data: %s" % ip_data)
        self._analyse_ip_data(ip_data.get("protocol"), pack[ip_data.get("length_header"):ip_data.get("length")],
                              pack_dict)

    def _get_ipv6(self, pack, pack_dict):
        # handle IP data
        header = self._bit_int(pack[:1])
        header = self._int_bin(header)
        header = self._byte(header, [4, 4])
        ipv6_data = {
            'cur_protocol': "ipv6",
            'version': int(int(header[0], 2)),
            'length_header': 40,
            'length': self._short_int(pack[4:6]),
            'src_ip': self._get_ipv6_from_str(pack[8:24]),
            'dst_ip': self._get_ipv6_from_str(pack[24:40]),
            'protocol': self._char(pack[6:7])
        }
        pack_dict["ipv6_data"] = ipv6_data
        base_global_var.ci_logger.debug("this packet ipv6 data: %s" % ipv6_data)
        self._analyse_ipv6_data(ipv6_data.get("protocol"), pack[ipv6_data.get("length_header"):ipv6_data.get(
            "length") + ipv6_data.get("length_header")], pack_dict)

    def _get_vlan(self, pack, pack_dict):
        header = self._short_int(pack[:2])
        header = self._int_bin(header)
        header = self._byte(header, [3, 1, 12])
        vlan_data = {
            "id": int(int(header[-1], 2)),
            "protocol": self._char(pack[2:4])
        }
        vlan_data['cur_protocol'] = "vlan%s" % vlan_data.get("id")
        pack_dict["vlan%s" % vlan_data.get("id")] = vlan_data
        base_global_var.ci_logger.debug("this packet vlan%s data: %s" % (vlan_data.get("id"), vlan_data))
        self._analyse_protocol(vlan_data.get("protocol"), pack[4:], pack_dict)

    @staticmethod
    def _get_roce_gid(gid):
        ret_gid = ''
        for num in range(16):
            t_gid = str("%02x" % (int(hex(gid[num]), 16)))
            ret_gid += t_gid
            if (num % 2) == 1:
                ret_gid += ":"
        ret_gid = ret_gid[:-1]
        base_global_var.ci_logger.debug("gid: %s" % ret_gid)
        return ret_gid

    @staticmethod
    def _get_roce_qp(qp):
        ret_qp = '0x'
        for i in qp:
            ret_qp += str("%02x" % (int(hex(i), 16)))
        return ret_qp

    def _get_roce(self, pack, pack_dict):
        header = self._bit_int(pack[:1])
        header = self._int_bin(header)
        header = self._byte(header, [4, 4])

        roce_data = {
            "version": header[0],
            "payload": self._short_int(pack[4:6]) - 16,
            "source_gid": self._get_roce_gid(pack[8:24]),
            "dest_gid": self._get_roce_gid(pack[24:40]),
            "opcode": pack[40],
        }
        t_list = ["0"] * 8
        t_info = self._int_bin(pack[41])
        t_len = len(t_info)
        for k, v in enumerate(t_info):
            t_list[k - t_len] = v
        base_global_var.ci_logger.debug(t_list)
        roce_data["migreq"] = t_list[1]
        roce_data["t_ver"] = "".join(t_list[4:])

        roce_data["p_key"] = self._short_int(pack[42:44])
        roce_data["dest_qp"] = self._get_roce_qp(pack[45:48])
        roce_data["ack_rqst"] = str(self._int_bin(pack[48]))[0]
        roce_data["psn"] = int(self._get_roce_qp(pack[49:52]), 16)
        base_global_var.ci_logger.debug("this packet roce data: %s" % roce_data)

        pack_dict["roce_data"] = roce_data

    def _analyse_ip_data(self, protocol, pack, pack_dict):
        '''
        根据IP报文内容与协议类型，进行内容解析
        :param data:
        :param protocol:
        :return:
        '''
        # 1 ICMP
        # 2 IGMP
        # 4 IP in IP
        # 6 TCP
        # 17 UDP
        # 45 IDRP
        # 46 RSVP
        # 47 GRE
        # 54 NHRP
        # 88 IGRP
        # 89 OSPF
        if protocol == '06':
            self._get_tcp(pack, pack_dict)
        elif protocol == '11':
            self._get_udp(pack, pack_dict)

    def _analyse_ipv6_data(self, protocol, pack, pack_dict):
        '''
        根据IP报文内容与协议类型，进行内容解析
        :param data:
        :param protocol:
        :return:
        '''
        # 1 ICMP
        # 2 IGMP
        # 4 IP in IP
        # 6 TCP
        # 17 UDP
        # 45 IDRP
        # 46 RSVP
        # 47 GRE
        # 54 NHRP
        # 88 IGRP
        # 89 OSPF
        if protocol == '06':
            self._get_tcpv6(pack, pack_dict)
        elif protocol == '11':
            self._get_udpv6(pack, pack_dict)

    def _analyse_protocol(self, protocol, pack, pack_dict):
        # 0800: IP
        # 86dd: IPv6
        # 0806: ARP
        # 8100: vlan
        # ...
        if protocol == "0800":
            base_global_var.ci_logger.debug("protocol: %s -> ip" % protocol)
            self._get_ip(pack, pack_dict)
        elif protocol == "86dd":
            base_global_var.ci_logger.debug("protocol: %s -> ipv6" % protocol)
            self._get_ipv6(pack, pack_dict)
        elif protocol == "0806":
            base_global_var.ci_logger.debug("protocol: %s -> arp" % protocol)
        elif protocol == "8100":
            base_global_var.ci_logger.debug("protocol: %s -> vlan" % protocol)
            self._get_vlan(pack, pack_dict)
        elif protocol == "8915":
            base_global_var.ci_logger.debug("protocol: %s -> roce" % protocol)
            self._get_roce(pack, pack_dict)

    def _file_hander(self):
        packets = []

        pack_header_len = 24
        pack_frame_len = 16
        pack_eth_len = 14

        f_pcap = open(self.cap_file, 'rb')
        string_data = f_pcap.read()
        f_pcap.close()
        base_global_var.ci_logger.info("open file: %s" % self.cap_file)

        # get header information
        packet_head = self._get_file_header(string_data[:pack_header_len])
        packets.append(packet_head)

        # get each packet's information
        packet_num = 0
        i = pack_header_len
        while i < len(string_data):
            try:
                this_packet = {}
                this_pack_len = self._get_frame(string_data[i:], this_packet)
                i += pack_frame_len
                protocol = self._get_eth(string_data[i:], this_packet)
                pack_end = i + this_pack_len
                i += pack_eth_len
                self._analyse_protocol(protocol, string_data[i: pack_end], this_packet)
                packets.append(this_packet)
                i = pack_end
                packet_num += 1
                base_global_var.ci_logger.debug(
                    "end of analyzing packet num: %s, and it's end point: %s " % (packet_num, i))
                base_global_var.ci_logger.debug("########### pack of %s ################" % packet_num)
                for j in this_packet:
                    base_global_var.ci_logger.debug("# %s %s" % (j, this_packet.get(j)))
                base_global_var.ci_logger.debug("#########################################")
            except Exception as e:
                base_global_var.ci_logger.error("this packet error, end analyse, error: %s" % e)
                break
            finally:
                pass

        base_global_var.ci_logger.info("all packet num: %s" % packet_num)
        self.packets = packets
        return packets

    @staticmethod
    def _count_packet(packet, pack_type=None, cur_protocol=None, src_ip=None, src_mac=None, dst_ip=None,
                      dst_mac=None):
        found = 0
        all_para = 0
        if pack_type != None:
            all_para += 1
            if pack_type in packet.keys():
                base_global_var.ci_logger.debug("get %s packet" % pack_type)
                found += 1
            else:
                return False
        check_dict = {
            "cur_protocol": cur_protocol,
            "src_ip": src_ip,
            "src_mac": src_mac,
            "dst_ip": dst_ip,
            "dst_mac": dst_mac
        }
        for k in check_dict:
            v = check_dict.get(k)
            if v == None:
                continue
            all_para += 1
            for i in packet:
                cur_data = packet[i]
                if v == cur_data.get(k):
                    base_global_var.ci_logger.debug("found: %s %s" % (v, cur_data))
                    found += 1
                    break
        if found == all_para:
            base_global_var.ci_logger.debug("this packet is matched")
            return True
        return False

    def _count_length(self, packet, cur_protocol, src_ip=None, src_mac=None, dst_ip=None,
                      dst_mac=None):
        rst = self._count_packet(packet, None, cur_protocol, src_ip, src_mac, dst_ip, dst_mac)
        if rst == False:
            return False
        for i in packet:
            if cur_protocol == packet[i].get("cur_protocol"):
                length = packet[i].get("length")
        return length

    def count_packet(self, packets=None, pack_type=None, protocol=None, src_ip=None, src_mac=None, dst_ip=None,
                     dst_mac=None):
        if packets == None:
            packets = self.packets
        count = 0
        for i in packets[1:]:
            rst = self._count_packet(i, pack_type, protocol, src_ip, src_mac, dst_ip, dst_mac)
            if rst:
                count += 1
        base_global_var.ci_logger.info("count:  %s" % count)
        return count

    def count_length(self, protocol, packets=None, src_ip=None, src_mac=None, dst_ip=None,
                     dst_mac=None, max_length=None, min_length=None):
        if packets == None:
            packets = self.packets
        count = 0

        if max_length == None:
            max_length = 1000000
        if min_length == None:
            min_length = 0
        for i in packets[1:]:
            length = self._count_length(i, protocol, src_ip, src_mac, dst_ip, dst_mac)
            if length != None:
                if min_length <= int(length) <= max_length:
                    count += 1
        base_global_var.ci_logger.info("count:  %s" % count)
        return count

    def get_all_frame_length(self, protocol, packets=None, src_ip=None, src_mac=None, dst_ip=None,
                             dst_mac=None, ):
        if packets == None:
            packets = self.packets
        target_pack_dict = {}
        other_pack_dict = {}
        num = 0
        for i in packets[1:]:
            rst = self._count_packet(i, None, protocol, src_ip, src_mac, dst_ip, dst_mac)
            num += 1
            if rst:
                target_pack_dict[num] = i["frame_data"]["length"]
            else:
                other_pack_dict[num] = i["frame_data"]["length"]
        base_global_var.ci_logger.info("target packet count:  %s" % len(target_pack_dict))
        base_global_var.ci_logger.info("other pachet count:  %s" % len(other_pack_dict))
        return target_pack_dict, other_pack_dict


if __name__ == "__main__":
    cap = Pcap("target.cap")
    cap.count_packet(protocol="ip", dst_mac="e0:00:84:2b:41:fd")
    cap.count_length(protocol="ip", max_length=800)
    target_dict, other_dict = cap.get_all_frame_length(protocol="ip", dst_mac="e0:00:84:2b:41:fd")
