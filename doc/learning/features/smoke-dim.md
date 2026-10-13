# smoke-dim

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-dim` |
| 注册用例数 | 2 |
| 环境约束 | machine num = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dim_measure_001 | dim measure test | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_dim_measure_002 | dim measure tampered test | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dim_measure_001

- 描述：dim measure test
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "dim_gen_baseline failed."
  CHECK_RESULT $? 0 0 "dim_gen_baseline failed."
  CHECK_RESULT $? 0 0 "dim_gen_baseline failed."
  CHECK_RESULT $? 0 0 "baseline_init failed."
  CHECK_RESULT $? 0 0 "measure failed."
  CHECK_RESULT $? 0 0 "get measure log failed."
  CHECK_RESULT $? 0 0 "get measure log failed."
  CHECK_RESULT $? 0 0 "get measure log failed."
  CHECK_RESULT $? 0 1 "get measure log failed."
  CHECK_RESULT $? 0 0 "monitor_baseline failed."
  CHECK_RESULT $? 0 0 "monitor_run failed."
  CHECK_RESULT $? 0 0 "get monitor log failed."
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：depmod×1, mkdir×1, dim_gen_baseline×1

#### oe_test_dim_measure_002

- 描述：dim measure tampered test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "baseline_init failed."
  CHECK_RESULT $? 0 1 "get measure log failed."
  CHECK_RESULT $? 0 0 "monitor_baseline failed."
  CHECK_RESULT $? 0 0 "monitor_run failed."
  CHECK_RESULT $? 0 1 "get monitor log failed."
  CHECK_RESULT $? 0 0 "measure failed."
  CHECK_RESULT $? 0 0 "get measure log failed."
  CHECK_RESULT $? 0 0 "get measure log failed."
  CHECK_RESULT $? 0 0 "baseline_init failed."
  CHECK_RESULT $? 0 0 "monitor_run failed."
  CHECK_RESULT $? 0 0 "get monitor log failed."
```

- 涉及命令：make×2, pkill×2, mkdir×1, depmod×1
