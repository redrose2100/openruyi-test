# powerapi_interface

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/powerapi_interface` |
| 注册用例数 | 95 |
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
| oe_test_interface_powerapi_07 | PWR_UnRegister() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_08 | PWR_RequestControlAuth() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_09 | PWR_RequestControlAuth() test1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_10 | PWR_RequestControlAuth() observer=test1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_11 | PWR_RequestControlAuth() test1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_12 | PWR_ReleaseControlAuth() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_13 | PWR_CPU_GetInfo() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_14 | PWR_CPU_GetFreqAbility() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_15 | PWR_CPU_GetFreqGovernor() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_16 | PWR_CPU_GetFreqGovernor() test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_interface_powerapi_17 | PWR_CPU_SetFreqGovernor() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_18 | PWR_CPU_GetFreqGovAttrs() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_19 | PWR_CPU_GetFreqGovAttr() exists attr test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_20 | PWR_CPU_GetFreqGovAttr() no exists attr test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_21 | PWR_CPU_GetFreqGovAttr() no exists attr test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_23 | PWR_CPU_SetFreqGovAttr() failure test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_24 | PWR_CPU_SetFreqGovAttr() failure test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_25 | PWR_CPU_GetFreqRange() success test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_26 | PWR_CPU_SetFreqRange() [min, max] test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_27 | PWR_CPU_SetFreqRange() [min-1, max+1] test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_28 | PWR_CPU_SetFreqRange() [min+1, max-1] test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_29 | PWR_CPU_SetFreqRange() [min+2, max+3] test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_30 | PWR_CPU_GetFreq() num = TEST_CORE_NUM;spec = 0 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_31 | PWR_CPU_GetFreq() num = 2;spec = 0 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_33 | PWR_CPU_SetFreq() failure test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_34 | PWR_CPU_SetFreq() success test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_35 | PWR_CPU_SetFreq() failure test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_36 | PWR_CPU_SetFreq() failure test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_37 | PWR_CPU_GetIdleInfo() success test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_38 | PWR_CPU_GetIdleGovernor() success test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_40 | PWR_CPU_DmaGetLatency() success test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_41 | PWR_CPU_DmaSetLatency() latency=0 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_42 | PWR_CPU_DmaSetLatency() latency=2000000000 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_43 | PWR_CPU_DmaSetLatency() latency=-1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_44 | PWR_CPU_DmaSetLatency() latency=2000000001 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_45 | PWR_CPU_DmaSetLatency() latency=-0.99 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_46 | PWR_CPU_DmaSetLatency() latency=1.9 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_47 | set file_size=1 cmp_cnt=2 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_48 | modify log_path log_pfx test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_49 | log_level test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_powerapi_50 | pwrapis.service restart test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_powerapi_51 | pwrapis.service restart test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_interface_powerapi_52 | PWR_CPU_GetInfo test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_53 | normal user PWR_CPU_GetInfo test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_54 | PWR_SetClientSockPath() the path is not exist test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_55 | PWR_SetClientSockPath() the path is exist test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_56 | normal user PWR_SetClientSockPath() the path is not exist test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_57 | normal user PWR_SetClientSockPath() the path is exist test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_58 | PWR_CreateDcTask() and PWR_DeleteDcTask() test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_interface_powerapi_59 | PWR_CreateDcTask() param about boundary value test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_interface_powerapi_60 | normal user PWR_CreateDcTask() and PWR_DeleteDcTask() repeat test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_interface_powerapi_61 | normal user PWR_CreateDcTask() param about boundary value repeat test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_interface_powerapi_62 | normal user not permission about SetEventCallback() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_63 | SetEventCallback() test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_interface_powerapi_65 | root user PWR_SYS_SetPowerState() state -1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_67 | normal user PWR_SYS_SetPowerState() state -1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_68 | SYS_GetRtPowerInfo() test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_interface_powerapi_69 | general user SYS_GetRtPowerInfo() test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_interface_powerapi_70 | PWR_CPU_GetUsage() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_71 | general user PWR_CPU_GetUsage() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_72 | PWR_CPU_GetPerfData() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_73 | general user PWR_CPU_GetPerfData() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_74 | root user PWR_HBM_GetSysState() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_75 | normal user PWR_HBM_GetSysState()  test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_78 | root user PWR_HBM_SetAllPwrState() state -1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_81 | normal user PWR_HBM_SetAllPwrState() state -1 test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_82 | PWR_PROC_QueryProcs() about a single keyword exists test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_83 | PWR_PROC_QueryProcs() about multiple keywords exists test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_84 | PWR_PROC_QueryProcs() about multiple non-existent keywords test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_85 | PWR_PROC_QueryProcs() about the keyword is empty test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_86 | PWR_PROC_QueryProcs() about the keyword contains spaces test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_87 | PWR_PROC_QueryProcs() boundary value test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_interface_powerapi_88 | PWR_PROC_GetWattState() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_89 | PWR_PROC_SetWattState() test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_interface_powerapi_90 | general user PWR_PROC_GetWattState() test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_interface_powerapi_91 | general user PWR_PROC_SetWattState() test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_interface_powerapi_92 | PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(0) test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_interface_powerapi_93 | PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(1) test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_interface_powerapi_94 | general user PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(0) test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_interface_powerapi_95 | general user PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(1) test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_interface_powerapi_96 | PWR_PROC_GetWattAttrs() and PWR_PROC_SetWattAttrs() test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_interface_powerapi_97 | general user PWR_PROC_GetWattAttrs() and PWR_PROC_SetWattAttrs() test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_interface_powerapi_98 | PWR_PROC_GetWattProcs(), PWR_PROC_AddWattProcs() and PWR_PROC_DelWattProcs() test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_interface_powerapi_99 | PWR_PROC_AddWattProcs() the param procs is not exist test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_interface_powerapi_100 | PWR_PROC_QueryProcs() boundary value test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_interface_powerapi_101 | TEST_PWR_PROC_SetAndGetSmartGridState() test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_interface_powerapi_102 | PWR_PROC_SetSmartGridLevel() test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_interface_powerapi_103 | PWR_PROC_SetSmartGridLevel() procs boundary value test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_interface_powerapi_104 | PWR_PROC_GetSmartGridGov() and PWR_PROC_SetSmartGridGov() test | pre_test/run_test/post_test | 5 | ✔ |  |  |

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

#### oe_test_interface_powerapi_07

- 描述：PWR_UnRegister() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_UnRegister failed"
```

