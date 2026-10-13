# grubby

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/grubby` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_grubby_install | grubby install verification and package check | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_grubby_cli | grubby command line options test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_grubby_config | grubby configuration management test | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_grubby_install

- 描述：grubby install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "grubby package not installed"
  CHECK_RESULT $? 0 0 "Failed to get grubby package info"
  CHECK_RESULT $? 0 0 "grubby binary not found"
  CHECK_RESULT $? 0 0 "grubby version check failed"
```

- 涉及命令：rpm×2

#### oe_test_grubby_cli

- 描述：grubby command line options test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "grubby --help failed"
  CHECK_RESULT $? 0 0 "grubby --version failed"
  CHECK_RESULT $? 0 0 "grubby --default-kernel failed"
  CHECK_RESULT $? 0 0 "grubby --default-index failed"
  CHECK_RESULT $? 0 0 "grubby --default-title failed"
  CHECK_RESULT $? 0 0 "grubby --info failed"
```

#### oe_test_grubby_config

- 描述：grubby configuration management test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get default index"
  CHECK_RESULT $? 0 0 "grubby --info missing expected fields"
  CHECK_RESULT $? 0 0 "Failed to add kernel argument"
  CHECK_RESULT $? 0 0 "Kernel argument was not added"
  CHECK_RESULT $? 0 0 "Failed to remove kernel argument"
  CHECK_RESULT $? 0 1 "Kernel argument was not removed"
```
