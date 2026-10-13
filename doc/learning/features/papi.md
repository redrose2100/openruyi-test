# papi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/papi` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_papi_avail_01 | verify the uasge of papi command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_papi_avail_02 | verify the uasge of papi command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_papi_command_line | verify the uasge of papi command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_papi_native_avail_01 | verify the uasge of papi command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_papi_native_avail_02 | verify the uasge of papi command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_papi_xml_event_info | verify the uasge of papi command | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_papi_avail_01

- 描述：verify the uasge of papi command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check papi_avail failed"
  CHECK_RESULT $? 0 0 "Check papi_avail -h failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --avail failed"
  CHECK_RESULT $? 0 0 "Check papi_avail -a failed"
  CHECK_RESULT $? 0 0 "Check papi_avail -c failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --check failed"
  CHECK_RESULT $? 0 0 "Check papi_avail -d failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --detail failed"
  CHECK_RESULT $? 0 0 "Check papi_avail -e PAPI_TLB_DM failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --br failed"
```

- 涉及命令：papi_avail×5

#### oe_test_papi_avail_02

- 描述：verify the uasge of papi command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check papi_avail --cache failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --cnd failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --fp failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --ins failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --idl failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --l1 failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --l2 failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --l3 failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --mem failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --msc failed"
  CHECK_RESULT $? 0 0 "Check papi_avail --tlb failed"
```

#### oe_test_papi_command_line

- 描述：verify the uasge of papi command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check papi_command_line -h failed"
  CHECK_RESULT $? 0 0 "Check papi_command_line -u failed"
  CHECK_RESULT $? 0 0 "Check papi_avail clockres failed"
  CHECK_RESULT $? 0 0 "Check papi_component_avail -h failed"
  CHECK_RESULT $? 0 0 "Check papi_component_avail --help failed"
  CHECK_RESULT $? 0 0 "Check papi_component_avail -d failed"
  CHECK_RESULT $? 0 0 "Check papi_cost -h failed"
  CHECK_RESULT $? 0 1 "Check papi_cost -b -s -t failed"
  CHECK_RESULT $? 0 0 "Check papi_cost -b -s -t failed"
  CHECK_RESULT $? 0 0 "Check papi_decode -h failed"
  CHECK_RESULT $? 0 0 "Check papi_decode -a failed"
```

- 涉及命令：papi_cost×3, papi_component_avail×2, papi_decode×2, papi_command_line×1

#### oe_test_papi_native_avail_01

- 描述：verify the uasge of papi command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check papi_native_avail -h failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --help failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail -c failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --check failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail -e failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail -i failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail -x failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --noqual failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --darr failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --dear failed"
```

- 涉及命令：papi_native_avail×5

#### oe_test_papi_native_avail_02

- 描述：verify the uasge of papi command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check papi_native_avail --iarr failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --iear failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --opcm failed"
  CHECK_RESULT $? 0 0 "Check papi_native_avail --nogroups failed"
  CHECK_RESULT $? 0 0 "Check papi_multiplex_cost -h failed"
  CHECK_RESULT $? 0 0 "Check papi_multiplex_cost -m -x -t -s failed"
  CHECK_RESULT $? 0 0 "Check papi_multiplex_cost -m -x -t -k failed"
  CHECK_RESULT $? 0 0 "Check papi_error_codes failed"
  CHECK_RESULT $? 0 0 "Check papi_mem_info failed"
```

- 涉及命令：papi_multiplex_cost×3

#### oe_test_papi_xml_event_info

- 描述：verify the uasge of papi command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check 'papi_xml_event_info -h failed"
  CHECK_RESULT $? 0 0 "Check 'papi_xml_event_info -p failed"
  CHECK_RESULT $? 0 0 "Check 'papi_xml_event_info -n failed"
  CHECK_RESULT $? 0 0 "Check 'papi_xml_event_info -c failed"
  CHECK_RESULT $? 0 0 "Check 'papi_version failed"
  CHECK_RESULT $? 0 1 "Check papi_event_chooser NATIVE failed"
  CHECK_RESULT $? 0 0 "Check papi_event_chooser NATIVE failed"
```

- 涉及命令：papi_xml_event_info×4
