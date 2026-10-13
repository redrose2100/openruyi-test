# jq

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jq` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jq | verify the uasge of jq command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_jq_errorjson | Handle malformed JSON | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_jq_inputline_4095 | Print lines with a length of 4095 multiples | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_jq_inputline_file | Print file line number | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_jq_teshu | Read and output more than 2048 special characters | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_jq_try_cache | Make | =, try cache during capture | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_jq

- 描述：verify the uasge of jq command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_jq_errorjson

- 描述：Handle malformed JSON
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

#### oe_test_jq_inputline_4095

- 描述：Print lines with a length of 4095 multiples
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：python3×2

#### oe_test_jq_inputline_file

- 描述：Print file line number
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_jq_teshu

- 描述：Read and output more than 2048 special characters
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_jq_try_cache

- 描述：Make | =, try cache during capture
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```