#### oe_test_interface_powerapi_08

- 描述：PWR_RequestControlAuth() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_RequestControlAuth failed"
```

#### oe_test_interface_powerapi_09

- 描述：PWR_RequestControlAuth() test1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_RequestControlAuth failed"
```

- 涉及命令：sed×1, userdel×1

#### oe_test_interface_powerapi_10

- 描述：PWR_RequestControlAuth() observer=test1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_RequestControlAuth failed"
```

- 涉及命令：sed×1, userdel×1

#### oe_test_interface_powerapi_11

- 描述：PWR_RequestControlAuth() test1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_RequestControlAuth failed"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_interface_powerapi_12

- 描述：PWR_ReleaseControlAuth() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_ReleaseControlAuth failed"
```

#### oe_test_interface_powerapi_13

- 描述：PWR_CPU_GetInfo() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetInfo failed"
```

#### oe_test_interface_powerapi_14

- 描述：PWR_CPU_GetFreqAbility() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqAbility failed"
```

#### oe_test_interface_powerapi_15

- 描述：PWR_CPU_GetFreqGovernor() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqGovernor failed"
```

#### oe_test_interface_powerapi_16

- 描述：PWR_CPU_GetFreqGovernor() test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqGovernor failed"
  CHECK_RESULT $? 0 0 "Check test log failed"
```

#### oe_test_interface_powerapi_17

- 描述：PWR_CPU_SetFreqGovernor() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqGovernor failed"
```

#### oe_test_interface_powerapi_18

- 描述：PWR_CPU_GetFreqGovAttrs() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqGovAttrs failed"
```

#### oe_test_interface_powerapi_19

- 描述：PWR_CPU_GetFreqGovAttr() exists attr test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqGovAttr exists attr failed"
```

#### oe_test_interface_powerapi_20

- 描述：PWR_CPU_GetFreqGovAttr() no exists attr test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqGovAttr no exists attr failed"
```

#### oe_test_interface_powerapi_21

- 描述：PWR_CPU_GetFreqGovAttr() no exists attr test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqGovAttr no exists attr failed"
```

#### oe_test_interface_powerapi_23

- 描述：PWR_CPU_SetFreqGovAttr() failure test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqGovAttr failure failed"
```

#### oe_test_interface_powerapi_24

- 描述：PWR_CPU_SetFreqGovAttr() failure test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqGovAttr failure failed"
```

#### oe_test_interface_powerapi_25

- 描述：PWR_CPU_GetFreqRange() success test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreqRange failed"
```

#### oe_test_interface_powerapi_26

- 描述：PWR_CPU_SetFreqRange() [min, max] test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqRange failed"
```

#### oe_test_interface_powerapi_27

- 描述：PWR_CPU_SetFreqRange() [min-1, max+1] test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqRange failed"
```

