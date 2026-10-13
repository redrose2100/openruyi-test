# pkgship_selfdepend_query

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_selfdepend_query` |
| 注册用例数 | 13 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_selfdepend_binary_1 | Take the test pkgship selfdepend {binaryName} command | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_selfdepend_binary_2 | Take the test pkgship selfbuild {binaryName} -t binary -w 0/1 -s 0/1 | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_selfdepend_binary_3 | Take the test pkgship selfbuild {binaryName} command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_selfdepend_binary_4 | Take the test pkgship selfbuild {binaryName} -t binary -w 0/1 -s 0/1 | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_selfdepend_binary_5 | Take the test pkgship selfdep {binaryName} command | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_selfdepend_fail_1 | Take the test pkgship selfdepend {with error dbName} | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_selfdepend_fail_2 | Test pkgship selfdepend command with lacking parameters | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_selfdepend_fail_3 | Take the test QUERY_SELFDEPEND {binaryName} {not existing dbName} | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_selfdepend_source_1 | Take the test pkgship selfdep {sourceName} command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_selfdepend_source_2 | Take the test pkgship selfbuild {sourceName} | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_selfdepend_source_3 | Take the test pkgship selfdep {sourceName} command | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_selfdepend_source_4 | Take the test pkgship selfdepend {sourceName} command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_selfdepend_source_5 | Take the test pkgship selfbuild {sourceName} | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_selfdepend_binary_1

- 描述：Take the test pkgship selfdepend {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check the self depend of binary  openEuler-gpg-keys failed."
  CHECK_RESULT $? 0 0 "Check the self depend of binary openEuler-repos failed."
  CHECK_RESULT $? 0 0 "Check the self depend of binary glibc failed."
  CHECK_RESULT $? 0 0 "Check the self depend of binary zlib-devel failed."
  CHECK_RESULT $? 0 0 "Check the self depend of binary $pkg_name for number '$i'failed."
```

#### oe_test_pkgship_selfdepend_binary_2

- 描述：Take the test pkgship selfbuild {binaryName} -t binary -w 0/1 -s 0/1
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check the result of glibc-devel with subpack failed."
  CHECK_RESULT $? 0 0 "Check the result of glibc-devel with selfdepend failed."
  CHECK_RESULT $? 0 0 "Check the result of glibc-devel with subpack and selfdepend failed."
```

#### oe_test_pkgship_selfdepend_binary_3

- 描述：Take the test pkgship selfbuild {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check builddep for ${para[$i]} failed."
```

#### oe_test_pkgship_selfdepend_binary_4

- 描述：Take the test pkgship selfbuild {binaryName} -t binary -w 0/1 -s 0/1
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check the result of setup with selfdepend failed."
  CHECK_RESULT $? 0 0 "Check the result of setup with subpack failed."
  CHECK_RESULT $? 0 0 "Check the result of setup with subpack and selfdepend failed."
```

#### oe_test_pkgship_selfdepend_binary_5

- 描述：Take the test pkgship selfdep {binaryName} command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check the selfdepend of Judy,glibc -b failed."
  CHECK_RESULT $? 0 0 "Check the selfdepend of Judy,glibc,testA,testB -b failed."
  CHECK_RESULT $? 0 0 "Check the selfdepend of CUnit,glibc -b -s failed."
  CHECK_RESULT $? 0 0 "Check the selfdepend of CUnit,glibc -b -w failed."
  CHECK_RESULT $? 0 0 "Check the selfdepend of CUnit,glibc -b -w -s failed."
```

#### oe_test_pkgship_selfdepend_fail_1

- 描述：Take the test pkgship selfdepend {with error dbName}
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set pkg = dddd."
  CHECK_RESULT $? 0 0 "The message is error when set pkg = dddd with -b."
```

#### oe_test_pkgship_selfdepend_fail_2

- 描述：Test pkgship selfdepend command with lacking parameters
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set pkg = ''"
  CHECK_RESULT $? 0 0 "The message is error when query without -dbs"
```

#### oe_test_pkgship_selfdepend_fail_3

- 描述：Take the test QUERY_SELFDEPEND {binaryName} {not existing dbName}
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set non-exist dName."
  CHECK_RESULT $? 0 0 "The message is error when set lower&upper characters on dName."
  CHECK_RESULT $? 0 0 "The message is error when set non-exist dblist."
  CHECK_RESULT $? 0 0 "The message is error when set part non-exist dName."
```

#### oe_test_pkgship_selfdepend_source_1

- 描述：Take the test pkgship selfdep {sourceName} command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check the self depend of openEuler-repos failed."
  CHECK_RESULT $? 0 0 "Check the self depend of openEuler-indexhtml failed."
  CHECK_RESULT $? 0 0 "Check the self depend of Judy failed."
  CHECK_RESULT $? 0 0 "Check the self depend of $pkg_name for numer '$i'failed."
```

#### oe_test_pkgship_selfdepend_source_2

- 描述：Take the test pkgship selfbuild {sourceName}
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check the selfdepend of CUint by -s failed."
  CHECK_RESULT $? 0 0 "Check the selfdepend of CUint by -w failed."
  CHECK_RESULT $? 0 0 "Check the selfdepend of CUint by -s,-w failed."
```

#### oe_test_pkgship_selfdepend_source_3

- 描述：Take the test pkgship selfdep {sourceName} command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check the self depend of Judy glibc failed."
  CHECK_RESULT $? 0 0 "Check the self depend of Judy glibc testA testB failed."
  CHECK_RESULT $? 0 0 "Check the self depend of CUnit glibc -s failed."
  CHECK_RESULT $? 0 0 "Check the self depend of CUnit glibc -w failed."
  CHECK_RESULT $? 0 0 "Check the self depend of CUnit glibc -w -s failed."
```

#### oe_test_pkgship_selfdepend_source_4

- 描述：Take the test pkgship selfdepend {sourceName} command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check builddep for ${para[$i]} failed."
```

#### oe_test_pkgship_selfdepend_source_5

- 描述：Take the test pkgship selfbuild {sourceName}
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check builddep for F -s failed."
  CHECK_RESULT $? 0 0 "Check builddep for F -w failed."
  CHECK_RESULT $? 0 0 "Check builddep for F -w -s failed."
```
