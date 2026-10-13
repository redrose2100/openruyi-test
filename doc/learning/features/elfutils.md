# elfutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/elfutils` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_elfutils | elfutils package testing | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_debuginfod | Test debuginfod.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_elfutils

- 描述：elfutils package testing
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "Compilation failed"
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Collapse failure"
  CHECK_RESULT $? 0 0 "Acquisition failed"
```

- 涉及命令：test×2, rpm×1, ulimit×1, coredumpctl×1, eu-addr2line×1

#### oe_test_service_debuginfod

- 描述：Test debuginfod.service restart
- 函数：`pre_test, run_test, post_test`