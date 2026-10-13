# libsepol

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libsepol` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libsepol_basic | Test libsepol package installation and basic functionality | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libsepol_commands | Test libsepol commands: sepol_check_access, sepol_compute_av, sepol_compute_member, sepol_compute_relabel, sepol_validate_transition | config_params/pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_libsepol_policy | Test SELinux policy operations: create, load, modify and query | config_params/pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libsepol_basic

- 描述：Test libsepol package installation and basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "libsepol package not installed"
  CHECK_RESULT $? 0 0 "libsepol version check failed"
  CHECK_RESULT $? 0 0 "libsepol library not found"
  CHECK_RESULT $? 0 0 "libsepol header not found"
  CHECK_RESULT $? 0 0 "sepol_check_access command not found"
  CHECK_RESULT $? 0 0 "sepol_compute_av command not found"
  CHECK_RESULT $? 0 0 "sepol_compute_member command not found"
  CHECK_RESULT $? 0 0 "sepol_compute_relabel command not found"
  CHECK_RESULT $? 0 0 "sepol_validate_transition command not found"
```

- 涉及命令：command×5, rpm×2

#### oe_test_libsepol_commands

- 描述：Test libsepol commands: sepol_check_access, sepol_compute_av, sepol_compute_member, sepol_compute_relabel, sepol_validate_transition
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "sepol_check_access should allow unconfined_t to read etc_t"
  CHECK_RESULT $? 0 0 "sepol_check_access should allow unconfined_t to write etc_t"
  CHECK_RESULT $? 0 1 "sepol_check_access should deny user_t to read shadow_t"
  CHECK_RESULT $? 0 1 "sepol_check_access should deny user_t to write shadow_t"
  CHECK_RESULT $? 0 0 "sepol_compute_av should produce valid output"
  CHECK_RESULT $? 0 0 "sepol_compute_member output is not a valid context"
  CHECK_RESULT $? 0 0 "sepol_compute_relabel output is not a valid context"
  CHECK_RESULT $? 0 0 "sepol_validate_transition should succeed for valid transition"
  CHECK_RESULT $? 0 1 "sepol_check_access should fail with invalid context"
  CHECK_RESULT $? 0 1 "sepol_check_access should fail with invalid permission"
  CHECK_RESULT $? 0 1 "sepol_compute_av should fail with invalid context"
  CHECK_RESULT $? 0 1 "sepol_validate_transition should fail with invalid new context"
  ... 共 13 条（其余见源脚本）
```

#### oe_test_libsepol_policy

- 描述：Test SELinux policy operations: create, load, modify and query
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "checkmodule compilation failed"
  CHECK_RESULT $? 0 0 "semodule_package creation failed"
  CHECK_RESULT $? 0 0 "semodule load failed"
  CHECK_RESULT $? 0 0 "test_policy module not found after loading"
  CHECK_RESULT $? 0 0 "sepol_check_access with test policy failed"
  CHECK_RESULT $? 0 0 "updated policy module creation failed"
  CHECK_RESULT $? 0 0 "updated checkmodule compilation failed"
  CHECK_RESULT $? 0 0 "updated semodule_package creation failed"
  CHECK_RESULT $? 0 0 "updated semodule load failed"
  CHECK_RESULT $? 0 0 "sepol_check_access with execute permission failed"
```

- 涉及命令：semodule×4, checkmodule×2, semodule_package×2, mkdir×1
