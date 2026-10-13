# figlet

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/figlet` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_figlet | package figlet test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_figlet_01 | package figlet test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_figlet_02 | package figlet test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_figlet_03 | package figlet test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_figlet

- 描述：package figlet test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Unable to output detailed information"
  CHECK_RESULT $? 0 0 "Failed to check flf file"
  CHECK_RESULT $? 0 0 "Unable to list figlet fonts and control files"
  CHECK_RESULT $? 0 0 "Unable to display large letters based on original text"
  CHECK_RESULT $? 0 0 "Failed to output information"
```

- 涉及命令：figlet×2

#### oe_test_figlet_01

- 描述：package figlet test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Convert to artistic font and error output terminal"
  CHECK_RESULT $? 0 0 "Replacing with text you want to convert to artistic font failed"
```

- 涉及命令：figlet×1

#### oe_test_figlet_02

- 描述：package figlet test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Convert to artistic font and error output terminal"
  CHECK_RESULT $? 0 0 "Convert to artistic font and error output terminal"
  CHECK_RESULT $? 0 0 "Convert to artistic font and error output terminal"
```

- 涉及命令：figlet×3

#### oe_test_figlet_03

- 描述：package figlet test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Convert to artistic font and error output terminal"
  CHECK_RESULT $? 0 0 "Convert to artistic font and error output terminal"
  CHECK_RESULT $? 0 0 "Convert to artistic font and error output terminal"
```

- 涉及命令：figlet×3
