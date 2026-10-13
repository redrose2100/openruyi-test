# pkgship_installdep_query

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_installdep_query` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_installdep_01 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_installdep_02 | Take the test QUERY_INSTALLDEP {binaryName list} command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_installdep_03 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_installdep_04 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_installdep_05 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_installdep_06 | Take the test QUERY_INSTALLDEP {binary list} command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_installdep_07 | Take the test QUERY_INSTALLDEP {binary list} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_installdep_08 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_installdep_09 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_installdep_10 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_installdep_11 | Take the test QUERY_INSTALLDEP {binaryName} command | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_installdep_fail_1 | Test QUERY_INSTALLDEP command without critical binaryName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_installdep_fail_2 | Take the test QUERY_INSTALLDEP {not existing binaryName} | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_installdep_fail_3 | Take the test QUERY_INSTALLDEP {binaryName} -dbs {not existing dbName} | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_installdep_fail_4 | Take the test QUERY_INSTALLDEP {binaryName} {not existing dbName} | pre_test/run_test/post_test | 4 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_installdep_01

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The search result of openEuler-gpg-keys is error."
  CHECK_RESULT 1 0 0 "The search result of openEuler-repos is error."
  CHECK_RESULT 1 0 0 "The search result of glibc is error."
  CHECK_RESULT 1 0 0 "The search result of coreutils is error."
```

#### oe_test_pkgship_installdep_02

- 描述：Take the test QUERY_INSTALLDEP {binaryName list} command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT 0 0 0 "The search result of Judy openEuler-repos CUnit"
  CHECK_RESULT 1 0 0 "The search result of Judy openEuler-repos CUnit is error."
  CHECK_RESULT 0 0 0 "The search result of Judy openEuler-repos CUnit xyztest abctest"
  CHECK_RESULT 1 0 0 "The search result of Judy openEuler-repos CUnit xyztest abctest is error."
```

#### oe_test_pkgship_installdep_03

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check installdep for '$i' failed."
```

#### oe_test_pkgship_installdep_04

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$code" 0 0 "Check query failed."
```

#### oe_test_pkgship_installdep_05

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 1."
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 2."
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 500000."
  CHECK_RESULT "$code" 0 0 "The compare result '$i' of pkgship and dnf is different for level 1."
```

#### oe_test_pkgship_installdep_06

- 描述：Take the test QUERY_INSTALLDEP {binary list} command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 1."
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 2."
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 500000."
```

#### oe_test_pkgship_installdep_07

- 描述：Take the test QUERY_INSTALLDEP {binary list} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 1."
  CHECK_RESULT "$code" 0 0 "The compare result of pkgship and dnf is different for level 3."
```

#### oe_test_pkgship_installdep_08

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "Query first failed"
  CHECK_RESULT $? 1 0 "Query second failed"
```

#### oe_test_pkgship_installdep_09

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "Query installdep for openEuler-repos failed."
  CHECK_RESULT $? 1 0 "Query installdep for setup failed."
```

#### oe_test_pkgship_installdep_10

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check openEuler-repos failed."
  CHECK_RESULT $? 0 0 "Check Cunit-devel failed."
  CHECK_RESULT "$code" 0 0 "Check A2 failed."
  CHECK_RESULT "$code" 0 0 "Check E1,A2 failed."
```

- 涉及命令：sed×2

#### oe_test_pkgship_installdep_11

- 描述：Take the test QUERY_INSTALLDEP {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Query installdep for unzip failed"
  CHECK_RESULT $? 0 0 "Query installdep for unzip,git failed"
```

#### oe_test_pkgship_installdep_fail_1

- 描述：Test QUERY_INSTALLDEP command without critical binaryName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The msg is false when no package name input."
  CHECK_RESULT $? 0 0 "The msg is false when no para input"
  CHECK_RESULT $? 0 0 "The msg is false when no parameters."
  CHECK_RESULT $? 0 0 "The msg is false when no -level."
```

#### oe_test_pkgship_installdep_fail_2

- 描述：Take the test QUERY_INSTALLDEP {not existing binaryName}
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set pkg = dddd."
  CHECK_RESULT $? 0 0 "The message is error when set pkg = dddd, dbs = openeuler-lts."
  CHECK_RESULT $? 0 0 "The message is error when set pkg = dddd, dbs = openeuler-lts, level = 1."
```

#### oe_test_pkgship_installdep_fail_3

- 描述：Take the test QUERY_INSTALLDEP {binaryName} -dbs {not existing dbName}
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set dbs = test."
  CHECK_RESULT $? 0 0 "The message is error when set dbs = openeuler-lts test."
```

#### oe_test_pkgship_installdep_fail_4

- 描述：Take the test QUERY_INSTALLDEP {binaryName} {not existing dbName}
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when level = 0."
  CHECK_RESULT $? 0 0 "The message is error when level = test."
  CHECK_RESULT $? 0 0 "The message is error when level = 1.234."
  CHECK_RESULT $? 0 0 "The message is error when level = -5."
```
