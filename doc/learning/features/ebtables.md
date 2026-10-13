# ebtables

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ebtables` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_ebtables | Test ebtables.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_ebtables_01 | ebtables command testing | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_ebtables_02 | ebtables additional command testing | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_ebtables

- 描述：Test ebtables.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_ebtables_01

- 描述：ebtables command testing
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get ebtables version"
  CHECK_RESULT $? 0 0 "Failed to add filter rule"
  CHECK_RESULT $? 0 0 "Failed to find the added rule in listing"
  CHECK_RESULT $? 0 0 "Failed to delete filter rule"
  CHECK_RESULT $? 1 0 "Rule still exists after deletion"
  CHECK_RESULT $? 0 0 "Failed to create new chain"
  CHECK_RESULT $? 0 0 "New chain not found in listing"
  CHECK_RESULT $? 0 0 "Failed to delete chain"
  CHECK_RESULT $? 1 0 "Chain still exists after deletion"
```

- 涉及命令：ebtables×12

#### oe_test_ebtables_02

- 描述：ebtables additional command testing
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list filter table"
  CHECK_RESULT $? 0 0 "Failed to list nat table"
  CHECK_RESULT $? 0 0 "Failed to list broute table"
  CHECK_RESULT $? 0 0 "Failed to add ACCEPT rule"
  CHECK_RESULT $? 0 0 "Failed to add DROP rule"
  CHECK_RESULT $? 0 0 "Failed to add destination MAC filter"
  CHECK_RESULT $? 0 0 "Failed to add destination MAC DROP rule"
  CHECK_RESULT $? 0 0 "Failed to set chain policy"
  CHECK_RESULT $? 0 0 "Failed to verify rule after policy set"
  CHECK_RESULT $? 1 0 "Rule still exists after flushing chain"
  CHECK_RESULT $? 1 0 "INPUT rule exists after global flush"
  CHECK_RESULT $? 1 0 "FORWARD rule exists after global flush"
```

- 涉及命令：ebtables×23
