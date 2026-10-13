# utshell

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/utshell` |
| 注册用例数 | 81 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_utshell_test | utshell-test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_test_01 | Test using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_type_01 | utshell-type | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_type_02 | utshell-test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_type_03 | utshell-test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_readarray_01 | readarray using the utshell test command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_test_02 | utshell-test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_readarray_02 | readarray using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_typeset | test utshell typeset direction. | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_exit_01 | Exit using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_test_03 | utshell-test-p | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_filetest | utshell-test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_source_01 | Exit using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_hash | utshell-test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_compgen_01 | compgen using the utshell test command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_utshell_set | utshell-test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_while_01 | while using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_unset | utshell-test | pre_test/run_test/show_result/show_result/post_test | 6 | ✔ |  |  |
| oe_test_utshell_while | utshell-test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_until | until using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_umask | umask using the utshell test command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_utshell_false | utshell-test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_if | If using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_alias | alias using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_unalias | unalias using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_test_04 | test utshell unset | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_utshell_test_05 | utshell-test-p | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_test_06 | utshell-test-g | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_test_07 | utshell-test-ef | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_test_08 | utshell-test-r | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_test_09 | utshell-test-r | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_test_10 | utshell-test-r | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_test_11 | utshell-test-r | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_test_12 | utshell-test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_let_01 | let using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_let_02 | let using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_export_01 | test utshell export | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_return | Return using the utshell test command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_utshell_compgen_02 | compgen using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_ulimit_01 | test utshell export | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_utshell_case | case using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_compgen_03 | compgen using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_ulimit_02 | test utshell ulimit | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_bind_01 | bind using the utshell test command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_readonly | readonly using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_select | select using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_cd_01 | cd using the utshell test command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_mapfile_01 | mapfile using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_mapfile_02 | mapfile using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_mapfile_03 | mapfile using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_shopt | eval using the utshell test command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_enable | enable using the utshell test command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_utshell_for | for using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_cd_02 | cd-L ;cd -P cd -e using the utshell test command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_utshell_true | utshell-true | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_trap_001 | utshell trap test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_shift | Exit using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_continue | continue using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_caller_001 | utshell caller test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_printf | printf using the utshell test command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_caller_002 | utshell caller_002 test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_pwd | pwd using the utshell test command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_local | local using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_ps_001 | utshell ps_001 test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_ps_002 | utshell ps_002 test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_utshell_getopts | If using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_getopts_02 | getopts using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_ps_003 | utshell ps_003 test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_eval | eval using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_times | times using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_command | eval using the utshell test command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_utshell_kill | eval using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_function | function using the utshell test command | pre_test/run_test/test/post_test | 5 | ✔ |  |  |
| oe_test_utshell_jobs_x | jobs -x using the utshell test command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utshell_dirs | dirs using the utshell test command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_utshell_time | utshell-time | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_pushd | pushd using the utshell test command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_utshell_popd | popd using the utshell test command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_utshell_builtin | builtin using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_ps_004 | utshell ps_004 test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_utshell_disown | disown using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_utshell_test

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "eq fail"
  CHECK_RESULT $? 0 0 "ne fail"
  CHECK_RESULT $? 0 0 "lt fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_test_01

- 描述：Test using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Not using the utshell environment"
  CHECK_RESULT $? 0 0 "Test help view failed"
  CHECK_RESULT $? 0 1 "File exists "
  CHECK_RESULT $? 0 0 "Not a character file"
```

- 涉及命令：useradd×1, userdel×1

#### oe_test_utshell_type_01

- 描述：utshell-type
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "-a fail"
  CHECK_RESULT $? 0 0 "-f fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_type_02

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "-p fail"
  CHECK_RESULT $? 0 0 "-p date fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_type_03

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "-p date fail"
  CHECK_RESULT $? 0 0 "--help fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_readarray_01

- 描述：readarray using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Not using the utshell environment"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "Incorrect array reading"
  CHECK_RESULT $? 0 0 "Failed to display the last 16 letters"
  CHECK_RESULT $? 0 0 "Failed to display the first 6 letters"
```

- 涉及命令：useradd×1, test×1, userdel×1

#### oe_test_utshell_test_02

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "le fail"
  CHECK_RESULT $? 0 1 "gt fail"
  CHECK_RESULT $? 0 1 "ge fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_readarray_02

- 描述：readarray using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Not using the utshell environment"
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Execution failed"
```

