# atune

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/atune` |
| 注册用例数 | 14 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_atuned | Test atuned.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_atune-rest | Test atune-rest.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_atune-engine | Test atune-engine.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_tune-openapi | Test tune-openapi.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_tune-mcpserver | Test tune-mcpserver.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_atuned_01 | File system common command test-atune | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_atuned_02 | File system common command test-atune | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_atuned_03 | File system common command test-atune | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_atuned_04 | File system common command test-atune_undefine | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_atuned_05 | File system common command test-atune-version | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_atuned_06 | File system common command test-atune-collection | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_atuned_07 | File system common command test-atune | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_atuned_08 | File system common command test-atune-rollback | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_atuned_09 | File system common command test-atune-profile | pre_test/run_test/post_test | 7 |  |  |  |

### 断言与命令明细

#### oe_test_service_atuned

- 描述：Test atuned.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×10

#### oe_test_service_atune-rest

- 描述：Test atune-rest.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×8

#### oe_test_service_atune-engine

- 描述：Test atune-engine.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×10

#### oe_test_service_tune-openapi

- 描述：Test tune-openapi.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_tune-mcpserver

- 描述：Test tune-mcpserver.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_atuned_01

- 描述：File system common command test-atune
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The output is not 0"
  CHECK_RESULT $? 0 0 "atune-adm info -h command execution failed. Procedure"
  CHECK_RESULT $? 0 0 "atune-adm info command execution failed. Procedure"
```

#### oe_test_atuned_02

- 描述：File system common command test-atune
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "atune-adm list command execution failed. Procedure"
  CHECK_RESULT $? 0 0 "atune-adm list -h command execution failed. Procedure"
  CHECK_RESULT $? 0 0 "atune-adm list extra_input command execution failed. Procedure"
```

#### oe_test_atuned_03

- 描述：File system common command test-atune
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The help information is displayed incorrectly"
  CHECK_RESULT $? 0 0 "atune-adm define command execution failure"
  CHECK_RESULT $? 0 0 "define failure"
  CHECK_RESULT $? 0 0 "undefine failure"
```

#### oe_test_atuned_04

- 描述：File system common command test-atune_undefine
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "atune-adm define command execution failed"
  CHECK_RESULT $? 1 0 "atune-adm undefine command execution failed"
  CHECK_RESULT $? 0 0 "atune-adm undefine -h command execution failed"
  CHECK_RESULT $? 0 0 "undefine command execution failed"
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 1 0 "The status code is not 1"
  CHECK_RESULT $? 0 0 "The status code is not 0"
  CHECK_RESULT $? 1 0 "only self defined type can be deleted"
  CHECK_RESULT $? 0 0 "Cyclic failure"
```

#### oe_test_atuned_05

- 描述：File system common command test-atune-version
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "atune-adm command execution failed"
  CHECK_RESULT $? 0 0 "atune-adm version nonexistence"
```

#### oe_test_atuned_06

- 描述：File system common command test-atune-collection
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "atune-adm collection -h failure"
  CHECK_RESULT $? 0 0 "atune-adm collection failure"
```

#### oe_test_atuned_07

- 描述：File system common command test-atune
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "atune-adm analysis failure"
  CHECK_RESULT $? 0 0 "atune-adm list failure"
  CHECK_RESULT $? 0 0 "atune-adm check failure"
  CHECK_RESULT $? 0 0 "Check finished not found"
  CHECK_RESULT $? 0 0 "check system basic information not found"
  CHECK_RESULT $? 0 0 "Incorrect Usage not found"
```

- 涉及命令：grep×1

#### oe_test_atuned_08

- 描述：File system common command test-atune-rollback
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "atune-adm rollback failure"
  CHECK_RESULT $? 0 1 "atune-adm list failure"
  CHECK_RESULT $? 0 0 "atune-adm rollback -h failure"
  CHECK_RESULT $? 0 0 "Incorrect Usage not found"
```

- 涉及命令：awk×1

#### oe_test_atuned_09

- 描述：File system common command test-atune-profile
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "atune-adm profile failure"
  CHECK_RESULT $? 0 1 "load profile exist"
  CHECK_RESULT $? 0 0 "ARRAY_PROFILE not found"
  CHECK_RESULT $? 0 0 "active the specified profile not found"
  CHECK_RESULT $? 0 1 "atune-adm profile success"
  CHECK_RESULT $? 0 0 "load profile not found"
  CHECK_RESULT $? 0 0 "only one workloadload type can be set not found"
```

- 涉及命令：grep×2
