# FS_FileSystem

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_FileSystem` |
| 注册用例数 | 63 |
| 环境约束 | machine num = 2；add disk = 20 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_FSIO_change_fs | Take the test change fs | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_FSIO_check_fs_mounted | Take the test check default mounted fs type | run_test | 2 |  |  |  |
| oe_test_FSIO_check_fs_type | Take the test check fs type which OS supports | run_test | 4 |  |  |  |
| oe_test_FSIO_create_ext3 | Take the test create ext3 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_create_ext4 | Take the test create ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_create_xfs | Take the test create xfs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_dd_mkfs | Take the test mkfs on dd | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_ext3_resize2fs | Take the test mount ext3 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_ext4_e4defrag | Take the test e4defrag ext4 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_ext4_resize2fs | Take the test mount ext3 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_loop_fs | Take the test mount fs on loop device | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_mount_automount | Take the test umount fs when file is opened | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_FSIO_mount_block_dir | Take the test mount on block | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_mount_character_dir | Take the test mount on character device | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_mount_empty_dir | Take the test mount fs on empty directory | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_mount_ext3_ro | Take the test mount ext3 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext3_rw | Take the test mount ext3 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext3_setData | Take the test mount ext3 | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_mount_ext3_setErrors | Take the test mount ext3 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_mount_ext3_sync | Take the test mount ext3 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_mount_ext3_to_ext4 | Take the test create ext3 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_block_validity | Take the test mount ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_delalloc | Take the test mount ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_discard | Take the test mount ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_noblock_validity | Take the test mount ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_nodiscard | Take the test mount ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_ro | Take the test mount ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_rw | Take the test mount ext4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_setData | Take the test mount ext4 | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_mount_ext4_setErrors | Take the test mount ext4 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_mount_ext4_sync | Take the test mount ext4 | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_mount_nonempty_dir | Take the test mount fs on non-empty directory | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_FSIO_mount_reboot | Take the test umount fs when file is opened | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_FSIO_mount_remount | Take the test mount many fs on one point, check the files | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_FSIO_mount_umount_ext3 | Take the test create ext3 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_FSIO_mount_umount_ext4 | Take the test create ext4 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_FSIO_mount_umount_xfs | Take the test create xfs | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_dax | Take the test mount xfs | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_discard | Take the test mount xfs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_nodiscard | Take the test mount xfs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_ro | Take the test mount xfs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_rw | Take the test mount xfs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_sync | Take the test mount xfs | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_xfsdump | Take the test mount xfs | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_mount_xfs_xfsrestore | Take the test mount xfs | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_mv_rm_mount | Take the test mv/rm mounted point | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_overlay_modify_1 | Take the test modfiy file on overlayfs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_overlay_modify_2 | Take the test modfiy file on overlayfs | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_overlay_modify_3 | Take the test modfiy file on overlayfs | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_overlay_mount | Take the test mount overlayfs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_overlay_rename_1 | Take the test modfiy file on overlayfs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_overlay_rename_2 | Take the test modfiy file on overlayfs | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_overlay_rename_3 | Take the test modfiy file on overlayfs | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_overlay_rm_1 | Take the test rm file on overlayfs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_overlay_rm_2 | Take the test rm file on overlayfs | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_overlay_rm_3 | Take the test rm file on overlayfs | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_remkfs | Take the test re mkfs | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_rw_mount | Take the test mount fs duplicately | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_umount_busy | Take the test umount fs busy | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_umount_by_openfile | Take the test umount fs when file is opened | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_xfs_resize2fs | Take the test mount xfs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_create_squashfs | Make squashfs test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_FSIO_mount_tmpfs | Mount tmpfs test | run_test/post_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_FSIO_change_fs

- 描述：Take the test change fs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "mkfs from ext3 to ext4 failed."
  CHECK_RESULT $? 0 0 "mkfs from ext4 to ext3 failed."
  CHECK_RESULT $? 0 0 "mkfs from ext3 to xfs failed."
  CHECK_RESULT $? 0 0 "mkfs from xfs to ext4 failed."
```

- 涉及命令：lvcreate×1

#### oe_test_FSIO_check_fs_mounted

- 描述：Take the test check default mounted fs type
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The system doesn't mount ext4 defaultly."
  CHECK_RESULT $? 0 0 "The system doesn't mount tmpfs defaultly."