- 涉及命令：useradd×1, userdel×1

#### oe_test_utshell_typeset

- 描述：test utshell typeset direction.
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "typeset failed."
  CHECK_RESULT $? 0 1 "typeset -p unknown string success unexpectedly."
  CHECK_RESULT $? 0 0 "typeset -p failed."
  CHECK_RESULT $? 0 0 "typeset -n failed."
  CHECK_RESULT $? 0 0 "typeset -t failed."
```

- 涉及命令：utshell×5

#### oe_test_utshell_exit_01

- 描述：Exit using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "exit --help fail"
  CHECK_RESULT $? 0 0 "touch fail"
  CHECK_RESULT $? 8 0 "utshell test.sh fail"
  CHECK_RESULT $? 0 0 "echo fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_test_03

- 描述：utshell-test-p
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "test1 fail"
  CHECK_RESULT $? 0 0 "ne fail"
  CHECK_RESULT $? 0 0 "1.txt fail"
  CHECK_RESULT $? 0 1 "test 1.txt fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_filetest

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "utshell --help fail"
  CHECK_RESULT "Hello world!" "Hello world!" 0 "execute shell file fail in utshell"
```

#### oe_test_utshell_source_01

- 描述：Exit using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "source --help fail"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  CHECK_RESULT $? 0 0 "source test.sh fail"
  CHECK_RESULT $? 0 0 "echo $KKK fail"
```

- 涉及命令：utshell×5

#### oe_test_utshell_hash

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "hash -p /bin/ls test fail"
  CHECK_RESULT $? 0 0 "hash -p /bin/cat test fail"
  CHECK_RESULT $? 0 0 "hash -l test fail"
  CHECK_RESULT $? 0 0 "hash -l test fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_compgen_01

- 描述：compgen using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "View Help Failed"
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Failed to view alias"
  CHECK_RESULT $? 0 0 "View plugin failed"
  CHECK_RESULT $? 0 0 "View all function failed"
  CHECK_RESULT $? 0 0 "Command execution failed"
```

- 涉及命令：useradd×1, userdel×1

#### oe_test_utshell_set

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "set --help fail"
  CHECK_RESULT $? 0 0 "set -a h fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_while_01

- 描述：while using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "help while fail"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  CHECK_RESULT $? 0 0 "utshell test.sh fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_unset

- 描述：utshell-test
- 函数：`pre_test, run_test, show_result, show_result, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "unset --help fail"
  CHECK_RESULT $? 0 0 "function command fail"
  CHECK_RESULT $? 1 0 "unset -f command fail"
  CHECK_RESULT $? 0 0 "declare -n command fail"
  CHECK_RESULT $? 1 0 "unset -n command fail"
  CHECK_RESULT $? 0 0 "unset -n command fail"
```

- 涉及命令：utshell×6

#### oe_test_utshell_while

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "help while fail"
  CHECK_RESULT $? 0 0 "test.sh fail"
```

- 涉及命令：utshell×1

#### oe_test_utshell_until

- 描述：until using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "echo fail"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  CHECK_RESULT $? 0 0 "utshell test.sh fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_umask

- 描述：umask using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "umask --help fail"
  CHECK_RESULT $? 0 0 "umask fail"
  CHECK_RESULT $? 0 0 "umask -p fail"
  CHECK_RESULT $? 0 0 "umask -S fail"
  CHECK_RESULT $? 0 0 "umask 0044 fail"
  CHECK_RESULT $? 0 0 "umask -p fail"
  CHECK_RESULT $? 0 0 "umask -S fail"
```

- 涉及命令：utshell×8

#### oe_test_utshell_false

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "false --help fail in utshell"
  CHECK_RESULT $? 1 0 "false fail in utshell"
```

- 涉及命令：utshell×2

#### oe_test_utshell_if

- 描述：If using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "help if fail"
  CHECK_RESULT $? 0 0 "utshell test.sh 5 fail"
  CHECK_RESULT $? 0 0 "utshell test.sh 6 fail"
  CHECK_RESULT $? 0 0 "utshell test.sh 3 fail"
```

