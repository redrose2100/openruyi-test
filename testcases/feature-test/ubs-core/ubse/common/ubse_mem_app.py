def parse_node_list(node_str):
    if not node_str:
        return []
    try:
        return [int(node_id.strip()) for node_id in node_str.split(',') if node_id.strip()]
    except ValueError:
        raise ValueError(f"Invalid noed ID format: '{node_str}'")


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
    mem_priv_data.one_path = 0
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
                if size <+ 0:
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
        self.libnuma - self._load_libnuma()
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
            lib.numa_run_on_node_restype = ctypes.c_int
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
        aligned_size = ((size_bytes + page_size -1) // page_size) * page_size
        # 检查节点是否可用
        if not self.is_numa_node_available(numa_id):
            raise ValueError(f"NUMA {numa_id} not available")
        try:
            # 使用 Python mmap 分配匿名内存

        
        ###########################720行
        try:
            self.lib_ubse = ctypes.CDLL(lib_path)
        except OSError as ex:
            logger.error(f"Unable to load library {lib_path} : {ex}")
            raise
        self.set__function_prototypes()
    
    def set__function_prototypes(self):
        """设置C函数的参数类型和返回值类型"""
        # 定义函数原型
        self.lib_ubse.ubs_engine_client_initialize.argtypes = [ctypes.c_char_p]
        self.lib_ubse.ubs_engine_client_initialize.restype =  ctypes.c_int32

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









