# oec-hardware

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/oec-hardware` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_oech | Test oech.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_oech-server | Test oech-server.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_oech | test oech | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_oech

- 描述：Test oech.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_oech-server

- 描述：Test oech-server.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_oech

- 描述：test oech
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Display Help Information Error"
  CHECK_RESULT $? 0 0 "Clearing compatibility test data failed"
  CHECK_RESULT $? 0 0 "Continuing to run tests after system restart failed"
  CHECK_RESULT $? 0 0 "Error in listing version information in oech"
```

- 涉及命令：oech×1
