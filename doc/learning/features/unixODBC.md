# unixODBC

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/unixODBC` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_unixODBC | test  unixODBC | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_unixODBC

- 描述：test  unixODBC
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to obtain help command"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  CHECK_RESULT $? 0 0 "Error printing prefix path for libogdi"
  CHECK_RESULT $? 0 0 "Error printing directory path containing library files"
  CHECK_RESULT $? 0 0 "Error printing preprocessor flags, I_opts, and compiler options"
  CHECK_RESULT $? 0 0 "odbcinst tool validation failed"
  CHECK_RESULT $? 0 0 "Mariadb driver not found"
  CHECK_RESULT $? 0 0 "mariadb odbc driver not detected"
```

- 涉及命令：odbcinst×3
