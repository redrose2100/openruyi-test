# mocha

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mocha` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mocha | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_01 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_02 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_03 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_04 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_05 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_06 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_07 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_08 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_mocha_09 | test  mocha | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_mocha

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Running Mocha to execute test failed"
  CHECK_RESULT $? 0 0 "Mocha testing and using the - c option to enable color display failed"
  CHECK_RESULT $? 0 0 "Mocha test and use the - R option to specify report format errors"
```

#### oe_test_mocha_01

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error in running only test cases that match the pattern"
  CHECK_RESULT $? 0 0 "Error running test case containing specified string"
  CHECK_RESULT $? 0 0 "Test file sorting error"
```

#### oe_test_mocha_02

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "-t execution failed"
  CHECK_RESULT $? 0 0 "-i execution failed"
  CHECK_RESULT $? 0 0 "-s execution failed"
```

- 涉及命令：mocha×3

#### oe_test_mocha_03

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "-c execution failed"
  CHECK_RESULT $? 0 0 "-O execution failed"
  CHECK_RESULT $? 0 0 "--growl execution failed"
```

- 涉及命令：mocha×2

#### oe_test_mocha_04

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "-u execution failed"
  CHECK_RESULT $? 0 0 "--check execution failed"
  CHECK_RESULT $? 0 0 "--prof execution failed"
```

#### oe_test_mocha_05

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "-C execution failed"
  CHECK_RESULT $? 0 0 "-G execution failed"
  CHECK_RESULT $? 0 0 "--gc execution failed"
```

- 涉及命令：mocha×3

#### oe_test_mocha_06

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "-S execution failed"
  CHECK_RESULT $? 0 0 "--reporter execution failed"
  CHECK_RESULT $? 0 0 "--interfaces execution failed"
```

- 涉及命令：mocha×2

#### oe_test_mocha_07

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "--sort execution failed"
  CHECK_RESULT $? 0 0 "--bail execution failed"
  CHECK_RESULT $? 0 0 "--slow execution failed"
```

#### oe_test_mocha_08

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "es_staging execution failed"
  CHECK_RESULT $? 0 0 "--harmony execution failed"
  CHECK_RESULT $? 0 0 "--recursive execution failed"
```

#### oe_test_mocha_09

- 描述：test  mocha
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "-b execution failed"
  CHECK_RESULT $? 0 0 "--retries execution failed"
  CHECK_RESULT $? 0 0 "--recyrsive execution failed"
```

- 涉及命令：mocha×1