#### oe_test_interface_powerapi_28

- 描述：PWR_CPU_SetFreqRange() [min+1, max-1] test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqRange failed"
```

#### oe_test_interface_powerapi_29

- 描述：PWR_CPU_SetFreqRange() [min+2, max+3] test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreqRange failed"
```

#### oe_test_interface_powerapi_30

- 描述：PWR_CPU_GetFreq() num = TEST_CORE_NUM;spec = 0 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreq failed"
```

#### oe_test_interface_powerapi_31

- 描述：PWR_CPU_GetFreq() num = 2;spec = 0 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetFreq failed"
```

#### oe_test_interface_powerapi_33

- 描述：PWR_CPU_SetFreq() failure test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreq failed"
```

#### oe_test_interface_powerapi_34

- 描述：PWR_CPU_SetFreq() success test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreq failed"
```

#### oe_test_interface_powerapi_35

- 描述：PWR_CPU_SetFreq() failure test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreq failed"
```

#### oe_test_interface_powerapi_36

- 描述：PWR_CPU_SetFreq() failure test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_SetFreq failed"
```

#### oe_test_interface_powerapi_37

- 描述：PWR_CPU_GetIdleInfo() success test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetIdleInfo failed"
```

#### oe_test_interface_powerapi_38

- 描述：PWR_CPU_GetIdleGovernor() success test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_GetIdleGovernor failed"
```

#### oe_test_interface_powerapi_40

- 描述：PWR_CPU_DmaGetLatency() success test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_DmaGetLatency failed"
```

#### oe_test_interface_powerapi_41

- 描述：PWR_CPU_DmaSetLatency() latency=0 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_DmaSetLatency latency=0 failed"
```

#### oe_test_interface_powerapi_42

- 描述：PWR_CPU_DmaSetLatency() latency=2000000000 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_DmaSetLatency latency=2000000000 failed"
```

#### oe_test_interface_powerapi_43

- 描述：PWR_CPU_DmaSetLatency() latency=-1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_DmaSetLatency latency=-1 failed"
```

#### oe_test_interface_powerapi_44

- 描述：PWR_CPU_DmaSetLatency() latency=2000000001 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_DmaSetLatency latency=2000000001 failed"
```

#### oe_test_interface_powerapi_45

- 描述：PWR_CPU_DmaSetLatency() latency=-0.99 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_DmaSetLatency latency=-0.99 failed"
```

#### oe_test_interface_powerapi_46

- 描述：PWR_CPU_DmaSetLatency() latency=1.9 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CPU_DmaSetLatency latency=1.9 failed"
```

#### oe_test_interface_powerapi_47

- 描述：set file_size=1 cmp_cnt=2 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_RequestControlAuth failed"
```

- 涉及命令：sed×3, pgrep×1

#### oe_test_interface_powerapi_48

- 描述：modify log_path log_pfx test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check log path failed"
```

- 涉及命令：sed×2, test×1

#### oe_test_interface_powerapi_49

- 描述：log_level test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check log failed"
  CHECK_RESULT $? 0 0 "Check log failed"
  CHECK_RESULT $? 0 0 "Check log failed"
  CHECK_RESULT $? 0 0 "Check log failed"
```

- 涉及命令：sed×4

#### oe_test_service_powerapi_50

- 描述：pwrapis.service restart test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "pwrapis.service stop failed"
  CHECK_RESULT $? 0 0 "pwrapis.service start failed"
```

- 涉及命令：sed×1

#### oe_test_service_powerapi_51

- 描述：pwrapis.service restart test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "pwrapis.service stop failed"
  CHECK_RESULT $? 0 0 "pwrapis.service start failed"
```

- 涉及命令：sed×1

#### oe_test_interface_powerapi_52

- 描述：PWR_CPU_GetInfo test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check Get Sock failed"
```

#### oe_test_interface_powerapi_53

- 描述：normal user PWR_CPU_GetInfo test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check Get NormalUser Sock failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_54

- 描述：PWR_SetClientSockPath() the path is not exist test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetClientSockPath failed"
```

#### oe_test_interface_powerapi_55

- 描述：PWR_SetClientSockPath() the path is exist test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetClientSockPath failed"
```

#### oe_test_interface_powerapi_56

- 描述：normal user PWR_SetClientSockPath() the path is not exist test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetClientSockPath failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_57

- 描述：normal user PWR_SetClientSockPath() the path is exist test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SetClientSockPath failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_58

- 描述：PWR_CreateDcTask() and PWR_DeleteDcTask() test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 1 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 2 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 3 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 4 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is -1 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 1 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 2 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 3 failed"
  CHECK_RESULT $? 0 0 "Check PWR_COM_DATATYPE_CPU_USAGE failed"
  CHECK_RESULT $? 0 0 "Check PWR_COM_DATATYPE_CPU_PERF failed"
```

