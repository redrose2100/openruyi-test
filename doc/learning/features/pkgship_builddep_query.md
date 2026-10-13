# pkgship_builddep_query

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_builddep_query` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_builddep_01 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_builddep_02 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_builddep_03 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_builddep_04 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_builddep_05 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_builddep_06 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_builddep_07 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_builddep_08 | Take the test pkgship builddep {binaryName} command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_builddep_09 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_builddep_10 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_builddep_11 | Take the test pkgship builddep {srcName} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_builddep_fail_1 | Test pkgship buildldep command without critical binaryName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_builddep_fail_2 | Take the test pkgship builddep {not existing srcName} | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_builddep_fail_3 | Take the test pkgship builddep {srcName} {not existing dbName} | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_builddep_fail_4 | Take the test pkgship builddep {srcName} {not existing dbName} | pre_test/run_test/post_test | 4 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_builddep_01

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check the builddep for openEuler-repos failed."
  CHECK_RESULT $? 0 0 "Check the builddep for coreutils failed."
  CHECK_RESULT $? 0 0 "Check the builddep for $pkg_name failed."
```

#### oe_test_pkgship_builddep_02

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check the builddep for unzip,CUnit failed."
  CHECK_RESULT $? 0 0 "Check the builddep for unzip,CUnit failed."
```

#### oe_test_pkgship_builddep_03

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check the builddep for Judy failed."
  CHECK_RESULT $? 0 0 "Check the builddep for Judy failed."
  CHECK_RESULT $? 0 0 "Check the builddep for Judy failed."
```

#### oe_test_pkgship_builddep_04

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check the builddep for Judy,CUnit failed for level 1."
  CHECK_RESULT $? 0 0 "Check the builddep for Judy,CUnit failed for level 2."
  CHECK_RESULT $? 0 0 "Check the builddep for Judy,CUnit failed."
```

#### oe_test_pkgship_builddep_05

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check builddep for ${para[$i]} failed."
```

#### oe_test_pkgship_builddep_06

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check builddep for 'A B' failed."
```

#### oe_test_pkgship_builddep_07

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check the builddep of level 1 for B failed."
  CHECK_RESULT $? 0 0 "Check the builddep of level 1 for B failed."
```

#### oe_test_pkgship_builddep_08

- 描述：Take the test pkgship builddep {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Query first failed."
  CHECK_RESULT $? 1 0 "Query second failed."
  CHECK_RESULT $? 1 0 "Query third failed."
```

#### oe_test_pkgship_builddep_09

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check the builddep of openEuler-repos failed."
  CHECK_RESULT $? 0 0 "Check the builddep of CUnit failed."
```

#### oe_test_pkgship_builddep_10

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Query builddep for openEuler-repos failed."
  CHECK_RESULT $? 0 0 "Query builddep for CUnit failed."
  CHECK_RESULT $? 0 0 "Query builddep for E failed."
```

#### oe_test_pkgship_builddep_11

- 描述：Take the test pkgship builddep {srcName} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "Query for unzip failed."
  CHECK_RESULT $? 1 0 "Query for unzip,CUnit,A failed."
```

#### oe_test_pkgship_builddep_fail_1

- 描述：Test pkgship buildldep command without critical binaryName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check failed when no pkg name"
  CHECK_RESULT $? 0 0 "Check failed when no level"
  CHECK_RESULT $? 0 0 "Check failed when no parameter"
  CHECK_RESULT $? 0 0 "Check failed when no -level"
```

#### oe_test_pkgship_builddep_fail_2

- 描述：Take the test pkgship builddep {not existing srcName}
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check failed when pkg name doesn't exist"
  CHECK_RESULT $? 0 0 "Check failed when all pkg names don't exist"
  CHECK_RESULT $? 0 0 "Check failed when all pkg names don't exist"
```

#### oe_test_pkgship_builddep_fail_3

- 描述：Take the test pkgship builddep {srcName} {not existing dbName}
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check failed when db name doesn't exist"
  CHECK_RESULT $? 0 0 "Check failed when db names don't exist"
```

#### oe_test_pkgship_builddep_fail_4

- 描述：Take the test pkgship builddep {srcName} {not existing dbName}
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check failed when -level=0"
  CHECK_RESULT $? 0 0 "Check failed when -level=test"
  CHECK_RESULT $? 0 0 "Check failed when -level=1.234"
  CHECK_RESULT $? 0 0 "Check failed when -level=-5"
```
