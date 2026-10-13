# elasticMem

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/elasticMem` |
| 注册用例数 | 27 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_elasticMem_common_fun_001 | Verify log_level takes effect at each level | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_elasticMem_common_fun_002 | Verify paral whitelist only takes the first keyword | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_elasticMem_common_fun_003 | Verify light mode does not filter when whitelist is empty | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_elasticMem_common_fun_004 | Verify specifying config file path via command line argument | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_elasticMem_config_fun_001 | Verify default policy=paral service start | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_elasticMem_config_fun_002 | Verify policy=light service start and cgroup creation | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_elasticMem_config_fun_003 | Verify invalid policy value causes startup failure | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_elasticMem_config_fun_004 | Verify paral<->light switch requires restart | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_elasticMem_config_fun_005 | Verify startup fails when the config file is missing | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_elasticMem_light_fun_001 | Verify light mode creates em_node cgroups | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_elasticMem_light_fun_002 | Verify CPU load balancing placement | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_elasticMem_light_fun_003 | Verify memory_migration=true triggers memory migration | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_elasticMem_light_fun_004 | Verify processes bound to non-em_node cgroups are filtered | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_elasticMem_light_fun_005 | Verify memory_migration=false does not migrate memory | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_elasticMem_light_fun_006 | Verify sample_interval and sample_count affect tune frequency | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_elasticMem_light_fun_007 | Verify low load skips balance | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_elasticMem_light_fun_008 | Verify balance triggers under load imbalance | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_elasticMem_paral_fun_001 | Verify paral distributes processes round-robin across NUMA | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_elasticMem_paral_fun_002 | Verify nr_cpus binding range is correct | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_elasticMem_paral_fun_003 | Verify slot reuse after process exit | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_elasticMem_paral_fun_004 | Verify short-lived processes are not missed | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_elasticMem_paral_fun_005 | Verify comm_whitelist filtering | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_elasticMem_paral_fun_006 | Verify nr_cpus exceeding node CPU count causes startup failure | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_elasticMem_paral_fun_007 | Verify paral capacity_scheduling rotates by numa weights | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_elasticMem_compact_ras_001 | Verify compact_memory interaction | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_elasticMem_concurrent_ras_001 | Verify first instance survives a second instance launch | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_elasticMem_process_ras_001 | Verify graceful exit on SIGTERM | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_elasticMem_common_fun_001

- 描述：Verify log_level takes effect at each level
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "no log output for level=$level"
  CHECK_RESULT $? 0 0 "level=debug did not emit [DEBUG] lines"
  CHECK_RESULT $? 0 0 "level=$level leaked [DEBUG] lines"
```

#### oe_test_elasticMem_common_fun_002

- 描述：Verify paral whitelist only takes the first keyword
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "process with first keyword failed to start"
  CHECK_RESULT $? 0 0 "process with second keyword failed to start"
  CHECK_RESULT $? 0 0 "process without keyword failed to start"
  CHECK_RESULT $? 0 0 "first keyword process not bound by paral (affinity=$aff1)"
  CHECK_RESULT $? 0 0 "second keyword was honoured unexpectedly (affinity=$aff2)"
  CHECK_RESULT $? 0 0 "process without keyword was bound unexpectedly (affinity=$aff3)"
```

- 涉及命令：bash×3, kill×3

#### oe_test_elasticMem_common_fun_003

- 描述：Verify light mode does not filter when whitelist is empty
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "test process failed to start"
  CHECK_RESULT $? 0 0 "process not assigned to any cgroup"
```

- 涉及命令：bash×1, kill×1

#### oe_test_elasticMem_common_fun_004

- 描述：Verify specifying config file path via command line argument
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "elasticMem custom-config process failed to start"
  CHECK_RESULT $? 0 0 "elasticMem not running with custom config"
  CHECK_RESULT $? 0 0 "custom log file not created"
  CHECK_RESULT $? 0 0 "config not loaded from custom path"
  CHECK_RESULT $? 1 0 "SIGTERM graceful exit failed"
```

- 涉及命令：mkdir×1, kill×1, grep×1

#### oe_test_elasticMem_config_fun_001

- 描述：Verify default policy=paral service start
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "policy not set to paral"
  CHECK_RESULT $? 0 0 "service not active"
  CHECK_RESULT $? 0 0 "elasticMem process not found"
```

- 涉及命令：pgrep×1

#### oe_test_elasticMem_config_fun_002

- 描述：Verify policy=light service start and cgroup creation
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "policy not light"
  CHECK_RESULT $? 0 0 "service not active"
  CHECK_RESULT $? 0 0 "cgroup em_node$i not found"
  CHECK_RESULT $? 0 0 "cpuset.cpus missing for em_node$i"
  CHECK_RESULT $? 0 0 "cpuset.mems missing for em_node$i"
```

#### oe_test_elasticMem_config_fun_003

- 描述：Verify invalid policy value causes startup failure
- 函数：`pre_test, run_test, post_test`
#### oe_test_elasticMem_config_fun_004

- 描述：Verify paral<->light switch requires restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "em_node0 cgroup not created after switch"
```

- 涉及命令：sed×1

#### oe_test_elasticMem_config_fun_005

- 描述：Verify startup fails when the config file is missing
- 函数：`pre_test, run_test, post_test`
#### oe_test_elasticMem_light_fun_001

