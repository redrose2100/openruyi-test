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