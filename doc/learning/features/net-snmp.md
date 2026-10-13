# net-snmp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/net-snmp` |
| 注册用例数 | 4 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_snmpd | Test snmpd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_snmptrapd | Test snmptrapd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_net-snmp_01 | Test net-snmp function | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_net-snmp_02 | Test net-snmp function of checking the MIB objects by remote client | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_service_snmpd

- 描述：Test snmpd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "snmpd.service reload failed"
  CHECK_RESULT $? 0 0 "snmpd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_snmptrapd

- 描述：Test snmptrapd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "snmptrapd.service reload failed"
  CHECK_RESULT $? 0 0 "snmptrapd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_net-snmp_01

- 描述：Test net-snmp function
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "snmpd.conf file not exist"
  CHECK_RESULT $? 0 0 "snmpd.service restart fail"
  CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v2c"
  CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v1"
  CHECK_RESULT $? 0 0 "Get hostname fail"
  CHECK_RESULT $? 0 0 "Check SNMPv2-MIB::sysName.0 information fail"
  CHECK_RESULT $? 0 0 "Get SNMPv2-MIB::sysName fail"
```

- 涉及命令：snmpwalk×3, snmpget×1, snmptranslate×1

#### oe_test_net-snmp_02

- 描述：Test net-snmp function of checking the MIB objects by remote client
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "snmpd.conf file not exist"
  CHECK_RESULT $? 0 0 "snmpd.service restart fail"
  CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v2c"
  CHECK_RESULT $? 0 0 "Check the MIB objects information fail by v1"
```