```

#### oe_test_FSIO_check_fs_type

- 描述：Take the test check fs type which OS supports
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The system doesn't support ext4."
  CHECK_RESULT $? 0 0 "The system doesn't support xfs."
  CHECK_RESULT $? 0 0 "The system doesn't support nfs."
  CHECK_RESULT $? 0 0 "The system doesn't support overlayfs."
```

#### oe_test_FSIO_create_ext3

- 描述：Take the test create ext3
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "mkfs.ext3 failed"
  CHECK_RESULT $? 0 0 "Check lv infos failed"
```

- 涉及命令：lvcreate×1

#### oe_test_FSIO_create_ext4

- 描述：Take the test create ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "mkfs.ext4 failed"
  CHECK_RESULT $? 0 0 "Check lv infos failed"
```

- 涉及命令：lvcreate×1

#### oe_test_FSIO_create_xfs

- 描述：Take the test create xfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "mkfs.xfs failed"
  CHECK_RESULT $? 0 0 "Check lv infos failed"
```

- 涉及命令：lvcreate×1

#### oe_test_FSIO_dd_mkfs

- 描述：Take the test mkfs on dd
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "mkfs ext3 on virtual block failed."
  CHECK_RESULT $? 0 0 "mkfs ext4 on virtual block failed."
  CHECK_RESULT $? 0 0 "mkfs xfs on virtual block failed."
```

#### oe_test_FSIO_ext3_resize2fs

- 描述：Take the test mount ext3
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Change size of ext3 failed."
  CHECK_RESULT $? 0 0 "Resize for ext3 failed."
```

- 涉及命令：read×1, e2fsck×1, lvresize×1

#### oe_test_FSIO_ext4_e4defrag

- 描述：Take the test e4defrag ext4
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "e4defrag for ext4 failed."
```

- 涉及命令：read×1

#### oe_test_FSIO_ext4_resize2fs

- 描述：Take the test mount ext3
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Change size of ext3 failed."
  CHECK_RESULT $? 0 0 "Resize for ext3 failed."
```

- 涉及命令：read×1, e2fsck×1, lvresize×1

#### oe_test_FSIO_loop_fs

- 描述：Take the test mount fs on loop device
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "mkfs $var for $loop failed."
  CHECK_RESULT $? 0 0 "Mount fs $var on $loop failed."
  CHECK_RESULT $? 0 0 "Umount fs $var on $loop failed."
```

- 涉及命令：mkfs×2, mknod×1, mount×1, losetup×1

#### oe_test_FSIO_mount_automount

- 描述：Take the test umount fs when file is opened
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check fs is mounted failed."
  CHECK_RESULT $? 0 0 "Check fs is mounted failed."
```

#### oe_test_FSIO_mount_block_dir

- 描述：Take the test mount on block
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "mount ext3 on character block unexpectly."
  CHECK_RESULT $? 0 1 "mount ext4 on character block unexpectly."
  CHECK_RESULT $? 0 1 "mount xfs on character block unexpectly."
```

- 涉及命令：lvcreate×3

#### oe_test_FSIO_mount_character_dir

- 描述：Take the test mount on character device
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "mount ext3 on character block unexpectly."
  CHECK_RESULT $? 0 1 "mount ext4 on character block unexpectly."
  CHECK_RESULT $? 0 1 "mount xfs on character block unexpectly."
```

- 涉及命令：lvcreate×3

#### oe_test_FSIO_mount_empty_dir

- 描述：Take the test mount fs on empty directory
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "mount ext3 on empty directory failed."
  CHECK_RESULT $? 0 0 "mount ext4 on empty directory failed."
  CHECK_RESULT $? 0 0 "mount xfs on empty directory failed."
```

- 涉及命令：lvcreate×3

#### oe_test_FSIO_mount_ext3_ro

- 描述：Take the test mount ext3
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext3 by ro failed."
  CHECK_RESULT $? 0 0 "Create file when ext3 is readonly unexpectly."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext3_rw

- 描述：Take the test mount ext3
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext3 by ro failed."
  CHECK_RESULT $? 0 0 "Create file on ext3 failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext3_setData

