# thrift

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/thrift` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_thrift_version | thrift version test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_thrift_generate_cppcode | thrift generate cpp code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_pycode | thrift generate python code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_gocode | thrift generate go code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_javacode | thrift generate java code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_jscode | thrift generate js code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_htmlcode | thrift generate html code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_phpcode | thrift generate php code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_xmlcode | thrift generate xml code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_rbcode | thrift generate ruby code test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_thrift_generate_luacode | thrift generate lua code test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_thrift_version

- 描述：thrift version test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：thrift×1

#### oe_test_thrift_generate_cppcode

- 描述：thrift generate cpp code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_pycode

- 描述：thrift generate python code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_gocode

- 描述：thrift generate go code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_javacode

- 描述：thrift generate java code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_jscode

- 描述：thrift generate js code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_htmlcode

- 描述：thrift generate html code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_phpcode

- 描述：thrift generate php code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_xmlcode

- 描述：thrift generate xml code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_rbcode

- 描述：thrift generate ruby code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```

#### oe_test_thrift_generate_luacode

- 描述：thrift generate lua code test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
```