- 描述：Verify light mode creates em_node cgroups
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "cgroup em_node$i not found"
  CHECK_RESULT $? 0 0 "cpuset.cpus empty for em_node$i"
  CHECK_RESULT $? 0 0 "cpuset.mems empty for em_node$i"
  CHECK_RESULT $? 0 0 "found unexpected elasticMem_ cgroup naming"
```

#### oe_test_elasticMem_light_fun_002

- 描述：Verify CPU load balancing placement
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "cpu load failed to start"
  CHECK_RESULT $? 0 0 "new process failed to start"
  CHECK_RESULT $? 0 0 "new process not assigned to em_node cgroup"
```

- 涉及命令：pgrep×1, bash×1, kill×1

#### oe_test_elasticMem_light_fun_003

- 描述：Verify memory_migration=true triggers memory migration
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "memory load process failed to start"
  CHECK_RESULT $? 0 0 "process not in em_node cgroup"
```

- 涉及命令：kill×1, grep×1

#### oe_test_elasticMem_light_fun_004

- 描述：Verify processes bound to non-em_node cgroups are filtered
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test process failed to start"
  CHECK_RESULT $? 0 0 "process not bound to manual_test"
  CHECK_RESULT $? 0 0 "process was moved from manual_test cgroup"
```

- 涉及命令：grep×2, mkdir×1, bash×1, kill×1

#### oe_test_elasticMem_light_fun_005

- 描述：Verify memory_migration=false does not migrate memory
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "memory load process failed to start"
```

- 涉及命令：kill×1

#### oe_test_elasticMem_light_fun_006

- 描述：Verify sample_interval and sample_count affect tune frequency
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×2

#### oe_test_elasticMem_light_fun_007

- 描述：Verify low load skips balance
- 函数：`pre_test, run_test, post_test`
#### oe_test_elasticMem_light_fun_008

- 描述：Verify balance triggers under load imbalance
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "cpu load failed to start"
  CHECK_RESULT $? 0 0 "extra cpu load failed to start"
```

- 涉及命令：pgrep×1, kill×1

#### oe_test_elasticMem_paral_fun_001

- 描述：Verify paral distributes processes round-robin across NUMA
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test processes failed to start"
  CHECK_RESULT $? 0 0 "some processes were not pinned to any node"
  CHECK_RESULT $? 0 0 "NUMA distribution not uniform"
```

- 涉及命令：bash×1, kill×1, declare×1

#### oe_test_elasticMem_paral_fun_002

- 描述：Verify nr_cpus binding range is correct
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test process 1 failed to start"
  CHECK_RESULT $? 0 0 "test process 2 failed to start"
  CHECK_RESULT "$n" "$NR" 0 "PID $pid bound to $n cpus, expected nr_cpus=$NR (list=$aff)"
```

- 涉及命令：bash×2, kill×2

#### oe_test_elasticMem_paral_fun_003

- 描述：Verify slot reuse after process exit
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "process A failed to start"
  CHECK_RESULT $? 0 0 "process B failed to start"
  CHECK_RESULT $? 0 0 "process B was not pinned by paral"
  CHECK_RESULT $? 0 0 "process C failed to start"
  CHECK_RESULT $? 0 0 "process C was not pinned by paral"
  CHECK_RESULT $? 0 0 "C got same affinity as B, slot not rotated"
```

- 涉及命令：bash×3, kill×3

#### oe_test_elasticMem_paral_fun_004

- 描述：Verify short-lived processes are not missed
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "short-lived processes failed to start"
  CHECK_RESULT $? 0 0 "capture rate too low: $count/50"
```

- 涉及命令：bash×1, kill×1

#### oe_test_elasticMem_paral_fun_005

- 描述：Verify comm_whitelist filtering
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "comm_whitelist filter not set"
```

#### oe_test_elasticMem_paral_fun_006

- 描述：Verify nr_cpus exceeding node CPU count causes startup failure
- 函数：`pre_test, run_test, post_test`
#### oe_test_elasticMem_paral_fun_007

- 描述：Verify paral capacity_scheduling rotates by numa weights
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT "$order_len" "$sum" 0 "schedule length $order_len != sum(weights) $sum"
  CHECK_RESULT "$cnt" "$expected" 0 "node$i appears $cnt times in schedule, expected $expected"
  CHECK_RESULT "$ok" 1 0 "schedule order mismatch (expect ${EM_CAP_DOC_ORDER[*]})"
  CHECK_RESULT "$got" "${EM_CAP_ORDER[$idx]}" 0 \
  CHECK_RESULT "${cnt[$i]:-0}" "$expected" 0 "node$i placement count != weight $expected"
```

- 涉及命令：bash×1, declare×1

#### oe_test_elasticMem_compact_ras_001

- 描述：Verify compact_memory interaction
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "fragmentation workload failed to start"
  CHECK_RESULT $? 0 0 "service died after compact_memory #$i"
```

- 涉及命令：kill×1

#### oe_test_elasticMem_concurrent_ras_001

- 描述：Verify first instance survives a second instance launch
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "second elasticMem instance failed to start"
  CHECK_RESULT $? 0 0 "first instance was affected"
```

- 涉及命令：kill×1

#### oe_test_elasticMem_process_ras_001

- 描述：Verify graceful exit on SIGTERM
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "paral process still alive after SIGTERM"
  CHECK_RESULT $? 0 0 "trace event not disabled after exit"
  CHECK_RESULT $? 1 0 "light process still alive after SIGTERM"
```
