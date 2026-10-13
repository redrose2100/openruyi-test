# dejagnu

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dejagnu` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dejagnu_runtest_01 | The test of dejagnu package | config_params/pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_dejagnu_runtest_02 | The test of dejagnu package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dejagnu_runtest_03 | The test of dejagnu package | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dejagnu_runtest_01

- 描述：The test of dejagnu package
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed option : -V"
  CHECK_RESULT $? 0 0 "Failed option : --version"
  CHECK_RESULT $? 0 0 "Failed option : --help"
  CHECK_RESULT $? 0 0 "Failed option : --verbose"
  CHECK_RESULT $? 0 0 "Failed option : -v"
  CHECK_RESULT $? 0 0 "Failed option : --debug"
  CHECK_RESULT $? 0 0 "Failed option : --all"
  CHECK_RESULT $? 0 0 "Failed option : -a"
  CHECK_RESULT $? 0 0 "Failed option : --directory"
  CHECK_RESULT $? 0 0 "Failed option : --ignore"
  CHECK_RESULT $? 0 0 "Failed option : --log_dialog"
  CHECK_RESULT $? 0 0 "Failed option : --mail (to one host)"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×3, runtest×2, userdel×1

#### oe_test_dejagnu_runtest_02

- 描述：The test of dejagnu package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option : --objdir"
  CHECK_RESULT $? 0 0 "Failed option : --outdir or --srcdir"
  CHECK_RESULT $? 0 0 "Failed option : --reboot"
  CHECK_RESULT $? 0 0 "Failed option : --strace"
  CHECK_RESULT $? 0 0 "Failed option : --tool"
  CHECK_RESULT $? 0 0 "Failed option : --D"
  CHECK_RESULT $? 0 0 "Failed option : --xml"
  CHECK_RESULT $? 0 0 "Failed option : -x"
  CHECK_RESULT $? 0 0 "Failed option : --script.exp"
  CHECK_RESULT $? 0 0 "Failed option : --target_boards"
```

- 涉及命令：test×4

#### oe_test_dejagnu_runtest_03

- 描述：The test of dejagnu package
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed option : --build"
  CHECK_RESULT $? 0 0 "Failed option : --target"
  CHECK_RESULT $? 0 0 "Failed option : --host"
  CHECK_RESULT $? 0 0 "Failed option : --status"
  CHECK_RESULT $? 0 0 "Failed option : --tool_exec"
  CHECK_RESULT $? 0 0 "Failed option : --tool_opts"
  CHECK_RESULT $? 0 0 "Failed option : --host_board"
```

- 涉及命令：test×2
