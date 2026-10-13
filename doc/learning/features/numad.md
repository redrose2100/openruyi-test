# numad

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/numad` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_numad | Test numad.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_command_numad | numad command testing | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_numad

- 描述：Test numad.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_command_numad

- 描述：numad command testing
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "numad process not running"
  CHECK_RESULT $? 0 0 "Service logging not working"
  CHECK_RESULT $? 0 0 "Version information not available"
  CHECK_RESULT $? 0 0 "Verbose mode test failed"
  CHECK_RESULT $? 0 0 "Debug mode test failed"
  CHECK_RESULT $? 0 0 "Interval setting test failed"
  CHECK_RESULT $? 0 0 "Memory locality target test failed"
  CHECK_RESULT $? 0 0 "CPU reservation test failed"
  CHECK_RESULT $? 0 0 "NUMA node suggestions test failed"
```

- 涉及命令：numad×7, pgrep×1, journalctl×1
