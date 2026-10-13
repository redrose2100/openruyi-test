# sqlite

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sqlite` |
| 注册用例数 | 17 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sqlite_alter_01 | verification sqlite‘s alter command | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_command_01 | verification sqlite‘s quit/exit command | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_command_02 | verification sqlite‘s .table和.schema command | run_test/post_test | 3 |  |  |  |
| oe_test_sqlite_command_03 | verification sqlite‘s .table和.schema command | run_test/post_test | 1 |  |  |  |
| oe_test_sqlite_command_04 | verification sqlite‘s .import command | run_test/post_test | 1 |  |  |  |
| oe_test_sqlite_command_05 | verification sqlite‘s .headers command | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_command_06 | verification sqlite‘s .dump  command | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_command_07 | verification sqlite‘s .backup and .restore  command | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_command_08 | verification sqlite‘s .dump  command | run_test/post_test | 4 |  |  |  |
| oe_test_sqlite_delete_01 | verification sqlite‘s update command | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_function_01 | verification sqlite‘s count/MAX/MIN function | run_test/post_test | 3 |  |  |  |
| oe_test_sqlite_function_02 | verification sqlite‘s AVG/SUM function | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_function_03 | verification sqlite‘s UPPER/LOWER/LENGTH function | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_sqlite_function_04 | verification sqlite‘s UPPER/LOWER/LENGTH function | run_test/post_test | 2 |  |  |  |
| oe_test_sqlite_update_01 | verification sqlite‘s update command | run_test/post_test | 3 |  |  |  |
| oe_test_sqlite_select_05 | verification sqlite‘s limit command | run_test/post_test | 3 |  |  |  |
| oe_test_sqlite_create_06 | verification sqlite‘s DEFAULT define  command | run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_sqlite_alter_01

- 描述：verification sqlite‘s alter command
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -cE "OLD_COMPANY" ./output.txt)" 1
  CHECK_RESULT "$(grep -cE "SEX|female" ./output.txt)" 2
```

#### oe_test_sqlite_command_01

- 描述：verification sqlite‘s quit/exit command
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_sqlite_command_02

- 描述：verification sqlite‘s .table和.schema command
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$(awk 'NR==1' ./output.txt | grep -cE "main")" 1
  CHECK_RESULT "$(awk 'NR==2' ./output.txt)" COMPANY
  CHECK_RESULT "$(awk 'NR==3' ./output.txt | grep -cE "CREATE TABLE COMPANY")" 1
```

#### oe_test_sqlite_command_03

- 描述：verification sqlite‘s .table和.schema command
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "24")" 1
```

#### oe_test_sqlite_command_04

- 描述：verification sqlite‘s .import command
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "23")" 1
```

#### oe_test_sqlite_command_05

- 描述：verification sqlite‘s .headers command
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "24")" 1
  CHECK_RESULT "$(wc -l ./output1.txt | grep -cE "23")" 1
```

#### oe_test_sqlite_command_06

- 描述：verification sqlite‘s .dump  command
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "24")" 1
```

#### oe_test_sqlite_command_07

- 描述：verification sqlite‘s .backup and .restore  command
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "0")" 1
  CHECK_RESULT "$(wc -l ./output1.txt | grep -cE "24")" 1
```

#### oe_test_sqlite_command_08

- 描述：verification sqlite‘s .dump  command
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "25")" 1
  CHECK_RESULT "$(grep -cE "select" ./output.txt)" 1
  CHECK_RESULT "$(wc -l ./output1.txt | grep -cE "24")" 1
  CHECK_RESULT $? 1
```

- 涉及命令：sed×1

#### oe_test_sqlite_delete_01

- 描述：verification sqlite‘s update command
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(awk 'NR==1' ./output.txt | grep -cE "7")" 1
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "1")" 1
```

#### oe_test_sqlite_function_01

- 描述：verification sqlite‘s count/MAX/MIN function
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$(awk 'NR==1' ./output.txt)" 24
  CHECK_RESULT "$(awk 'NR==2' ./output.txt | grep -cE '85000.0')" 1
  CHECK_RESULT "$(awk 'NR==3' ./output.txt | grep -cE '15000.0')" 1
```

#### oe_test_sqlite_function_02

- 描述：verification sqlite‘s AVG/SUM function
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(awk 'NR==1' ./output.txt | grep -cE '25')" 1
  CHECK_RESULT "$(awk 'NR==2' ./output.txt | grep -cE '616')" 1
```

#### oe_test_sqlite_function_03

- 描述：verification sqlite‘s UPPER/LOWER/LENGTH function
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(awk 'NR==1' ./output.txt | grep -cE 'KIM')" 1
  CHECK_RESULT "$(awk 'NR==2' ./output.txt | grep -cE 'kim')" 1
  CHECK_RESULT "$(awk 'NR==3' ./output.txt)" 3
  CHECK_RESULT "$(awk 'NR==4' ./output.txt)" $version
```

#### oe_test_sqlite_function_04

- 描述：verification sqlite‘s UPPER/LOWER/LENGTH function
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(awk 'NR==1' ./output.txt | grep -cE '7|Paul')" 1
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE '1')" 1
```

#### oe_test_sqlite_update_01

- 描述：verification sqlite‘s update command
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$(awk 'NR==1' ./output.txt | grep -cE "Kim")" 1
  CHECK_RESULT "$(awk 'NR==2' ./output.txt | grep -cE "Tom2")" 1
  CHECK_RESULT "$(grep -cE "Beijing|20000.0" ./output.txt)" 24
```

#### oe_test_sqlite_select_05

- 描述：verification sqlite‘s limit command
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$(wc -l ./output.txt | grep -cE "6")" 1
  CHECK_RESULT "$(wc -l ./output1.txt | grep -cE "3")" 1
  CHECK_RESULT "$(awk 'NR==1' ./output1.txt | grep -cE "3")" 1
```

#### oe_test_sqlite_create_06

- 描述：verification sqlite‘s DEFAULT define  command
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$(grep -cE "28" ./output.txt)" 1
```
