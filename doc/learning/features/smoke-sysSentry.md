# smoke-sysSentry

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-sysSentry` |
| 注册用例数 | 10 |
| 环境约束 | machine num = 3 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sysSentry_xalarmd_recorver |  | check_RA_xalarmd_log/pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_sysSentry_oom |  | pre_test/test_hugepages/run_test/post_test | 5 |  |  |  |
| oe_test_sysSentry_kernel_reboot_001 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |
| oe_test_sysSentry_kernel_reboot_002 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |
| oe_test_sysSentry_kernel_reboot_003 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |
| oe_test_sysSentry_kernel_reboot_004 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |
| oe_test_sysSentry_panic_001 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |
| oe_test_sysSentry_panic_002 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |
| oe_test_sysSentry_panic_003 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |
| oe_test_sysSentry_panic_004 |  | pre_test/run_test/post_test | 0 |  | ✔ |  |

### 断言与命令明细

#### oe_test_sysSentry_xalarmd_recorver

- 描述：
- 函数：`check_RA_xalarmd_log, pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：kill×2, set×1

#### oe_test_sysSentry_oom

- 描述：
- 函数：`pre_test, test_hugepages, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：set×1

#### oe_test_sysSentry_kernel_reboot_001

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1

#### oe_test_sysSentry_kernel_reboot_002

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1

#### oe_test_sysSentry_kernel_reboot_003

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1

#### oe_test_sysSentry_kernel_reboot_004

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1

#### oe_test_sysSentry_panic_001

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1

#### oe_test_sysSentry_panic_002

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1

#### oe_test_sysSentry_panic_003

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1

#### oe_test_sysSentry_panic_004

- 描述：
- 函数：`pre_test, run_test, post_test`
- 涉及命令：set×1
