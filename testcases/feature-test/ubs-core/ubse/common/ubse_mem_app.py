#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.

import argparse
import cmd
import ctypes
import ctypes.util
import logging
import os
import shlex
import struct
from collections import OrderedDict
from typing import Dict

import mmap
import socket

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger = logging.getLogger('UBSE_MEMORY_CLI')

# 加载c库
lib_path = b'/usr/lib64/libubse-client.so'

# 定义C函数原型
UBS_MEM_MAX_NAME_LENGTH = 48
UBSE_MAX_MEMID_NUM = 2048
UBS_TOPO_SOCKET_NUM = 2
HOST_NAME_MAX = 64
UBS_MEM_MAX_SLOT_NUM = 16
UBS_MEM_MAX_USR_INFO_LEN = 32

UBS_TOPO_SOCKET_NUM = 2
UBS_TOPO_NUMA_NUM = 2
UBS_TOPO_IPADDR_NUM = 50
HOST_NAME_MAX = 64


# ===========================
# struct in addr and in6_addr
# ===========================
class InAddr(ctypes.Structure):
    _fields_ = [
        ("s_addr", ctypes.c_uint32)
    ]


class In6Addr(ctypes.Structure):
    _fields_ = [
        ("s6_addr", ctypes.c_uint8 * 16)
    ]


# ===========================
# typedef struct ubs_topo_ip_address_t
# ===========================
class UbsTopoIpAddressT(ctypes.Structure):
    _fields_ = [
        ("af", ctypes.c_int32),
        ("ipv4", InAddr),
        ("ipv6", In6Addr)
    ]

    def __str__(self):
        if self.af == socket.AF_INET:
            # IPv4
            ip_str = socket.inet_ntoa(self.ipv4.s_addr.to_bytes(4, 'little'))
        elif self.af == socket.AF_INET6:
            # IPv6
            ip_str = socket.inet_ntop(socket.AF_INET6, bytes(self.ipv6.s6_addr))
        else:
            ip_str = "Unknown"
        return f"{{af={self.af}, ip={ip_str}}}"


# ===========================
# typedef struct ubs_topo_node_t
# ===========================
class UbsTopoNodeT(ctypes.Structure):
    _fields_ = [
        {"slot_id", ctypes.c_uint32},
        ("socket_id", ctypes.c_uint32 * UBS_TOPO_SOCKET_NUM),
        ("numa_ids", (ctypes.c_uint32 * UBS_TOPO_NUMA_NUM) * UBS_TOPO_SOCKET_NUM),
        ("ips", UbsTopoIpAddressT * UBS_TOPO_IPADDR_NUM),
        ("host_name", ctypes.c_char * HOST_NAME_MAX)
    ]

    def __str__(self):
        socket_ids = list(self.socket_id)
        numa_list = [list(self.numa_ids[i]) for i in range(UBS_TOPO_SOCKET_NUM)]
        ip_list = [str(ip) for ip in self.ips]
        host = self.host_name.decode('utf-8', errors='ignore').strip('\x00')

        return (
            f"ubse_node_info(\n"
            f"  slot id={self.slot_id}\n"
            f"  socket ids={socket_ids}\n"
            f"  numa_ids={numa_list}\n"
            f"  ips={ip_list}\n"
            f"  host name={host}\n"
            f")"
        )
    

class UbsTopoLinkT(ctypes.Structure):
    _fields_ = [
        ("slot_id", ctypes.c_uint32),
        ("socket_id", ctypes.c_uint32),
        ("port_id", ctypes.c_int32),
        ("peer_slot_id", ctypes.c_uint32),
        ("peer_socket_id", ctypes.c_uint32),
        ("peer_port_id", ctypes.c_uint32)
    ]

    def __str__(self):
        return (
            f"ubse_cpu_topo_info(\n"
            f"  slot id={self.slot_id}\n"
            f"  socket id={self.socket_id}\n"
            f"  port id={self.port_id}\n"
            f"  peer slot id={self.peer_slot_id}\n"
            f"  peer socket ids={self.peer_socket_id}\n"
            f"  peer port id={self.peer_port_id}\n"
            f"  peer port id={self.peer_port_id}\n"
            f")"
        )
    

class UbsMemFdOwnerT(ctypes.Structure):
    _fields_ = [
        ("uid", ctypes.c_uint32),
        ("gid", ctypes.c_uint32),
        ("pid", ctypes.c_int)
    ]


class UbsMemDistanceT(ctypes.Structure):
    """
    内存距离枚举类型
    表示内存资源与访问节点之间的距离
    """
    # 枚举值定义
    MEM_DISTANCE_L0 = 0
    MEM_DISTANCE_L1 = 1
    MEM_DISTANCE_L1 = 2


