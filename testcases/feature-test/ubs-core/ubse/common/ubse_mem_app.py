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
            ip_str = "unknown"
        return f"{{af={self.af}, ip={ip_str}}}"


# ===========================
# typedef struct ubs_topo_node_t
# ===========================
class UbsTopoNodeT(ctypes.Structure):
    _fields_ = [
        ("slot_id", ctypes.c_uint32),
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
            f"  numa ids={numa_list}\n"
            f"  ips={ip_list}\n"
            f"  host name={host}\n"
            f")"
        )
    

class UbsTopoLinkT(ctypes.Structure):
    _fields_ = [
        ("slot_id", ctypes.c_uint32),
        ("socket_id", ctypes.c_uint32),
        ("port_id", ctypes.c_uint32),
        ("peer_slot_id", ctypes.c_uint32),
        ("peer_socket_id", ctypes.c_uint32),
        ("peer_port_id", ctypes.c_uint32)
    ]

    def __str__(self):
        return (
            f"ubse_cpu_topo_info(\n"
            f"  slot id={self.slot_id}\n"
            f"  socket ids={self.socket_id}\n"
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


class UbsMemDistanceT(ctypes.c_uint32):
    """
    内存距离枚举类型
    表示内存资源与访问节点之间的距离
    """
    # 枚举值定义
    MEM_DISTANCE_L0 = 0
    MEM_DISTANCE_L1 = 1
    MEM_DISTANCE_L2 = 2


class UbsMemLenderT(ctypes.Structure):
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
        ("mem_free", ctypes.c_uint64),
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
            f"  mem free={self.mem_free} bytes\n"
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
        ("unit_size", ctypes.c_size_t),
        ("export_node", UbsTopoNodeT),
        ("import_node", UbsTopoNodeT)
    ]

    def __str__(self):
        return (
            f"ubse_mem_fd_desc_t(\n"
            f"  name={self.name.decode('utf-8', errors='ignore')}\n"
            f"  memid_cnt={self.memid_cnt}\n"
            f"  memids={list(self.memids)[:self.memid_cnt]}\n"
            f"  mem_size={self.mem_size} bytes\n"
            f"  unit_size={self.unit_size} bytes\n"
            f"  export_node={self.export_node.slot_id}\n"
            f"  import_node={self.import_node.slot_id}\n"
            f")"
        )


class UbsMemNumaDescT(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char * (UBS_MEM_MAX_NAME_LENGTH)),
        ("numa_id", ctypes.c_int64),
        ("export_node", UbsTopoNodeT),
        ("import_node", UbsTopoNodeT),
        ("size", ctypes.c_uint64)
    ]

    def __str__(self):
        return (
            f"ubse_mem_numa_desc_t(\n"
            f"  name={self.name.decode('utf-8', errors='ignore')}\n"
            f"  numa_id={self.numa_id}\n"
            f"  export_node={self.export_node.slot_id}\n"
            f"  import_node={self.import_node.slot_id}\n"
            f"  size={self.size}"
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

    @classmethod
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
        ("slot_ids", ctypes.c_uint32 * UBS_MEM_MAX_SLOT_NUM)
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
        import_node_str = str(self.import_node).replace('\n', '\n        ')
        return f"""UbseMemShmImportDescT(
    memid_cnt={self.memid_cnt},
    import_node={import_node_str}
)"""
    

class UbsMemShmDescT(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char * UBS_MEM_MAX_NAME_LENGTH),
        ("mem_size", ctypes.c_uint64),
        ("unit_size", ctypes.c_size_t),
        ("export_node", UbsTopoNodeT),
        ("usr_info", ctypes.c_uint8 * UBS_MEM_MAX_USR_INFO_LEN),
        ("import_desc_cnt", ctypes.c_uint32),
        ("import_desc", ctypes.POINTER(UbsMemShmImportDescT))
    ]

    def __str__(self):
        byte_data = bytes(self.usr_info).decode('utf-8', errors='ignore')

        export_node_str = str(self.export_node).replace('\n', '\n    ')

        import_desc_strs = []
        for i in range(self.import_desc_cnt):
            desc_str = str(self.import_desc[i])

            indented_desc = desc_str.replace('\n', '\n        ')
            import_desc_strs.append(indented_desc)
            
        import_desc_str = ",\n        ".join(import_desc_strs)
        return f"""UbsMemShmDescT(
    name={self.name.decode('utf-8', errors='ignore')},
    mem_size={self.mem_size},
    unit_size={self.unit_size},
    export_node={export_node_str},
    usr_info (hex): {byte_data},
    import_desc_cnt={self.import_desc_cnt},
    import_desc=[
        {import_desc_str}
    ]
)"""
    

def parse_size(size_str):
    """解析带单位的大小字符串"""
    size_str = size_str.strip().upper()
    if not size_str:
        return 0

    # 检查单位
    units = {
        'K': 1024, 'KB': 1024,
        'M': 1024 ** 2, 'MB': 1024 ** 2,
        'G': 1024 ** 3, 'GB': 1024 ** 3
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
            f"Invalid mode format: '{mode_str}'. Use octal format (e.g., 660, 0660, 0o660)")
    

def parse_slot_ids(slot_ids_str):
    # 解析逗号分隔的slot ID列表
    slot_list = [int(s.strip()) for s in slot_ids_str.split(',') if s.strip()]
    slot_cnt = len(slot_list)

    # 创建slot ID数组
    slot_ids = (ctypes.c_uint32 * slot_cnt)(*slot_list)
    logger.info(f"Using candidate slot IDs: {slot_list}")
    return slot_cnt, slot_ids


def parse_node_list(node_str):
    if not node_str:
        return []

    try:
        return [int(node_id.strip()) for node_id in node_str.split(',') if node_id.strip()]
    except ValueError:
        raise ValueError(f"Invalid node ID format: '{node_str}'")


def create_nodes_struct(node_ids):
    node_cnt = min(len(node_ids), UBS_MEM_MAX_SLOT_NUM)
    nodes = UbsMemNodesT()
    nodes.node_cnt = node_cnt

    # 填充节点ID
    for i in range(node_cnt):
        nodes.slot_ids[i] = node_ids[i]
    
    return nodes


def gen_mem_priv_data():
    mem_priv_data = UbsMemPrivDataT()
    mem_priv_data.one_pth = 0
    mem_priv_data.wr_delay_comp = 0
    mem_priv_data.reduce_delay_comp = 0
    mem_priv_data.cmo_delay_comp = 0
    mem_priv_data.so = 0
    mem_priv_data.ad_tr_ochip = 1
    mem_priv_data.cacheable_flag = 1
    mem_priv_data.mar_id = 0
    mem_priv_data.rsv0 = 0
    return mem_priv_data


def _concurrent_execute(operation, count, concurrency, **kwargs):
    """通用并发执行函数"""
    from concurrent.futures import ThreadPoolExecutor
    import threading

    success_count = 0
    failure_count = 0
    lock = threading.Lock()

    def wrapper(index):
        nonlocal success_count, failure_count
        result = operation(index=index, **kwargs)
        with lock:
            if result:
                success_count += 1
            else:
                failure_count += 1
        return result
    
    # 使用线程池控制并发
    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        futures = [executor.submit(wrapper, i) for i in range(count)]
        for future in futures:
            future.result() # 等待所有任务完成
        
    return success_count, failure_count


