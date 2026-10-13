# unbound

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/unbound` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_unbound-anchor | Test unbound-anchor.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_unbound-keygen | Test unbound-keygen.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_unbound | Test unbound.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_unbound-control | test unbound-control | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_unbound-anchor

- 描述：Test unbound-anchor.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_unbound-keygen

- 描述：Test unbound-keygen.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_unbound

- 描述：Test unbound.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} enable failed"
  CHECK_RESULT $? 0 1 "${service} disable failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_unbound-control

- 描述：test unbound-control
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT "$(systemctl is-active unbound.service)" "active" 0 "unbound.service status failed"
  CHECK_RESULT $? 0 0 "checkconf failed"
  CHECK_RESULT $? 0 0 "set up the keys and certificates failed"
  CHECK_RESULT $? 0 0 "enable remote control failed"
  CHECK_RESULT $? 0 0 "restart unbound.service failed"
  CHECK_RESULT $? 0 0 "print statistics without resetting them failed"
  CHECK_RESULT $? 0 0 "dump cache to stdout failed"
  CHECK_RESULT $? 0 0 "flush cache and reload configuration failed"
```

- 涉及命令：sed×1
