# cups-filters

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cups-filters` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_cups-browsed | Test cups-browsed.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_cups-filters_config | Test cups-filters configuration and tools | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_cups-filters_tools | Test cups-filters tools functionality | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_cups-browsed

- 描述：Test cups-browsed.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_cups-filters_config

- 描述：Test cups-filters configuration and tools
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "pdftops filter does not exist"
  CHECK_RESULT $? 0 0 "gstoraster filter does not exist"
  CHECK_RESULT $? 0 0 "texttopdf filter does not exist"
  CHECK_RESULT $? 0 0 "cupsfilter command not found"
  CHECK_RESULT $? 0 0 "cupsfilter text processing failed"
  CHECK_RESULT $? 0 0 "cups-files.conf does not exist"
  CHECK_RESULT $? 0 0 "cups-filters README does not exist"
  CHECK_RESULT $? 0 0 "libcupsfilters.so.1 library does not exist"
  CHECK_RESULT $? 0 0 "cupsfilter -o parameter failed"
  CHECK_RESULT $? 0 0 "cupsfilter -n parameter failed"
  CHECK_RESULT $? 0 0 "cupsfilter --list-filters parameter failed"
```

- 涉及命令：test×6, cupsfilter×2

#### oe_test_cups-filters_tools

- 描述：Test cups-filters tools functionality
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "cupsfilter command not found"
  CHECK_RESULT $? 0 0 "cupsfilter text processing failed"
  CHECK_RESULT $? 0 0 "cupsfilter output is empty"
  CHECK_RESULT $pdf_result 0 0 "PDF to PS conversion failed"
  CHECK_RESULT $? 0 0 "PDF to PS conversion output is empty"
  CHECK_RESULT $? 0 0 "cupsfilter format specification failed"
  CHECK_RESULT $? 0 1 "Error handling for non-existent file failed"
  CHECK_RESULT $? 0 1 "Invalid parameter handling failed"
```

- 涉及命令：test×2, cupsfilter×2, command×1
