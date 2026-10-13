# aops-ceres

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-aops-ceres` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ceres_apollo_fix | Take the test ls command as an example | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ceres_apollo_set-repo | Take the test ls command as an example | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ceres_collect_host | Take the test ls command as an example | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ceres_collect_application | Take the test ls command as an example | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_ceres_apollo_scan | Take the test ls command as an example | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ceres_collect_file | Take the test ls command as an example | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ceres_apollo_fix

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Test fix cve without argument failed"
  CHECK_RESULT $? 0 0 "Test fix cve with invalid argument failed"
  CHECK_RESULT $? 0 0 "Test fix cve failed"
```

#### oe_test_ceres_apollo_set-repo

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test set invalid repo failed"
  CHECK_RESULT $? 0 0 "test repo_info is blank failed"
  CHECK_RESULT $? 0 0 "test verify invalid param failed"
```

#### oe_test_ceres_collect_host

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "test collect host info failed"
  CHECK_RESULT $? 0 0 "test collect host cpu info failed"
  CHECK_RESULT $? 0 0 "test collect host non-exist info failed"
  CHECK_RESULT $? 0 0 "Failed to test host info with incorrect type"
  CHECK_RESULT $? 0 0 "Failed to test host info with missing argument"
```

#### oe_test_ceres_collect_application

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "test collect application failed"
```

#### oe_test_ceres_apollo_scan

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test scan failed"
  CHECK_RESULT $? 0 0 "Test scan without argument failed "
  CHECK_RESULT $? 0 0 "Test scan with invalid argument failed"
```

#### oe_test_ceres_collect_file

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "test collect exist file failed"
  CHECK_RESULT $? 0 0 "test collect non-exist file failed"
  CHECK_RESULT $? 0 0 "test collect non-exist file failed"
  CHECK_RESULT $? 0 0 "test collect file more than 1MB failed"
  CHECK_RESULT $? 0 0 "test collect empty file failed"
  CHECK_RESULT $? 0 0 "test collect executable file failed"
```
