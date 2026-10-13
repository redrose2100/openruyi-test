# cpio

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/cpio` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_cpio | command test-cpio | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_cpio_options_01 | command test-cpio options -v and -d | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_cpio_options_02 | command test-cpio options -m and -a | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_cpio_options_03 | command test-cpio options -L and -n | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_cpio_format_01 | command test-cpio format | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_cpio_format_02 | command test-cpio format file io | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_cpio_advanced_01 | command test-cpio advanced | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_cpio_advanced_02 | command test-cpio advanced file attributes | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_cpio

- 描述：command test-cpio
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create..."
  CHECK_RESULT $? 0 0 "failed to cpio list..."
  CHECK_RESULT $? 0 0 "cpio list results are inconsistent..."
  CHECK_RESULT $? 0 0 "failed to cpio option -I..."
  CHECK_RESULT $? 0 0 "cpio list with -I results are inconsistent..."
  CHECK_RESULT $? 0 0 "failed create testdir..."
  CHECK_RESULT $? 0 0 "failed to cpio extract..."
  CHECK_RESULT $? 0 0 "cpio create and extract results are inconsistent..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with -u -i option..."
  CHECK_RESULT $? 0 0 "cpio -i -u option test failed..."
  CHECK_RESULT $? 0 0 "failed to cpio pass-through"
  CHECK_RESULT $? 0 0 "cpio -p option test failed..."
```

- 涉及命令：cpio×6, diff×5, mkdir×1

#### oe_test_cpio_options_01

- 描述：command test-cpio options -v and -d
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create with -v option..."
  CHECK_RESULT $? 0 0 "failed to display verbose output with -v option..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with -d option..."
  CHECK_RESULT $? 0 0 "failed to create directory with -d option..."
```

- 涉及命令：cpio×2, mkdir×1, grep×1, test×1

#### oe_test_cpio_options_02

- 描述：command test-cpio options -m and -a
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create archive for -m test..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with -m option..."
  CHECK_RESULT $((touch_time == new_touch_time)) 1 0 "failed to preserve modification time with -m option..."
  CHECK_RESULT $? 0 0 "failed to cpio create with -a option..."
  CHECK_RESULT $((access_time_before == access_time_after)) 1 0 "failed to reset access time with -a option..."
```

- 涉及命令：cpio×3, mkdir×2

#### oe_test_cpio_options_03

- 描述：command test-cpio options -L and -n
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create with -L option..."
  CHECK_RESULT $? 0 0 "failed to cpio extract after -L option..."
  CHECK_RESULT $? 0 0 "failed to dereference symlink with -L option..."
  CHECK_RESULT $? 0 0 "failed to cpio create archive for -n test..."
  CHECK_RESULT $? 0 0 "failed to cpio list archive..."
  CHECK_RESULT $? 0 0 "failed to cpio list with -n option..."
  CHECK_RESULT $? 0 0 "failed to generate output with -n option..."
  CHECK_RESULT $? 0 0 "failed to display numeric UID/GID with -n option..."
```

- 涉及命令：cpio×5, test×2, mkdir×1, grep×1

#### oe_test_cpio_format_01

- 描述：command test-cpio format
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create with -c option..."
  CHECK_RESULT $? 0 0 "failed to create newc format archive with -c option..."
  CHECK_RESULT $? 0 0 "failed to cpio create with -H newc option..."
  CHECK_RESULT $? 0 0 "failed to cpio create with -H odc option..."
  CHECK_RESULT $? 0 0 "failed to create archives with different formats..."
```

- 涉及命令：cpio×3, mkdir×1, test×1

#### oe_test_cpio_format_02

- 描述：command test-cpio format file io
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create with -F option..."
  CHECK_RESULT $? 0 0 "failed to create archive file with -F option..."
  CHECK_RESULT $? 0 0 "failed to list archive with -F option..."
  CHECK_RESULT $? 0 0 "failed to cpio create with -O option..."
  CHECK_RESULT $? 0 0 "failed to create archive file with -O option..."
  CHECK_RESULT $? 0 0 "failed to extract archive created with -O option..."
  CHECK_RESULT $? 0 0 "failed to verify extracted files from -O archive..."
  CHECK_RESULT $? 0 0 "failed to cpio create archive for -I test..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with -I option..."
  CHECK_RESULT $? 0 0 "failed to verify extracted files with -I option..."
```

- 涉及命令：cpio×6, test×4, mkdir×1

#### oe_test_cpio_advanced_01

- 描述：command test-cpio advanced
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create archive..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with -f option..."
  CHECK_RESULT $? 0 0 "failed to create directory with -f option..."
  CHECK_RESULT $? 0 0 "failed to cpio create archive for -E test..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with -E option..."
  CHECK_RESULT $? 0 0 "failed to extract file1 with -E option..."
  CHECK_RESULT $? 0 0 "unexpectedly extracted file2 with -E option..."
  CHECK_RESULT $? 0 0 "unexpectedly extracted file3 with -E option..."
```

- 涉及命令：cpio×3, mkdir×2, test×2

#### oe_test_cpio_advanced_02

- 描述：command test-cpio advanced file attributes
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "failed to cpio create archive for -R test..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with -R option..."
  CHECK_RESULT $? 0 0 "failed to set file ownership with -R option..."
  CHECK_RESULT $? 0 0 "failed to cpio pass-through with -l option..."
  CHECK_RESULT $? 0 0 "failed to link file with -l option..."
  CHECK_RESULT $((inode1 == inode2)) 1 0 "failed to create hard link with -l option..."
  CHECK_RESULT $? 0 0 "failed to cpio create with sparse file..."
  CHECK_RESULT $? 0 0 "failed to cpio extract with --sparse option..."
  CHECK_RESULT $? 0 0 "failed to extract sparse file with --sparse option..."
```

- 涉及命令：cpio×5, mkdir×3, test×2
