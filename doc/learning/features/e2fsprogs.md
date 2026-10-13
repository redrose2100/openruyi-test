# e2fsprogs

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/e2fsprogs` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_e2scrub_all | Test e2scrub_all.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_e2scrub_reap | Test e2scrub_reap.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_e2fsck_repair | Repair file system integrity | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_chattr | test chattr | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_fuse2fs | test fuse2fs | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_debugfs | test debugfs | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_e2image | test e2image | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_e2freefrag | test e2freefrag | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_e2scrub_all

- 描述：Test e2scrub_all.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_e2scrub_reap

- 描述：Test e2scrub_reap.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_e2fsck_repair

- 描述：Repair file system integrity
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "log message: Failed install minimap2 "
  CHECK_RESULT $? 0 0 "formatting fail"
  CHECK_RESULT $? 0 0 "mount fail"
  CHECK_RESULT $? 0 0 "test fail"
  CHECK_RESULT $? 0 0 "umount fail"
  CHECK_RESULT $? 0 1 "Failure to destroy"
  CHECK_RESULT $? 0 0 "repair fail"
```

- 涉及命令：mkfs.ext4×1, e2fsck×1, losetup×1

#### oe_test_chattr

- 描述：test chattr
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "chattr +i failed"
  CHECK_RESULT $? 0 0 "lsattr +i check failed"
  CHECK_RESULT $? 0 1 "Write should fail with +i attribute"
  CHECK_RESULT $? 0 1 "Delete should fail with +i attribute"
  CHECK_RESULT $? 0 0 "chattr -i failed"
  CHECK_RESULT $? 0 0 "chattr +a failed"
  CHECK_RESULT $? 0 0 "lsattr +a check failed"
  CHECK_RESULT $? 0 0 "Append operation should succeed"
  CHECK_RESULT $? 0 1 "Overwrite should fail with +a attribute"
  CHECK_RESULT $? 0 0 "chattr -a failed"
  CHECK_RESULT $? 0 0 "chattr -R +i failed"
  CHECK_RESULT $? 0 0 "Recursive attribute check failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：chattr×7, mkdir×2

#### oe_test_fuse2fs

- 描述：test fuse2fs
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "fuse2fs read-write mount failed"
  CHECK_RESULT $? 0 0 "write operation failed"
  CHECK_RESULT $? 0 0 "read operation failed"
  CHECK_RESULT $? 0 0 "fusermount unmount failed"
  CHECK_RESULT $? 0 0 "fuse2fs read-only mount failed"
  CHECK_RESULT $? 0 1 "read-only mount should not allow write"
  CHECK_RESULT $? 0 0 "fusermount unmount failed"
  CHECK_RESULT $? 0 0 "fakeroot mount failed"
  CHECK_RESULT $? 0 0 "fakeroot permission check failed"
  CHECK_RESULT $? 0 0 "fusermount unmount failed"
  CHECK_RESULT $? 0 0 "help information missing"
```

- 涉及命令：fusermount×4, fuse2fs×3, mkdir×1, mkfs.ext4×1, grep×1

#### oe_test_debugfs

- 描述：test debugfs
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "debugfs -R stats failed"
  CHECK_RESULT $? 0 0 "debugfs -R ls failed to show testfile.txt"
  CHECK_RESULT $? 0 0 "File recovery failed"
  CHECK_RESULT $? 0 0 "Recovered file content verification failed"
  CHECK_RESULT 0 0 0 "lsdel test skipped - ext4 limitation"
```

- 涉及命令：debugfs×4, mount×2, grep×2, mkdir×1, mkfs.ext4×1

#### oe_test_e2image

- 描述：test e2image
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "e2image basic mode failed"
  CHECK_RESULT $? 0 0 "e2image metadata image not created"
  CHECK_RESULT $? 0 0 "e2image -r option failed"
  CHECK_RESULT $? 0 0 "e2image -r metadata image not created"
  CHECK_RESULT $? 0 0 "e2image -Q option failed"
  CHECK_RESULT $? 0 0 "e2image QEMU format image not created"
  CHECK_RESULT $? 0 0 "qemu-img info on e2image output failed"
  CHECK_RESULT $? 0 0 "e2image error output missing"
```

- 涉及命令：test×3, losetup×2, e2image×2, grep×2, mkdir×1, mkfs.ext4×1

#### oe_test_e2freefrag

- 描述：test e2freefrag
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "e2freefrag basic command failed"
  CHECK_RESULT $? 0 0 "e2freefrag failed to display fragmentation info"
  CHECK_RESULT $? 0 0 "e2freefrag -c option failed"
  CHECK_RESULT $? 0 0 "e2freefrag -c option output verification failed"
  CHECK_RESULT $? 0 0 "e2freefrag -c ${chunksize} failed"
  CHECK_RESULT $? 0 0 "e2freefrag -c ${chunksize} output missing chunksize"
  CHECK_RESULT $? 0 0 "e2freefrag help information missing"
```

- 涉及命令：e2freefrag×4, mkdir×2, mkfs.ext4×1, grep×1, losetup×1
