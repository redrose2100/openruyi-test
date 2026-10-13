# FS_File

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_File` |
| 注册用例数 | 40 |
| 环境约束 | add disk = 20 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_FSIO_act_alias | Take the test touch file without inode | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_act_file_lack_inode | Take the test touch file without inode | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_act_hardlink | Take the test hard link file | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_FSIO_bzip2 | Take the test bzip2 | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_change_proc | Take the test change file under /proc | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_chattr | Take the test chattr for file | pre_test/run_test | 4 |  |  |  |
| oe_test_FSIO_check_alias | Take the test normal block file | run_test | 1 |  |  |  |
| oe_test_FSIO_check_block | Take the test normal block file | run_test | 1 |  |  |  |
| oe_test_FSIO_check_file_info | Take the test check file on fs | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_chmod | File system common command test-chmod | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_FSIO_chown | File system common command test-chown | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_FSIO_concurrency_read_file | Take the test concurrency read file | pre_test/run_test/read_file/post_test | 1 |  |  |  |
| oe_test_FSIO_concurrency_write_file | Take the test concurrency write file | pre_test/run_test/write_file/post_test | 1 |  |  |  |
| oe_test_FSIO_cp_file | Take the test copy file on fs | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_create_block | Take the test create block file on fs | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_create_character | Take the test create character file on fs | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_create_hardlink_fail | Take the test create hard link file failed | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_FSIO_create_mv_hardlink | Take the test create and mv hard link file | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_create_softlink | Take the test soft link file | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_create_softlink_diff_fs | Take the test soft link file | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_create_softlink_dir | Take the test soft link file | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_create_softlink_file | Take the test soft link file | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_dd_file | Take the test dd file on fs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_filefrag | Take filefrag | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_gzip | Take the test gzip | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_FSIO_gzip_overfs | Take the test gzip over fs | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_FSIO_modify_file | Take the test modify file on fs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_modify_magicfile | Take the test bzip2 | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_mv_file_1 | Take the test create file on fs | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_mv_file_2 | Take the test mv file on fs | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_rename_file | Take the test rename file on fs | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_FSIO_rename_file_fail | Take the test rename file on fs fail | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_rm_file | Take the test remove file | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_rm_hardlink | Take the test hard link file | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_rm_softlink | Take the test soft link file | config_params/run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_sys_fs_check | Take the test check /sys/fs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_tar | Take the test tar | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_FSIO_touch_file | Take the test create file failed | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_zip_unzip | Take the test zip/unzip on same fs | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_FSIO_zip_unzip_overfs | Take the test zip/unzip on different fs | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_FSIO_act_alias

- 描述：Take the test touch file without inode
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Add alias or create file failed."
  CHECK_RESULT $? 0 0 "Modify alias or mv file failed."
  CHECK_RESULT $? 1 0 "Remove alias failed."
```

- 涉及命令：sed×1, userdel×1

#### oe_test_FSIO_act_file_lack_inode

- 描述：Take the test touch file without inode
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Create file when $var doesn't have space unexpectly."
  CHECK_RESULT $? 0 0 "Modify file when $var doesn't have space failed."
  CHECK_RESULT $? 0 0 "Copy file when $var doesn't have space unexpectly."
  CHECK_RESULT $? 0 0 "Remove file when $var doesn't have space failed."
```

- 涉及命令：sed×1

#### oe_test_FSIO_act_hardlink

- 描述：Take the test hard link file
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $inode1 $inode2 0 "The inode of source file and hard link file are not same."
  CHECK_RESULT $? 0 0 "Check hard link file /tmp/$hard_link failed."
  CHECK_RESULT $? 0 0 "Check hard link file /tmp/$hard_link failed."
  CHECK_RESULT $? 0 0 "Check hard link file /tmp/$hard_link failed."
  CHECK_RESULT $? 0 0 "Check source file /tmp/$file failed."
```

- 涉及命令：sed×2

#### oe_test_FSIO_bzip2

- 描述：Take the test bzip2
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Compress file by bzip2 in $var failed."
  CHECK_RESULT $? 0 0 "Decompress file by bzip2 in $var failed."
```

- 涉及命令：bzip2×2

#### oe_test_FSIO_change_proc

- 描述：Take the test change file under /proc
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Modify /proc/sys/fs/file-max failed."
  CHECK_RESULT $? 1 0 "/proc/sys/fs/file-nr can be modified"
```

#### oe_test_FSIO_chattr