- 涉及命令：grep×8

#### oe_test_interface_powerapi_59

- 描述：PWR_CreateDcTask() param about boundary value test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 1000 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 100000000 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 999 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 100000001 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 1 failed"
```

- 涉及命令：grep×5

#### oe_test_interface_powerapi_60

- 描述：normal user PWR_CreateDcTask() and PWR_DeleteDcTask() repeat test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 1 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 2 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 3 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is 4 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param dataType is -1 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 1 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 2 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 3 failed"
  CHECK_RESULT $? 0 0 "Check PWR_COM_DATATYPE_CPU_USAGE failed"
  CHECK_RESULT $? 0 0 "Check PWR_COM_DATATYPE_CPU_PERF failed"
```

- 涉及命令：grep×8, sed×2, userdel×1

#### oe_test_interface_powerapi_61

- 描述：normal user PWR_CreateDcTask() param about boundary value repeat test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 1000 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 100000000 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 999 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_CreateDcTask with Param interval is 100000001 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_DeleteDcTask with Param dataType is 1 failed"
```

- 涉及命令：grep×5, sed×2, userdel×1

#### oe_test_interface_powerapi_62

- 描述：normal user not permission about SetEventCallback() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_SetEventCallback failed"
```

- 涉及命令：userdel×1

#### oe_test_interface_powerapi_63

- 描述：SetEventCallback() test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_SetEventCallback failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_SetEventCallback about papis.log info failed"
```

- 涉及命令：sed×2, grep×1, userdel×1

#### oe_test_interface_powerapi_65

- 描述：root user PWR_SYS_SetPowerState() state -1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SYS_SetPowerState() state -1 failed"
```

#### oe_test_interface_powerapi_67

- 描述：normal user PWR_SYS_SetPowerState() state -1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_SYS_SetPowerState() state -1 failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_68

- 描述：SYS_GetRtPowerInfo() test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about sysPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about cpuPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about memPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about cpuPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about memPower failed"
```

#### oe_test_interface_powerapi_69

- 描述：general user SYS_GetRtPowerInfo() test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about sysPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about cpuPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about memPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about cpuPower failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_SYS_GetRtPowerInfo about memPower failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_70

- 描述：PWR_CPU_GetUsage() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 'Check interface TEST_PWR_CPU_GetUsage failed'
```

- 涉及命令：gcc×1, taskset×1

#### oe_test_interface_powerapi_71

- 描述：general user PWR_CPU_GetUsage() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 'Check interface TEST_PWR_CPU_GetUsage failed'
```

- 涉及命令：sed×2, gcc×1, taskset×1, userdel×1

#### oe_test_interface_powerapi_72

- 描述：PWR_CPU_GetPerfData() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_CPU_GetPerfData failed"
```

#### oe_test_interface_powerapi_73

- 描述：general user PWR_CPU_GetPerfData() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_CPU_GetPerfData failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_74

- 描述：root user PWR_HBM_GetSysState() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_HBM_GetSysState() failed"
```

#### oe_test_interface_powerapi_75

- 描述：normal user PWR_HBM_GetSysState()  test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_HBM_GetSysState()  failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_78

- 描述：root user PWR_HBM_SetAllPwrState() state -1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_HBM_SetAllPwrState() state -1 failed"
```

#### oe_test_interface_powerapi_81

- 描述：normal user PWR_HBM_SetAllPwrState() state -1 test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_HBM_SetAllPwrState() state -1 failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_82

- 描述：PWR_PROC_QueryProcs() about a single keyword exists test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
```

#### oe_test_interface_powerapi_83

- 描述：PWR_PROC_QueryProcs() about multiple keywords exists test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
```

- 涉及命令：gcc×1

#### oe_test_interface_powerapi_84

- 描述：PWR_PROC_QueryProcs() about multiple non-existent keywords test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
```

- 涉及命令：grep×1

#### oe_test_interface_powerapi_85

- 描述：PWR_PROC_QueryProcs() about the keyword is empty test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
```

#### oe_test_interface_powerapi_86

- 描述：PWR_PROC_QueryProcs() about the keyword contains spaces test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
```

- 涉及命令：grep×1, kill×1

#### oe_test_interface_powerapi_87

- 描述：PWR_PROC_QueryProcs() boundary value test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_QueryProcs failed"
```

- 涉及命令：grep×4, pkill×1

#### oe_test_interface_powerapi_88

