# fuse

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fuse` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fuse_daemon_recovery | Test daemon crash recovery and remount | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_fuse_ulockmgr_server | Test ulockmgr_server command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_fuse_mount_fuse | Test mount.fuse command | config_params/pre_test/run_test/post_test | 25 | ✔ |  |  |
| oe_test_fuse_fusermount | Test fusermount command options | config_params/pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fuse_daemon_recovery

- 描述：Test daemon crash recovery and remount
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "fuse2fs mount failed"
  CHECK_RESULT $? 0 0 "file creation failed during normal operation"
  CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
  CHECK_RESULT $? 0 0 "remount failed - data recovery failed"
  CHECK_RESULT $? 0 0 "crash_test.txt missing after recovery"
  CHECK_RESULT $? 0 0 "crash_test.txt content corrupted after recovery"
  CHECK_RESULT $? 0 0 "file creation failed after recovery"
  CHECK_RESULT $? 0 0 "new file content corrupted"
```

- 涉及命令：fusermount×2, grep×2, mkdir×1, mkfs.ext2×1

#### oe_test_fuse_ulockmgr_server

- 描述：Test ulockmgr_server command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ulockmgr_server command not found"
  CHECK_RESULT $? 0 0 "ulockmgr_server did not output expected message"
```

- 涉及命令：command×1

#### oe_test_fuse_mount_fuse

- 描述：Test mount.fuse command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（25 条）：

```
  CHECK_RESULT $? 0 0 "mount.fuse command not found"
  CHECK_RESULT $? 0 0 "mount.fuse basic mount failed"
  CHECK_RESULT $? 0 0 "mount.fuse mount verification failed"
  CHECK_RESULT $? 0 0 "file creation failed after mount.fuse"
  CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
  CHECK_RESULT $? 0 0 "mount.fuse -o allow_other mount failed"
  CHECK_RESULT $? 0 0 "mount.fuse -o allow_other mount verification failed"
  CHECK_RESULT $? 0 0 "allow_other option not effective"
  CHECK_RESULT $? 0 0 "nobody user not can access the mount point"
  CHECK_RESULT $? 0 0 "fusermount -u unmount failed"
  CHECK_RESULT $? 0 0 "mount.fuse -o allow_root mount failed"
  CHECK_RESULT $? 0 0 "mount.fuse -o allow_root mount verification failed"
  ... 共 25 条（其余见源脚本）
```

- 涉及命令：grep×6, fusermount×6, mkdir×1, mkfs.ext4×1, command×1

#### oe_test_fuse_fusermount

- 描述：Test fusermount command options
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "fusermount -h failed"
  CHECK_RESULT $? 0 0 "fusermount --help failed"
  CHECK_RESULT $? 0 0 "fusermount -V failed"
  CHECK_RESULT $? 0 0 "fusermount --version failed"
  CHECK_RESULT $? 0 0 "fuse2fs mount failed, cannot proceed with unmount tests"
  CHECK_RESULT $? 0 0 "fusermount -u failed"
  CHECK_RESULT $? 0 1 "mount point still exists after fusermount -u"
  CHECK_RESULT $? 0 0 "fuse2fs mount failed"
  CHECK_RESULT $? 0 0 "fusermount -uq failed"
  CHECK_RESULT $? 0 0 "quiet mode should have no output"
  CHECK_RESULT $? 0 0 "fuse2fs mount failed"
  CHECK_RESULT $? 0 0 "fusermount -u failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：fusermount×6, grep×2, mkdir×1, mkfs.ext4×1
