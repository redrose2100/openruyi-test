# smoke-powerapi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-powerapi` |
| 注册用例数 | 6 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_interface_powerapi_01 | PWR_SetLogCallback() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_02 | PWR_SetServerInfo() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_03 | PWR_SetServerInfo() test1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_04 | PWR_Register() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_05 | PWR_Register() repeat test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_06 | PWR_SetServerInfo() test1 (sock file no permission)test | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_interface_powerapi_01

- 描述：PWR_SetLogCallback() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetLogCallback failed"
```

#### oe_test_interface_powerapi_02

- 描述：PWR_SetServerInfo() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetServerInfo failed"
```

- 涉及命令：sed×2, grep×1

#### oe_test_interface_powerapi_03

- 描述：PWR_SetServerInfo() test1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetServerInfo failed"
```

- 涉及命令：sed×3, userdel×1

#### oe_test_interface_powerapi_04

- 描述：PWR_Register() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_Register failed"
```

#### oe_test_interface_powerapi_05

- 描述：PWR_Register() repeat test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_Register failed"
```

- 涉及命令：grep×1

#### oe_test_interface_powerapi_06

- 描述：PWR_SetServerInfo() test1 (sock file no permission)test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetServerInfo failed"
```

- 涉及命令：sed×3, pgrep×1, userdel×1
