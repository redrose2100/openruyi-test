# hivex

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hivex` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_hivex_hivexget | Test hivexget, hivexml | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_hivex_hivexregedit | Test hivexregedit | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hivex_hivexsh_01 | Test hivexsh | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hivex_hivexsh_02 | Test hivexsh | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_hivex_hivexget

- 描述：Test hivexget, hivexml
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "hivexget: failed to get hivefile path"
  CHECK_RESULT $? 0 0 "hivexget: failed to get hivefile key-value"
  CHECK_RESULT $? 0 0 "hivexml: failed to convert hivefile to xml"
```

- 涉及命令：hivexml×1

#### oe_test_hivex_hivexregedit

- 描述：Test hivexregedit
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --help"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --export"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --prefix"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --unsafe-printable-strings"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --debug"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --unsafe"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --max-depth"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --merge"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test --merge without regfile"
  CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --encoding"
```

#### oe_test_hivex_hivexsh_01

- 描述：Test hivexsh
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hivexsh: faild to test options -d"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test options -u"
  CHECK_RESULT $? 1 0 "hivexsh: faild to test options -w"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test options -f"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'help'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'quit'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'exit'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'load'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'close'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'unload'"
```

- 涉及命令：hivexsh×1

#### oe_test_hivex_hivexsh_02

- 描述：Test hivexsh
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'ls'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'add'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'cd'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'lsval'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'setval'"
  CHECK_RESULT $? 1 0 "hivexsh: faild to test command 'del'"
  CHECK_RESULT $? 0 0 "hivexsh: faild to test command 'commit'"
```
