# dnssec-trigger

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dnssec-trigger` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_dnssec-triggerd-keygen | Test dnssec-triggerd-keygen.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_dnssec-triggerd | Test dnssec-triggerd.service restart | config_params/pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_dnssec-triggerd | Test dnssec-trigger-control command | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_dnssec-trigger-control-setup | Test dnssec-trigger-control-setup command | config_params/pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dnssec-trigger-control_01 | Test dnssec-trigger-control command | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dnssec-trigger-control_02 | Test dnssec-trigger-control command | config_params/pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dnssec-trigger-control_03 | Test dnssec-trigger-control command | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_dnssec-trigger-control_04 | Test dnssec-trigger-control command | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_dnssec-triggerd-keygen

- 描述：Test dnssec-triggerd-keygen.service restart
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

#### oe_test_service_dnssec-triggerd

- 描述：Test dnssec-triggerd.service restart
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of dnssec-triggerd.service"
```

- 涉及命令：sed×1

#### oe_test_dnssec-triggerd

- 描述：Test dnssec-trigger-control command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -h"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -v"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -v process"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -d"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -d process"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -c "
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -c process"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -u"
```

- 涉及命令：pgrep×6, dnssec-triggerd×5

#### oe_test_dnssec-trigger-control-setup

- 描述：Test dnssec-trigger-control-setup command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -u"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -u'log"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -i"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -i'log"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -s"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -s'log"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -d"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger-control-setup -d'log"
```

- 涉及命令：dnssec-trigger-control-setup×5, test×1

#### oe_test_dnssec-trigger-control_01

- 描述：Test dnssec-trigger-control command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the -h"
  CHECK_RESULT $? 0 0 "Failed to check the start"
  CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger status"
  CHECK_RESULT $? 0 0 "Failed to check the results"
  CHECK_RESULT $? 0 0 "Failed to check the stop"
  CHECK_RESULT $? 1 0 "Failed to check the stop dnssec-trigger-control process"
  CHECK_RESULT $? 0 0 "Failed to check the cmdtray"
```

- 涉及命令：pgrep×4, dnssec-trigger-control×1

#### oe_test_dnssec-trigger-control_02

- 描述：Test dnssec-trigger-control command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the results"
  CHECK_RESULT $? 0 0 "Failed to check the results'process"
  CHECK_RESULT $? 0 0 "Failed to check the stoppanel"
  CHECK_RESULT $? 1 0 "Failed to check the stop dnssec-trigger-control process"
  CHECK_RESULT $? 0 0 "Failed to check the status"
  CHECK_RESULT $? 0 0 "Failed to check the status process"
```

- 涉及命令：pgrep×3

#### oe_test_dnssec-trigger-control_03

- 描述：Test dnssec-trigger-control command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the test_ssl"
  CHECK_RESULT $? 0 0 "Failed to check the test_ssl'log"
  CHECK_RESULT $? 0 0 "Failed to check the test_tcp"
  CHECK_RESULT $? 0 0 "Failed to check the test_tcp'log"
  CHECK_RESULT $? 0 0 "Failed to check the test_http"
  CHECK_RESULT $? 0 0 "Failed to check the test_http'log"
  CHECK_RESULT $? 0 0 "Failed to check the submit status"
  CHECK_RESULT $? 0 0 "Failed to check the submit status'log"
```

#### oe_test_dnssec-trigger-control_04

- 描述：Test dnssec-trigger-control command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the unsafe"
  CHECK_RESULT $? 0 0 "Failed to check the unsafe'log"
  CHECK_RESULT $? 0 0 "Failed to check the hotspot_signon"
  CHECK_RESULT $? 0 0 "Failed to check the hotspot_signon'log"
  CHECK_RESULT $? 0 0 "Failed to check the skip_http"
  CHECK_RESULT $? 0 0 "Failed to check the reprobe"
  CHECK_RESULT $? 0 0 "Failed to check the test_tcp -s"
  CHECK_RESULT $? 0 0 "Failed to check the test_tcp -c"
```