- 描述：Take the test chattr for file
- 函数：`pre_test, run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Change attribution +a of file failed."
  CHECK_RESULT $? 0 0 "Remove file which is +a unexpectly."
  CHECK_RESULT $? 0 0 "Change attribution -a of file failed."
  CHECK_RESULT $? 0 0 "Remove file failed."
```

- 涉及命令：chattr×1

#### oe_test_FSIO_check_alias

- 描述：Take the test normal block file
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The alias on system are changed."
```

- 涉及命令：grep×3

#### oe_test_FSIO_check_block

- 描述：Take the test normal block file
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The normal block files on /dev are lack."
```

#### oe_test_FSIO_check_file_info

- 描述：Take the test check file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The stat info of $var/testfile is false."
  CHECK_RESULT $? 0 0 "The file type of $var/testfile is false."
  CHECK_RESULT $? 0 0 "The count of $var/testfile is false."
```

#### oe_test_FSIO_chmod

- 描述：File system common command test-chmod
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "The access of /tmp is error."
  CHECK_RESULT $? 0 0 "The access of /tmp is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/$testdir is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/$testdir/test02/test03/test03.txt is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/$testdir/test02/test03/test03.txt is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/$testdir/test02/test03/test03.txt is error."
  CHECK_RESULT $? 0 0 "The access of /tmp is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/$testdir is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/$testdir/test02/test02.txt is error."
  CHECK_RESULT $? 0 0 "The chmode help usage is error."
```

- 涉及命令：mkdir×1, chmod×1

#### oe_test_FSIO_chown

- 描述：File system common command test-chown
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check user failed."
  CHECK_RESULT $? 0 0 "Check group failed."
  CHECK_RESULT $? 0 0 "Execute chown -R failed."
  CHECK_RESULT $? 0 0 "$tmpdir user change failed."
  CHECK_RESULT $? 0 0 "$tmpdir group change failed."
  CHECK_RESULT $? 0 0 "$testdir user change failed."
  CHECK_RESULT $? 0 0 "$testdir group change failed."
```

- 涉及命令：mkdir×1, chown×1, userdel×1

#### oe_test_FSIO_concurrency_read_file

- 描述：Take the test concurrency read file
- 函数：`pre_test, run_test, read_file, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Concurrency read file failed."
```

#### oe_test_FSIO_concurrency_write_file

- 描述：Take the test concurrency write file
- 函数：`pre_test, run_test, write_file, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Concurrency write file failed."
```

- 涉及命令：sed×1

#### oe_test_FSIO_cp_file

- 描述：Take the test copy file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check inode failed."
  CHECK_RESULT $? 0 0 "Check $var/testdir1/$var/testdir1/testfile2 file failed."
  CHECK_RESULT $? 0 0 "Check file failed."
```

- 涉及命令：mkdir×1, grep×1

#### oe_test_FSIO_create_block

- 描述：Take the test create block file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Create block file in $var failed."
  CHECK_RESULT $? 0 0 "The device number of block file in $var is error."
  CHECK_RESULT $? 0 0 "Delete block file in $var failed."
```

#### oe_test_FSIO_create_character

- 描述：Take the test create character file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Create character file in $var failed."
  CHECK_RESULT $? 0 0 "The device number of character file in $var is error."
  CHECK_RESULT $? 0 0 "Delete character file in $var failed."
```

#### oe_test_FSIO_create_hardlink_fail

- 描述：Take the test create hard link file failed
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Create hard link for directory unexpectly."
  CHECK_RESULT $? 0 0 "Create hard link for non-exist directory unexpectly."
  CHECK_RESULT $? 0 0 "Create hard link between ext3 and ext4 unexpectly."
  CHECK_RESULT $? 0 0 "Create hard link between ext4 and xfs unexpectly."
  CHECK_RESULT $? 0 0 "Create hard link between xfs and ext3 unexpectly."
```

- 涉及命令：read×1

#### oe_test_FSIO_create_mv_hardlink

- 描述：Take the test create and mv hard link file
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The hard link inode is changed unexpectly when mv on ext3"
  CHECK_RESULT $? 0 0 "The hard link inode change when mv from ext3 to ext4"
  CHECK_RESULT $? 0 0 "The hard link inode doesn't change when mv from ext3 to xfs"
```

- 涉及命令：mapfile×1

#### oe_test_FSIO_create_softlink

- 描述：Take the test soft link file
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The sort link file has some errors."
  CHECK_RESULT $? 0 0 "The sort link directory has some errors."
  CHECK_RESULT $? 0 0 "The sort link file has some errors."
  CHECK_RESULT $? 0 0 "The sort link directory has some errors."