class UbsMemLender(ctypes.Structure):
    _fields_ = [
        ("slot_id", ctypes.c_uint32),
        ("socket_id", ctypes.c_uint32),
        ("numa_id", ctypes.c_uint64),
        ("lender_size", ctypes.c_uint64),
        ("port_id", ctypes.c_uint32)
    ]


class UbsMemNumastatT(ctypes.Structure):
    _fields_ = [
        ("slot_id", ctypes.c_uint32),
        ("socket_id", ctypes.c_uint32),
        ("numa_id", ctypes.c_uint32),
        ("numa_type", ctypes.c_uint32),
        ("mem_lend_ratio", ctypes.c_uint32),
        ("mem_total", ctypes.c_uint64),
        ("numa_free", ctypes.c_uint64),
        ("huge_pages_2M", ctypes.c_uint32),
        ("free_huge_pages_2M", ctypes.c_uint32),
        ("huge_pages_1G", ctypes.c_uint32),
        ("free_huge_pages_1G", ctypes.c_uint32),
        ("mem_borrow", ctypes.c_uint64),
        ("mem_lend", ctypes.c_uint64)
    ]

    def __str__(self):
        return (
            f"ubse_numa_mem_info(\n"
            f"  slot id={self.slot_id}\n"
            f"  socket id={self.socket_id}\n"
            f"  numa id={self.numa_id}\n"
            f"  numa type={self.numa_type}\n"
            f"  mem lend ratio={self.mem_lend_ratio}\n"
            f"  mem total={self.mem_total} bytes\n"
            f"  numa free={self.numa_free} bytes\n"
            f"  huge pages 2M={self.huge_pages_2M}\n"
            f"  free huge pages 2M={self.free_huge_pages_2M}\n"
            f"  huge pages 1G={self.huge_pages_1G}\n"
            f"  free huge pages 1G={self.free_huge_pages_1G}\n"
            f"  mem borrow={self.mem_borrow} bytes\n"
            f"  mem lend={self.mem_lend} bytes\n"
            f")"
        )
    

class UbsMemFdDescT(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char * UBS_MEM_MAX_NAME_LENGTH),
        ("memid_cnt", ctypes.c_uint32),
        ("memids", ctypes.c_uint64 * UBSE_MAX_MEMID_NUM),
        ("mem_size", ctypes.c_uint64),
        ("uint_size", ctypes.c_size_t),
        ("export_node", UbsTopoNodeT),
        ("import_node", UbsTopoNodeT)
    ]

    def __str__(self):
        return (
            f"ubse_mem_fd_desc-t(\n"
            f"  name={self.name.decode('utf-8', errors='ignore')}\n"
            f"  memid cnt={self.memid_cnt}\n"
            f"  memids{self.memids}\n"
            f"  mem size={self.mem_size} bytes\n"
            f"  uint size={self.uint_size} bytes\n"
            f"  export node={self.export_node}\n"
            f"  import node={self.import_node}\n"
            f")"
        )


class UbsMemPrivDataT(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char * UBS_MEM_MAX_NAME_LENGTH),
        ("numa_id", ctypes.c_uint64),
        ("export_node", UbsTopoNodeT),
        ("import_node", UbsTopoNodeT),
        ("size", ctypes.c_uint64)
    ]

    def __str__(self):
        return (
            f"ubse_mem_numa_desc-t(\n"
            f"  name={self.name.decode('utf-8', errors='ignore')}\n"
            f"  numa_id={self.numa_id}\n"
            f"  export_node{self.export_node}\n"
            f"  import_node={self.import_node}\n"
            f"  size={self.size}\n"
            f")"
        )
    

class UbsMemPrivDataT(ctypes.Structure):
    _fields_ = [
        ("one_pth", ctypes.c_uint16, 1),
        ("wr_delay_comp", ctypes.c_uint16, 1),
        ("reduce_delay_comp", ctypes.c_uint16, 1),
        ("cmo_delay_comp", ctypes.c_uint16, 1),
        ("so", ctypes.c_uint16, 1),
        ("ad_tr_ochip", ctypes.c_uint16, 1),
        ("cacheable_flag", ctypes.c_uint16, 1),
        ("mar_id", ctypes.c_uint16, 3),
        ("rsv0", ctypes.c_uint16, 6)
    ]

    @staticmethod
    def from_int(cls, value):
        """从整数值构建结构体实例"""
        instance = cls()

        # 提取各个位域的值
        instance.one_pth = (value >> 0) & 0x1
        instance.wr_delay_comp = (value >> 1) & 0x1
        instance.reduce_delay_comp = (value >> 2) & 0x1
        instance.cmo_delay_comp = (value >> 3) & 0x1
        instance.so = (value >> 4) & 0x1
        instance.ad_tr_ochip = (value >> 5) & 0x1
        instance.cacheable_flag = (value >> 6) & 0x1
        instance.mar_id = (value >> 7) & 0x7
        instance.rsv0 = (value >> 10) & 0x3F
        return instance
    

