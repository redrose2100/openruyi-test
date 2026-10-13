# lxcfs

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lxcfs` |
| 注册用例数 | 4 |
| 环境约束 | machine num = 1；machine type = kvm；add network interface = 1；add disk =  |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_lxcfs | Test lxcfs.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_lxcfs_mount | Test lxcfs FUSE mount and unmount functionality | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_lxcfs_virtualization | Test lxcfs /proc virtualization (cpuinfo, meminfo, loadavg, swaps, stat, uptime, diskstats) | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_lxcfs_command_args | Test lxcfs command line arguments | pre_test/run_test/post_test | 19 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_lxcfs

- 描述：Test lxcfs.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "lxcfs.service reload failed"
  CHECK_RESULT $? 0 0 "lxcfs.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_lxcfs_mount

- 描述：Test lxcfs FUSE mount and unmount functionality
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "lxcfs is not mounted on $MOUNT_POINT"
  CHECK_RESULT $? 0 0 "proc directory does not exist in lxcfs mount point"
  CHECK_RESULT $? 0 0 "sys directory does not exist in lxcfs mount point"
  CHECK_RESULT $? 0 0 "cgroup directory does not exist in lxcfs mount point"
  CHECK_RESULT $? 0 0 "fusermount -u failed"
  CHECK_RESULT $? 1 0 "lxcfs is still mounted after unmount"
```

- 涉及命令：fusermount×3, test×3, grep×2, mkdir×1

#### oe_test_lxcfs_virtualization

- 描述：Test lxcfs /proc virtualization (cpuinfo, meminfo, loadavg, swaps, stat, uptime, diskstats)
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "lxcfs failed to mount on $MOUNT_POINT"
  CHECK_RESULT $? 0 0 "cpuinfo file does not exist"
  CHECK_RESULT $? 0 0 "cpuinfo has no processor field"
  CHECK_RESULT $? 0 0 "meminfo file does not exist"
  CHECK_RESULT $? 0 0 "meminfo MemTotal is missing"
  CHECK_RESULT $? 0 0 "meminfo MemFree is missing"
  CHECK_RESULT $? 0 0 "Virtualized MemTotal is empty or invalid"
  CHECK_RESULT $? 0 0 "loadavg file does not exist"
  CHECK_RESULT $? 0 0 "loadavg content is invalid"
  CHECK_RESULT $? 0 0 "swaps file does not exist"
  CHECK_RESULT $? 0 0 "swaps header is missing"
  CHECK_RESULT $? 0 0 "stat file does not exist"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：grep×8, test×8, fusermount×3, mkdir×1

#### oe_test_lxcfs_command_args

- 描述：Test lxcfs command line arguments
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "lxcfs -v failed"
  CHECK_RESULT $? 0 0 "lxcfs --version failed"
  CHECK_RESULT $? 0 0 "lxcfs -h failed"
  CHECK_RESULT $? 0 0 "lxcfs --help failed"
  CHECK_RESULT $? 0 0 "lxcfs -f (foreground) failed"
  CHECK_RESULT $? 0 0 "lxcfs -p pid file not created"
  CHECK_RESULT $? 0 0 "lxcfs -p pid file content invalid"
  CHECK_RESULT $? 0 0 "lxcfs --pidfile pid file not created"
  CHECK_RESULT $? 0 0 "lxcfs --pidfile pid file content invalid"
  CHECK_RESULT $? 0 0 "lxcfs -d (debug) failed"
  CHECK_RESULT $? 0 0 "lxcfs --debug failed"
  CHECK_RESULT $? 0 0 "lxcfs -o allow_other process not running"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：fusermount×14, mkdir×12, test×12, kill×12, lxcfs×8, grep×2