def parse_lender_info(slot_id, socket_id, lender_port, numa_infos):
    # 处理 NUMA ID 参数
    numa_sizes: Dict[int, int] = OrderedDict()
    if numa_infos:
        for numa_pair in numa_infos:
            try:
                numa_id = int(numa_pair[0])
                size = parse_size(numa_pair[1])

                if numa_id < 0:
                    raise ValueError("NUMA ID must be non-negative")
                if size <= 0:
                    raise ValueError("Size must be positive")
                
                if numa_id in numa_sizes:
                    logger.warning(f"NUMA ID {numa_id} specified multiple times, using last value")

                numa_sizes[numa_id] = size
            except ValueError as ex:
                logger.error(f"Invalid NUMA ID/size pair: {numa_pair} - {ex}")
                raise ex
    
    # 如果没有有效地 NUMA 信息，返回空指针
    if not numa_sizes:
        return 0, None
    #准备 lender 结构体数组
    lender_cnt = len(numa_sizes)
    lenders = (UbsMemLenderT * lender_cnt)()

    # 填充结构体数组
    for i, (numa_id, size) in enumerate(numa_sizes.items()):
        lenders[i].slot_id = slot_id
        lenders[i].socket_id = socket_id
        lenders[i].numa_id = numa_id
        lenders[i].lender_size = size
        lenders[i].port_id = lender_port
    return lender_cnt, lenders


