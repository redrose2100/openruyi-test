# sulogin

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sulogin` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sulogin | Test case for sulogin command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_sulogin

- 描述：Test case for sulogin command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "sulogin binary not found at expected path /usr/sbin/sulogin"
  CHECK_RESULT $? 0 0 "sulogin -h help option test failed"
  CHECK_RESULT $? 0 0 "sulogin --help option test failed"
  CHECK_RESULT $? 0 0 "sulogin -V version option test failed"
  CHECK_RESULT $? 0 0 "sulogin --version option test failed"
  CHECK_RESULT $? 124 1 "sulogin -t option failed: process hung beyond expected timeout"
  CHECK_RESULT $? 0 0 "sulogin -p login-shell option is invalid"
  CHECK_RESULT $? 0 0 "sulogin --login-shell long option is invalid"
  CHECK_RESULT $? 0 0 "sulogin -e force option is invalid"
  CHECK_RESULT $? 0 0 "sulogin --force long option is invalid"
```

- 涉及命令：sulogin×4
