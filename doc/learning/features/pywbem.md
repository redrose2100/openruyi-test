# pywbem

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pywbem` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pywbem_base_mof_compiler_01 | Test pywbem_mof_compiler command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pywbem_base_mof_compiler_02 | Test pywbem_mof_compiler command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pywbem_base_mof_compiler_01

- 描述：Test pywbem_mof_compiler command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -s"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -n"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -u"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -p"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -nvc"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option --cacerts"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option --certfile"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option --keyfile"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -r"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -d"
```

- 涉及命令：mof_compiler×10

#### oe_test_pywbem_base_mof_compiler_02

- 描述：Test pywbem_mof_compiler command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -I"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -v"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -V"
  CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -h"
```

- 涉及命令：mof_compiler×4
