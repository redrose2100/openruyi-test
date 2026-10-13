# conntrack-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/conntrack-tools` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_conntrackd | Test conntrackd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_conntrack_basic_commands | Test conntrack basic commands functionality | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_conntrack_events | Test conntrack events functionality | pre_test/generate_network_activity/wait_for_events/verify_conntrack_output/run_test/post_test | 14 | ✔ |  |  |
| oe_test_conntrack_parameters | Test conntrack command parameters and options | pre_test/run_test/post_test | 17 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_conntrackd

- 描述：Test conntrackd.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×4

#### oe_test_conntrack_basic_commands

- 描述：Test conntrack basic commands functionality
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list conntrack table"
  CHECK_RESULT $? 0 0 "Conntrack list output format incorrect"
  CHECK_RESULT $? 0 0 "Failed to show conntrack statistics"
  CHECK_RESULT $? 0 0 "Statistics output format incorrect"
  CHECK_RESULT $? 0 0 "Failed to list dying table"
  CHECK_RESULT $? 0 0 "Failed to show conntrack counters"
  CHECK_RESULT $? 0 0 "Counter output is not numeric"
  CHECK_RESULT $? 0 0 "Failed to list with XML output format"
  CHECK_RESULT $? 0 0 "XML output format incorrect"
```

- 涉及命令：ping×1, conntrack×1

#### oe_test_conntrack_events

- 描述：Test conntrack events functionality
- 函数：`pre_test, generate_network_activity, wait_for_events, verify_conntrack_output, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT 1 0 1 "Conntrack events process should be running"
  CHECK_RESULT $? 0 0 "Conntrack default events test failed"
  CHECK_RESULT 1 0 1 "Conntrack NEW mask process should be running"
  CHECK_RESULT $? 0 0 "Conntrack NEW mask events test failed"
  CHECK_RESULT 1 0 1 "Conntrack DESTROY mask process should be running"
  CHECK_RESULT $? 0 0 "Conntrack DESTROY mask events test failed"
  CHECK_RESULT 1 0 1 "Conntrack multiple masks process should be running"
  CHECK_RESULT $? 0 0 "Conntrack multiple masks events test failed"
  CHECK_RESULT 1 0 1 "Conntrack XML output process should be running"
  CHECK_RESULT 0 0 0 "Conntrack XML output test passed"
  CHECK_RESULT 1 0 1 "Conntrack XML output format is incorrect"
  CHECK_RESULT 0 0 0 "Conntrack XML command syntax is correct"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：ping×3, conntrack×1

#### oe_test_conntrack_parameters

- 描述：Test conntrack command parameters and options
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $RET 0 0 "Failed to list with protocol filter"
  CHECK_RESULT 1 0 0 "Protocol filter test failed: empty output is not acceptable"
  CHECK_RESULT 1 0 0 "Protocol filter test failed: permission denied"
  CHECK_RESULT 1 0 0 "Conntrack command failed with unexpected error"
  CHECK_RESULT $? 0 0 "Output does not contain expected protocol tcp"
  CHECK_RESULT 1 0 0 "Protocol filter test failed: output does not contain connection entries"
  CHECK_RESULT $RET 0 0 "Failed to list with family filter"
  CHECK_RESULT 1 0 0 "Family filter test failed: empty output is not acceptable"
  CHECK_RESULT 1 0 0 "Family filter test failed: permission denied"
  CHECK_RESULT 1 0 0 "Conntrack command failed with unexpected error"
  CHECK_RESULT $? 0 0 "Output does not contain expected IPv4 address format"
  CHECK_RESULT 1 0 0 "Family filter test failed: output does not contain connection entries"
  ... 共 17 条（其余见源脚本）
```
