# ipmitool

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ipmitool` |
| 注册用例数 | 4 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_bmc-snmp-proxy | Test bmc-snmp-proxy.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_exchange-bmc-os-info | Test exchange-bmc-os-info.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ipmievd | Test ipmievd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_ipmitool_ipmitool | verification ipmitool command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_bmc-snmp-proxy

- 描述：Test bmc-snmp-proxy.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：modprobe×5, sed×1

#### oe_test_service_exchange-bmc-os-info

- 描述：Test exchange-bmc-os-info.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：modprobe×5, sed×1

#### oe_test_service_ipmievd

- 描述：Test ipmievd.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：modprobe×5

#### oe_test_ipmitool_ipmitool

- 描述：verification ipmitool command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "ipmitool -help failed"
  CHECK_RESULT $? 0 0 "sel elist failed"
  CHECK_RESULT $? 0 0 "sel clear failed"
  CHECK_RESULT $? 0 0 "sel time get failed"
  CHECK_RESULT $? 0 0 "sensor list"
  CHECK_RESULT $? 0 0 "mc info failed"
```

- 涉及命令：modprobe×5
