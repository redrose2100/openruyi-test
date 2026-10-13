# systemtap

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/systemtap` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_stap-exporter | Test stap-exporter.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_stap-server | Test stap-server.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemtap | Test systemtap.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_stap-exporter

- 描述：Test stap-exporter.service restart
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

#### oe_test_service_stap-server

- 描述：Test stap-server.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemtap

- 描述：Test systemtap.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "systemtap.service reload failed"
  CHECK_RESULT $? 0 0 "systemtap.service reload causes the service status to change"
```

- 涉及命令：sed×2
