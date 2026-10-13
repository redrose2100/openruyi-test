# libdap

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/libdap` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libdap_getdap | A c++ SDK | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_libdap_getdap4 | A c++ SDK | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_libdap_devel_dap_config | A c++ SDK | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libdap_getdap

- 描述：A c++ SDK
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to obtain the DAP version"
  CHECK_RESULT $? 0 0 "Failed to obtain the DDS"
  CHECK_RESULT $? 0 0 "Failed to obtain the DAS"
  CHECK_RESULT $? 0 0 "Failed to obtain the DAP2"
  CHECK_RESULT $? 0 0 "Failed to get DAP2 without data"
  CHECK_RESULT $? 0 0 "Failed to obtain the Server version"
  CHECK_RESULT $? 0 0 "Failed to obtain the getdap version"
  CHECK_RESULT $? 0 0 "Failed to save the temporary file created by libdap"
  CHECK_RESULT $? 0 0 "Failed to request the same URL 3 times"
  CHECK_RESULT $? 0 0 "Data compression failure"
  CHECK_RESULT $? 0 0 "Failed to print sequence with numbered line"
  CHECK_RESULT $? 0 0 "Failed to read data from file without MIME header"
```

- 涉及命令：getdap×12

#### oe_test_libdap_getdap4

- 描述：A c++ SDK
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to obtain the client version"
  CHECK_RESULT $? 0 0 "Failed to request the same URL 3 times"
  CHECK_RESULT $? 0 0 "Data compression failure"
  CHECK_RESULT $? 0 0 "Failed to print sequence with numbered line"
```

- 涉及命令：getdap4×4

#### oe_test_libdap_devel_dap_config

- 描述：A c++ SDK
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Help message is misprinted"
  CHECK_RESULT $? 0 0 "GCC open failed"
  CHECK_RESULT $? 0 0 "G++ open failed"
  CHECK_RESULT $? 0 0 "Preprocessor and compiler flags failed to open"
  CHECK_RESULT $? 0 0 "Failed to open lib library link information for libdap"
  CHECK_RESULT $? 0 0 "Description The server- liBS server library fails to be started"
  CHECK_RESULT $? 0 0 "Description The client-liBS client library fails to be started"
  CHECK_RESULT $? 0 0 "OPeNDAP failed to install the prefix"
  CHECK_RESULT $? 0 0 "Version message is misprinted"
```
