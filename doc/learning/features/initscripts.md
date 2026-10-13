# initscripts

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/initscripts` |
| 注册用例数 | 5 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_import-state | Test import-state.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_loadmodules | Test loadmodules.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_network | Test network.service restart | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_service_netconsole | Test netconsole.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_readonly-root | Test readonly-root.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_import-state

- 描述：Test import-state.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×1

#### oe_test_service_loadmodules

- 描述：Test loadmodules.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_network

- 描述：Test network.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
```

#### oe_test_service_netconsole

- 描述：Test netconsole.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_readonly-root

- 描述：Test readonly-root.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit readonly-root.service"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```
