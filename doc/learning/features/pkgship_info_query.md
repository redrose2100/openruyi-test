# pkgship_info_query

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_info_query` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_query_list_1 | Take the test pkgship list command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_list_2 | Take the test pkgship list command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_list_3 | Take the test QUERY_LIST | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_query_list_fail_1 | Take the test the parameter exception for pkgship list | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_list_fail_2 | Take the test input error parameter for QUERY_LIST | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_pkgship_query_pkginfo_1 | Take the test QUERY_PKGINFO | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_query_pkginfo_2 | Take the test QUERY_PKGINFO | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_query_pkginfo_3 | Take the test pkgship single | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_query_pkginfo_fail_1 | Test QUERY_PKGINFO command without pkgName | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_query_pkginfo_fail_2 | Take the test QUERY_PKGINFO {sourceName} -db dbname with not existing sourceName | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_pkginfo_fail_3 | Take the test QUERY_PKGINFO source -db dbName command with not existing db, negative cases | pre_test/run_test/post_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_query_list_1

- 描述：Take the test pkgship list command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$result" "$actual_num" 0 "Check pkgship list failed."
```

#### oe_test_pkgship_query_list_2

- 描述：Take the test pkgship list command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$result" "$actual_num" 0 "Check pkgship list failed."
```

#### oe_test_pkgship_query_list_3

- 描述：Take the test QUERY_LIST
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$actual1" "$fedora_num" 0 "Check the query for fedora failed."
  CHECK_RESULT "$actual2" "$fedora_num" 0 "Check the query for fedora -s failed."
  CHECK_RESULT $? 0 0 "Check the query for openeuler-20_09-os failed."
  CHECK_RESULT $? 0 0 "Check the query for openeuler-20_09-os -s failed."
  CHECK_RESULT $? 0 0 "Check the query for openeuler-20_03 failed."
  CHECK_RESULT $? 0 0 "Check the query for openeuler-20_03 failed."
```

- 涉及命令：sed×2

#### oe_test_pkgship_query_list_fail_1

- 描述：Take the test the parameter exception for pkgship list
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "There is no error mesaage when set parameters all null."
  CHECK_RESULT $? 0 0 "There is no error mesaage when set parameters all null with -s."
```

#### oe_test_pkgship_query_list_fail_2

- 描述：Take the test input error parameter for QUERY_LIST
- 函数：`pre_test, run_test, post_test`
#### oe_test_pkgship_query_pkginfo_1

- 描述：Take the test QUERY_PKGINFO
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$code" 0 0 "Check failed for git-daemon."
  CHECK_RESULT "$code" 0 0 "Check failed for lshw."
  CHECK_RESULT $? 0 0 "Check $i failed for $pkg_name."
```

#### oe_test_pkgship_query_pkginfo_2

- 描述：Take the test QUERY_PKGINFO
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$code" 0 0 "Check failed for git."
  CHECK_RESULT "$code" 0 0 "Check failed for lshw."
  CHECK_RESULT "$code" 0 0 "Check $i failed for $pkg_name."
```

#### oe_test_pkgship_query_pkginfo_3

- 描述：Take the test pkgship single
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Search pkginfo from fedora failed."
  CHECK_RESULT $? 0 0 "Search pkginfo from openEuler-20.09-OS failed."
  CHECK_RESULT $? 0 0 "Search source pkginfo from fedora failed."
  CHECK_RESULT $? 0 0 "Search source pkginfo from openEuler-20.09-OS failed."
```

- 涉及命令：sed×2

#### oe_test_pkgship_query_pkginfo_fail_1

- 描述：Test QUERY_PKGINFO command without pkgName
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The error message of lacking pkg name is false."
  CHECK_RESULT $? 0 0 "The error message of lacking pkg name is false."
  CHECK_RESULT $? 0 0 "The error message of lacking dbname is false."
  CHECK_RESULT $? 0 0 "The error message of lacking dbname is false."
  CHECK_RESULT $? 0 0 "The error message of lacking pkg name and dbname is false."
  CHECK_RESULT $? 0 0 "The error message of lacking pkg name and dbname is false."
```

#### oe_test_pkgship_query_pkginfo_fail_2

- 描述：Take the test QUERY_PKGINFO {sourceName} -db dbname with not existing sourceName
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The error message while pkgName doesn't exist is false."
  CHECK_RESULT $? 0 0 "The error message while pkgName doesn't exist is false."
```

#### oe_test_pkgship_query_pkginfo_fail_3

- 描述：Take the test QUERY_PKGINFO source -db dbName command with not existing db, negative cases
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The error msg of query for non-exist db name is error."
  CHECK_RESULT $? 0 0 "The error msg of query for non-exist db name is error."
```