- 涉及命令：utshell×6

#### oe_test_utshell_alias

- 描述：alias using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "alias --help failed"
  CHECK_RESULT $? 0 0 "alias -p execution failed"
  CHECK_RESULT $? 0 0 "alias -p execution failed"
```

- 涉及命令：utshell×3

#### oe_test_utshell_unalias

- 描述：unalias using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "unalias --help failed"
  CHECK_RESULT $? 0 0 "alias lx execution failed"
  CHECK_RESULT $? 1 1 "unalias execution failed"
```

- 涉及命令：utshell×3

#### oe_test_utshell_test_04

- 描述：test utshell unset
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Execution failed"
```

#### oe_test_utshell_test_05

- 描述：utshell-test-p
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "file1 not exist"
  CHECK_RESULT $? 0 0 "chmod fail"
  CHECK_RESULT $? 0 0 "file not SGID"
  CHECK_RESULT $? 1 0 "file not SUID"
```

- 涉及命令：utshell×4

#### oe_test_utshell_test_06

- 描述：utshell-test-g
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "file1 not exist"
  CHECK_RESULT $? 0 1 "file not SGID"
```

- 涉及命令：utshell×2

#### oe_test_utshell_test_07

- 描述：utshell-test-ef
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "1.txt not exist"
  CHECK_RESULT $? 0 0 "test not exist"
  CHECK_RESULT $? 0 0 "ln fail"
  CHECK_RESULT $? 0 0 "ef fail"
  CHECK_RESULT $? 0 1 "ef success"
```

- 涉及命令：utshell×5

#### oe_test_utshell_test_08

- 描述：utshell-test-r
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test.txt not exist"
  CHECK_RESULT "$res" 0 0 "test -r test.txt fail"
  CHECK_RESULT "$res1" 1 0 "test -r test1.txt fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_test_09

- 描述：utshell-test-r
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test.txt not exist"
  CHECK_RESULT "$res" 1 0 "test -x test.txt fail"
  CHECK_RESULT "$res1" 0 0 "test -x test1.txt fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_test_10

- 描述：utshell-test-r
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test.txt not exist"
  CHECK_RESULT "$res" 1 0 "test -x test.txt fail"
  CHECK_RESULT "$res1" 0 0 "test -x test1.txt fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_test_11

- 描述：utshell-test-r
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$res" 0 0 "test -x test.txt fail"
  CHECK_RESULT "$res1" 1 0 "test -x test1.txt fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_test_12

- 描述：utshell-test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$res" 0 0 "test -x test.txt fail"
  CHECK_RESULT "$res1" 1 0 "test -x test1.txt fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_let_01

- 描述：let using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "let --help failed"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  CHECK_RESULT $? 0 0 "utshell test.sh fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_let_02

- 描述：let using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "let --help failed"
  CHECK_RESULT $? 0 0 "utshell let execution fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_export_01

- 描述：test utshell export
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "export var fail"
  CHECK_RESULT $? 1 0 "delete export var fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_return

- 描述：Return using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "return --help fail"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  CHECK_RESULT $? 9 0 "utshell test.sh fail"
  CHECK_RESULT $? 0 0 "utshell test.sh ;echo \$? fail"
  CHECK_RESULT $? 0 0 "touch test2.sh fail"
  CHECK_RESULT $? 3 0 "utshell test.sh fail"
  CHECK_RESULT $? 0 0 "utshell test2.sh ;echo \$? fail"
```

- 涉及命令：utshell×9

#### oe_test_utshell_compgen_02

- 描述：compgen using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Command execution failed"
  CHECK_RESULT $? 0 0 "Command execution failed"
  CHECK_RESULT $? 0 0 "Command execution failed"
```

- 涉及命令：useradd×1, userdel×1

#### oe_test_utshell_ulimit_01

- 描述：test utshell export
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "ulimit -H fail"
  CHECK_RESULT $? 0 0 "ulimit -m fail"
  CHECK_RESULT $? 0 0 "ulimit -n fail"
  CHECK_RESULT $? 0 0 "ulimit -p fail"
  CHECK_RESULT $? 0 0 "ulimit -s fail"
  CHECK_RESULT $? 0 0 "ulimit -S fail"
  CHECK_RESULT $? 0 0 "ulimit -t fail"
  CHECK_RESULT $? 0 0 "ulimit -u fail"
  CHECK_RESULT $? 0 0 "ulimit -v fail"
  CHECK_RESULT $? 0 0 "ulimit -q fail"
