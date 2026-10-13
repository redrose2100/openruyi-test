# mt-st

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mt-st` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_stinit | Test stinit.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_command_mt | mt command testing | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_stinit

- 描述：Test stinit.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_command_mt

- 描述：mt command testing
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "mt command not available"
  CHECK_RESULT $? 0 0 "stinit configuration file syntax error"
  CHECK_RESULT $? 0 0 "mt command help check failed"
  CHECK_RESULT $? 0 0 "mt command manual page missing"
  CHECK_RESULT $? 0 0 "mt command version check failed"
  CHECK_RESULT $? 0 0 "Service dependencies incorrect"
  CHECK_RESULT $? 0 0 "Service logging not working"
```

- 涉及命令：stinit×1, man×1, journalctl×1
