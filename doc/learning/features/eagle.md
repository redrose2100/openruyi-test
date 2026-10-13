# eagle

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/eagle` |
| 注册用例数 | 39 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_eagle_01 | set parameter file_size cmp_cnt test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_eagle_02 | set parameter log_level test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_eagle_03 | set parameter log_path test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_04 | set parameter log_path bak_log_path test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_eagle_05 | set parameter bak_log_path test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_eagle_06 | set parameter log_pfx test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_eagle_07 | set parameter policy test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_08 | set parameter plugin_path test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_09 | set parameter config_update_interval test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_10 | set parameter policy_update_interval test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_11 | set parameter name test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_eagle_12 | set parameter desc test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_eagle_13 | set parameter [sched_service] enable test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_14 | set parameter [sched_service] sched_lib test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_15 | set parameter [sched_service] watt_sched_enable test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_16 | set parameter [sched_service] watt_threshold test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_eagle_17 | set parameter [sched_service] watt_interval_ms test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_eagle_18 | set parameter [sched_service] watt_domain_mask test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_eagle_19 | set parameter [sched_service] watt_first_domain test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_eagle_20 | set parameter [sched_service] watt_procs test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_21 | set parameter [sched_service] smart_grid_enable test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_22 | set parameter [sched_service] smart_grid_vip_procs test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_23 | set parameter [sched_service] smart_grid_gov_enable test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_24 | set parameter [sched_service] smart_grid_vip_gov test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_25 | set parameter [sched_service] smart_grid_lev1_gov test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_26 | set parameter [freq_service] enable test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_27 | set parameter [freq_service] freq_lib test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_28 | set parameter [freq_service] cpufreq_gov test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_29 | set parameter [freq_service] sampling_rate_us test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_eagle_30 | set parameter [freq_service] perf_loss_rate test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_eagle_31 | set parameter [idle_service] enable test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_32 | set parameter [idle_service] idle_lib test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_33 | set parameter [idle_service] cpuidle_gov test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_34 | set parameter [mpc_service] enable test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_35 | set parameter [mpc_service] mpc_lib test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_36 | set parameter [mpc_service] enable_mpc test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_37 | user eagle force released by root test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_eagle_38 | parameter restore test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_eagle_39 | eagle.service restart test | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_eagle_01

- 描述：set parameter file_size cmp_cnt test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check file_size cmp_cnt failed"
```

- 涉及命令：sed×2, kill×1

#### oe_test_eagle_02

- 描述：set parameter log_level test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check log_level=0 failed"
  CHECK_RESULT $? 0 0 "Check log_level=1 failed"
  CHECK_RESULT $? 0 0 "Check log_level=2 failed"
  CHECK_RESULT $? 0 0 "Check log_level=3 failed"
```

- 涉及命令：sed×4

#### oe_test_eagle_03

- 描述：set parameter log_path test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check log_path is not exists failed"
  CHECK_RESULT $? 0 0 "Check log_path is exists failed"
```

- 涉及命令：sed×3, test×1

#### oe_test_eagle_04

- 描述：set parameter log_path bak_log_path test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check bak_log_path failed"
```

- 涉及命令：sed×4, test×1, kill×1

#### oe_test_eagle_05

- 描述：set parameter bak_log_path test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check bak_log_path failed"
```

- 涉及命令：sed×3, kill×1

#### oe_test_eagle_06

- 描述：set parameter log_pfx test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check log_pfx failed"
```

- 涉及命令：sed×1, test×1

#### oe_test_eagle_07

- 描述：set parameter policy test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check policy is not exists failed"
  CHECK_RESULT $? 0 0 "Check policy is exists failed"
```

- 涉及命令：sed×4

#### oe_test_eagle_08

- 描述：set parameter plugin_path test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check plugin_path is not exists failed"
  CHECK_RESULT $? 0 0 "Check plugin_path is exists failed"
```

- 涉及命令：sed×4

#### oe_test_eagle_09

- 描述：set parameter config_update_interval test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check config_update_interval is dynamic modify failed"
  CHECK_RESULT $? 0 0 "Check config_update_interval is dynamic modify failed"
```

- 涉及命令：sed×2

#### oe_test_eagle_10

- 描述：set parameter policy_update_interval test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check policy_update_interval is dynamic modify failed"
  CHECK_RESULT $? 0 0 "Check policy_update_interval is dynamic modify failed"
```

- 涉及命令：sed×3

#### oe_test_eagle_11

- 描述：set parameter name test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 1 0 "Check name is null failed"
  CHECK_RESULT $? 1 0 "Check name failed"
  CHECK_RESULT $? 1 0 "Check name length is 1 failed"
  CHECK_RESULT $? 1 0 "Check name length is 255 failed"
  CHECK_RESULT $? 1 0 "Check name length is 256 failed"
```

