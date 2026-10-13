# sysstat

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sysstat` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_sysstat-collect | Test sysstat-collect.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_sysstat | Test sysstat.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_sysstat-summary | Test sysstat-summary.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_sysstat_iostat | package sysstat_iostat test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_sysstat-rotate | Test sysstat-rotate.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_sysstat-collect

- 描述：Test sysstat-collect.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_sysstat

- 描述：Test sysstat.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_sysstat-summary

- 描述：Test sysstat-summary.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_sysstat_iostat

- 描述：package sysstat_iostat test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "iostat Display statistics of error CPU and disk"
  CHECK_RESULT $? 0 0 "iostat  -c Do not display cpu statistics"
  CHECK_RESULT $? 0 0 "iostat -d  Do not display disk statistics"
  CHECK_RESULT $? 0 0 "iostat -k Does not display the number of disk requests per second in K, the default unit is block"
  CHECK_RESULT $? 0 1 "iostat --help Display iostat command error help information"
```

- 涉及命令：iostat×3

#### oe_test_service_sysstat-rotate

- 描述：Test sysstat-rotate.service restart
- 函数：`pre_test, run_test, post_test`