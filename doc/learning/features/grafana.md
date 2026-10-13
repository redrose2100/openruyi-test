# grafana

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/grafana` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_grafana-server | Test grafana-server.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_grafana01 | Test grafana-server.service restart | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_grafana-server

- 描述：Test grafana-server.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_grafana01

- 描述：Test grafana-server.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Start grafana-server service failed"
  CHECK_RESULT $? 0 0 "Check grafana-server service status failed"
  CHECK_RESULT $? 0 0 "Check grafana-server port listening failed"
  CHECK_RESULT $? 0 0 "Check grafana install directory failed"
  CHECK_RESULT $? 0 0 "Check grafana configuration file failed"
```