- 涉及命令：sed×5

#### oe_test_eagle_12

- 描述：set parameter desc test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 1 0 "Check desc is null failed"
  CHECK_RESULT $? 1 0 "Check desc failed"
  CHECK_RESULT $? 1 0 "Check desc length is 1 failed"
  CHECK_RESULT $? 1 0 "Check desc length is 255 failed"
  CHECK_RESULT $? 1 0 "Check desc length is 256 failed"
```

- 涉及命令：sed×5

#### oe_test_eagle_13

- 描述：set parameter [sched_service] enable test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Check [sched_service] enable=0 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] enable=1 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] enable=-1 failed"
```

- 涉及命令：sed×4, grep×1

#### oe_test_eagle_14

- 描述：set parameter [sched_service] sched_lib test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check sched_lib default config failed"
  CHECK_RESULT $? 0 0 "Check sched_lib = test.so failed"
  CHECK_RESULT $? 1 0 "Check sched_lib = libidle_service.so failed"
```

- 涉及命令：sed×2, grep×1

#### oe_test_eagle_15

- 描述：set parameter [sched_service] watt_sched_enable test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Check [sched_service] watt_sched_enable = 0 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_sched_enable = 1 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_sched_enable = -1 failed"
```

- 涉及命令：sed×4, grep×1

#### oe_test_eagle_16

- 描述：set parameter [sched_service] watt_threshold test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "Check [sched_service] watt_threshold = 0 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_threshold = 100 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_threshold = -1 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_threshold = 101 failed"
```

- 涉及命令：sed×4, grep×2

#### oe_test_eagle_17

- 描述：set parameter [sched_service] watt_interval_ms test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "Check [sched_service] watt_interval_ms = 0 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_interval_ms = 3600000 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_interval_ms = -1 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_interval_ms = 3600001 failed"
```

- 涉及命令：sed×4, grep×2

#### oe_test_eagle_18

- 描述：set parameter [sched_service] watt_domain_mask test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1 0 "Check [sched_service] watt_domain_mask = 0 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_domain_mask = $((2**numa_nodes -1)) failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_domain_mask = -1 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_domain_mask = $((2**numa_nodes)) failed"
```

- 涉及命令：sed×4, grep×2

#### oe_test_eagle_19

- 描述：set parameter [sched_service] watt_first_domain test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_first_domain = ${arr[0]} failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_first_domain = ${arr[-1]} failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_first_domain = $((arr[0] - 1)) failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_first_domain = $((arr[-1] + 1)) failed"
```

- 涉及命令：sed×5, grep×2

#### oe_test_eagle_20

- 描述：set parameter [sched_service] watt_procs test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_procs=all failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_procs=sh test1.sh|test2.sh failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] watt_procs= failed"
```

- 涉及命令：sed×3, kill×3

#### oe_test_eagle_21

- 描述：set parameter [sched_service] smart_grid_enable test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Check [sched_service] smart_grid_eable=0 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_eable=1 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_eable=-1 failed"
```

- 涉及命令：sed×6, grep×1

#### oe_test_eagle_22

- 描述：set parameter [sched_service] smart_grid_vip_procs test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_vip_procs=all failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_vip_procs=sh test1.sh|test2.sh failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_vip_procs= failed"
```

- 涉及命令：sed×3, kill×3

#### oe_test_eagle_23

- 描述：set parameter [sched_service] smart_grid_gov_enable test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Check [sched_service] smart_grid_gov_enable=0 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_gov_enable=1 failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_gov_enable=-1 failed"
```

- 涉及命令：sed×3, grep×1

#### oe_test_eagle_24

- 描述：set parameter [sched_service] smart_grid_vip_gov test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_vip_gov is exists failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_vip_gov is not support failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_vip_gov is not exists failed"
```

- 涉及命令：sed×4, grep×1

#### oe_test_eagle_25

- 描述：set parameter [sched_service] smart_grid_lev1_gov test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_lev1_gov is exists failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_lev1_gov is not support failed"
  CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_lev1_gov is not exists failed"
```

- 涉及命令：sed×4, grep×1

#### oe_test_eagle_26

- 描述：set parameter [freq_service] enable test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Check [freq_service] enable=0 failed"
  CHECK_RESULT $? 0 0 "Check [freq_service] enable=1 failed"
  CHECK_RESULT $? 0 0 "Check [freq_service] enable=-1 failed"