```

- 涉及命令：utshell×10

#### oe_test_utshell_case

- 描述：case using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "help case fail"
  CHECK_RESULT $? 1 0 "utshell test.sh fail"
  CHECK_RESULT $? 0 0 "utshell test.sh -f fail"
  CHECK_RESULT $? 0 0 "utshell test.sh -d fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_compgen_03

- 描述：compgen using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "There is no such statement"
  CHECK_RESULT $? 1 0 "There is no such statement"
  CHECK_RESULT $? 0 0 "Command execution failed"
```

- 涉及命令：useradd×1, userdel×1

#### oe_test_utshell_ulimit_02

- 描述：test utshell ulimit
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "ulimit -S fail"
  CHECK_RESULT $? 0 0 "ulimit -t fail"
  CHECK_RESULT $? 0 0 "ulimit -u fail"
  CHECK_RESULT $? 0 0 "ulimit -v fail"
  CHECK_RESULT $? 0 0 "ulimit -q fail"
```

- 涉及命令：utshell×5

#### oe_test_utshell_bind_01

- 描述：bind using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "bind --help fail"
  CHECK_RESULT $? 0 0 "bind -l fail"
  CHECK_RESULT $? 0 0 "bind -p fail"
  CHECK_RESULT $? 0 0 "bind -v fail"
  CHECK_RESULT $? 0 0 "bind -q abort fail"
```

- 涉及命令：utshell×5

#### oe_test_utshell_readonly

- 描述：readonly using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Command execution failed"
  CHECK_RESULT $? 0 0 "Command execution failed"
  CHECK_RESULT $? 0 0 "Command execution failed"
```

- 涉及命令：useradd×1, userdel×1

#### oe_test_utshell_select

- 描述：select using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "help select fail"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  CHECK_RESULT $? 1 0 "utshell test.sh fail"
  CHECK_RESULT $? 0 0 "grep fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_cd_01

- 描述：cd using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "cd /home/ fail"
  CHECK_RESULT $? 0 0 "pwd fail"
  CHECK_RESULT $? 0 0 "cd fail"
  CHECK_RESULT $? 0 0 "pwd fail"
  CHECK_RESULT $? 0 0 "cd --help fail"
```

- 涉及命令：utshell×5

#### oe_test_utshell_mapfile_01

- 描述：mapfile using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Execution failed"
  CHECK_RESULT $? 0 0 "Execution failed"
```

- 涉及命令：utshell×3, mapfile×1

#### oe_test_utshell_mapfile_02

- 描述：mapfile using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "fail to write to file "
  CHECK_RESULT $? 0 0 "Failed to view callback function"
  CHECK_RESULT $? 0 0 "Execution failed"
```

- 涉及命令：utshell×3

#### oe_test_utshell_mapfile_03

- 描述：mapfile using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "Incorrect array reading"
  CHECK_RESULT $? 0 0 "Failed to display the first 6 letters"
  CHECK_RESULT $? 0 0 "Failed to display the last 16 letters"
```

- 涉及命令：useradd×1, test×1, userdel×1

#### oe_test_utshell_shopt

- 描述：eval using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "shopt --help fail"
  CHECK_RESULT $? 0 0 "shopt -p fail"
  CHECK_RESULT $? 0 0 "shopt fail"
  CHECK_RESULT $? 0 0 "shopt fail"
  CHECK_RESULT $? 0 0 "shopt fail"
```

- 涉及命令：utshell×5

#### oe_test_utshell_enable

- 描述：enable using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 " enable --help fail"
  CHECK_RESULT $? 0 0 "enable -a fail"
  CHECK_RESULT $? 0 0 " enable -n fail"
  CHECK_RESULT $? 0 0 "enable -n wait;enable -n |grep wait fail"
  CHECK_RESULT $? 1 0 "enable -a wait;enable -n | grep wait fail"
  CHECK_RESULT $? 0 0 "enable -s fail"
  CHECK_RESULT $? 0 0 "enable -p fail"
