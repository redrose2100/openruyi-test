# gdisk

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gdisk` |
| 注册用例数 | 13 |
| 环境约束 | add disk = 30 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gdisk_change_partition_name | gdisk change partition name test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_gdisk_verify_disk | gdisk verify disk test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_gdisk_check_partition_info | gdisk check partition info test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gdisk_change_partition_type_code | gdisk change partition code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gdisk_create_partition | gdisk create partition test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gdisk_create_partition_128 | gdisk test for create partition with max value 128 | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_gdisk_sort_partition | gdisk test for sort partition | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_sgdisk_backup_and_restore | gdisk test for sgdisk backup and restore function | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_sgdisk_change_disk_guid | gdisk test for sgdisk change disk guid function | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_sgdisk_change_partition_name | gdisk test for sgdisk change partition name function | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_sgdisk_check_partition_info | gdisk test for sgdisk check partition info function | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sgdisk_create_partition | gdisk test for sgdisk create partition function | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sgdisk_sort_partition | gdisk test for sgdisk sort partition function | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gdisk_change_partition_name

- 描述：gdisk change partition name test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_gdisk_verify_disk

- 描述：gdisk verify disk test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_gdisk_check_partition_info

- 描述：gdisk check partition info test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_gdisk_change_partition_type_code

- 描述：gdisk change partition code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_gdisk_create_partition

- 描述：gdisk create partition test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(cat mount_tmp/testfile)" 123
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：umount×1

#### oe_test_gdisk_create_partition_128

- 描述：gdisk test for create partition with max value 128
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT "$num" 129
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(cat "mount_tmp_$i/testfile")" 123
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：umount×1

#### oe_test_gdisk_sort_partition

- 描述：gdisk test for sort partition
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$num" 3
  CHECK_RESULT "$No" 1
```

#### oe_test_sgdisk_backup_and_restore

- 描述：gdisk test for sgdisk backup and restore function
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：sgdisk×6

#### oe_test_sgdisk_change_disk_guid

- 描述：gdisk test for sgdisk change disk guid function
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sgdisk×2

#### oe_test_sgdisk_change_partition_name

- 描述：gdisk test for sgdisk change partition name function
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：sgdisk×4

#### oe_test_sgdisk_check_partition_info

- 描述：gdisk test for sgdisk check partition info function
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：sgdisk×3

#### oe_test_sgdisk_create_partition

- 描述：gdisk test for sgdisk create partition function
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：sgdisk×3

#### oe_test_sgdisk_sort_partition

- 描述：gdisk test for sgdisk sort partition function
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

- 涉及命令：sgdisk×3