```

- 涉及命令：mkdir×1

#### oe_test_FSIO_create_softlink_diff_fs

- 描述：Take the test soft link file
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The sort link file on ext4 has some errors."
  CHECK_RESULT $? 0 0 "The sort link directory on ext4 has some errors."
  CHECK_RESULT $? 0 0 "The sort link file on xfs has some errors."
  CHECK_RESULT $? 0 0 "The sort link directory on xfs has some errors."
```

- 涉及命令：mkdir×1

#### oe_test_FSIO_create_softlink_dir

- 描述：Take the test soft link file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check inode failed."
  CHECK_RESULT $? 0 0 "The sort link directory has some errors."
```

#### oe_test_FSIO_create_softlink_file

- 描述：Take the test soft link file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check inode failed."
  CHECK_RESULT $? 0 0 "The sort link file has some errors."
```

#### oe_test_FSIO_dd_file

- 描述：Take the test dd file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "dd file $var/testFile2 failed."
  CHECK_RESULT $? 0 0 "Check file msg of $var/testFile2 failed."
```

- 涉及命令：grep×1

#### oe_test_FSIO_filefrag

- 描述：Take filefrag
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check filefrag of $var/testFile failed."
```

- 涉及命令：read×1, filefrag×1

#### oe_test_FSIO_gzip

- 描述：Take the test gzip
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Compress file by gzip in $var failed."
  CHECK_RESULT $? 0 0 "Check gzip file in $var failed."
  CHECK_RESULT $? 0 0 "Check gzip file version in $var failed."
  CHECK_RESULT $? 0 0 "test gzip file by gzip in $var failed."
  CHECK_RESULT $? 0 0 "Decompress file by gzip in $var failed."
```

- 涉及命令：gzip×5

#### oe_test_FSIO_gzip_overfs

- 描述：Take the test gzip over fs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Compress file by gzip in $ext4_point failed."
  CHECK_RESULT $? 0 0 "Decompress gzip file in $ext3_point failed."
  CHECK_RESULT $? 0 0 "Compress file by gzip in $xfs_point failed."
  CHECK_RESULT $? 0 0 "Decompress gzip file in $ext3_point failed."
  CHECK_RESULT $? 0 0 "Compress file by gzip in $xfs_point failed."
  CHECK_RESULT $? 0 0 "Decompress gzip file in $ext4_point failed."
```

- 涉及命令：gzip×6, read×1

#### oe_test_FSIO_modify_file

- 描述：Take the test modify file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Modify file by echo failed."
  CHECK_RESULT $? 0 0 "Check time failed."
```

- 涉及命令：mapfile×1

#### oe_test_FSIO_modify_magicfile

- 描述：Take the test bzip2
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The modified magic file doesn't work."
```

#### oe_test_FSIO_mv_file_1

- 描述：Take the test create file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Create file in $var failed."
  CHECK_RESULT $? 0 0 "Cat file in $var failed."
  CHECK_RESULT $? 0 0 "Cat file in $var failed."
  CHECK_RESULT $? 0 0 "Remove file in $var failed."
```

- 涉及命令：sed×1

#### oe_test_FSIO_mv_file_2

- 描述：Take the test mv file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check inode of file $ext4_point/testFile2 failed."
  CHECK_RESULT $? 0 0 "Check file msg of $ext4_point/testFile2 failed."
  CHECK_RESULT $? 0 0 "Check inode of file $xfs_point/testFile3 failed."
  CHECK_RESULT $? 0 0 "Check file msg of $xfs_point/testFile3 failed."
  CHECK_RESULT $? 0 0 "Check inode of file $ext3_point/testFile4 failed."
  CHECK_RESULT $? 0 0 "Check file msg of $ext3_point/testFile4 failed."
```

#### oe_test_FSIO_rename_file

- 描述：Take the test rename file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check inode failed."
  CHECK_RESULT $? 0 0 "The file info of $var/testfile2 is false."
  CHECK_RESULT $? 0 0 "Check inode failed."
  CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile2 is false."
  CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile3 is false."
  CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile3 is false."
  CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile4 is false."
  CHECK_RESULT $? 0 0 "The file info of $var/test_dir/testfile4 is false."
  CHECK_RESULT $? 0 0 "The file info of -fb $var/test_dir/testfile4 is false."