```

- 涉及命令：utshell×7

#### oe_test_utshell_for

- 描述：for using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "help for fail"
  CHECK_RESULT $? 0 0 "create file failed"
  CHECK_RESULT $? 0 0 "The for command is abnormal"
```

- 涉及命令：utshell×1, test×1, grep×1

#### oe_test_utshell_cd_02

- 描述：cd-L ;cd -P cd -e using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "cd --help fail"
  CHECK_RESULT $? 0 0 "mkdir /home/niu fail"
  CHECK_RESULT $? 0 0 "ln -s /home/niu/ /etc fail"
  CHECK_RESULT $? 0 0 "pwd fail"
  CHECK_RESULT $? 0 0 "pwd fail"
  CHECK_RESULT $? 0 0 "mkdir /home/uos fail"
  CHECK_RESULT $? 0 0 "echo \$? fail"
  CHECK_RESULT $? 0 0 "pwd fail"
```

- 涉及命令：utshell×8

#### oe_test_utshell_true

- 描述：utshell-true
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "true --help fail"
  CHECK_RESULT "$(utshell -c "true --help")" "" 0 "true --help print fail"
  CHECK_RESULT $? 0 0 "true fail"
  CHECK_RESULT "$(utshell -c "true")" "" 0 "true print fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_trap_001

- 描述：utshell trap test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "trap --help fail"
  CHECK_RESULT $? 0 0 "trap -l fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_shift

- 描述：Exit using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "shift --help fail"
  CHECK_RESULT $? 0 0 "touch test.sh fail"
  CHECK_RESULT $? 0 0 "utshell test.sh 4 3 2 1 fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_continue

- 描述：continue using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "continue command failed"
  CHECK_RESULT $? 0 0 "create file failed"
  CHECK_RESULT $? 0 0 "create file2 failed"
  CHECK_RESULT $? 0 0 "The for command is abnormal"
```

- 涉及命令：test×2, grep×2, utshell×1

#### oe_test_utshell_caller_001

- 描述：utshell caller test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "caller --help fail"
  CHECK_RESULT $? 0 0 "test caller fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_printf

- 描述：printf using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "printf --help fail"
  CHECK_RESULT $? 0 0 "print Tom fail"
  CHECK_RESULT $? 0 0 "printf 'hello world fail"
  CHECK_RESULT $? 0 0 "printf 'a b c' fail"
  CHECK_RESULT $? 0 0 "printf fail"
```

- 涉及命令：utshell×5, printf×1

#### oe_test_utshell_caller_002

- 描述：utshell caller_002 test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "caller --help fail"
  CHECK_RESULT $? 0 0 "test caller fail"
  CHECK_RESULT $? 0 0 "test caller fail"
  CHECK_RESULT $? 0 0 "test caller fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_pwd

- 描述：pwd using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "pwd --help fail"
  CHECK_RESULT $? 0 0 "cd /ec/init.d fail"
  CHECK_RESULT $? 0 0 "pwd -L fail"
  CHECK_RESULT $? 0 0 "pwd -P fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_local

- 描述：local using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "help local fail"
  CHECK_RESULT $? 0 0 "utshell test.sh fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_ps_001

- 描述：utshell ps_001 test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ps --help fail"
  CHECK_RESULT $? 0 0 "test ps fail"
  CHECK_RESULT $? 0 0 "test ps -a fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_ps_002

- 描述：utshell ps_002 test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ps -u fail"
  CHECK_RESULT $? 0 0 "test ps -x fail"
  CHECK_RESULT $? 0 0 "test ps -f fail"
  CHECK_RESULT $? 0 0 "test ps -e fail"
```

- 涉及命令：utshell×4

#### oe_test_utshell_getopts

- 描述：If using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "utshell getopts.sh fail"
  CHECK_RESULT $? 0 0 "utshell test fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_getopts_02

- 描述：getopts using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "getpots --help fail"
  CHECK_RESULT $? 0 0 "utshell test.sh fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_ps_003

- 描述：utshell ps_003 test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test ps -ef fail"
  CHECK_RESULT $? 0 0 "test ps -ely fail"
  CHECK_RESULT $? 0 0 "test ps -ax fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_eval

- 描述：eval using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 2 0 "eval --help fail"
  CHECK_RESULT $? 0 0 "eval cd /;ls fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_times

