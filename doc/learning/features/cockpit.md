# cockpit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cockpit` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_cockpit-motd | Test cockpit-motd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_cockpit | Test cockpit.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_socket_cockpit | Test cockpit.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_cockpit-wsinstance-http | Test cockpit-wsinstance-http.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_cockpit-session | Test cockpit-session.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_cockpit-wsinstance-https-factory | Test cockpit-wsinstance-https-factory.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_cockpit-wsinstance-http | Test cockpit-wsinstance-http.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_cockpit | Test cockpit | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_cockpit-motd

- 描述：Test cockpit-motd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_cockpit

- 描述：Test cockpit.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of cockpit.service "
```

#### oe_test_socket_cockpit

- 描述：Test cockpit.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_service_cockpit-wsinstance-http

- 描述：Test cockpit-wsinstance-http.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_cockpit-session

- 描述：Test cockpit-session.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_cockpit-wsinstance-https-factory

- 描述：Test cockpit-wsinstance-https-factory.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_cockpit-wsinstance-http

- 描述：Test cockpit-wsinstance-http.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_cockpit

- 描述：Test cockpit
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to stop cockpit service"
  CHECK_RESULT $? 0 0 "Failed to stop cockpit service"
  CHECK_RESULT $? 0 0 "Failed to start cockpit service"
  CHECK_RESULT $? 0 0 "Failed to start cockpit service"
  CHECK_RESULT $? 0 0 "Failed to restart cockpit service"
  CHECK_RESULT $? 0 0 "Failed to restart cockpit service"
  CHECK_RESULT $? 0 0 "Failed to disbale cockpit service"
  CHECK_RESULT $? 0 0 "Cockpit service function failed"
```