```

- 涉及命令：grep×7

#### oe_test_FSIO_rename_file_fail

- 描述：Take the test rename file on fs fail
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The cmd lacks parameter was executed succeed on unexpect on $var."
  CHECK_RESULT $? 0 0 "File can be moved when length of file name is more than 255 on $var."
  CHECK_RESULT $? 0 0 "The cmd with blank space parameter was executed succeed on unexpect on $var."
  CHECK_RESULT $? 0 0 "The cmd with dict parameter was executed succeed on unexpect on $var."
```

#### oe_test_FSIO_rm_file

- 描述：Take the test remove file
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Remove file /tmp/testfile$cur_date which used on backend failed."
  CHECK_RESULT $? 0 0 "Remove file /mnt/accessfile$cur_date which doesn't have access unexpectly."
  CHECK_RESULT $? 0 0 "The msg of remove non-exist file is error."
```

- 涉及命令：chattr×1

#### oe_test_FSIO_rm_hardlink

- 描述：Take the test hard link file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Remove origin hard link file /tmp/$file failed."
  CHECK_RESULT $? 0 0 "Check hard link file /tmp/$hard_link failed."
```

#### oe_test_FSIO_rm_softlink

- 描述：Take the test soft link file
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Remove origin soft link file /tmp/$file failed."
  CHECK_RESULT $? 0 0 "The soft link file has some errors."
  CHECK_RESULT $? 0 0 "The soft link file has some errors."
  CHECK_RESULT $? 0 0 "The source file has some errors."
```

#### oe_test_FSIO_sys_fs_check

- 描述：Take the test check /sys/fs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount failed."
  CHECK_RESULT $change 1 0 "Check change failed."
```

- 涉及命令：lvcreate×1, umount×1

#### oe_test_FSIO_tar

- 描述：Take the test tar
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Compress file by tar in $var failed."
  CHECK_RESULT $? 0 0 "Check files in tar in $var failed."
  CHECK_RESULT $? 0 0 "Decompress file by tar in $var failed."
  CHECK_RESULT $? 0 0 "Compress file by tar in $var failed."
  CHECK_RESULT $? 0 0 "Check files $var/testTar$cur_date.tar.gz failed."
  CHECK_RESULT $? 0 0 "Check files $var/$testFile1 failed."
  CHECK_RESULT $? 0 0 "Compress file by tar in $var failed."
  CHECK_RESULT $? 0 0 "Check files $var/testTar$cur_date.tar.bz2 failed."
  CHECK_RESULT $? 0 0 "Check files $var/$testFile2 failed."
```

- 涉及命令：tar×7, grep×2

#### oe_test_FSIO_touch_file

- 描述：Take the test create file failed
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Create file without file operand succeed."
  CHECK_RESULT $? 0 0 "File can be created when length of file name is more than 255."
  CHECK_RESULT $? 0 0 "Create file a failed."
  CHECK_RESULT $? 0 0 "Create file b failed."
  CHECK_RESULT $? 0 0 "Create file a:1 failed."
  CHECK_RESULT $? 0 0 "Create file b:2 failed."
```

#### oe_test_FSIO_zip_unzip

- 描述：Take the test zip/unzip on same fs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Compress file by zip in $var failed."
  CHECK_RESULT $? 0 0 "Check file on zip in $var failed."
  CHECK_RESULT $? 0 0 "Decompress file by zip in $var failed."
  CHECK_RESULT $? 0 0 "delete $var/test1/testfile1 failed in $var/test.zip"
  CHECK_RESULT $? 0 0 "add $var/testfile failed in $var/test.zip"
  CHECK_RESULT $? 0 1 "-j does not support compressing directories"
```

- 涉及命令：zip×5, read×1, mkdir×1, unzip×1

#### oe_test_FSIO_zip_unzip_overfs

- 描述：Take the test zip/unzip on different fs
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Compress file by zip from ext3 to ext4 failed."
  CHECK_RESULT $? 0 0 "Check file on zip in ext4 failed."
  CHECK_RESULT $? 0 0 "Decompress file by zip in ext4 failed."
  CHECK_RESULT $? 0 0 "Compress file by zip from ext3 to xfs failed."
  CHECK_RESULT $? 0 0 "Check file on zip in xfs failed."
  CHECK_RESULT $? 0 0 "Decompress file by zip in xfs failed."
  CHECK_RESULT $? 0 0 "Compress file by zip from ext4 to xfs failed."
  CHECK_RESULT $? 0 0 "Check file on zip in xfs failed."
  CHECK_RESULT $? 0 0 "Decompress file by zip in xfs failed."
```

- 涉及命令：zip×3, unzip×3, read×1