- 描述：times using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "times --help fail"
  CHECK_RESULT $? 0 0 "times fail"
```

- 涉及命令：utshell×2

#### oe_test_utshell_command

- 描述：eval using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 2 0 "command --help fail"
  CHECK_RESULT $? 0 0 "command fdisk -l fail"
  CHECK_RESULT $? 0 0 "command echo Linuxcool fail"
  CHECK_RESULT $? 0 0 "command -p fdisk -l fail"
  CHECK_RESULT $? 0 0 "command -v fdisk -l fail"
  CHECK_RESULT $? 0 0 "command -V fdisk fail"
```

- 涉及命令：utshell×6

#### oe_test_utshell_kill

- 描述：eval using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 2 0 "kill --help fail"
  CHECK_RESULT $? 0 0 "kill -l fail"
  CHECK_RESULT $? 0 0 "kill $$ fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_function

- 描述：function using the utshell test command
- 函数：`pre_test, run_test, test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "help function fail"
  CHECK_RESULT $? 0 0 "utshell test.sh one fail"
  CHECK_RESULT $? 0 0 "utshell test.sh two fail"
  CHECK_RESULT $? 0 0 "utshell test.sh three fail"
  CHECK_RESULT $? 0 0 "utshell test.sh ta1a1 fail"
```

- 涉及命令：utshell×6

#### oe_test_utshell_jobs_x

- 描述：jobs -x using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "jobs --help failed"
  CHECK_RESULT $? 0 0 "jobs -x lsblk execution failed"
```

- 涉及命令：utshell×2

#### oe_test_utshell_dirs

- 描述：dirs using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "dirs --help failed"
  CHECK_RESULT $? 0 0 "dirs -l execution failed"
  CHECK_RESULT $? 0 1 "dirs -p execution failed"
  CHECK_RESULT $? 0 0 "dirs -v execution failed"
  CHECK_RESULT $? 0 0 "dirs +2 execution failed"
  CHECK_RESULT $? 0 0 "dirs -2 execution failed"
  CHECK_RESULT $? 0 1 "dirs -c execution failed"
```

- 涉及命令：utshell×7

#### oe_test_utshell_time

- 描述：utshell-time
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "help time fail"
  CHECK_RESULT $? 0 0 "time date fail"
  CHECK_RESULT $? 0 0 "time -p date fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_pushd

- 描述：pushd using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "pushd --help failed"
  CHECK_RESULT $? 0 0 "pushd execution failed"
  CHECK_RESULT $? 0 0 "pushd -n execution failed"
  CHECK_RESULT $? 0 0 "pushd execution failed"
  CHECK_RESULT $? 0 0 "pushd +1 execution failed"
  CHECK_RESULT $? 0 0 "pushd -1 execution failed"
```

- 涉及命令：utshell×6, mkdir×1

#### oe_test_utshell_popd

- 描述：popd using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "popd --help failed"
  CHECK_RESULT $? 0 0 "pushd execution failed"
  CHECK_RESULT $? 0 0 "popd execution failed"
  CHECK_RESULT $? 0 0 "popd -n execution failed"
  CHECK_RESULT $? 0 0 "pushd execution failed"
  CHECK_RESULT $? 0 0 "popd +1 execution failed"
  CHECK_RESULT $? 0 0 "popd -1 execution failed"
```

- 涉及命令：utshell×7, mkdir×1

#### oe_test_utshell_builtin

- 描述：builtin using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "cd execution failed"
  CHECK_RESULT $? 0 0 "alias pwd execution failed"
  CHECK_RESULT $? 0 0 "builtin pwd execution failed"
```

- 涉及命令：utshell×3

#### oe_test_utshell_ps_004

- 描述：utshell ps_004 test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test ps -aux fail"
  CHECK_RESULT $? 0 0 "test ps -ejH fail"
  CHECK_RESULT $? 0 0 "test ps -axjf fail"
```

- 涉及命令：utshell×3

#### oe_test_utshell_disown

- 描述：disown using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "utshell execution failed"
  CHECK_RESULT $? 0 0 "utshell disown -h execution failed"
  CHECK_RESULT $? 0 0 "utshell pgrep execution failed"
```

- 涉及命令：utshell×3
