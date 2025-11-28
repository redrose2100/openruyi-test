def do_numa_info(self, arg):
    """Get numa info: numa_topo <node_id>"""
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("node_id", type=int)
        args = parser.parse_args(shlex.split(arg))

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
                    ctypes.POINTER(UbsMemResource))
                logger.info(resource_ptr.contents)
            self.lib_ubse.free(numa_infos_ptr)
        else:
            logger.error(f"Failed to get numa info")
    except SystemExit:
        pass
    except Exception as ex:
        logger.error(f"Unexpected error: {ex}")

def do_fd_create(self, arg):
    """Create remote memory in FD form: fd_create <name> <size> [--owner-uid=] [--owner-gid=] [--owner-pid=]
    [--mode=] [--slot_ids] [--distance] [--slot_cnt] [--count=] [--concurry=]"""
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("name")
        parser.add_argument("size", type=str)
        parser.add_argument("--owner-uid", type=int, default=0)
        parser.add_argument("--owner-gid", type=int, default=0)
        parser.add_argument("--owner-pid", type=int, default=0)
        parser.add_argument("--mode", type=int, default=0o660)
        parser.add_argument("--slot_ids", type=str, default=None, help="Candidate slot IDs (comma-separated)")
        parser.add_argument("--distance", type=int, default=0)
        parser.add_argument("--slot_cnt", type=int, default=None)
        parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
        parser.add_argument("--concurry", type=int, default=1, help="Max concurrent operations (default=1)")
        args = parser.parse_args(shlex.split(arg))

        # 批量创建模式
        if args.count > 1:
            success, failure = _concurrent_execute(
                operation=self._create_single_fd,
                count=args.count,
                concurrent=args.concurry,
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
        else:
            # 单次创建模式
            result, latency, error = self._create_single_fd(
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
    <lender_socket_id> [--numa_id=ID SIZE]... [--owner_uid=] [--owner_gid=] [--owner_pid=] [--mode=]
    [--lender_cnt] [--count=] [--concurrency=]"""

    try:
        parser = argparse.ArgumentParser(
            prog="fd_create_with_lender",
            description="Create remote memory in FD form with lender",
            usage="fd_create_with_lender <name> <lender_slot_id> <lender_socket_id> [--numa_id=ID SIZE]..."
                  "[--owner_uid=] [--owner_gid=] [--owner_pid=] [--mode=] [--lender_cnt] [--count=] [--concurrency=]"
        )
        parser.add_argument("name")
        parser.add_argument("lender_slot_id", type=int)
        parser.add_argument("lender_socket_id", type=int)
        parser.add_argument("lender_port", type=int, nargs="?", default=OxFFFFFFFF)
        parser.add_argument("--lender_cnt", type=int, default=None)
        # NUMA 相关参数
        parser.add_argument("--numa_id",
                            action="append",
                            nargs=2,
                            metavar=("ID", "SIZE"),
                            help="NUMA node ID and memory size (e.g., --numa_id 0 1G)"
        )
        parser.add_argument("--owner_uid", type=int, default=0)
        parser.add_argument("--owner_gid", type=int, default=0)
        parser.add_argument("--owner_pid", type=int, default=0)
        parser.add_argument("--mode", type=int, default=0o660)
        # 新增并发参数
        parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
        parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
        args = parser.parse_args(shlex.split(arg))

        # 批量创建模式
        if args.count > 1:
            success, failure = _concurrent_execute(
                operation=self._create_single_fd_with_lender,
                count=args.count,
                concurrent=args.concurrency,
                name=args.name,
                lender_slot_id=args.lender_slot_id,
                lender_socket_id=args.lender_socket_id,
                lender_port=args.lender_port,
                numa_id=args.numa_id,
                owner_uid=args.owner_uid,
                owner_gid=args.owner_gid,
                owner_pid=args.owner_pid,
                mode=args.mode,
                lender_cnt=args.lender_cnt,
            )
        else:
            result, latency, = self._create_single_fd_with_lender(
                name=args.name,
                lender_slot_id=args.lender_slot_id,
                lender_socket_id=args.lender_socket_id,
                lender_port=args.lender_port,
                numa_id=args.numa_id,
                owner_uid=args.owner_uid,
                owner_gid=args.owner_gid,
                owner_pid=args.owner_pid,
                mode=args.mode,
                lender_cnt=args.lender_cnt,
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
            logger.info(f"Successfully retrieved FD-form memory resource: {name_bytes}")
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
            logger.info(f"Found {fd_desc_cnt.value} FD-form memory resource:")
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
        logger.error(f"Failed to list FD-form memory! {ex}")

def do_fd_delete(self, arg):
    """Delete remote memory in FD form: fd_delete <name> [--count=] [--concurrency=]"""

    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("name")
        parser.add_argument("--count", type=int, default=1, help="Total number of memories to delete (default=1)")
        parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
        args = parser.parse_args(shlex.split(arg))

        # 批量创建模式
        if args.count > 1:
            success, failure = _concurrent_execute(
                operation=self._delete_single_fd,
                count=args.count,
                concurrency=args.concurrency,
                name=args.name,
            )
        else:
          # 单次创建模式
          self._delete_single_fd(name=args.name)
    except SystemExit:
        pass
    except Exception as ex:
        logger.error(f"Failed to delete FD-form memory! {ex}")

def do_fd_permission(self, arg):
    """Modify the permission for FD-form memory resource: fd_permission <name> <owner_uid> <owner_gid> <<mode>"""
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("name", type=str, help="Memory resource name")
        parser.add_argument("owner_uid", type=int, default=None)
        parser.add_argument("owner_gid", type=int, default=None)
        parser.add_argument("mode", type=int, type=parse_mode, default=None)
        args = parser.parse_args(shlex.split(arg))

        name_bytes = args.name.encode("utf-8")
        owner = UbsMemOwnerT()
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
        else:
            # 单次创建模式
            self._create_single_numa(
                name=args.name,
                size=args.size,
                slot_ids=args.slot_ids,
                distance=args.distance,
                slot_cnt=args.slot_cnt)
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
        parser.add_argument("lender_port", type=int, nargs="?", default=OxFFFFFFFF)
        parser.add_argument("--lender_cnt", type=int, default=None)
        parser.add_argument("--count", type=int, default=1, help="Total number of memories to create (default=1)")
        parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")
        # NUMA 相关参数
        parser.add_argument(
            "--numa_id",
            action="append",
            nargs="2",
            metavar=("ID", "SIZE"),
            help="NUMA note ID and memory size (e.g., --numa_id 0 128M)"
        )
        args = parser.parse_args(shlex.split(arg))
        # 批量创建模式
        if args.count > 1:
            success, failure = _concurrent_execute(
                operation=self._create_single_numa_with_lender,
                count=args.count,
                concurrency=args.concurrency,
                name=args.name,
                lender_slot_ids=args.lender_slot_id,
                lender_socket_ids=args.lender_socket_id,
                lender_port=args.lender_port,
                numa_id=args.numa_id,
                lender_cnt=args.lender_cnt
            )
        else:
            # 单次创建模式
            self._create_single_numa_with_lender(
                name=args.name,
                lender_slot_ids=args.lender_slot_id,
                lender_socket_ids=args.lender_socket_id,
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
        numa_desc = UbseMemDescT()
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
        numa_descs_ptr = ctypes.POINTER(UbseMemDescT)()
        numa_desc_cnt = ctypes.c_int32(0)
        result = self.lib_ubse.ubs_mem_numa_list(ctypes.byref(numa_descs_ptr), ctypes.byref(numa_descs_cnt))
        # 处理结果
        if result == 0:
            logger.info(f"Successfully list Numa-form memory resource")
            logger.info(f"Found {numa_descs_cnt.value} Numa-form memory resource:")
            for i in range(numa_desc_cnt.value):
                resource_ptr = ctypes.cast(
                    ctypes.addressof(numa_descs_ptr.contents) + i * ctypes.sizeof(UbsMemNumaDescT),
                    ctypes.POINTER(UbseMemNumaDescT)
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
        parser.add_argument("--count", type=int, default=1, help="Total number of memories to delete (default=1)")
        parser.add_argument("--concurrency", type=int, default=1, help="Max concurrent operations (default=1)")

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
                  "[--provider_cnt] [--affinity_socket_id] [--count] [--concurrency]"
        )
        parser.add_argument("name", type=str, help="Memory resource name")
        parser.add_argument("size", type=str, help="Memory size (e.g., 10, 100M)")
        parser.add_argument("--region", type=str, required=True,
                            help="Region node IDs (comma separated, required)")
        parser.add_argument("--provider", type=str, default="", help="Provider node IDs (comma separated)")
        parser.add_argument("--usr_info", type=str, default="")
        parser.add_argument("--flag", type=int, default=None)
        parser.add_argument("--region_cnt", type=int, default=None)
        parser.add_argument("--provider_cnt", type=int, default=None)
        parser.add_argument("--affinity_socket_id", type=int, default=None)
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
                provider_cnt=args.provider_cnt,
                affinity_socket_id=args.affinity_socket_id
            )
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
                provider_cnt=args.provider_cnt,
                affinity_socket_id=args.affinity_socket_id
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
            description="Attach remote share memory resource",
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
                mode=args.mode,
            )
        else:
            # 单次导入模式
            self._attach_single_shm(
                name=args.name,
                owner_uid=args.owner_uid,
                owner_gid=args.owner_gid,
                owner_pid=args.owner_pid,
                mode=args.mode,
            )
    except SystemExit:
        pass
    except Exception as ex:
        logger.error(f"Failed to attach share memory! {ex}")
