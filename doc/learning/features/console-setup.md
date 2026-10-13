# console-setup

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/console-setup` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_console-setup_ckbcomp_01 | the test of ckbcomp package | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_console-setup_ckbcomp_02 | the test of ckbcomp package | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_console-setup_setupcon_01 | the test of setupcon package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_console-setup_setupcon_02 | the test of setupcon package | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_console-setup_ckbcomp_01

- 描述：the test of ckbcomp package
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check ckbcomp: -? failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -help failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -charmap failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -I failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -keycodes failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -symbols failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -rules failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -model failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -layout failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -variant failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -option failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -v failed"
```

- 涉及命令：ckbcomp×10

#### oe_test_console-setup_ckbcomp_02

- 描述：the test of ckbcomp package
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check ckbcomp: -compact failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -freebsd failed"
  CHECK_RESULT $? 0 0 "Check ckbcomp: -backspace failed"
```

- 涉及命令：ckbcomp×3

#### oe_test_console-setup_setupcon_01

- 描述：the test of setupcon package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check setupcon:  -v failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  --verbose failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  -k failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  --keyboard-only failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  -f failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  --font-only failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  -t failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  --terminal-only failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  --current-tty failed"
  CHECK_RESULT $? 0 0 "Check setupcon:  --force failed"
```

- 涉及命令：setupcon×4

#### oe_test_console-setup_setupcon_02

- 描述：the test of setupcon package
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check option:  --print-commands-only failed"
  CHECK_RESULT $? 0 0 "Check option:  --save-keyboard failed"
  CHECK_RESULT $? 0 0 "Check setupcon --setup-dir failed"
  CHECK_RESULT $? 0 0 "Check option:  -h failed"
  CHECK_RESULT $? 0 0 "Check option:  --help failed"
```

- 涉及命令：setupcon×1
