# pkgship_bedepend_query

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_bedepend_query` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_bedepend_binary_1 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_bedepend_binary_2 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_binary_3 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_binary_4 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_bedepend_binary_5 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_binary_6 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_bedepend_fail_1 | Take the test pkgship bedepend {with error pkgName} | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_bedepend_fail_2 | Take the test pkgship bedepend {with error dbName} | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_bedepend_fail_3 | Test pkgship bedepend pkgname dbname  with lacking parameters | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_source_1 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_source_2 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_source_3 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_source_4 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_bedepend_source_5 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_bedepend_source_6 | Take the test pkgship bedepend dbName pkgName | pre_test/run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_bedepend_binary_1

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT "$code" 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_binary_2

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$code" 0 0 "Check bedepend result of PyPAM failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT "$code" 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_binary_3

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$code" 0 0 "Check bedepend result of PyPAM failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT "$code" 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_binary_4

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check bedepend result of PyPAM-help failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of SDL failed."
  CHECK_RESULT 0 0 0 "Check '$i' bedepend result of '$pkg_name' succeed ."
  CHECK_RESULT 1 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_binary_5

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit -w failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit -install failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit -build failed."
```

#### oe_test_pkgship_bedepend_binary_6

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit,testA,testB failed."
```

#### oe_test_pkgship_bedepend_fail_1

- 描述：Take the test pkgship bedepend {with error pkgName}
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The msg is error when pkgName doesn't exist."
  CHECK_RESULT $? 0 0 "The msg is error when pkgName doesn't exist."
```

#### oe_test_pkgship_bedepend_fail_2

- 描述：Take the test pkgship bedepend {with error dbName}
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The msg is error when dbName doesn't exist."
  CHECK_RESULT $? 0 0 "The msg is error when dbName doesn't exist."
```

#### oe_test_pkgship_bedepend_fail_3

- 描述：Test pkgship bedepend pkgname dbname  with lacking parameters
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The msg is error when no pkgName input."
  CHECK_RESULT $? 0 0 "The msg is error when no dbName input."
  CHECK_RESULT $? 0 0 "The msg is error when no parameter input."
  CHECK_RESULT $? 0 0 "The msg is error when input both -install -build."
```

#### oe_test_pkgship_bedepend_source_1

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$code" 0 0 "Check bedepend result of PyPAM failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT "$code" 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_source_2

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$code" 0 0 "Check bedepend result of PyPAM failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT "$code" 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_source_3

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$code" 0 0 "Check bedepend result of PyPAM failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT "$code" 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT "$code" 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_source_4

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check bedepend result of PyPAM failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of openhpi failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of SDL failed."
  CHECK_RESULT 0 0 0 "Check '$i' bedepend result of '$pkg_name' succeed ."
  CHECK_RESULT 1 0 0 "Check '$i' bedepend result of '$pkg_name' failed."
```

#### oe_test_pkgship_bedepend_source_5

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit -w failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit -install failed."
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit -build failed."
```

#### oe_test_pkgship_bedepend_source_6

- 描述：Take the test pkgship bedepend dbName pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check bedepend result of Judy,CUnit,testA,testB failed."
```