- 描述：Take the test mount ext3
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext3 by data=$var failed."
```

- 涉及命令：lvcreate×1, mount×1, umount×1

#### oe_test_FSIO_mount_ext3_setErrors

- 描述：Take the test mount ext3
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext3 by errors=$var failed."
```

- 涉及命令：lvcreate×1, mount×1, umount×1

#### oe_test_FSIO_mount_ext3_sync

- 描述：Take the test mount ext3
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext3 by sync failed."
  CHECK_RESULT $? 0 0 "Write file failed."
  CHECK_RESULT $? 0 0 "Umount failed."
```

- 涉及命令：lvcreate×1, mount×1, umount×1

#### oe_test_FSIO_mount_ext3_to_ext4

- 描述：Take the test create ext3
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Umount ext3 failed."
  CHECK_RESULT $? 0 0 "mount ext4 failed."
  CHECK_RESULT $? 0 0 "Transfer ext3 to ext4 failed."
```

- 涉及命令：mount×2, lvcreate×1, tune2fs×1, fsck×1

#### oe_test_FSIO_mount_ext4_block_validity

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
  CHECK_RESULT $? 0 0 "Mount ext4 by delalloc failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext4_delalloc

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
  CHECK_RESULT $? 0 0 "Mount ext4 by delalloc failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext4_discard

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
  CHECK_RESULT $? 0 0 "Mount ext4 by delalloc failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext4_noblock_validity

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
  CHECK_RESULT $? 0 0 "Mount ext4 by delalloc failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext4_nodiscard

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
  CHECK_RESULT $? 0 0 "Mount ext4 by delalloc failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext4_ro

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
  CHECK_RESULT $? 0 0 "Create file when ext4 is readonly unexpectly."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext4_rw

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
  CHECK_RESULT $? 0 0 "Create file on ext4 failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_ext4_setData

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by data=$var failed."
```

- 涉及命令：lvcreate×1, mount×1, umount×1

#### oe_test_FSIO_mount_ext4_setErrors

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by errors=$var failed."
```

- 涉及命令：lvcreate×1, mount×1, umount×1

#### oe_test_FSIO_mount_ext4_sync

- 描述：Take the test mount ext4
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 by sync failed."
  CHECK_RESULT $? 0 0 "Write file failed."
  CHECK_RESULT $? 0 0 "Umount failed."
```

- 涉及命令：lvcreate×1, mount×1, umount×1

#### oe_test_FSIO_mount_nonempty_dir

- 描述：Take the test mount fs on non-empty directory
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Mount $var on non-empty directory failed."
  CHECK_RESULT $? 1 0 "Check file on $var after mount failed."
  CHECK_RESULT $? 0 0 "Umount $var on non-empty directory failed."
  CHECK_RESULT $? 0 0 "Check file on $var after umount failed."
```

- 涉及命令：lvcreate×1, mkfs×1, test×1

#### oe_test_FSIO_mount_reboot

- 描述：Take the test umount fs when file is opened
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check fs is mounted failed."
  CHECK_RESULT $? 1 0 "Check fs is mounted after reboot."
