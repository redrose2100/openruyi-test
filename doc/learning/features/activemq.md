# activemq

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/activemq` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_activemq_fun_01 | package activemq test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_activemq_jms_connectivity | ActiveMQ JMS(OpenWire) connectivity test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_activemq_fun_01

- 描述：package activemq test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Activemq server startup failed1"
  CHECK_RESULT $? 0 0 "Activemq state is not active"
  CHECK_RESULT $? 0 0 "Failed to listen to port information"
  CHECK_RESULT $? 0 0 "Web page access failed"
```

- 涉及命令：netstat×1

#### oe_test_activemq_jms_connectivity

- 描述：ActiveMQ JMS(OpenWire) connectivity test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ActiveMQ client libraries not found"
  CHECK_RESULT $? 0 0 "ActiveMQConnectionFactory class cannot be found in JAR files"
  CHECK_RESULT $port_accessible 0 0 "OpenWire port 61616 not accessible"
```
