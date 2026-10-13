# oeaware_embedded

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/oeaware_embedded` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_oeAware_embedded_01 | oeAware embedded test | pre_test/run_test/post_test | 12 | ✔ | ✔ | 60m |
| oe_test_oeAware_embedded_02 | oeAware embedded test | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_03 | oeAware embedded test | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_04 | oeAware embedded test | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_05 | oeAware embedded test | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_06 | oeAware embedded test | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_07 | oeAware embedded test | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_08 | oeAware embedded test | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_09 | oeAware embedded test | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_oeAware_embedded_10 | oeAware embedded test | pre_test/run_test/post_test | 5 | ✔ | ✔ | 60m |
| oe_test_oeAware_embedded_11 | oeAware embedded test | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_oeAware_embedded_01

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check single cpu isolation failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune disable failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check multiple cpu isolation failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check multiple cpu isolation failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 1 0 "Check cpu0 isolation failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 1 0 "Check cpu off failed."
```

- 涉及命令：oeawarectl×6, sed×4

#### oe_test_oeAware_embedded_02

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check range is exception value failed."
  CHECK_RESULT $? 0 0 "Check log ERROR failed."
  CHECK_RESULT $? 0 0 "Check isolcpus is exception value failed."
  CHECK_RESULT $? 0 0 "Check log ERROR failed."
  CHECK_RESULT $? 0 0 "Check nohz_full is exception value failed."
  CHECK_RESULT $? 0 0 "Check log ERROR failed."
```

- 涉及命令：sed×3, oeawarectl×3

#### oe_test_oeAware_embedded_03

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check irqaffinity on failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 1 0 "Check irqaffinity off failed."
```

- 涉及命令：sed×4, oeawarectl×1

#### oe_test_oeAware_embedded_04

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check rcu_nocbs on failed."
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 1 0 "Check rcu_nocbs off failed."
```

- 涉及命令：sed×4, oeawarectl×1

#### oe_test_oeAware_embedded_05

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 1 0 "Check swap on failed."
  CHECK_RESULT $? 0 0 "Check swap off failed."
  CHECK_RESULT $? 0 0 "Check swap is exception value failed."
  CHECK_RESULT $? 0 0 "Check swap is exception value failed."
```

- 涉及命令：oeawarectl×2, sed×1

#### oe_test_oeAware_embedded_06

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check ksm on failed."
  CHECK_RESULT $? 0 0 "Check ksm off failed."
  CHECK_RESULT $? 0 0 "Check ksm is exception value failed."
  CHECK_RESULT $? 0 0 "Check ksm is exception value failed."
```

- 涉及命令：oeawarectl×2, sed×1

#### oe_test_oeAware_embedded_07

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check migration on failed."
  CHECK_RESULT $? 0 0 "Check migration off failed."
  CHECK_RESULT $? 0 0 "Check migration is exception value failed."
  CHECK_RESULT $? 0 0 "Check migration is exception value failed."
```

- 涉及命令：oeawarectl×2, sed×1

#### oe_test_oeAware_embedded_08

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check rt_runtime_us on failed."
  CHECK_RESULT $? 0 0 "Check rt_runtime_us off failed."
  CHECK_RESULT $? 0 0 "Check rt_runtime_us is exception value failed."
  CHECK_RESULT $? 0 0 "Check rt_runtime_us is exception value failed."
```

- 涉及命令：oeawarectl×2, sed×1

#### oe_test_oeAware_embedded_09

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check cpufreq_performance on failed."
  CHECK_RESULT $? 0 0 "Check cpufreq_performance off failed."
  CHECK_RESULT $? 0 0 "Check cpufreq_performance is exception value failed."
  CHECK_RESULT $? 0 0 "Check cpufreq_performance is exception value failed."
```

- 涉及命令：oeawarectl×2, sed×1

#### oe_test_oeAware_embedded_10

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check kernel-rt failed."
  CHECK_RESULT $? 0 0 "Check kernel-rt failed."
  CHECK_RESULT $? 0 0 "Check cmdline modify failed."
  CHECK_RESULT $? 0 0 "Check cmdline modify failed."
  CHECK_RESULT $? 1 0 "Check cmdline modify failed."
```

- 涉及命令：sed×2, grub2-mkconfig×1

#### oe_test_oeAware_embedded_11

- 描述：oeAware embedded test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check realtime_tune enable failed."
  CHECK_RESULT $? 0 0 "Check default realtime_tune enable failed."
  CHECK_RESULT $? 1 0 "Check default realtime_tune enable failed."
```