- 描述：PWR_PROC_GetWattState() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattState failed"
```

#### oe_test_interface_powerapi_89

- 描述：PWR_PROC_SetWattState() test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetWattState failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattState is enable failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattState is disable failed"
```

#### oe_test_interface_powerapi_90

- 描述：general user PWR_PROC_GetWattState() test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattState failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_91

- 描述：general user PWR_PROC_SetWattState() test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetWattState failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattState is enable failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattState is disable failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_92

- 描述：PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(0) test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Online failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Offline or notExist failed"
```

#### oe_test_interface_powerapi_93

- 描述：PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(1) test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Online failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Offline or notExist failed"
```

#### oe_test_interface_powerapi_94

- 描述：general user PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(0) test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Online failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is notExist failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Offline failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_95

- 描述：general user PWR_PROC_SetWattFirstDomain() and PWR_PROC_SetWattState(1) test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Online failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is notExist failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_RebuildAffinityDomain is Offline failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_96

- 描述：PWR_PROC_GetWattAttrs() and PWR_PROC_SetWattAttrs() test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs all param are set to 0 failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 100, 3600000, $((DMask-1)) failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are -1, -1, $((DMask-1)) or 101, 3600001, $((DMask-1)) failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 0, 0, 1 failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 0, 0, ${DMask} failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs all param are set to default values failed"
```

#### oe_test_interface_powerapi_97

- 描述：general user PWR_PROC_GetWattAttrs() and PWR_PROC_SetWattAttrs() test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs all param are set to 0 failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 100, 3600000, $((DMask-1)) failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are -1, -1, $((DMask-1)) or 101, 3600001, $((DMask-1)) failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 0, 0, 1 failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs param are 0, 0, ${DMask} failed"
  CHECK_RESULT $? 0 0 "Check interface TEST_PWR_PROC_SetAndGetWattAttrs all param are set to default values failed"
```

- 涉及命令：sed×2, userdel×1

#### oe_test_interface_powerapi_98

- 描述：PWR_PROC_GetWattProcs(), PWR_PROC_AddWattProcs() and PWR_PROC_DelWattProcs() test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetWattProcs if no proc failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_DelWattProcs failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetWattProcs after del failed"
```

- 涉及命令：iperf3×1, kill×1

#### oe_test_interface_powerapi_99

- 描述：PWR_PROC_AddWattProcs() the param procs is not exist test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetWattProcs if no proc failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetWattProcs after del failed"
```

#### oe_test_interface_powerapi_100

- 描述：PWR_PROC_QueryProcs() boundary value test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_AddWattProcs failed"
```

- 涉及命令：sed×6, pkill×4, grep×3

#### oe_test_interface_powerapi_101

- 描述：TEST_PWR_PROC_SetAndGetSmartGridState() test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetSmartGridState failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridState(PWR_ENABLE) failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridState(PWR_DISABLE) failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridState(-1) failed"
```

- 涉及命令：grep×2

#### oe_test_interface_powerapi_102

- 描述：PWR_PROC_SetSmartGridLevel() test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel single task level=0 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel single task level=1 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel multiple task level=0 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel multiple task level=0 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel multiple task level=1 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel multiple task level=1 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel level=-1 failed"
```

- 涉及命令：sed×15, grep×4, pkill×4

#### oe_test_interface_powerapi_103

- 描述：PWR_PROC_SetSmartGridLevel() procs boundary value test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=0 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=0 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=1 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5000 level=1 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5001 level=0 failed"
  CHECK_RESULT $? 1 0 "Check interface SetSmartGridLevel procs is 5001 level=0 failed"
  CHECK_RESULT $? 0 0 "Check interface SetSmartGridLevel procs is 5001 level=1 failed"
  CHECK_RESULT $? 1 0 "Check interface SetSmartGridLevel procs is 5001 level=1 failed"
```

- 涉及命令：sed×12, pkill×3, grep×2, pgrep×1

#### oe_test_interface_powerapi_104

- 描述：PWR_PROC_GetSmartGridGov() and PWR_PROC_SetSmartGridGov() test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_GetSmartGridGov() failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov(1, \"performance\", \"conservative\") failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov() params about sgAgentState,level0Gov,level1Gov:1,not exist or 1,the length is 31 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov() params about sgAgentState,level0Gov,level1Gov:1, the length is 32 failed"
  CHECK_RESULT $? 0 0 "Check interface PWR_PROC_SetSmartGridGov(0, \"ondemand\", \"userspace\") failed"
```

- 涉及命令：grep×2
