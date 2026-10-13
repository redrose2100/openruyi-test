# postfix

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/postfix` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_postfix | Test postfix.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_postfix_configuration | postfix configuration and status query | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_postfix

- 描述：Test postfix.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "postfix.service reload failed"
  CHECK_RESULT $? 0 0 "postfix.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_postfix_configuration

- 描述：postfix configuration and status query
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "start fail"
  CHECK_RESULT $? 0 0 "postfix not active"
  CHECK_RESULT $? 0 0 "check fail"
  CHECK_RESULT $? 0 0 "check fail"
```

- 涉及命令：postconf×2
