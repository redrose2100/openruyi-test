# hsqldb

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hsqldb` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_hsqldb | Test hsqldb.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_hsqldb01 | Test hsqldb | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_hsqldb

- 描述：Test hsqldb.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_hsqldb01

- 描述：Test hsqldb
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "HSQLDB service is not active"
  CHECK_RESULT $? 0 0 "HSQLDB command line tool is not working"
  CHECK_RESULT $? 0 0 "HSQLDB JAR file not found"
  CHECK_RESULT $? 0 0 "HSQLDB version parameter failed"
  CHECK_RESULT $? 0 0 "HSQLDB --silent parameter failed"
  CHECK_RESULT $? 0 0 "HSQLDB --port parameter failed"
```

- 涉及命令：java×4