class NUMAManager:
    """NUMA 内存管理器"""
    
    def __init__(self):
        self.libnuma = self._load_libnuma()
        # NUMA 策略常量
        self.MPOL_DEFAULT = 0
        self.MPOL_BIND = 1
        self.MPOL_INTERLEAVE = 2
        self.MPOL_PREFERRED = 3
        self.MPOL_LOCAL = 4

        # 标志常量
        self.MPROT_READ = 0x1
        self.MPROT_WRITE = 0x2
        self.MPROT_EXEC = 0x4

        self.MAP_SHARED = 0x01
        self.MAP_PRIVATE = 0x02
        self.MAP_ANONYMOUS = 0x20
        self.MAP_HUGETLB = 0x40000

        self.numa_blocks = {} # 存储分配的 NUMA 内存块 {numa_id: (address, size)}
    
    def _load_libnuma(self):
        """加载 libnuma 库"""
        lib_path = ctypes.util.find_library('numa')
        if not lib_path:
            logger.warning("libnuma not found, NUMA functionality will be unavailable")
            return None
        try:
            lib = ctypes.CDLL(lib_path)

            # 定义函数原型
            lib.numa_available.restype = ctypes.c_int
            lib.numa_max_node.restype = ctypes.c_int
            lib.numa_alloc_onnode.restype = ctypes.c_void_p
            lib.numa_free.restype = None
            lib.numa_node_of_cpu.restype = ctypes.c_int
            lib.numa_run_on_node.restype = ctypes.c_int
            lib.numa_preferred.restype = ctypes.c_int

            # 定义 mbind 函数原型
            lib.mbind.argtypes = [
                ctypes.c_void_p, # addr
                ctypes.c_ulong, # len
                ctypes.c_int, # mode
                ctypes.POINTER(ctypes.c_ulong), # nodemask
                ctypes.c_ulong, # maxnode
                ctypes.c_ulong # flags
            ]
            lib.mbind.restype = ctypes.c_int

            # 检查 NUMA 可用性
            if lib.numa_available() == -1:
                logger.warning("NUMA not available")
                return None
            
            return lib
        except Exception as e:
            logger.warning(f"Failed to load libnuma: {e}")
            return None

    def is_available(self):
        """检查 NUMA 是否可用"""
        return self.libnuma is not None and self.libnuma.numa_available() != -1

    def get_max_node(self):
        """获取最大节点号"""
        if not self.is_available():
            return 0
        return self.libnuma.numa_max_node()

    def is_numa_node_available(self, node_id):
        """检查 NUMA 节点是否可用"""
        node_path = f"/sys/devices/system/node/node{node_id}"
        return os.path.exists(node_path)
    
    def allocate_on_node(self, numa_id, size_bytes):
        """在指定 NUMA 节点上分配内存"""
        if not self.is_available():
            raise RuntimeError("NUMA not available")
        # 确保大小是页面大小的倍数
        page_size = os.sysconf("SC_PAGESIZE")
        aligned_size = ((size_bytes + page_size - 1) // page_size) * page_size
        # 检查节点是否可用
        if not self.is_numa_node_available(numa_id):
            raise ValueError(f"NUMA {numa_id} not available")
        try:
            #使用 Python mmap 分配匿名内存
            mmap_obj = mmap.mmap(
                -1,
                aligned_size,
                flags=mmap.MAP_PRIVATE | mmap.MAP_ANONYMOUS,
                prot=mmap.PROT_READ | mmap.PROT_WRITE
            )

            #获取内存地址
            ptr = ctypes.addressof(ctypes.c_char.from_buffer(mmap_obj))

            #准备节点掩码
            nodemask = (ctypes.c_ulong * 1)(1 << numa_id)

            # 绑定内存到NUMA节点
            result = self.libnuma.mbind(
                ptr,
                aligned_size,
                self.MPOL_BIND,
                nodemask,
                8 * ctypes.sizeof(ctypes.c_ulong),
                0
            )

            if result != 0:
                errno = ctypes.get_errno()
                mmap_obj.close()
                raise RuntimeError(f"Failed to bind the memory: {os.strerror(errno)}")

            # 记录分配的内存
            self.numa_blocks[numa_id] = (ptr, aligned_size, mmap_obj)
            return ptr, aligned_size
        except Exception as e:
            raise

    def free_on_node(self, numa_id):
        """释放指定 NUMA 节点上的内存"""
        if not self.is_available():
            raise RuntimeError("NUMA not available")

        if numa_id not in self.numa_blocks:
            raise ValueError(f"No memory allocated on numa {numa_id}")
        
        ptr, size_bytes, mmap_obj = self.numa_blocks[numa_id]
        try:
            # 关闭 mmap 对象会释放内存
            mmap_obj.close()
        except Exception as e:
            raise
        finally:
            # 从记录中移除
            del self.numa_blocks[numa_id]

    def free_all(self):
        """释放所有NUMA 内存"""
        for numa_id in list(self.numa_blocks.keys()):
            self.free_on_node(numa_id)
    
    def read_memory(self, numa_id, offset, length):
        """从NUMA内存读取数据"""
        if not self.is_available():
            raise RuntimeError("NUMA not available")
        
        if numa_id not in self.numa_blocks:
            raise ValueError(f"No memory allocated on numa {numa_id}")

        ptr, size_bytes, mmap_obj = self.numa_blocks[numa_id]

        if offset + length > size_bytes:
            raise ValueError(f"The read range exceeds the memory boundary (0-{size_bytes - 1})")

        # 使用 ctypes 读取内存
        buffer = (ctypes.c_char * length).from_address(ptr + offset)
        return bytes(buffer)

    def write_memory(self, numa_id, offset, data):
        """向NUMA内存写入数据"""
        if not self.is_available():
            raise RuntimeError("NUMA not available")
        
        if numa_id not in self.numa_blocks:
            raise ValueError(f"No memory allocated on numa {numa_id}")
        
        ptr, size_bytes, mmap_obj = self.numa_blocks[numa_id]

        if offset + len(data) > size_bytes:
            raise ValueError(f"The write range exceeds the memory boundary (0-{size_bytes - 1})")

        # 使用ctypes写入内存
        ctypes.memmove(ptr + offset, data, len(data))

    def get_node_info(self, numa_id):
        """获取NUMA节点信息"""
        if not self.is_available():
            raise RuntimeError("NUMA不可用")
        
        # 获取首选节点
        preferred = self.libnuma.numa_preferred()

        # 获取当前运行的节点
        current_node = -1
        try:
            #尝试获取当前CPU的节点
            current_node = self.libnuma.numa_node_of_cpu(0)
        except:
            pass
        
        return {
            "id": numa_id,
            "preferred": preferred == numa_id,
            "current": current_node == numa_id,
            "max_node": self.get_max_node()
        }


class UbseMemApp(cmd.Cmd):
    """远端内存管理交互式命令行工具"""

    def __init__(self):
        super().__init__()
        self.prompt = "ubse_mem_app> "
        self.intro = 'Welcome to UbseMemApp. Type help or ? to list commands.'
        self.current_device = None
        self.mmap_obj = None
        self.fd = None
        self.mem_size = 134217728
        self.numa_manager = NUMAManager()
        try:
            self.lib_ubse = ctypes.CDLL(lib_path)
        except OSError as ex:
            logger.error(f"Unable to load library {lib_path} : {ex}")
            raise
        self.set_function_prototypes()
    
    def set_function_prototypes(self):
        """设置C函数的参数类型和返回值类型"""
        # 定义函数原型
        self.lib_ubse.ubs_engine_client_initialize.argtypes = [ctypes.c_char_p]
        self.lib_ubse.ubs_engine_client_initialize.restype = ctypes.c_int32

        self.lib_ubse.ubs_error_name.argtypes = [ctypes.c_int32] # int32_t error
        self.lib_ubse.ubs_error_name.restype = ctypes.c_char_p # const char * 

        self.lib_ubse.ubs_error_string.argtypes = [ctypes.c_int32] # int32_t error
        self.lib_ubse.ubs_error_string.restype = ctypes.c_char_p # const char *

        # node
        self.lib_ubse.ubs_topo_node_local_get.argtypes = [ctypes.POINTER(UbsTopoNodeT)]
        self.lib_ubse.ubs_topo_node_local_get.restype = ctypes.c_int32

        self.lib_ubse.ubs_topo_node_list.argtypes = [ctypes.POINTER(ctypes.POINTER(UbsTopoNodeT)),
                                                     ctypes.POINTER(ctypes.c_uint32)]
        self.lib_ubse.ubs_topo_node_list.restype = ctypes.c_int32

        self.lib_ubse.ubs_topo_link_list.argtypes = [
            ctypes.POINTER(ctypes.POINTER(UbsTopoLinkT)),
            ctypes.POINTER(ctypes.c_uint32)
        ]
        self.lib_ubse.ubs_topo_link_list.restype = ctypes.c_int32

        self.lib_ubse.ubs_mem_numastat_get.argtypes = [
            ctypes.c_uint32,
            ctypes.POINTER(ctypes.POINTER(UbsMemNumastatT)),
            ctypes.POINTER(ctypes.c_uint32)
        ]
        self.lib_ubse.ubs_mem_numastat_get.restype = ctypes.c_int32

        # fd
        self.lib_ubse.ubs_mem_fd_create.argtypes = [
            ctypes.c_char_p, # name
            ctypes.c_uint64, # size
            ctypes.POINTER(UbsMemFdOwnerT), # owner
            ctypes.c_uint32, # mode
            UbsMemDistanceT, # distance
            ctypes.POINTER(UbsMemFdDescT) # desc
        ]
        self.lib_ubse.ubs_mem_fd_create.restype = ctypes.c_int32

        self.lib_ubse.ubs_mem_fd_create_with_lender.argtypes = [
            ctypes.c_char_p, # const char *name
            ctypes.POINTER(UbsMemFdOwnerT), # const ubse_mem_fd_owner_t *owner
            ctypes.c_uint32, # mode_t mode (使用c_uint32表示mode_t)
            ctypes.POINTER(UbsMemLenderT), # const ubse_mem_lender_t *lender
            ctypes.c_uint32, # uint32_t lender_cnt
            ctypes.POINTER(UbsMemFdDescT) # ubse_mem_fd_desc_t *fd_desc
        ]
        self.lib_ubse.ubs_mem_fd_create_with_lender.restype = ctypes.c_int

        self.lib_ubse.ubs_mem_fd_delete.argtypes = [ctypes.c_char_p]
        self.lib_ubse.ubs_mem_fd_delete.restype = ctypes.c_int32

        self.lib_ubse.ubs_mem_fd_get.argtypes = [ctypes.c_char_p, ctypes.POINTER(UbsMemFdDescT)]
        self.lib_ubse.ubs_mem_fd_get.restype = ctypes.c_int32

        self.lib_ubse.ubs_mem_fd_list.argtypes = [ctypes.POINTER(ctypes.POINTER(UbsMemFdDescT)),
                                                  ctypes.POINTER(ctypes.c_uint32)]
        self.lib_ubse.ubs_mem_fd_list.restype = ctypes.c_int32


        self.lib_ubse.ubs_mem_numa_create_with_lender.argtypes = [
            ctypes.c_char_p, # const char *name
            ctypes.POINTER(UbsMemLenderT), # const ubse_mem_lender_t * lender
            ctypes.c_uint32, # uint32_t lender_cnt
            ctypes.POINTER(UbsMemNumaDescT) # ubse_mem_numa_desc_t *numa_desc
        ]
        self.lib_ubse.ubs_mem_numa_create_with_lender.restype = ctypes.c_int

        self.lib_ubse.ubs_mem_numa_delete.argtypes = [ctypes.c_char_p]
        self.lib_ubse.ubs_mem_numa_delete.restype = ctypes.c_int32

        self.lib_ubse.ubs_mem_numa_get.argtypes = [ctypes.c_char_p, ctypes.POINTER(UbsMemNumaDescT)]
        self.lib_ubse.ubs_mem_numa_get.restype = ctypes.c_int32

        self.lib_ubse.ubs_mem_numa_list.argtypes = [ctypes.POINTER(ctypes.POINTER(UbsMemNumaDescT)),
                                                    ctypes.POINTER(ctypes.c_uint32)]
        self.lib_ubse.ubs_mem_numa_list.restype = ctypes.c_int32


    def print_error(self, error_code):
        name_ptr = self.lib_ubse.ubs_error_name(error_code)
        error_name = name_ptr.decode('utf-8') if name_ptr else "UNKNOWN_ERROR"

        # 获取错误描述
        desc_ptr = self.lib_ubse.ubs_error_string(error_code)
        error_desc = desc_ptr.decode('utf-8') if desc_ptr else "Unknown error"
        return f"[UBS Error {error_code}] {error_name}: {error_desc}"

    def _create_single_fd(self, name, size, owner_uid, owner_gid, owner_pid, mode, slot_ids, distance, slot_cnt,
                            index=None):
        """创建单个FD内存区域的辅助函数"""
        # 如果有索引，修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')

            owner = UbsMemFdOwnerT()
            owner.uid = owner_uid
            owner.gid = owner_gid
            owner.pid = owner_pid
            fd_desc = UbsMemFdDescT()

            if slot_ids:
                parsed_slot_cnt, parsed_slot_ids = parse_slot_ids(slot_ids)
                if slot_cnt:
                    parsed_slot_cnt = slot_cnt
                result = self.lib_ubse.ubs_mem_fd_create_with_candidate(
                    name_bytes, parse_size(size), ctypes.byref(owner),
                    mode, parsed_slot_ids, parsed_slot_cnt, ctypes.byref(fd_desc))
            else:
                result = self.lib_ubse.ubs_mem_fd_create(   
                    name_bytes, parse_size(size), ctypes.byref(owner),
                    mode, distance, ctypes.byref(fd_desc))
            
            if result == 0:
                logger.info(f"Successfully created FD-form memory: {actual_name}")
                logger.info(fd_desc)
                return True
            else:
                logger.error(f"Failed to create {actual_name}! {self.print_error(result)}")
                return False
        except Exception as ex:
            logger.error(f"Failed to create memory {actual_name}! {ex}")
            return False

    def _eate_single_fd_with_lender(self, name, lender_slot_id, lender_socket_id, lender_port,
                                    numa_id, owner_uid, owner_gid, owner_pid, mode, lender_cnt, index=None):
        """创建单个带lender的FD内存区域的辅助函数"""
        # 如果以索引，修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')

            owner = UbsMemFdOwnerT()
            owner.uid = owner_uid
            owner.gid = owner_gid
            owner.pid = owner_pid
            
            # 处理 NUMA ID 参数
            lender_count, lenders = parse_lender_info(lender_slot_id, lender_socket_id, lender_port, numa_id)

            if lender_cnt is not None:
                lender_count = lender_cnt
            
            fd_desc = UbsMemFdDescT()
            result = self.lib_ubse.ubs_mem_fd_create_with_lender(
                name_bytes, ctypes.byref(owner), mode, lenders, lender_count, ctypes.byref(fd_desc)
            )

            if result == 0:
                logger.info(f"Successfully created FD-form memory with lender: {actual_name}")
                logger.info(fd_desc)
                return True
            else:
                logger.error(f"Failed to create {actual_name}! {self.print_error(result)}")
                return False
        except Exception as ex:
            logger.error(f"Failed to create memory {actual_name}! {ex}")
            return False

    def _delete_single_fd(self, name, index=None):
        """删除单个FD内存区域的辅助函数"""
        # 如果有索引， 修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')
            result = self.lib_ubse.ubs_mem_fd_delete(name_bytes)

            if result == 0:
                logger.info(f"Successfully deleted FD-form memory: {actual_name}")
                return True
            else:
                logger.error(f"Failed to delete {actual_name}! {self.print_error(result)}")
                return False

        except Exception as ex:
            logger.error(f"Failed to delete memory {actual_name}! {ex}")
        return False

    def _create_single_numa(self, name, size, slot_ids, distance, slot_cnt, index=None):
        """创建单个NUMA内存区域的辅助函数"""
        # 如果以索引，修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')
            numa_desc = UbsMemNumaDescT()
            
            if slot_ids:
                parsed_slot_cnt, parsed_slot_ids = parse_slot_ids(slot_ids)
                if slot_cnt:
                    parsed_slot_cnt = slot_cnt
                result = self.lib_ubse.ubs_mem_numa_create_with_candidate(
                    name_bytes, parse_size(size), parsed_slot_ids, parsed_slot_cnt, ctypes.byref(numa_desc))
            else:
                result = self.lib_ubse.ubs_mem_numa_create(   
                    name_bytes, parse_size(size), distance, ctypes.byref(numa_desc))
            
            if result == 0:
                logger.info(f"Successfully created Numa-form memory: {actual_name}")
                logger.info(numa_desc)
                return True
            else:
                logger.error(f"Failed to create {actual_name}! {self.print_error(result)}")
                return False
        except Exception as ex:
            logger.error(f"Failed to create memory {actual_name}! {ex}")
            return False
            
    def _create_single_numa_with_lender(self, name, lender_slot_id, lender_socket_id, lender_port, numa_id, lender_cnt,
                                        index=None):
        """创建单个带lender的NUMA内存区域的辅助函数"""
        # 如果以索引，修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')

            # 处理 NUMA ID 参数
            lender_count, lenders = parse_lender_info(lender_slot_id, lender_socket_id, lender_port, numa_id)

            if lender_cnt is not None:
                lender_count = lender_cnt
            
            numa_desc = UbsMemNumaDescT()
            result = self.lib_ubse.ubs_mem_numa_create_with_lender(name_bytes, lenders, lender_count, 
                                                                    ctypes.byref(numa_desc))

            if result == 0:
                logger.info(f"Successfully created Numa-form memory with lender: {actual_name}")
                logger.info(numa_desc)
                return True
            else:
                logger.error(f"Failed to create {actual_name}! {self.print_error(result)}")
                return False
        except Exception as ex:
            logger.error(f"Failed to create memory {actual_name}! {ex}")
            return False

    def _delete_single_numa(self, name, index=None):
        """删除单NUMA内存区域的辅助函数"""
        # 如果有索引，修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')
            result = self.lib_ubse.ubs_mem_numa_delete(name_bytes)

            if result == 0:
                logger.info(f"Successfully deleted Numa-form memory: {actual_name}")
                return True
            else:
                logger.error(f"Failed to delete {actual_name}! {self.print_error(result)}")
                return False

        except Exception as ex:
            logger.error(f"Failed to delete memory {actual_name}! {ex}")
        return False

    def _create_single_shm(self, name, size, region, provider, usr_info, flag, region_cnt, provider_cnt,
                            index=None):
        """创建单个共享内存区域的辅助函数"""
        # 提前定义actual_name以确保异常处理中可用
        actual_name = f"{name}_{index}" if index is not None else name
        
        try:
            name_bytes = actual_name.encode('utf-8')

            # 处理用户信息
            usr_info_arr = (ctypes.c_uint8 * UBS_MEM_MAX_USR_INFO_LEN)()
            for i in range(min(len(usr_info), UBS_MEM_MAX_USR_INFO_LEN)):
                usr_info_arr[i] = ord(usr_info[i])

            # 处理区域节点
            region_nodes = parse_node_list(region)
            region_struct = create_nodes_struct(region_nodes)
            if region_cnt is not None:
                region_struct.node_cnt = region_cnt
                
            # 处理提供者节点
            provider_nodes = parse_node_list(provider)
            if provider_nodes:
                provider_struct = create_nodes_struct(provider_nodes)
                if provider_cnt is not None:
                    provider_struct.node_cnt = provider_cnt
                provider_ptr = ctypes.pointer(provider_struct)
            else:
                provider_ptr = ctypes.POINTER(UbsMemNodesT)()

            # 调用C库函数
            result = self.lib_ubse.ubs_mem_shm_create(
                name_bytes, parse_size(size),
                ctypes.byref(usr_info_arr),
                flag,
                ctypes.byref(region_struct),
                provider_ptr
            )

            if result == 0:
                logger.info(f"Successfully created share memory: {actual_name}")
                return True
            else:
                logger.error(f"Failed to create {actual_name}! {self.print_error(result)}")
                return False
        except ValueError as ex:
            logger.error(f"Invalid node list for {actual_name}: {ex}")
            return False
        except Exception as ex:
            logger.error(f"Failed to create memory {actual_name}! {ex}")
            return False
    
    def _attach_single_shm(self, name, owner_uid, owner_gid, owner_pid, mode, index=None):
        """导入单个共享内存区域的辅助函数"""
        # 提前定义actual_name以确保异常处理中可用
        actual_name = f"{name}_{index}" if index is not None else name
        
        try:
            name_bytes = actual_name.encode('utf-8')

            owner = UbsMemFdOwnerT()
            owner.uid = owner_uid
            owner.gid = owner_gid
            owner.pid = owner_pid 

            shm_descs_ptr = ctypes.POINTER(UbsMemShmDescT)()
            result = self.lib_ubse.ubs_mem_shm_attach(
                name_bytes,
                ctypes.byref(owner),
                mode,
                ctypes.byref(shm_descs_ptr)
            )

            if result == 0:
                logger.info(f"Successfully attached share memory: {actual_name}")
                logger.info(shm_descs_ptr.contents)
                self.lib_ubse.free(shm_descs_ptr)
                return True
            else:
                logger.error(f"Failed to attach {actual_name}! {self.print_error(result)}")
                return False
        except Exception as ex:
            logger.error(f"Failed to attach memory {actual_name}! {ex}")
            return False

    def _detach_single_shm(self, name, index=None):
        """删除导入SHM内存区域的辅助函数"""
        # 如果以索引，修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')
            result = self.lib_ubse.ubs_mem_shm_detach(name_bytes)

            if result == 0:
                logger.info(f"Successfully detach share memory: {actual_name}")
                return True
            else:
                logger.error(f"Failed to detach {actual_name}! {self.print_error(result)}")
                return False

        except Exception as ex:
            logger.error(f"Failed to detach memory {actual_name}! {ex}")
        return False

    def _delete_single_shm(self, name, index=None):
        """删除SHM内存区域的辅助函数"""
        # 如果以索引，修改名称以确保唯一性
        actual_name = f"{name}_{index}" if index is not None else name
        try:
            name_bytes = actual_name.encode('utf-8')
            result = self.lib_ubse.ubs_mem_shm_delete(name_bytes)

            if result == 0:
                logger.info(f"Successfully delete share memory: {actual_name}")
                return True
            else:
                logger.error(f"Failed to delete {actual_name}! {self.print_error(result)}")
                return False

        except Exception as ex:
            logger.error(f"Failed to delete memory {actual_name}! {ex}")
        return False

    def do_node_get(self, arg):
        """Get local node info: node_get"""
        try:
            # 调用获取函数
            node_info = UbsTopoNodeT()
            result = self.lib_ubse.ubs_topo_node_local_get(ctypes.byref(node_info))

            if result == 0:
                logger.info(f"Successfully get local node info")
                logger.info(node_info)
            else:
                logger.error(f"Failed to get local node information")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Unexpected error: {ex}")

    def do_node_list(self, arg):
        """Get all node info: node_list"""

        try:
            # 调用获取函数
            node_infos_ptr = ctypes.POINTER(UbsTopoNodeT)()
            node_infos_cnt = ctypes.c_uint32(0)
            result = self.lib_ubse.ubs_topo_node_list(ctypes.byref(node_infos_ptr), ctypes.byref(node_infos_cnt))

            if result == 0:
                logger.info(f"Successfully get all node info")
                for i in range(node_infos_cnt.value):
                    resource_ptr = ctypes.cast(
                        ctypes.addressof(node_infos_ptr.contents) + i * ctypes.sizeof(UbsTopoNodeT),
                        ctypes.POINTER(UbsTopoNodeT)
                    )
                    logger.info(resource_ptr.contents)
                self.lib_ubse.free(node_infos_ptr)
            else:
                logger.error(f"Failed to get all node information")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Unexpected error: {ex}")

    def do_cpu_topo(self, arg):
        """Get cpu topo info: cpu_topo"""
        try:
            links_ptr = ctypes.POINTER(UbsTopoLinkT)()
            link_cnt = ctypes.c_uint32(0)

            # 调用函数
            result = self.lib_ubse.ubs_topo_link_list(
                ctypes.byref(links_ptr),
                ctypes.byref(link_cnt)
            )

            if result == 0:
                logger.info(f"Successfully get cpu topo info")
                for i in range(link_cnt.value):
                    resource_ptr = ctypes.cast(
                        ctypes.addressof(links_ptr.contents) + i * ctypes.sizeof(UbsTopoLinkT),
                        ctypes.POINTER(UbsTopoLinkT)
                    )
                    logger.info(resource_ptr.contents)
                self.lib_ubse.free(links_ptr)
            else:
                logger.error(f"Failed to get cpu topo info")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Unexpected error: {ex}")

    def do_numa_info(self, arg):
        """Get numa info: numa_topo <node_id>"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("node_id", type=int)
            arg = parser.parse_args(shlex.split(arg))

            # 调用函数
            numa_infos_ptr = ctypes.POINTER(UbsMemNumastatT)()
            numa_infos_cnt = ctypes.c_uint32(0)
            result = self.lib_ubse.ubs_mem_numastat_get(arg.node_id, ctypes.byref(numa_infos_ptr),
                                                        ctypes.byref(numa_infos_cnt))
            
            if result == 0:
                logger.info(f"Successfully get numa info")
                for i in range(numa_infos_cnt.value):
                    resource_ptr = ctypes.cast(
                        ctypes.addressof(numa_infos_ptr.contents) + i * ctypes.sizeof(UbsMemNumastatT),
                        ctypes.POINTER(UbsMemNumastatT)
                    )
                    logger.info(resource_ptr.contents)
                self.lib_ubse.free(numa_infos_ptr)
            else:
                logger.error(f"Failed to get numa info")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Unexpected error: {ex}")

    def do_fd_create(self, arg):
        """Create remote memory in FD form: fd_create <name> <size> [--owner_uid=] [--owner_gid=] [--owner_pid=]
        [--mode=] [--slot_ids] [--distance] [--slot_cnt] [--count=] [--concurrecy=]"""
        
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name")
            parser.add_argument("size", type=str)
            parser.add_argument("--owner_uid", type=int, default=0)
            parser.add_argument("--owner_gid", type=int, default=0)
            parser.add_argument("--owner_pid", type=int, default=0)
            parser.add_argument("--mode", type=parse_mode, default=0o660)
            parser.add_argument('--slot_ids', type=str, default=None, help='Candidate slot IDs (comma-separated)')
            parser.add_argument("--distance", type=int, default=0)
            parser.add_argument("--slot_cnt", type=int, default=None)
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._create_single_fd,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name,
                    size=args.size,
                    owner_uid=args.owner_uid,
                    owner_gid=args.owner_gid,
                    owner_pid=args.owner_pid,
                    mode=args.mode,
                    slot_ids=args.slot_ids,
                    distance=args.distance,
                    slot_cnt=args.slot_cnt
                )
                logger.info(f"Batch creation completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次创建模式
                self._create_single_fd(
                    name=args.name,
                    size=args.size,
                    owner_uid=args.owner_uid,
                    owner_gid=args.owner_gid,
                    owner_pid=args.owner_pid,
                    mode=args.mode,
                    slot_ids=args.slot_ids,
                    distance=args.distance,
                    slot_cnt=args.slot_cnt
                )
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to create FD-form memory! {ex}")

    def do_fd_create_with_lender(self, arg):
        """Create remote memory in FD form with lender: fd_create_with_lender <name> <lender_slot_id>
        <lender_socket_id> [--numa_id=ID SIZE]... [--owner_uid] [--owner_gid] [--owner_pid] [--mode=]
        [--lender_cnt] [--count=] [--concurrency=]"""

        try:
            parser = argparse.ArgumentParser(
                prog='fd_create_with_lender',
                description='Create remote memory in FD form with lender',
                usage='fd_create_with_lender <name> <lender_slot_id> <lender_socket_id> [--numa_id=ID SIZE]... '
                      '[--owner_uid=] [--owner_gid=] [--owner_pid] [--mode=] [--lender_cnt] [--count=] [--concurrency=]'
            )
            parser.add_argument("name")
            parser.add_argument("lender_slot_id", type=int)
            parser.add_argument("lender_socket_id", type=int)
            parser.add_argument("lender_port", type=int, nargs="?", default=0xFFFFFFFF)
            parser.add_argument("--lender_cnt", type=int, default=None)
            # NUMA 相关参数
            parser.add_argument(
                '--numa_id',
                action='append',
                nargs=2,
                metavar=('ID', 'SIZE'),
                help='NUMA node ID and memory size (e.g., --numa_id 0 1G)'
            )
            parser.add_argument("--owner_uid", type=int, default=0)
            parser.add_argument("--owner_gid", type=int, default=0)
            parser.add_argument("--owner_pid", type=int, default=0)
            parser.add_argument("--mode", type=parse_mode, default=0o660)
            # 新增并发参数
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._create_single_fd_with_lender,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name,
                    lender_slot_id=args.lender_slot_id,
                    lender_socket_id=args.lender_socket_id,
                    lender_port=args.lender_port,
                    numa_id=args.numa_id,
                    owner_uid=args.owner_uid,
                    owner_gid=args.owner_gid,
                    owner_pid=args.owner_pid,
                    mode=args.mode,
                    lender_cnt=args.lender_cnt
                )
                logger.info(f"Batch creation completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                #单次创建模式
                self._create_single_fd_with_lender(
                    name=args.name,
                    lender_slot_id=args.lender_slot_id,
                    lender_socket_id=args.lender_socket_id,
                    lender_port=args.lender_port,
                    numa_id=args.numa_id,
                    owner_uid=args.owner_uid,
                    owner_gid=args.owner_gid,
                    owner_pid=args.owner_pid,
                    mode=args.mode,
                    lender_cnt=args.lender_cnt
                )
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to create FD-form memory! {ex}")

    def do_fd_get(self, arg):
        """Query FD-form memory resource: fd_get <name>"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name", type=str, help="Memory resource name")
            args = parser.parse_args(shlex.split(arg))

            name_bytes = args.name.encode("utf-8")
            fd_desc = UbsMemFdDescT()
            result = self.lib_ubse.ubs_mem_fd_get(name_bytes, ctypes.byref(fd_desc))
            # 处理结果
            if result == 0:
                logger.info(f"Successfully retrieved FD-form memory resource")
                logger.info(fd_desc)
            else:
                logger.error(f"Query failed {self.print_error(result)}")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to query FD-form memory! {ex}")

    def do_fd_list(self, arg):
        """Query all FD-form memory resource: fd_list"""
        try:
            fd_descs_ptr = ctypes.POINTER(UbsMemFdDescT)()
            fd_desc_cnt = ctypes.c_uint32(0)
            result = self.lib_ubse.ubs_mem_fd_list(ctypes.byref(fd_descs_ptr), ctypes.byref(fd_desc_cnt))
            # 处理结果
            if result == 0:
                logger.info(f"Successfully list FD-form memory resources")
                logger.info(f"Found {fd_desc_cnt.value} FD-form memory resources:")
                for i in range(fd_desc_cnt.value):
                    resource_ptr = ctypes.cast(
                        ctypes.addressof(fd_descs_ptr.contents) + i * ctypes.sizeof(UbsMemFdDescT),
                        ctypes.POINTER(UbsMemFdDescT)
                    )
                    logger.info(resource_ptr.contents)
                self.lib_ubse.free(fd_descs_ptr)
            else:
                logger.error(f"List failed {self.print_error(result)}")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to query FD-form memory! {ex}")

    def do_fd_delete(self, arg):
        """Delete remote memory in FD form: fd_delete <name> [--count=] [--concurrency=]"""

        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name")
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._delete_single_fd,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name
                )
                logger.info(f"Batch delete completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次创建模式
                self._delete_single_fd(name=args.name)
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to delete FD-form memory! {ex}")

    def do_fd_permission(self, arg):
        """Modify the permission for FD form memory resource: fd_permission <name> <owner_uid> <owner_gid> <mode>"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name", type=str, help="Memory resource name")
            parser.add_argument("owner_uid", type=int, default=None)
            parser.add_argument("owner_gid", type=int, default=None)
            parser.add_argument("mode", type=parse_mode, default=None)
            args = parser.parse_args(shlex.split(arg))

            name_bytes = args.name.encode("utf-8")
            owner = UbsMemFdOwnerT()
            owner.uid = args.owner_uid
            owner.gid = args.owner_gid
            result = self.lib_ubse.ubs_mem_fd_permission(name_bytes, ctypes.byref(owner), args.mode)
            # 处理结果
            if result == 0:
                logger.info(f"Successfully modified the permission for FD form memory resource")
            else:
                logger.error(f"Modify the permission failed {self.print_error(result)}")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to modify the permission of FD-form memory! {ex}")

    def do_numa_create(self, arg):
        """Create remote memory in Numa form: numa_create <name> <size> [--slot_ids] [--distance] [--slot_cnt] [
        --count] [--concurrency=]"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name")
            parser.add_argument("size", type=str)
            parser.add_argument("--slot_ids", type=str, default=None, help="Candidate slot IDs (comma-separated)")
            parser.add_argument("--distance", type=int, default=0)
            parser.add_argument("--slot_cnt", type=int, default=None)
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._create_single_numa,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name,
                    size=args.size,
                    slot_ids=args.slot_ids,
                    distance=args.distance,
                    slot_cnt=args.slot_cnt
                )
                logger.info(f"Batch creation completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次创建模式
                self._create_single_numa(
                    name=args.name,
                    size=args.size,
                    slot_ids=args.slot_ids,
                    distance=args.distance,
                    slot_cnt=args.slot_cnt
                )
        except SystemExit:
                pass
        except Exception as ex:
            logger.error(f"Failed to create Numa-form memory! {ex}")

    def do_numa_create_with_lender(self, arg):
        """Create remote memory in Numa form with lender: create_numa_with_lender <name> <lender_slot_id>
         <lender_socket_id> [lender_port] [--numa_id=ID SIZE]... [--lender_cnt] [--count] [--concurrency]"""

        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name")
            parser.add_argument("lender_slot_id", type=int)
            parser.add_argument("lender_socket_id", type=int)
            parser.add_argument("lender_port", type=int, nargs="?", default=0xFFFFFFFF)
            parser.add_argument("--lender_cnt", type=int, default=None)
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            # NUMA 相关参数
            parser.add_argument(
                "--numa_id",
                action="append",
                nargs=2,
                metavar=("ID", "SIZE"),
                help="NUMA node ID and memory size (e.g., --numa_id 0 128M)"
            )
            args = parser.parse_args(shlex.split(arg))
            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._create_single_numa_with_lender,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name,
                    lender_slot_id=args.lender_slot_id,
                    lender_socket_id=args.lender_socket_id,
                    lender_port=args.lender_port,
                    numa_id=args.numa_id,
                    lender_cnt=args.lender_cnt
                )
                logger.info(f"Batch creation completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次创建模式
                self._create_single_numa_with_lender(
                    name=args.name,
                    lender_slot_id=args.lender_slot_id,
                    lender_socket_id=args.lender_socket_id,
                    lender_port=args.lender_port,
                    numa_id=args.numa_id,
                    lender_cnt=args.lender_cnt
                )
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to create Numa-form memory! {ex}")

    def do_numa_get(self, arg):
        """Query Numa-form memory resource: numa_get <name>"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name", type=str, help="Memory resource name")
            args = parser.parse_args(shlex.split(arg))

            name_bytes = args.name.encode("utf-8")
            numa_desc = UbsMemNumaDescT()
            result = self.lib_ubse.ubs_mem_numa_get(name_bytes, ctypes.byref(numa_desc))
            # 处理结果
            if result == 0:
                logger.info(f"Successfully retrieved Numa-form memory resource")
                logger.info(numa_desc)
            else:
                logger.error(f"Query failed {self.print_error(result)}")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to query Numa-form memory! {ex}")

    def do_numa_list(self, arg):
        """Query all Numa-form memory resource: numa_list"""
        try:
            numa_descs_ptr = ctypes.POINTER(UbsMemNumaDescT)()
            numa_desc_cnt = ctypes.c_uint32(0)
            result = self.lib_ubse.ubs_mem_numa_list(ctypes.byref(numa_descs_ptr), ctypes.byref(numa_desc_cnt))
            # 处理结果
            if result == 0:
                logger.info(f"Successfully list Numa-form memory resources")
                logger.info(f"Found {numa_desc_cnt.value} Numa-form memory resources:")
                for i in range(numa_desc_cnt.value):
                    resource_ptr = ctypes.cast(
                        ctypes.addressof(numa_descs_ptr.contents) + i * ctypes.sizeof(UbsMemNumaDescT),
                        ctypes.POINTER(UbsMemNumaDescT)
                    )
                    logger.info(resource_ptr.contents)
                self.lib_ubse.free(numa_descs_ptr)
            else:
                logger.error(f"List failed {self.print_error(result)}")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to query Numa-form memory! {ex}")

    def do_numa_delete(self, arg):
        """Delete remote memory in Numa form: numa_delete <name> [--count] [--concurrency]"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name")
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量删除模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._delete_single_numa,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name
                )
                logger.info(f"Batch delete completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次删除模式
                self._delete_single_numa(name=args.name)
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to delete Numa-form memory! {ex}")

    def do_shm_create(self, arg):
        """create remote share memory: shm_create <name> <size> <--region> [--provider=] [--usr_info=]
        [--flag=] [--region_cnt] [--provider_cnt] [--affinity_socket_id] [--count] [--concurrency]"""
        try:
            parser = argparse.ArgumentParser(
                prog="shm_create",
                description="Create shared memory resource",
                usage="shm_create <name> <size> <--region=> [--provider=] [--usr_info=] [--flag=] [--region_cnt] "
                      "[--provider_cnt] [--count] [--concurrency]"
            )
            parser.add_argument("name", type=str, help="Memory resource name")
            parser.add_argument("size", type=str, help="Memory size (e.g., 1G, 100M)")
            parser.add_argument("--region", type=str, required=True,
                                help="Region node IDs (comma-separated, required)")
            parser.add_argument("--provider", type=str, default='', help="Provider node IDs (comma-separated)")
            parser.add_argument("--usr_info", type=str, default='')
            parser.add_argument("--flag", type=int, default=0)
            parser.add_argument("--region_cnt", type=int, default=None)
            parser.add_argument("--provider_cnt", type=int, default=None)
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._create_single_shm,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name,
                    size=args.size,
                    region=args.region,
                    provider=args.provider,
                    usr_info=args.usr_info,
                    flag=args.flag,
                    region_cnt=args.region_cnt,
                    provider_cnt=args.provider_cnt
                )
                logger.info(f"Batch creation completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次创建模式
                self._create_single_shm(
                    name=args.name,
                    size=args.size,
                    region=args.region,
                    provider=args.provider,
                    usr_info=args.usr_info,
                    flag=args.flag,
                    region_cnt=args.region_cnt,
                    provider_cnt=args.provider_cnt
                )
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to create share memory! {ex}")

    def do_shm_attach(self, arg):
        """Attach remote share memory: shm_attach <name> [--owner_uid=] [--owner_gid=] [--owner_pid=] [--mode=]
        [--count] [--concurrency]"""

        try:
            parser = argparse.ArgumentParser(
                prog="shm_attach",
                description="Attach share memory resource",
                usage="shm_attach <name> [--owner_uid=] [--owner_gid=] [--owner_pid=] [--mode=] [--count] [--concurrency]"
            )
            parser.add_argument("name", type=str, help="Memory resource name")
            parser.add_argument("--owner_uid", type=int, default=0)
            parser.add_argument("--owner_gid", type=int, default=0)
            parser.add_argument("--owner_pid", type=int, default=0)
            parser.add_argument("--mode", type=parse_mode, default=0o660)
            parser.add_argument("--count", type=int, default=1, help="Total number of attach operations (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量导入模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._attach_single_shm,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name,
                    owner_uid=args.owner_uid,
                    owner_gid=args.owner_gid,
                    owner_pid=args.owner_pid,
                    mode=args.mode
                )
                logger.info(f"Batch attach completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次导入模式
                self._attach_single_shm(
                    name=args.name,
                    owner_uid=args.owner_uid,
                    owner_gid=args.owner_gid,
                    owner_pid=args.owner_pid,
                    mode=args.mode
                )
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to attach share memory! {ex}")

    def do_shm_detach(self, arg):
        """Detach share memory: shm_detach <name> [--count=] [--concurrency=]"""

        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name")
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._detach_single_shm,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name
                )
                logger.info(f"Batch detach completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次创建模式
                self._detach_single_shm(name=args.name)
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to detach share memory! {ex}")

    def do_shm_delete(self, arg):
        """Delete shm memory: shm_delete <name> [--count=] [--concurrency=]"""

        try:
            parser = argparse.ArgumentParser()
            parser.add_argument("name")
            parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
            parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
            args = parser.parse_args(shlex.split(arg))

            # 批量创建模式
            if args.count > 1:
                success, failure = _concurrent_execute(
                    operation=self._delete_single_shm,
                    count=args.count,
                    concurrency=args.concurrency,
                    name=args.name
                )
                logger.info(f"Batch delete completed. Total: {args.count}, Success: {success}, Failed: {failure}")
            else:
                # 单次创建模式
                self._delete_single_shm(name=args.name)
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to delete share memory! {ex}")

    def do_shm_get(self, arg):
        """Query shm memory resource: shm_get <name>"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument('name', type=str, help='Memory resource name')
            args = parser.parse_args(shlex.split(arg))

            name_bytes = args.name.encode('utf-8')
            shm_descs_ptr = ctypes.POINTER(UbsMemShmDescT)()
            result = self.lib_ubse.ubs_mem_shm_get(name_bytes, ctypes.byref(shm_descs_ptr))
            # 处理结果
            if result == 0:
                logger.info("Successfully retrieved shm memory resource")
                logger.info(shm_descs_ptr.contents)
                self.lib_ubse.free(shm_descs_ptr)
            else:
                logger.error(f"Query failed {self.print_error(result)}")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to query shm memory! {ex}")

    def do_shm_list(self, arg):
        """Query all shm memory resource: shm_list"""
        try:
            shm_descs_ptr = ctypes.POINTER(UbsMemShmDescT)()
            shm_desc_cnt = ctypes.c_uint32(0)
            result = self.lib_ubse.ubs_mem_shm_list(ctypes.byref(shm_descs_ptr), ctypes.byref(shm_desc_cnt))
            # 处理结果
            if result == 0:
                logger.info("Successfully list shm memory resources")
                logger.info(f"Found {shm_desc_cnt.value} shm memory resources:")
                for i in range(shm_desc_cnt.value):
                    resource_ptr = ctypes.cast(
                        ctypes.addressof(shm_descs_ptr.contents) + i * ctypes.sizeof(UbsMemShmDescT),
                        ctypes.POINTER(UbsMemShmDescT)
                    )
                    logger.info(resource_ptr.contents)
                self.lib_ubse.free(shm_descs_ptr)
            else:
                logger.error(f"List failed {self.print_error(result)}")
        except SystemExit:
            pass
        except Exception as ex:
            logger.error(f"Failed to query shm memory! {ex}")

    def do_fd_mmap(self, arg):
        """Mapped fd Memory Device: fd_mmap <mem_id> [size]"""
        try:
            parser = argparse.ArgumentParser()
            parser.add_argument('mem_id', type=int)
            parser.add_argument('size', type=str, default='1024', help='Memory size (e.g., 1G, 2M)')
            args = parser.parse_args(shlex.split(arg))

            size = parse_size(args.size)

            # 关闭已打开的设备
            if self.mmap_obj:
                self.mmap_obj.close()
            if self.fd:
                os.close(self.fd)
            # 打开新设备
            device_path = f"/dev/obmm_shmdev{args.mem_id}"
            self.fd = os.open(device_path, os.O_RDWR)
            self.mmap_obj = mmap.mmap(
                self.fd,
                size,
                mmap.MAP_SHARED,
                mmap.PROT_READ | mmap.PROT_WRITE
            )
            self.current_device = args.mem_id
            logger.info(f"Device opened: {device_path}, mapped size: {size} byte")
        except SystemExit:
            self.current_device = None
            self.mmap_obj = None
            self.fd = None
        except Exception as e:
            print(f"Failed to open the device: {e}")
            self.current_device = None
            self.mmap_obj = None
            self.fd = None

    def do_fd_read(self, arg):
        """Read fd memory: fd_read <addr> [length]"""
        if not self.mmap_obj:
            logger.error("Please use the 'fd_mmap' command to map the device first.")
            return

        try:
            parser = argparse.ArgumentParser()
            parser.add_argument('addr', type=lambda x: int(x, 0), help='Memory offset (e.g., 0x1000)')
            parser.add_argument('length', type=lambda x: int(x, 0), nargs='?', default=8)
            args = parser.parse_args(shlex.split(arg))

            address = args.addr
            length = args.length
            if address + length > self.mem_size:
                logger.error(f"The read range exceeds the mapped area (0-{self.mem_size - 1})")
                return

            self.mmap_obj.seek(address)
            data = self.mmap_obj.read(length)

            # 输出ID和地址信息
            logger.info(f"Read successfully - ID: {self.current_device}, addr: 0x{address:x}")

            # 格式化输出

            logger.info(f"Read data: {data.hex()}")

        except SystemExit:
            pass
        except Exception as e:
            print(f"Failed to read memory: {e}")

    def do_fd_write(self, arg):
        """write memory: fd_write <addr> <data>"""
        if not self.mmap_obj:
            logger.error("Please use the 'fd_mmap' command to map the device first.")
            return

        try:
            parser = argparse.ArgumentParser()
            parser.add_argument('addr', type=lambda x: int(x, 0), help='Memory offset (e.g., 0x1000)')
            parser.add_argument('data', type=str, help='Hexadecimal data')

            # 解析参数
            args = parser.parse_args(shlex.split(arg))
            address = args.addr
            hex_data = args.data

            # 将十六进制字符串转换为字节
            data = bytes.fromhex(hex_data)

            if address + len(data) > self.mem_size:
                logger.error(f"The write range exceeds the mapped area (0-{self.mem_size - 1})")
                return

            self.mmap_obj.seek(address)
            self.mmap_obj.write(data)

            # 读取并验证写入的数据
            self.mmap_obj.seek(address)
            written_data = self.mmap_obj.read(len(data))

            logger.info(f"Write successful - ID: {self.current_device}, addr: 0x{address:x}")
            logger.info(f"Write data: {data.hex()}")
            logger.info(f"Verification Read: {written_data.hex()}")

            if data == written_data:
                logger.info("Write verification succeeded")
            else:
                logger.info("Write validation failed")

        except SystemExit:
            pass
        except Exception as e:
            logger.error(f"Failed to write to memory: {e}")

    def do_fd_close(self, arg):
        """Close the current device: fd_close"""
        if self.mmap_obj:
            self.mmap_obj.close()
            self.mmap_obj = None
        if self.fd:
            os.close(self.fd)
            self.fd = None
        self.current_device = None
        logger.info("The device has been closed")

    def do_numa_alloc(self, arg):
        """Allocate memory on NUMA nodes: numa_alloc <numa_id> [size]"""
        if not self.numa_manager.is_available():
            logger.error("NUMA functionality is unavailable")
            return
        try:
            parser = argparse.ArgumentParser(prog='numa_alloc', description='Allocate memory on NUMA nodes')
            parser.add_argument('numa_id', type=int, help='NUMA ID')
            parser.add_argument('size', type=str, default='1024', help='Size of allocated memory')

            args = parser.parse_args(shlex.split(arg))
            size = parse_size(args.size)
            ptr, aligned_size = self.numa_manager.allocate_on_node(args.numa_id, size)
            logger.info(f"{aligned_size} bytes of memory were allocated on numa {args.numa_id}")
            logger.info(f"Memory Address: 0x{ptr:x}, Size: {aligned_size} byte")
        except SystemExit:
            pass
        except Exception as e:
            logger.error(f"NUMA memory allocation failed: {e}")

    def do_numa_free(self, arg):
        """Release memory on NUMA nodes: numa_free <numa_id>"""
        if not self.numa_manager.is_available():
            logger.error("NUMA functionality is unavailable")
            return

        try:
            parser = argparse.ArgumentParser(prog='numa_free', description='Release memory on NUMA nodes')
            parser.add_argument('numa_id', type=int, help='NUMA ID')

            args = parser.parse_args(shlex.split(arg))

            self.numa_manager.free_on_node(args.numa_id)
            logger.info(f"Memory on released numa {args.numa_id} has been freed")
        except SystemExit:
            pass
        except Exception as e:
            logger.error(f"Failed to release NUMA memory: {e}")

    def do_numa_read(self, arg):
        """Read NUMA memory: numa_read <numa_id> <offset> [length]"""
        if not self.numa_manager.is_available():
            logger.error("NUMA functionality is unavailable")
            return

        try:
            parser = argparse.ArgumentParser(prog='numa_read', description='Read NUMA memory')
            parser.add_argument('numa_id', type=int, help='NUMA ID')
            parser.add_argument('offset', type=lambda x: int(x, 0), help='Memory offset')
            parser.add_argument('length', type=lambda x: int(x, 0), nargs='?', default=8, help='Read length')

            args = parser.parse_args(shlex.split(arg))

            data = self.numa_manager.read_memory(args.numa_id, args.offset, args.length)

            logger.info(f"Read successfully - NUMA ID: {args.numa_id}, offset: 0x{args.offset:x}")
            # 格式化输出
            logger.info(f"value: {data.hex()}")

        except SystemExit:
            pass
        except Exception as e:
            logger.error(f"Failed to read NUMA memory: {e}")

    def do_numa_write(self, arg):
        """Write to NUMA memory: numa_write <numa_id> <offset> <data>"""
        if not self.numa_manager.is_available():
            logger.error("NUMA functionality is unavailable")
            return

        try:
            parser = argparse.ArgumentParser(prog='numa_write', description='Write to NUMA memory')
            parser.add_argument('numa_id', type=int, help='NUMA ID')
            parser.add_argument('offset', type=lambda x: int(x, 0), help='Memory offset')
            parser.add_argument('data', type=str, help='Hexadecimal data')

            args = parser.parse_args(shlex.split(arg))

            # 将十六进制字符串转换为字节
            data_bytes = bytes.fromhex(args.data)
            self.numa_manager.write_memory(args.numa_id, args.offset, data_bytes)

            # 验证写入
            read_back = self.numa_manager.read_memory(args.numa_id, args.offset, len(data_bytes))

            logger.info(f"Write successfully - NUMA ID: {args.numa_id}, offset: 0x{args.offset:x}")
            logger.info(f"Write data: {data_bytes.hex()}")
            logger.info(f"Verification Read: {read_back.hex()}")

            if data_bytes == read_back:
                logger.info("Write verification succeeded")
            else:
                logger.info("Write validation failed")

        except SystemExit:
            pass
        except Exception as e:
            logger.error(f"Failed to write to numa memory: {e}")

    def do_quit(self, arg):
        """退出程序: quit"""
        return True

    def do_exit(self, arg):
        """退出程序: exit"""
        return self.do_quit(arg)

    def emptyline(self):
        """空行时不做任何操作"""
        pass


def main():
    """主函数"""
    cli = UbseMemApp()
    cli.cmdloop()


if __name__ == "__main__":
    main()