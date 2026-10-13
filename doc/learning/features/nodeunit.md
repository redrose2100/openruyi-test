# nodeunit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nodeunit` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nodeunit | test nodeunit | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_nodeunit_01 | test nodeunit | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nodeunit

- 描述：test nodeunit
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Running nodeunit  to execute test failed"
  CHECK_RESULT $? 0 0 "NodeUnit lists available built-in report generator errors"
  CHECK_RESULT $? 0 0 "NodeUnit listing version information error"
  CHECK_RESULT $? 0 0 "NodeUnit listing help information error"
  CHECK_RESULT $? 0 0 "NodeUnit listing -t error"
  CHECK_RESULT $? 0 0 "NodeUnit listing -t failed"
```

- 涉及命令：nodeunit×2

#### oe_test_nodeunit_01

- 描述：test nodeunit
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Running nodeunit  to execute test failed"
  CHECK_RESULT $? 0 0 "Running nodeunit  to execute test failed"
  CHECK_RESULT $? 0 0 "NodeUnit List available built-in report generators with errors"
```

- 涉及命令：nodeunit×1
