# ltrace

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ltrace` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ltrace_01 | the test of ltrace package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_ltrace_02 | the test of ltrace package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_ltrace_03 | the test of ltrace package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_ltrace_04 | the test of ltrace package | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ltrace_01

- 描述：the test of ltrace package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -h"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --help"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -V"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --version"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -T"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -S"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -D"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --debug"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -Dh"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --debug=help"
```

- 涉及命令：ltrace×6, gcc×1

#### oe_test_ltrace_02

- 描述：the test of ltrace package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -i"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -x"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -e"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -l"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --library"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -r"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -f"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -t"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -tt"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -ttt"
```

- 涉及命令：ltrace×9, gcc×1

#### oe_test_ltrace_03

- 描述：the test of ltrace package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -p"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -u"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -b"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --no-signals"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -n"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --indent"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -F"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --config"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -L"
```

- 涉及命令：ltrace×7, gcc×1, userdel×1

#### oe_test_ltrace_04

- 描述：the test of ltrace package
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -a"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --align"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -o"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --output"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -w"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace --where"
  CHECK_RESULT $? 0 0 "Failed to run command: ltrace -s"
```

- 涉及命令：ltrace×4, test×2, gcc×1
