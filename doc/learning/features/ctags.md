# ctags

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ctags` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ctags | ctags functional testing | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ctags2 | ctags additional functional testing | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ctags3 | ctags advanced functional testing | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_ctags4 | ctags advanced functional testing | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ctags

- 描述：ctags functional testing
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Ctags failed to recognize language"
  CHECK_RESULT $? 0 0 "Failed to view default extension language"
  CHECK_RESULT $? 0 0 "Ctags failed to recognize Python language"
  CHECK_RESULT $? 0 0 "Failed to view recognizable Python syntax elements"
```

#### oe_test_ctags2

- 描述：ctags additional functional testing
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to generate tags for C code"
  CHECK_RESULT $? 0 0 "Tags file not created"
  CHECK_RESULT $? 0 0 "Tags file does not contain expected symbols"
  CHECK_RESULT $? 0 0 "Failed to generate tags for Python code"
  CHECK_RESULT $? 0 0 "Tags file not created for Python"
  CHECK_RESULT $? 0 0 "Tags file does not contain expected Python symbols"
```

- 涉及命令：test×2, grep×2

#### oe_test_ctags3

- 描述：ctags advanced functional testing
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to generate tags with exclude option"
  CHECK_RESULT $? 0 0 "Tags file not created"
  CHECK_RESULT $? 0 0 "Tags file should contain included function"
  CHECK_RESULT $? 0 0 "Tags file should contain included function"
  CHECK_RESULT $? 1 0 "Tags file should not contain excluded function"
  CHECK_RESULT $? 0 0 "Failed to generate tags with kind filter"
  CHECK_RESULT $? 0 0 "Tags file not created"
  CHECK_RESULT $? 0 0 "Tags file should contain function"
  CHECK_RESULT $? 1 0 "Tags file should not contain macro when filtering"
  CHECK_RESULT $? 1 0 "Tags file should not contain variable when filtering"
```

- 涉及命令：grep×6, test×2, mkdir×1, ctags×1

#### oe_test_ctags4

- 描述：ctags advanced functional testing
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed to generate initial tags"
  CHECK_RESULT $? 0 0 "Initial tags should contain function1"
  CHECK_RESULT $? 0 0 "Failed to append tags"
  CHECK_RESULT $? 0 0 "Tags file should still contain function1 after append"
  CHECK_RESULT $? 0 0 "Tags file should contain function2 after append"
  CHECK_RESULT $? 0 0 "Failed to output tags to stdout"
  CHECK_RESULT $? 0 0 "Default tags file should not be created when using stdout"
  CHECK_RESULT $? 0 0 "Stdout tags file should be created"
  CHECK_RESULT $? 0 0 "Stdout tags should contain function"
  CHECK_RESULT $? 0 0 "Failed to generate sorted tags"
  CHECK_RESULT $? 0 0 "Tags file not created"
  CHECK_RESULT $? 0 0 "Tags should be sorted alphabetically"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：grep×4, ctags×2, test×2