```

- 涉及命令：sed×5, grep×1

#### oe_test_eagle_27

- 描述：set parameter [freq_service] freq_lib test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check freq_lib default config failed"
  CHECK_RESULT $? 0 0 "Check freq_lib = test.so failed"
  CHECK_RESULT $? 1 0 "Check freq_lib = libidle_service.so failed"
```

- 涉及命令：sed×2, grep×1

#### oe_test_eagle_28

- 描述：set parameter [freq_service] cpufreq_gov test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check cpufreq_gov = ${available_governors[-1]} failed"
  CHECK_RESULT $? 0 0 "Check cpufreq_gov = seep failed"
  CHECK_RESULT $? 0 0 "Check cpufreq_gov = test failed"
```

- 涉及命令：sed×4, grep×2

#### oe_test_eagle_29

- 描述：set parameter [freq_service] sampling_rate_us test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check sampling_rate_us = 0 failed"
  CHECK_RESULT $? 0 0 "Check sampling_rate_us = 10000000 failed"
  CHECK_RESULT $? 0 0 "Check sampling_rate_us = -1 failed"
  CHECK_RESULT $? 0 0 "Check sampling_rate_us = 10000001 failed"
```

- 涉及命令：sed×5, grep×2

#### oe_test_eagle_30

- 描述：set parameter [freq_service] perf_loss_rate test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check perf_loss_rate = -1 failed"
  CHECK_RESULT $? 0 0 "Check perf_loss_rate = 100 failed"
  CHECK_RESULT $? 0 0 "Check perf_loss_rate = -2 failed"
  CHECK_RESULT $? 0 0 "Check perf_loss_rate = 101 failed"
```

- 涉及命令：sed×6, grep×2

#### oe_test_eagle_31

- 描述：set parameter [idle_service] enable test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check [idle_service] enable = 0 failed"
  CHECK_RESULT $? 0 0 "Check [idle_service] enable = 1 failed"
  CHECK_RESULT $? 0 0 "Check [idle_service] enable = -1 failed"
```

- 涉及命令：sed×4, grep×1

#### oe_test_eagle_32

- 描述：set parameter [idle_service] idle_lib test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check idle_lib default config failed"
  CHECK_RESULT $? 0 0 "Check idle_lib = test.so failed"
  CHECK_RESULT $? 1 0 "Check idle_lib = libfreq_service.so failed"
```

- 涉及命令：sed×3, grep×1

#### oe_test_eagle_33

- 描述：set parameter [idle_service] cpuidle_gov test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check [idle_service] cpuidle_gov config exists governor failed"
  CHECK_RESULT $? 0 0 "Check [idle_service] cpuidle_gov = test failed"
  CHECK_RESULT $? 0 0 "Check CpuIdleGov failed"
```

- 涉及命令：sed×3, grep×1

#### oe_test_eagle_34

- 描述：set parameter [mpc_service] enable test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Check [mpc_service] enable = 0 failed"
  CHECK_RESULT $? 0 0 "Check [mpc_service] enable = 1 failed"
  CHECK_RESULT $? 0 0 "Check [mpc_service] enable = -1 failed"
```

- 涉及命令：sed×3, grep×1

#### oe_test_eagle_35

- 描述：set parameter [mpc_service] mpc_lib test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "Check mpc_lib default config failed"
  CHECK_RESULT $? 0 0 "Check mpc_lib = test.so failed"
  CHECK_RESULT $? 1 0 "Check mpc_lib = libidle_service.so failed"
```

- 涉及命令：sed×3, grep×1

#### oe_test_eagle_36

- 描述：set parameter [mpc_service] enable_mpc test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check mpctool.service enable failed"
  CHECK_RESULT $? 0 0 "Check mpctool.service disable failed"
  CHECK_RESULT $? 0 0 "Check Error: seg:[mpc_service] item:enable_mpc value failed"
```

- 涉及命令：sed×4, grep×1

#### oe_test_eagle_37

- 描述：user eagle force released by root test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check user root RequestControlAuth failed"
  CHECK_RESULT $? 0 0 "Check user eagle Not authorized failed"
  CHECK_RESULT $? 0 0 "Check user eagle force released by root failed"
```

#### oe_test_eagle_38

- 描述：parameter restore test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "parameter watt_threshold、watt_interval_ms、watt_domain_mask set failed"
  CHECK_RESULT $? 0 0 "parameter watt_threshold、watt_interval_ms、watt_domain_mask restore failed"
```

- 涉及命令：sed×3

#### oe_test_service_eagle_39

- 描述：eagle.service restart test
- 函数：`pre_test, run_test, post_test`