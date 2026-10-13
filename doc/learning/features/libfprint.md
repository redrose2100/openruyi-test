# libfprint

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libfprint` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libfprint_basic | Test libfprint package installation and basic functionality | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libfprint_api | Test libfprint API interface correctness | config_params/pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libfprint_basic

- 描述：Test libfprint package installation and basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "libfprint package not installed"
  CHECK_RESULT $? 0 0 "libfprint not in ldconfig"
  CHECK_RESULT $? 0 0 "libfprint library file not found"
  CHECK_RESULT $? 0 0 "libfprint pkg-config not found"
  CHECK_RESULT $? 0 0 "libfprint pkg-config version check failed"
  CHECK_RESULT $? 0 0 "libfprint pkg-config cflags check failed"
  CHECK_RESULT $? 0 0 "libfprint pkg-config libs check failed"
```

- 涉及命令：rpm×1, ldconfig×1

#### oe_test_libfprint_api

- 描述：Test libfprint API interface correctness
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile libfprint API test"
  CHECK_RESULT $? 0 0 "libfprint API test failed"
  CHECK_RESULT $? 0 0 "fp_print symbol not found in libfprint"
  CHECK_RESULT $? 0 0 "enroll symbol not found in libfprint"
  CHECK_RESULT $? 0 0 "verify symbol not found in libfprint"
  CHECK_RESULT $? 0 0 "identify symbol not found in libfprint"
  CHECK_RESULT $? 0 0 "fp_print not found in fprint.h"
  CHECK_RESULT $? 0 0 "enroll not found in fprint.h"
  CHECK_RESULT $? 0 0 "verify not found in fprint.h"
  CHECK_RESULT $? 0 0 "identify not found in fprint.h"
```

- 涉及命令：grep×4
