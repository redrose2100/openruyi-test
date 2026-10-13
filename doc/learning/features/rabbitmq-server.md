# rabbitmq-server

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rabbitmq-server` |
| 注册用例数 | 12 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rabbitmqctl_access | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rabbitmqctl_app | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rabbitmqctl_cluster | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 11 | ✔ | ✔ |  |
| oe_test_rabbitmqctl_encode | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rabbitmqctl_parameter | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_rabbitmqctl_policy | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_rabbitmqctl_status | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rabbitmqctl_user | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_rabbitmq-plugins_list | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_rabbitmq-plugins | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_rabbitmq-server | Testing rabbitmq-server command parameters | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_rabbitmq-server | Test rabbitmq-server.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rabbitmqctl_access

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：grep×2

#### oe_test_rabbitmqctl_app

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_rabbitmqctl_cluster

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×4, rabbitmqctl×3, kill×2

#### oe_test_rabbitmqctl_encode

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_rabbitmqctl_parameter

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
```

#### oe_test_rabbitmqctl_policy

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_rabbitmqctl_status

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_rabbitmqctl_user

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_rabbitmq-plugins_list

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_rabbitmq-plugins

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：command×2, kill×1

#### oe_test_rabbitmq-server

- 描述：Testing rabbitmq-server command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
```

- 涉及命令：rabbitmq-server×1, kill×1

#### oe_test_service_rabbitmq-server

- 描述：Test rabbitmq-server.service restart
- 函数：`pre_test, run_test, post_test`