```

#### oe_test_FSIO_mount_remount

- 描述：Take the test mount many fs on one point, check the files
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Mount ext4 on $point failed."
  CHECK_RESULT $? 0 0 "The fs type of $point is not ext4."
  CHECK_RESULT $? 0 0 "Mount xfs on $point failed."
  CHECK_RESULT $? 0 0 "The fs type of $point is not xfs."
  CHECK_RESULT $? 0 0 "The testxfs doesn't exist."
  CHECK_RESULT $? 1 0 "The testext4 exists unexpectly."
  CHECK_RESULT $? 1 0 "The testext3 exists unexpectly."
  CHECK_RESULT $? 0 0 "The fs type of $point is not ext4."
  CHECK_RESULT $? 0 0 "The testext4 doesn't exist."
  CHECK_RESULT $? 1 0 "The testxfs exists unexpectly."
  CHECK_RESULT $? 1 0 "The testext3 exists unexpectly."
  CHECK_RESULT $? 0 0 "The fs type of $point is not ext3."
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：test×9, lvcreate×3

#### oe_test_FSIO_mount_umount_ext3

- 描述：Take the test create ext3
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "mount ext3 failed."
  CHECK_RESULT $? 0 0 "Check mount infos failed."
  CHECK_RESULT $? 0 0 "umount ext3 failed."
  CHECK_RESULT $? 0 0 "Check mount infos failed."
  CHECK_RESULT $? 0 0 "umount ext3 failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_umount_ext4

- 描述：Take the test create ext4
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "mount ext4 failed."
  CHECK_RESULT $? 0 0 "Check mount infos failed."
  CHECK_RESULT $? 0 0 "umount ext4 failed."
  CHECK_RESULT $? 0 0 "Check mount infos failed."
  CHECK_RESULT $? 0 0 "umount ext4 failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_umount_xfs

- 描述：Take the test create xfs
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "mount xfs failed."
  CHECK_RESULT $? 0 0 "Check mount infos failed."
  CHECK_RESULT $? 0 0 "umount xfs failed."
  CHECK_RESULT $? 0 0 "Check mount infos failed."
  CHECK_RESULT $? 0 0 "umount xfs failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_xfs_dax

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Mount xfs by dax failed."
  CHECK_RESULT $? 0 0 "Write file failed."
  CHECK_RESULT $? 0 0 "Read file failed."
  CHECK_RESULT $? 0 0 "Umount xfs failed."
```

- 涉及命令：lvcreate×1, mkfs.xfs×1, mount×1, umount×1

#### oe_test_FSIO_mount_xfs_discard

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount xfs by ro failed."
  CHECK_RESULT $? 0 0 "Mount xfs by delalloc failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_xfs_nodiscard

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount xfs by ro failed."
  CHECK_RESULT $? 0 0 "Mount xfs by delalloc failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_xfs_ro

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount xfs by ro failed."
  CHECK_RESULT $? 0 0 "Create file when xfs is readonly unexpectly."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_xfs_rw

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount xfs by ro failed."
  CHECK_RESULT $? 0 0 "Create file on xfs failed."
```

- 涉及命令：lvcreate×1, mount×1

#### oe_test_FSIO_mount_xfs_sync

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Mount xfs by sync failed."
  CHECK_RESULT $? 0 0 "Write file failed."
  CHECK_RESULT $? 0 0 "Umount failed."
```

- 涉及命令：lvcreate×1, mount×1, umount×1

#### oe_test_FSIO_mount_xfs_xfsdump

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Dump files for xfs failed."
```

- 涉及命令：xfsdump×1, test×1

#### oe_test_FSIO_mount_xfs_xfsrestore

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Restore data for xfs failed."
  CHECK_RESULT $? 0 0 "Check file exist for xfs failed."
  CHECK_RESULT $? 0 0 "Check files for xfs failed."
```

- 涉及命令：read×1, xfsdump×1, xfsrestore×1

#### oe_test_FSIO_mv_rm_mount

- 描述：Take the test mv/rm mounted point
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Move mounted point unexpectly."
  CHECK_RESULT $? 0 0 "Remove mounted point unexpectly."
```

- 涉及命令：read×1

#### oe_test_FSIO_overlay_modify_1

- 描述：Take the test modfiy file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Modify file from $upper failed."
  CHECK_RESULT $? 0 0 "Add file on directory from $upper failed."
```

- 涉及命令：mount×1, sed×1, test×1

#### oe_test_FSIO_overlay_modify_2

- 描述：Take the test modfiy file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Modify file from $upper failed."
  CHECK_RESULT $? 0 0 "Modify directory from $upper failed."
  CHECK_RESULT $? 1 0 "The file on $lower is changed unexpectly."
  CHECK_RESULT $? 1 0 "The directory on $lower is changed unexpectly."
```

- 涉及命令：test×2, mount×1, sed×1

#### oe_test_FSIO_overlay_modify_3

- 描述：Take the test modfiy file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "The file in $lower is modified unexpectly."
  CHECK_RESULT $? 1 0 "The directory in $lower is modified unexpectly."
  CHECK_RESULT $? 0 0 "The file in $upper doesn't create."
  CHECK_RESULT $? 0 0 "Modify directory in $upper doesn't create."
```

- 涉及命令：test×2, mount×1, sed×1

#### oe_test_FSIO_overlay_mount

- 描述：Take the test mount overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount overlayfs failed."
  CHECK_RESULT $? 0 0 "Check file on overlayfs failed."
