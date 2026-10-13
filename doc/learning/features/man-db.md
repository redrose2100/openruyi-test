# man-db

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/man-db` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_man-db-cache-update | Test man-db-cache-update.service restart | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_service_man-db | Test man-db.service restart | pre_test/run_test | 0 |  |  |  |
| oe_test_man-db_mandb | File system common command test-mandb | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_man-db_1 | Test man-db | pre_test/run_test | 3 |  |  |  |
| oe_test_apropos | test apropos | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_apropos_01 | test apropos | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_man-db-cache-update

- 描述：Test man-db-cache-update.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Service should show success indication in logs"
  CHECK_RESULT $? 0 0 "Cache file existence check failed"
  CHECK_RESULT $? 0 0 "Cache update verification failed (original:$original_mtime, new:$new_mtime)"
```

- 涉及命令：journalctl×1, test×1

#### oe_test_service_man-db

- 描述：Test man-db.service restart
- 函数：`pre_test, run_test`
#### oe_test_man-db_mandb

- 描述：File system common command test-mandb
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "there is no executable program"
  CHECK_RESULT $? 0 0 "version information is incorrect"
  CHECK_RESULT $? 0 0 "help information is incorrect"
  CHECK_RESULT $? 0 0 "manual page display error"
  CHECK_RESULT $? 0 0 "-u  operation failure"
  CHECK_RESULT $? 0 0 "-q  operation failure"
  CHECK_RESULT $? 0 0 "-f  operation failure"
  CHECK_RESULT $? 0 0 "-p operation failure"
  CHECK_RESULT $? 0 0 "-d Operation failure"
```

- 涉及命令：mandb×7

#### oe_test_man-db_1

- 描述：Test man-db
- 函数：`pre_test, run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "apropos command failed after service restart"
  CHECK_RESULT $? 0 0 "man command failed after service restart"
  CHECK_RESULT $? 0 0 "whatis command failed after service restart"
```

#### oe_test_apropos

- 描述：test apropos
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to search for the manual page related to 'ls'"
  CHECK_RESULT $? 0 0 "Failed to search for keywords using regular expressions"
  CHECK_RESULT $? 0 0 "Failed to search for entries matching tar"
  CHECK_RESULT $? 0 0 "Failed to set the search path entry"
  CHECK_RESULT $? 0 0 "Wildcard search failed"
  CHECK_RESULT $? 0 0 "Config file not applied"
  CHECK_RESULT $? 0 0 "Debug mode output failed"
```

- 涉及命令：apropos×6

#### oe_test_apropos_01

- 描述：test apropos
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Basic search for 'ls' failed"
  CHECK_RESULT $? 0 0 "Search for 'ls' content failed"
  CHECK_RESULT $? 0 0 "Search for 'printf' failed"
  CHECK_RESULT $? 0 0 "Search for 'file' returned no results"
  CHECK_RESULT $? 0 0 "Help option test failed"
  CHECK_RESULT $? 0 0 "Apropos command is not available"
```
