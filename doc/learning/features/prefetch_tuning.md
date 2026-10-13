# prefetch_tuning

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/prefetch_tuning` |
| 注册用例数 | 2 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_prefetch_tuning_install | Test prefetch_tuning package installation, CLI commands and parameter effectiveness | config_params/pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_prefetch_tuning_params | Test prefetch_tuning parameters valid range and invalid parameter handling | pre_test/run_test/post_test | 46 | ✔ |  |  |

### 断言与命令明细

#### oe_test_prefetch_tuning_install

- 描述：Test prefetch_tuning package installation, CLI commands and parameter effectiveness
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "prefetch_tuning package not installed"
  CHECK_RESULT $? 0 0 "prefetch_tuning kernel module not found"
  CHECK_RESULT $? 0 0 "prefetch_tuning module not loaded"
  CHECK_RESULT $? 0 0 "prefetch_tuning sysfs directory not found"
  CHECK_RESULT $? 0 0 "test file creation failed"
  CHECK_RESULT $? 0 0 "policy set to 1 for effectiveness test failed"
  CHECK_RESULT $? 0 0 "read test with prefetch enabled failed"
  CHECK_RESULT $? 0 0 "policy set to 0 for effectiveness test failed"
  CHECK_RESULT $? 0 0 "read test with prefetch disabled failed"
```

- 涉及命令：rpm×1, grep×1

#### oe_test_prefetch_tuning_params

- 描述：Test prefetch_tuning parameters valid range and invalid parameter handling
- 函数：`pre_test, run_test, post_test`
- 断言（46 条）：

```
  CHECK_RESULT $? 0 0 "policy set to 1 failed"
  CHECK_RESULT $? 0 0 "policy value not updated to 1"
  CHECK_RESULT $? 0 0 "policy set to 0 failed"
  CHECK_RESULT $? 0 0 "policy value not updated to 0"
  CHECK_RESULT $? 0 0 "policy set to 15 failed"
  CHECK_RESULT $? 0 0 "policy value not updated to 15"
  CHECK_RESULT $? 0 1 "policy should reject value 16"
  CHECK_RESULT $? 0 0 "read_unique set to 0 failed"
  CHECK_RESULT $? 0 0 "read_unique value not updated to 0"
  CHECK_RESULT $? 0 0 "read_unique set to 1 failed"
  CHECK_RESULT $? 0 0 "read_unique value not updated to 1"
  CHECK_RESULT $? 0 1 "read_unique should reject value 2"
  ... 共 46 条（其余见源脚本）
```

- 涉及命令：grep×27
