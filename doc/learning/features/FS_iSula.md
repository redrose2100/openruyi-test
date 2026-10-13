# FS_iSula

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_iSula` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_isula_check_overlay2fs | check isula overlay2fs | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_isula_compress | Compress and run isula | config_params/pre_test/run_test/post_test | 1 | ✔ |  | 60m |
| oe_test_isula_cp | cp file between localhost and isula | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_isula_info | check isula info | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_isula_mergedir | write file on isula MergedDir | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_isula_mount | check isula mount | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_isula_mount_system_isula | Mount file in isula | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_isula_write_in_isula | write file in isula | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_isula_check_overlay2fs

- 描述：check isula overlay2fs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The isula doesn't have /home/isula_dir."
```

- 涉及命令：mkdir×1

#### oe_test_isula_compress

- 描述：Compress and run isula
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Run isula failed."
```

#### oe_test_isula_cp

- 描述：cp file between localhost and isula
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "CP file from docker to localhost failed."
  CHECK_RESULT $? 0 0 "CP file from localhost to docker failed."
```

- 涉及命令：test×1

#### oe_test_isula_info

- 描述：check isula info
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check images failed."
  CHECK_RESULT $? 0 0 "Check isula info failed."
  CHECK_RESULT $? 0 0 "The isula directory lacks some things."
```

#### oe_test_isula_mergedir

- 描述：write file on isula MergedDir
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Write file to merge_dir failed."
  CHECK_RESULT $? 0 0 "Check file in docker failed."
  CHECK_RESULT $? 2 0 "MergedDir exists unexpectly when isula doesn't run."
```

#### oe_test_isula_mount

- 描述：check isula mount
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check mount fs failed."
  CHECK_RESULT $? 0 0 "Check mount fs in isula failed."
```

#### oe_test_isula_mount_system_isula

- 描述：Mount file in isula
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Create system isula failed."
  CHECK_RESULT $? 0 0 "Check system isula failed."
  CHECK_RESULT $? 0 0 "Execute system isula failed."
```

- 涉及命令：tar×2, sed×1

#### oe_test_isula_write_in_isula

- 描述：write file in isula
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file in isula failed."
  CHECK_RESULT $? 0 0 "Check file in local directory failed."
```
