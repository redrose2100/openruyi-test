# graphviz

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/graphviz` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_graphviz | graphviz function verification | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_graphviz01 | graphviz function verification | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_circo | circo command test, for generating graphs | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_graphviz

- 描述：graphviz function verification
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0  "check first.dot is fail"
  CHECK_RESULT $? 0 0 "check first.png is fail"
```

- 涉及命令：test×2, dot×1

#### oe_test_graphviz01

- 描述：graphviz function verification
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0  "check first.dot is fail"
  CHECK_RESULT $? 0 0 "Failed to convert DOT to PDF"
  CHECK_RESULT $? 0 0 "PDF file not created"
  CHECK_RESULT $? 0 0 "Failed to convert DOT to SVG"
  CHECK_RESULT $? 0 0 "SVG file not created"
  CHECK_RESULT $? 0 0 "Failed to use neato layout engine"
  CHECK_RESULT $? 0 0 "neato layout image not created"
  CHECK_RESULT $? 0 0 "Failed to create complex graph"
  CHECK_RESULT $? 0 0 "Complex graph image not created"
  CHECK_RESULT $? 0 0 "Failed to get graphviz version info"
```

- 涉及命令：test×5, dot×4, neato×1

#### oe_test_circo

- 描述：circo command test, for generating graphs
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "circo command not found"
  CHECK_RESULT $? 0 0 "circo version check failed"
  CHECK_RESULT $? 0 0 "circo PNG generation failed"
  CHECK_RESULT $? 0 0 "circo PNG output file not created"
  CHECK_RESULT $? 0 0 "circo SVG generation failed"
  CHECK_RESULT $? 0 0 "circo SVG output file not created"
  CHECK_RESULT $? 0 0 "circo PDF generation failed"
  CHECK_RESULT $? 0 0 "circo PDF output file not created"
  CHECK_RESULT $? 0 0 "circo with random start failed"
  CHECK_RESULT $? 0 0 "circo random output file not created"
  CHECK_RESULT $? 0 0 "circo help not working"
```

- 涉及命令：circo×5, test×4