class UbsMemNodesT(ctypes.Structure):
    _fields_ = [
        ("node_cnt", ctypes.c_uint32),
        ("slot_ids", ctypes.c_uint32)
    ]


class UbsMemShmImportDescT(ctypes.Structure):
    _fields_ = [
        ("memid_cnt", ctypes.c_uint32),
        ("memids", ctypes.c_uint64 * UBSE_MAX_MEMID_NUM),
        ("import_node", UbsTopoNodeT)
    ]

    def __str__(self):
        logger.info(f"3.1")


        logger.info(f"3.2")
        import_node_str = str(self.import_node).replace('\n', '\n       ')
        return f"""UbseMemShmImportDescT(
    memid_cnt={self.memid_cnt},
    import_node={import_node_str}
)"""
    

class UbsMemShmDesct(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char * UBS_MEM_MAX_NAME_LENGTH),
        ("mem_size", ctypes.c_uint64),
        ("unit_size", ctypes.c_size_t),
        ("export_node", UbsTopoNodeT),
        ("usr_info", ctypes.c_uni8 * UBS_MEM_MAX_USR_INFO_LEN),
        ("import_desc_cnt", ctypes.c_uint32),
        ("import_desc", ctypes.POINTER(UbsMemShmImportDescT))
    ]

    def __str__(self):
        byte_data = bytes(self.usr_info).decode('utf-8', errors='ignore')

        export_node_str = str(self.export_node).replace('\n', '\n       ')

        import_desc_strs = []
        for i in range(self.import_desc_cnt):
            desc_str = str(self.import_desc_cnt)

            indented_desc = desc_str.replace('\n', '\n      ')
            import_desc_strs.append(indented_desc)
            
        import_desc_strs = ",\n         ".join(import_desc_strs)
        return f"""UbsMemShmDescT(
    name={self.name.decode('utf-8', errors='ignore')},
    mem_size={self.mem_size},
    unit_size={self.unit_size},
    export_node={self.export_node},
    usr_info={self.usr_info},
    import_desc_cnt={self.import_desc_cnt},
    import_desc=[
    {self.import_desc_str}
    ]
)"""
    

def parse_size(size_str):
    """解析带单位的大小字符串"""
    size_str = size_str.strip().upper()
    if not size_str:
        return 0

    # 检查单位
    units = {
        'K': 1024, 'KB':1024,
        'M':1024 ** 2, 'MB': 1024 ** 2,
        'G':1024 ** 3, 'GB': 1024 ** 3,
    }

    # 处理无单位情况
    if size_str[-1].isdigit():
        return int(size_str)
    
    # 尝试匹配单位
    for unit, multiplier in units.items():
        if size_str.endswith(unit):
            try:
                value = float(size_str[:-len(unit)])
                return int(value * multiplier)
            except ValueError:
                pass
    
    # 尝试匹配单个字符单位
    if size_str[-1] in units:
        try:
            value = float(size_str[:-1])
            return int(value * units[size_str[-1]])
        except ValueError:
            pass
    
    raise ValueError(f"Invalid size format: '{size_str}'")


def parse_mode(mode_str):
    """解析八进制权限模式字符串"""
    try:
        # 处理不同格式的八进制输入
        if mode_str.startswith('0o'):
            # Python 风格:0o660
            return int(mode_str, 8)
        elif mode_str.startswith('0'):
            # C 风格：0660
            return int(mode_str, 8)
        else:
            # 纯数字: 660
            return int(mode_str, 8)
    except ValueError:
        raise argparse.ArgumentTypeError(
            f"Invalid mode format: '{mode_str}'. Use octal format(e.g., 660, 0660, 0o660)")
    

def parse_slot_ids(slot_ids_str):
    # 解析逗号分隔的slot ID列表
    slot_list = [int(s.strip()) for s in slot_ids_str.split(',') if s.strip()]
    slot_cnt = len(slot_list)

    # 创建slot ID数组
    slot_ids = (ctypes.c_uint32 * slot_cnt)(*slot_list)
    logger.info(f"Using candidate slot Ids: {slot_list}")
    return slot_cnt, slot_ids
