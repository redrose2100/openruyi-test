# prometheus2_2.20.0

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/prometheus2` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_prometheus | Test prometheus.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_prometheus_cli | Test Prometheus command line | config_params/pre_test/run_test/post_test | 37 | ✔ |  |  |
| oe_test_prometheus_querying_http_api | Test Prometheus querying API | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_prometheus_management_api | Test Prometheus management API | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_prometheus_promtool | Test promtool | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_prometheus_tsdb | Test tsdb | pre_test/run_test/post_test | 17 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_prometheus

- 描述：Test prometheus.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "prometheus.service reload failed"
  CHECK_RESULT $? 0 0 "prometheus.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_prometheus_cli

- 描述：Test Prometheus command line
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（37 条）：

```
  CHECK_RESULT $? 0 0 'Failed to output version info.'
  CHECK_RESULT $? 0 0 'Failed to output version info.'
  CHECK_RESULT $? 0 0 "Failed to use specific config file."
  CHECK_RESULT $? 0 0 'Failed to use flag: --web.listen-address'
  CHECK_RESULT $? 0 0 'Failed to use flag: --web.read-timeout'
  CHECK_RESULT $? 0 0 'Failed to use flag: --web.max-connections'
  CHECK_RESULT $? 0 0 'Failed to use flag: --web.external-url'
  CHECK_RESULT $? 0 0 'Failed to use flag: --web.route-prefix'
  CHECK_RESULT $? 0 0 'Failed to use flag: --web.user-assets'
  CHECK_RESULT "$(pgrep 'prometheus' | wc -l)" 0 0 'Failed to use flag: --web.enable-lifecycle'
  CHECK_RESULT $? 0 0 'Failed to use flag:  --web.enable-admin-api'
  CHECK_RESULT $? 0 0 'Failed to use flag: --web.console.templates'
  ... 共 37 条（其余见源脚本）
```

- 涉及命令：curl×7

#### oe_test_prometheus_querying_http_api

- 描述：Test Prometheus querying API
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use expression queries: instant queries."
  CHECK_RESULT $? 0 0 "Failed to use expression queries: range queries."
  CHECK_RESULT $? 0 0 "Failed querying metadata: finding series by label matchers."
  CHECK_RESULT $? 0 0 "Failed querying metadata: getting label names."
  CHECK_RESULT $? 0 0 "Failed querying metadata: querying label values."
  CHECK_RESULT $? 0 0 "Failed querying targets."
  CHECK_RESULT $? 0 0 "Failed querying rules."
  CHECK_RESULT $? 0 0 "Failed querying alerts."
  CHECK_RESULT $? 0 0 "Failed querying targets metadata."
  CHECK_RESULT $? 0 0 "Failed querying metric metadata."
  CHECK_RESULT $? 0 0 "Failed querying alertmanagers."
  CHECK_RESULT $? 0 0 "Failed querying config."
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：curl×18

#### oe_test_prometheus_management_api

- 描述：Test Prometheus management API
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed use api: health."
  CHECK_RESULT $? 0 0 "Failed use api: readiness."
  CHECK_RESULT $? 0 0 'Failed to use api: reload'
  CHECK_RESULT $? 0 0 'Failed to use api: quit'
```

- 涉及命令：curl×4

#### oe_test_prometheus_promtool

- 描述：Test promtool
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check flag: --version."
  CHECK_RESULT $? 0 0 "Failed to check flag: --help."
  CHECK_RESULT $? 0 0 "Failed to check flag: --help-man."
  CHECK_RESULT $? 0 0 "Failed to check metrics."
  CHECK_RESULT $? 1 0 "Failed to check metrics, type: counter."
  CHECK_RESULT $? 0 0 "Failed to check metrics, type: counter."
  CHECK_RESULT $? 1 0 "Failed to check metrics, type: gauge."
  CHECK_RESULT $? 0 0 "Failed to check metrics, type: gauge."
  CHECK_RESULT $? 1 0 "Failed to check metrics, type: histogram."
  CHECK_RESULT $? 0 0 "Failed to check metrics, type: histogram."
  CHECK_RESULT $? 1 0 "Failed to check metrics, type: summary."
  CHECK_RESULT $? 0 0 "Failed to check metrics, type: summary."
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：curl×1

#### oe_test_prometheus_tsdb

- 描述：Test tsdb
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check flag: --help."
  CHECK_RESULT $? 0 0 "Failed to check flag: --help-long."
  CHECK_RESULT $? 0 0 "Failed to check flag: --help-man."
  CHECK_RESULT $? 0 0 "Failed to use command: help."
  CHECK_RESULT $? 0 0 "Failed to use command: bench write, with flag: --help."
  CHECK_RESULT $? 0 0 "Failed to use command: bench write, with arg: file."
  CHECK_RESULT "$(( ${#files[@]} ))" 5 0 "Failed to use command: bench write, with flag: --out."
  CHECK_RESULT $? 0 0 "Failed to use command: bench write, with flag: --metrics."
  CHECK_RESULT $? 0 0 "Failed to use command: ls, with flag: --help."
  CHECK_RESULT $? 0 0 "Failed to use command: ls."
  CHECK_RESULT $? 0 0 "Failed to use command: ls, with flag: -h."
  CHECK_RESULT $? 0 0 "Failed to use command: ls, with arg: db path."
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：shopt×1
