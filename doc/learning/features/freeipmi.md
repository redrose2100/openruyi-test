# freeipmi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/freeipmi` |
| 注册用例数 | 3 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_bmc-watchdog | Test bmc-watchdog.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ipmidetectd | Test ipmidetectd.service restart | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_ipmiseld | Test ipmiseld.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_bmc-watchdog

- 描述：Test bmc-watchdog.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：modprobe×5

#### oe_test_service_ipmidetectd

- 描述：Test ipmidetectd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "ipmidetectd.service restart failed"
  CHECK_RESULT $? 0 0 "ipmidetectd.service restart failed"
  CHECK_RESULT $? 0 0 "ipmidetectd.service start failed"
  CHECK_RESULT $? 0 0 "ipmidetectd.service start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ipmidetectd.service"
```

#### oe_test_service_ipmiseld

- 描述：Test ipmiseld.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：modprobe×5
