# pkgship_compare

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_compare` |
| 注册用例数 | 17 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_compare_build_1 | Take the test compare build data comparison between dbs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_compare_build_2 | Take the test compare build to set output path | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_pkgship_compare_build_fail_1 | Take the test compare build data comparison between dbs failed | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_compare_build_fail_2 | Take the test compare build data comparison between dbs failed | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_compare_build_fail_3 | Take the test compare build data comparison between dbs when inode full | pre_test/run_test/post_test | 1 |  |  | 60m |
| oe_test_pkgship_compare_build_fail_4 | Take the test compare build data comparison between dbs failed when data full | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_compare_build_fail_5 | Take the test compare build data comparison between dbs failed | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_compare_fail_1 | Take the test compare failed with server stop | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_compare_fail_2 | Take the test compare failed with error type | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_compare_install_1 | Take the test compare install data comparison between dbs | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_compare_install_2 | Take the test compare install to set output path | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_pkgship_compare_install_fail_1 | Take the test compare install data comparison between dbs failed | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_compare_install_fail_2 | Take the test compare install data comparison between dbs failed | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_compare_install_fail_3 | Take the test compare install data comparison between dbs when inode full | pre_test/run_test/post_test | 1 |  |  | 60m |
| oe_test_pkgship_compare_install_fail_4 | Take the test compare install data comparison between dbs failed when data full | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_compare_install_fail_5 | Take the test compare install data comparison between dbs failed | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_compare_stop_redis | Take the test compare when stop redis | pre_test/run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_compare_build_1

- 描述：Take the test compare build data comparison between dbs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Execute compare build command failed when set 1 dbs."
  CHECK_RESULT $? 0 0 "Check openeuler1.csv created failed."
```

- 涉及命令：sed×2, grep×1

#### oe_test_pkgship_compare_build_2

- 描述：Take the test compare build to set output path
- 函数：`pre_test, run_test, post_test`
#### oe_test_pkgship_compare_build_fail_1

- 描述：Take the test compare build data comparison between dbs failed
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set dbs not exist."
  CHECK_RESULT "$(wc -l /opt/pkgship/compare | awk '{print $1}')" "$ori_num" 0 "It created comparison file unexpectly."
  CHECK_RESULT $? 0 0 "The message is error when set part of dbs not exist."
  CHECK_RESULT $? 0 0 "The message is error when set 5 dbs."
  CHECK_RESULT $? 0 0 "The message is error when set duplicate dbs."
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_build_fail_2

- 描述：Take the test compare build data comparison between dbs failed
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when output path has no access."
  CHECK_RESULT "$(wc -l /opt/pkgship/compare | awk '{print $1}')" "$ori_num" 0 "It created comparison file unexpectly."
  CHECK_RESULT $? 0 0 "The message is error when set output path not exist."
  CHECK_RESULT $? 0 0 "The message is error when no -o paramter."
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_build_fail_3

- 描述：Take the test compare build data comparison between dbs when inode full
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when output path is full inode."
```

#### oe_test_pkgship_compare_build_fail_4

- 描述：Take the test compare build data comparison between dbs failed when data full
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_build_fail_5

- 描述：Take the test compare build data comparison between dbs failed
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_fail_1

- 描述：Take the test compare failed with server stop
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Query install compare unexpectly when stop server."
  CHECK_RESULT $? 0 0 "Query build compare unexpectly when stop server."
  CHECK_RESULT $? 0 0 "Query install compare unexpectly when stop server."
  CHECK_RESULT $? 0 0 "Query build compare unexpectly when stop server."
```

- 涉及命令：kill×1

#### oe_test_pkgship_compare_fail_2

- 描述：Take the test compare failed with error type
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Query compare unexpectly when set type = INSTALL."
  CHECK_RESULT $? 0 0 "Query compare unexpectly when set type = BUILD."
  CHECK_RESULT $? 0 0 "Query compare unexpectly when set type = bedepend."
```

#### oe_test_pkgship_compare_install_1

- 描述：Take the test compare install data comparison between dbs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Execute compare install command failed when set 1 dbs."
  CHECK_RESULT $? 0 0 "Check openeuler1.csv created failed."
```

- 涉及命令：sed×2, grep×1

#### oe_test_pkgship_compare_install_2

- 描述：Take the test compare install to set output path
- 函数：`pre_test, run_test, post_test`
#### oe_test_pkgship_compare_install_fail_1

- 描述：Take the test compare install data comparison between dbs failed
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set dbs not exist."
  CHECK_RESULT "$(wc -l /opt/pkgship/compare | awk '{print $1}')" "$ori_num" 0 "It created comparison file unexpectly."
  CHECK_RESULT $? 0 0 "The message is error when set part of dbs not exist."
  CHECK_RESULT $? 0 0 "The message is error when set 5 dbs."
  CHECK_RESULT $? 0 0 "The message is error when set duplicate dbs."
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_install_fail_2

- 描述：Take the test compare install data comparison between dbs failed
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when output path has no access."
  CHECK_RESULT "$(wc -l /opt/pkgship/compare | awk '{print $1}')" "$ori_num" 0 "It created comparison file unexpectly."
  CHECK_RESULT $? 0 0 "The message is error when set output path not exist."
  CHECK_RESULT $? 0 0 "The message is error when no -o paramter."
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_install_fail_3

- 描述：Take the test compare install data comparison between dbs when inode full
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when output path is full inode."
```

#### oe_test_pkgship_compare_install_fail_4

- 描述：Take the test compare install data comparison between dbs failed when data full
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_install_fail_5

- 描述：Take the test compare install data comparison between dbs failed
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when no paramter."
```

#### oe_test_pkgship_compare_stop_redis

- 描述：Take the test compare when stop redis
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Execute compare command failed when stop redis server."
```

- 涉及命令：kill×1
