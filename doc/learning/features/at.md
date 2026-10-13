# at

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/at` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_at_at | Command test-at | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_at_atrm | Command test-atrm | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_atd | Test atd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_atd_01 | test at | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_at_at

- 描述：Command test-at
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "description failed to generate log files"
  CHECK_RESULT $? 0 0 "the scheduled task at 15:30 is not checked"
  CHECK_RESULT $? 0 0 "the scheduled task at 14:30 is not checked"
  CHECK_RESULT $? 0 0 "failed to enter using the file"
  CHECK_RESULT $? 0 0 "only the root user fails to be displayed"
  CHECK_RESULT $? 0 0 "the scheduled task at 15:31 and b is not checked"
  CHECK_RESULT $? 0 0 "failed to filter tty login users. Procedure"
  CHECK_RESULT $? 0 0 "Failed to create at job for -l test"
  CHECK_RESULT $? 0 0 "Failed to list at queue with -l parameter"
  CHECK_RESULT $? 0 0 "The scheduled task at 16:00 is not found in -l output"
  CHECK_RESULT $? 0 0 "Failed to create at job for -d test"
  CHECK_RESULT $? 0 0 "Failed to get job ID for deletion"
  ... 共 18 条（其余见源脚本）
```

#### oe_test_at_atrm

- 描述：Command test-atrm
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "description failed to generate log files"
  CHECK_RESULT $? 0 0 "the scheduled task at 15:30 is not checked"
  CHECK_RESULT $? 0 0 "the scheduled task at 14:30 is not checked"
  CHECK_RESULT $? 0 1 "failed to enter using the file"
```

#### oe_test_service_atd

- 描述：Test atd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_atd_01

- 描述：test at
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Test1 failed"
  CHECK_RESULT $? 0 0 "Test2 failure"
```
