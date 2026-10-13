# sendmail

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sendmail` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_sendmail | Test sendmail.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_sm-client | Test sm-client.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_sendmail_func_001 | sendmail basic function | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_sendmail

- 描述：Test sendmail.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "sendmail.service reload failed"
  CHECK_RESULT $? 0 0 "sendmail.service reload causes the service status to change"
```

- 涉及命令：sed×2, rpm×1, mkdir×1

#### oe_test_service_sm-client

- 描述：Test sm-client.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_sendmail_func_001

- 描述：sendmail basic function
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Service startup failure"
  CHECK_RESULT $? 0 0 "Default port error"
  CHECK_RESULT $? 0 0 "Test failure"
  CHECK_RESULT $? 0 0 "Test failure"
  CHECK_RESULT $? 0 0 "Service stop failure"
```

- 涉及命令：lsof×1