```

- 涉及命令：mkdir×1, mount×1

#### oe_test_FSIO_overlay_rename_1

- 描述：Take the test modfiy file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Modify file from $upper failed."
  CHECK_RESULT $? 0 0 "Modify directory from $upper failed."
```

- 涉及命令：test×2, mkdir×1, mount×1

#### oe_test_FSIO_overlay_rename_2

- 描述：Take the test modfiy file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The file/directory from $lower display on $point failed."
  CHECK_RESULT $? 0 0 "Modify file from $upper failed."
  CHECK_RESULT $? 0 0 "Modify directory from $upper failed."
```

- 涉及命令：test×3, mkdir×1, mount×1

#### oe_test_FSIO_overlay_rename_3

- 描述：Take the test modfiy file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "There is no file on $lower."
  CHECK_RESULT $? 0 0 "There is no directory on $lower."
  CHECK_RESULT $? 0 0 "There is no whiteout file testFile in $upper failed."
  CHECK_RESULT $? 0 0 "There is no whiteout file testDir in $upper failed."
  CHECK_RESULT $? 0 0 "Modify file in $upper failed."
  CHECK_RESULT $? 0 0 "Modify directory in $upper failed."
```

- 涉及命令：test×4, mkdir×1, mount×1

#### oe_test_FSIO_overlay_rm_1

- 描述：Take the test rm file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Remove file/directory on $point failed."
  CHECK_RESULT $? 1 0 "Remove file/directory from $upper failed."
```

- 涉及命令：mkdir×1, mount×1, test×1

#### oe_test_FSIO_overlay_rm_2

- 描述：Take the test rm file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Remove file/directory on $point failed."
  CHECK_RESULT $? 1 0 "The file/directory remove failed on $point."
  CHECK_RESULT $? 0 0 "There is no whiteout file testFile on $upper failed."
  CHECK_RESULT $? 0 0 "There is no whiteout file testDir on $upper failed."
  CHECK_RESULT $? 0 0 "There is no file on lower."
  CHECK_RESULT $? 0 0 "There is no directory on lower."
```

- 涉及命令：test×3, mkdir×1, mount×1

#### oe_test_FSIO_overlay_rm_3

- 描述：Take the test rm file on overlayfs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Remove file/directory on $point failed."
  CHECK_RESULT $? 1 0 "The file/directory remove failed on $point."
  CHECK_RESULT $? 0 0 "There is no whiteout file testFile on $upper failed."
  CHECK_RESULT $? 0 0 "There is no whiteout file testDir on $upper failed."
  CHECK_RESULT $? 0 0 "There is no file on $lower."
  CHECK_RESULT $? 0 0 "There is no directory on $lower."
```

- 涉及命令：test×3, mkdir×1, mount×1

#### oe_test_FSIO_remkfs

- 描述：Take the test re mkfs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mkfs xfs to be ext4 failed."
```

- 涉及命令：lvcreate×1, mkfs.xfs×1

#### oe_test_FSIO_rw_mount

- 描述：Take the test mount fs duplicately
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Write file in $ext4_point failed."
```

- 涉及命令：read×1

#### oe_test_FSIO_umount_busy

- 描述：Take the test umount fs busy
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Umount fs $var unexpectly."
```

- 涉及命令：read×1, mapfile×1

#### oe_test_FSIO_umount_by_openfile

- 描述：Take the test umount fs when file is opened
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Umount fs $var failed."
```

- 涉及命令：read×1

#### oe_test_FSIO_xfs_resize2fs

- 描述：Take the test mount xfs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Change size of xfs failed."
  CHECK_RESULT $? 0 0 "Resize for xfs failed."
```

- 涉及命令：read×1, lvextend×1

#### oe_test_FSIO_create_squashfs

- 描述：Make squashfs test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "mksquashfs failed"
  CHECK_RESULT $? 0 0 "mount squashfs failed"
  CHECK_RESULT $? 0 0 "read file failed"
  CHECK_RESULT $? 0 1 "touched file on readonly fs"
```

#### oe_test_FSIO_mount_tmpfs

- 描述：Mount tmpfs test
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "mount failed"
  CHECK_RESULT $? 0 0 "write or read file failed"
```

- 涉及命令：mount×1
