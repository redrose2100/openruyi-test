# coreutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/coreutils` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_numfmt | test numfmt | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_stty | Test case for stty command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nohup | test nohup | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_pathchk | Test case for pathchk command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_numfmt

- 描述：test numfmt
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Error converting numbers to International System of Units"
  CHECK_RESULT $? 0 0 "Error converting numbers to the International Electrotechnical Commission binary prefix unit system"
  CHECK_RESULT $? 0 0 "Convert numbers to the International Electrotechnical Commission's Binary Prefix System of Units (IEC) and report errors using binary units"
  CHECK_RESULT $? 0 0 "Failed to read numbers from input and convert them to SI units"
  CHECK_RESULT $? 0 0 "Reading numbers from input and converting them to IEC units failed"
  CHECK_RESULT $? 0 0 "Failed to convert numbers in file system information (using - B1 parameter in bytes) to SI units"
  CHECK_RESULT $? 0 0 "Conversion of numbers in file size information (using - l parameter to display file information in long format) to IEC units failed"
  CHECK_RESULT $? 0 0 "Conversion to IEC units using the - lh parameter to display file information in both long format and human readable format failed while using the specified format"
```

#### oe_test_stty

- 描述：Test case for stty command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Help output test failed"
  CHECK_RESULT $? 0 0 "Print all settings failed"
  CHECK_RESULT $? 0 0 "Save settings output empty"
  CHECK_RESULT $? 0 0 "Disable echo failed"
```

- 涉及命令：stty×3

#### oe_test_nohup

- 描述：test nohup
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "nohup execute fail"
  CHECK_RESULT $? 0 0 "nohup top execute fail"
  CHECK_RESULT $? 0 0 "nohup execute fail"
  CHECK_RESULT $? 0 0 "Background process not running"
  CHECK_RESULT $? 0 0 "Error output not redirected properly"
  CHECK_RESULT $? 0 0 "Command compatibility test failed"
```

- 涉及命令：grep×1, pkill×1

#### oe_test_pathchk

- 描述：Test case for pathchk command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed basic file check"
  CHECK_RESULT $? 1 0 "Failed colon check with -p"
  CHECK_RESULT $? 1 0 "Failed empty filename check with -P"
  CHECK_RESULT $? 1 0 "Failed leading hyphen check with -P"
  CHECK_RESULT $? 1 0 "Failed long filename check with --portability"
```

- 涉及命令：pathchk×3
