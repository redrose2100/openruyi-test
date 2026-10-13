# libreport

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libreport/` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libreport_satyr | Verify libreport package installation and satyr basic functions | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libreport_satyr

- 描述：Verify libreport package installation and satyr basic functions
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "libreport package not installed"
  CHECK_RESULT $? 0 0 "libreport package verification failed"
  CHECK_RESULT $? 0 0 "Failed to get libreport version"
  CHECK_RESULT $? 0 0 "satyr binary missing"
  CHECK_RESULT $? 0 0 "Failed to show satyr help"
  CHECK_RESULT $? 0 0 "Failed to show satyr version"
  CHECK_RESULT $? 0 0 "Failed to test abrt-print-report-from-dir"
  CHECK_RESULT $? 0 0 "Failed to test abrt-create-core-stacktrace"
  CHECK_RESULT $? 0 0 "core_backtrace not generated"
  CHECK_RESULT $? 0 0 "Failed to test debug normalize"
  CHECK_RESULT $? 0 0 "Failed to test debug duphash"
```

- 涉及命令：rpm×3, test×2, mkdir×1
