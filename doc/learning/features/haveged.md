# haveged

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/haveged` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_haveged | Test haveged.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_command_haveged | haveged command test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_haveged01 | Test haveged.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_haveged

- 描述：Test haveged.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_command_haveged

- 描述：haveged command test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "haveged process not running"
  CHECK_RESULT $? 0 0 "Entropy pool monitoring failed"
  CHECK_RESULT $? 0 0 "Entropy generation not working"
  CHECK_RESULT $? 0 0 "haveged version check failed"
  CHECK_RESULT $? 1 0 "Service logging not working"
  CHECK_RESULT $? 0 0 "Random device access failed"
  CHECK_RESULT $? 0 0 "Urandom device access failed"
  CHECK_RESULT $? 0 0 "Service dependencies incorrect"
  CHECK_RESULT $? 0 0 "Service recovery test failed"
  CHECK_RESULT $? 0 0 "Help documentation not available"
```

- 涉及命令：pgrep×1, journalctl×1

#### oe_test_haveged01

- 描述：Test haveged.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "haveged.service disable failed"
  CHECK_RESULT $? 0 0 "haveged.service disable failed to change status to disabled"
  CHECK_RESULT $? 0 0 "haveged.service enable failed"
  CHECK_RESULT $? 0 0 "haveged.service enable failed to change status to enabled"
  CHECK_RESULT $? 0 0 "haveged command help information query failed"
  CHECK_RESULT $? 0 0 "haveged version information query failed"
  CHECK_RESULT $? 0 0 "haveged.service is not active"
```

- 涉及命令：haveged×2
