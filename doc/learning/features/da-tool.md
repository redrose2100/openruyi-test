# da-tool

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/da-tool` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_da-tool_01 | da-tool.sh -h test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_02 | da-tool.sh default test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_03 | da-tool.sh -t boundary normal value test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_04 | da-tool.sh -t boundary normal value test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_05 | da-tool.sh invalid option test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_06 | da-tool.sh illegal parameter test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_07 | da-tool.sh -t invalid value test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_08 | da-tool.sh -t invalid option test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_09 | da-tool.sh -t illegal boundary value test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_10 | da-tool.sh -t illegal boundary value test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_11 | da-tool.sh -t extra large value test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_da-tool_12 | da-tool.sh -t invalid value test | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_da-tool_01

- 描述：da-tool.sh -h test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -h failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_02

- 描述：da-tool.sh default test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check default failed"
```

- 涉及命令：grep×1

#### oe_test_da-tool_03

- 描述：da-tool.sh -t boundary normal value test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -t boundary normal value failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_04

- 描述：da-tool.sh -t boundary normal value test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -t boundary normal value failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_05

- 描述：da-tool.sh invalid option test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check invalid option failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_06

- 描述：da-tool.sh illegal parameter test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check illegal parameter failed"
```

#### oe_test_da-tool_07

- 描述：da-tool.sh -t invalid value test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -t invalid value failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_08

- 描述：da-tool.sh -t invalid option test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -t invalid option failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_09

- 描述：da-tool.sh -t illegal boundary value test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -t illegal boundary value failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_10

- 描述：da-tool.sh -t illegal boundary value test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -t illegal boundary value failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_11

- 描述：da-tool.sh -t extra large value test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check -t extra large value failed"
```

- 涉及命令：da-tool.sh×1

#### oe_test_da-tool_12

- 描述：da-tool.sh -t invalid value test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check -t invalid value failed"
  CHECK_RESULT $? 0 0 "Check -t invalid value failed"
  CHECK_RESULT $? 0 0 "Check -t invalid value failed"
  CHECK_RESULT $? 0 0 "Check -t invalid value failed"
```

- 涉及命令：da-tool.sh×4
