# bolt

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/bolt` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_bolt | Test bolt.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_bolt_01 | bolt command testing | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_bolt

- 描述：Test bolt.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_bolt_01

- 描述：bolt command testing
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "bolt command not working"
  CHECK_RESULT $? 0 0 "Service start log not found"
  CHECK_RESULT $? 0 0 "DBus interface not available"
  CHECK_RESULT $? 0 0 "DBus policy file missing"
```

- 涉及命令：journalctl×1, test×1
