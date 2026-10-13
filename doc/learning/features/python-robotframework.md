# python-robotframework

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/python-robotframework` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_robotframework_libdoc | A Python based test automation framework | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_robotframework_rebot_01 | A Python based test automation framework | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_robotframework_rebot_02 | A Python based test automation framework | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_robotframework_rebot_03 | A Python based test automation framework | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_robotframework_robot_01 | A Python based test automation framework | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_robotframework_robot_02 | A Python based test automation framework | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_robotframework_robot_03 | A Python based test automation framework | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_robotframework_robot_04 | A Python based test automation framework | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_robotframework_run | test robotframework | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_robotframework_libdoc

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list the keyword names contained in the library/resource"
  CHECK_RESULT $? 0 0 "Failed to display library/resource document"
  CHECK_RESULT $? 0 0 "Failed to display the library version"
  CHECK_RESULT $? 0 0 "Failed to specify the format of the output file"
  CHECK_RESULT $? 0 0 "Failed to specify the document format to use for XML and JSON specification files"
  CHECK_RESULT $? 0 0 "Failed to specify the source document format"
  CHECK_RESULT $? 0 0 "Failed to set the document library or version resource"
  CHECK_RESULT $? 0 0 "Failed to set the document library or version resource"
  CHECK_RESULT $? 0 0 "The path to the generated output file is printed to the console"
  CHECK_RESULT $? 0 0 "Failed to view help information"
```

- 涉及命令：libdoc×7

#### oe_test_robotframework_rebot_01

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to open general Automation mode"
  CHECK_RESULT $? 0 0 "Failed to merge the output together"
  CHECK_RESULT $? 0 0 "Failed to specify the path to the output file"
  CHECK_RESULT $? 0 0 "Failed to set the name of the top-level suite"
  CHECK_RESULT $? 0 0 "Failed to specify the output file name"
  CHECK_RESULT $? 0 0 "Failed to set the top-level suite document"
  CHECK_RESULT $? 0 0 "Failed to set metadata for the top-level suite"
  CHECK_RESULT $? 0 0 "Failed to specify log file"
  CHECK_RESULT $? 0 0 "Failed to execute the report file path"
  CHECK_RESULT $? 0 0 "Failed to generate xUnit-compatible result file"
```

- 涉及命令：rebot×5

#### oe_test_robotframework_rebot_02

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use timestamp ended file format"
  CHECK_RESULT $? 0 0 "Failed to use Xunit"
  CHECK_RESULT $? 0 0 "Failed to use the critical tag"
  CHECK_RESULT $? 0 0 "Failed to use the noncritical tag"
  CHECK_RESULT $? 0 0 "Failed to set the given flag for all tests"
  CHECK_RESULT $? 0 0 "Failed to test for items not contained in the specified tag"
  CHECK_RESULT $? 0 0 "The generated log file title failed"
  CHECK_RESULT $? 0 0 "The generated report file title failed"
  CHECK_RESULT $? 0 0 "Failed to specify the background color to use in the report file"
  CHECK_RESULT $? 0 0 "Failed to set the log level"
```

- 涉及命令：rebot×6

#### oe_test_robotframework_rebot_03

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set logging and reporting levels"
  CHECK_RESULT $? 0 0 "Failed to set the execution start time"
  CHECK_RESULT $? 0 0 "Failed to set the end time"
  CHECK_RESULT $? 0 0 "The return code is not set to zero"
  CHECK_RESULT $? 0 0 "Failed to set the use of color on console output"
  CHECK_RESULT $? 0 0 "Failed to print help information"
  CHECK_RESULT $? 0 0 "Failed to print version information"
```

- 涉及命令：rebot×2

#### oe_test_robotframework_robot_01

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set the name of the top-level suite"
  CHECK_RESULT $? 0 0 "Failed to set the output format"
  CHECK_RESULT $? 0 0 "Failed to set metadata for the top-level suite"
  CHECK_RESULT $? 0 0 "Failed to set the given flag for all tests"
  CHECK_RESULT $? 0 0 "Failed to test for items not contained in the specified tag"
  CHECK_RESULT $? 0 0 "The failed test to be re-executed from the earlier output file failed"
  CHECK_RESULT $? 0 0 "Failed to select the failed suite to re-execute from the previous output file"
  CHECK_RESULT $? 0 0 "Suite execution failed"
  CHECK_RESULT $? 0 0 "Alias failed"
  CHECK_RESULT $? 0 0 "Failure to perform the opposite"
```

- 涉及命令：robot×6

#### oe_test_robotframework_robot_02

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to specify the output file directory"
  CHECK_RESULT $? 0 0 "Failed to specifies the name of the output file"
  CHECK_RESULT $? 0 0 "Failed to specifies a log file"
  CHECK_RESULT $? 0 0 "Failed to specifies the report file"
  CHECK_RESULT $? 0 0 "Failed to specifies the result file compatible with xUnit"
  CHECK_RESULT $? 0 0 "Failed to specifies the result file compatible with xunit"
  CHECK_RESULT $? 0 0 "Failed to write debug file during execution"
  CHECK_RESULT $? 0 0 "Failed to add the timestamp between the base name and extension of all generated output files"
  CHECK_RESULT $? 0 0 "The generated log file title failed"
  CHECK_RESULT $? 0 0 "The generated report file title failed"
```

- 涉及命令：robot×7

#### oe_test_robotframework_robot_03

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to specify the background color to use in the report file"
  CHECK_RESULT $? 0 0 "Failed to set the log level"
  CHECK_RESULT $? 0 0 "Statistics by suite shows how many levels of failure in logs and reports"
  CHECK_RESULT $? 0 0 "The return code is not zero"
  CHECK_RESULT $? 0 0 "Sets to stop test execution failure if any key tests fail"
  CHECK_RESULT $? 0 0 "Test execution is not stopped when an error occurs while parsing"
  CHECK_RESULT $? 1 0 "Test execution stopped early without skipping dismantlement"
  CHECK_RESULT $? 0 0 "Non-randomize test execution order"
  CHECK_RESULT $? 0 0 "Specifies how execution is reported on the console"
  CHECK_RESULT $? 0 0 "Specifies how to report execution on the console (shortcuts)"
```

- 涉及命令：robot×3

#### oe_test_robotframework_robot_04

- 描述：A Python based test automation framework
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 1 0 "In addition to errors and warnings, there is output"
  CHECK_RESULT $? 0 0 "Failed to set the width of console output"
  CHECK_RESULT $? 0 0 "Colors are used on the console output"
  CHECK_RESULT $? 0 0 "Failed to print help information. Procedure"
  CHECK_RESULT $? 0 0 "Failed to print version information. Procedure"
```

- 涉及命令：robot×3, test×1

#### oe_test_robotframework_run

- 描述：test robotframework
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "robotframework-4.0.3 not exist"
  CHECK_RESULT $? 0 0 "-q failture"pcprebotrobot
  CHECK_RESULT $? 0 0 "-v failture"
  CHECK_RESULT $? 0 0 "-d failture"
```

- 涉及命令：tar×1
