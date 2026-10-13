# FS_Negative

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_Negative` |
| 注册用例数 | 15 |
| 环境约束 | add disk = 10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_FSIO_boot_full_data | Inject data full on /boot | run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_cat_block_file | Inject: create error format file on fs to cat | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_cat_file_error_format | Inject: create error format file on fs to cat | pre_test/run_test/post_test | 2 |  |  | 60m |
| oe_test_FSIO_cat_stack | Take the test cat process stack | run_test | 1 |  |  |  |
| oe_test_FSIO_check_rootfs | Check rootfs lost_found | run_test | 1 |  |  |  |
| oe_test_FSIO_create_file_format | Inject: create format file on fs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_create_file_noformat | Inject: create non-format file on fs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_create_full_dir | Inject full dir on fs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_create_hard_link_rm | Inject: Change file access while reading file | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_create_same_name_dir_file | Inject create same name directory and file on mnt_point | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_destory_block | Inject: Destory the fs super block to rw the fs | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_e2fsck_datablock | Fsck ext3/ext4 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_etc_full_data | Inject data full on /etc | run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_fopen_r+_fail | fopen nonexist file by r+ | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_fread_larger_memsize | fread file | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_FSIO_boot_full_data

- 描述：Inject data full on /boot
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
  CHECK_RESULT $? 0 0 "The device is fulled."
  CHECK_RESULT $? 0 0 "The device isn't full but cannot write data."
  CHECK_RESULT $? 1 0 "Write data into device unexpectly."
  CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
  CHECK_RESULT $? 0 0 "The device is fulled."
```

#### oe_test_FSIO_cat_block_file

- 描述：Inject: create error format file on fs to cat
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Read block device failed."
```

#### oe_test_FSIO_cat_file_error_format

- 描述：Inject: create error format file on fs to cat
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Cat file failed."
  CHECK_RESULT $? 0 0 "Remove file failed."
```

#### oe_test_FSIO_cat_stack

- 描述：Take the test cat process stack
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "Cat process 1's stack caused process Z/X"
```

#### oe_test_FSIO_check_rootfs

- 描述：Check rootfs lost_found
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The rootfs lost_found direcotry doesn't exist."
```

#### oe_test_FSIO_create_file_format

- 描述：Inject: create format file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Cat file failed."
  CHECK_RESULT $? 0 0 "Remove file failed."
```

#### oe_test_FSIO_create_file_noformat

- 描述：Inject: create non-format file on fs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Cat file failed."
  CHECK_RESULT $? 0 0 "Remove file failed."
```

#### oe_test_FSIO_create_full_dir

- 描述：Inject full dir on fs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 "Check pwd failed."
  CHECK_RESULT $? 0
```

- 涉及命令：top×1, iostat×1

#### oe_test_FSIO_create_hard_link_rm

- 描述：Inject: Change file access while reading file
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "Create hard link file unexpectly while rm the source file."
```

#### oe_test_FSIO_create_same_name_dir_file

- 描述：Inject create same name directory and file on mnt_point
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "Cat same name file unexpectly."
  CHECK_RESULT $? 1 0 "cd same name directory unexpectly."
```

- 涉及命令：mapfile×1

#### oe_test_FSIO_destory_block

- 描述：Inject: Destory the fs super block to rw the fs
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Destory the fs super block failed on $mnt_point."
  CHECK_RESULT $? 0 0 "Read file on fs failed when destory the super block on $mnt_point."
  CHECK_RESULT $? 0 0 "Mkdir on fs unexpectly when destory the super block on $mnt_point."
```

- 涉及命令：read×1, tune2fs×1

#### oe_test_FSIO_e2fsck_datablock

- 描述：Fsck ext3/ext4
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The lost+found on $mnt_point doesn't exist."
  CHECK_RESULT $? 0 0 "The file is restored failed."
  CHECK_RESULT $? 0 0 "The direcotry is restored failed."
```

- 涉及命令：mkdir×1, dump×1, restore×1

#### oe_test_FSIO_etc_full_data

- 描述：Inject data full on /etc
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
  CHECK_RESULT $? 0 0 "The device is fulled."
  CHECK_RESULT $? 0 0 "The device isn't full but cannot write data."
  CHECK_RESULT $? 1 0 "Write data into device unexpectly."
  CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
  CHECK_RESULT $? 0 0 "The device is fulled."
```

#### oe_test_FSIO_fopen_r+_fail

- 描述：fopen nonexist file by r+
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Open file unexpectly"
```

#### oe_test_FSIO_fread_larger_memsize

- 描述：fread file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Execute to fread file unexpectly."
  CHECK_RESULT $? 0 0 "File is changed unexpectly."
```
