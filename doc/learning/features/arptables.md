# arptables

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/arptables` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_arptables | Test arptables.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_arptables_function | arptables function | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_arptables

- 描述：Test arptables.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_arptables_function

- 描述：arptables function
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "show arptables help fail"
  CHECK_RESULT $? 0 0 "List the rules in a chain or all chains fail"
  CHECK_RESULT $? 0 0 "Delete all rules in  chain or all chains fail"
  CHECK_RESULT $? 0 0 "Failed to add arptables rule"
  CHECK_RESULT $? 0 0 "Added rule not found in listing"
  CHECK_RESULT $? 0 0 "Failed to delete arptables rule"
  CHECK_RESULT $? 1 0 "Deleted rule still exists in listing"
```

- 涉及命令：arptables×7
