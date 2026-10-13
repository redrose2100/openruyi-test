# ipset

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ipset` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ipset | Test ipset.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_ipset_02 | test flac | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ipset_01 | The named set create/add/rename/set/swap/flush function | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_ipset | Test ipset.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ipset

- 描述：Test ipset.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ipset.service reload failed"
  CHECK_RESULT $? 0 0 "ipset.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_ipset_02

- 描述：test flac
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "save failure"
  CHECK_RESULT $? 0 1 "destory failure"
  CHECK_RESULT $? 0 0 "restory failure"
```

#### oe_test_ipset_01

- 描述：The named set create/add/rename/set/swap/flush function
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Add aa${random} entry to the named set fail"
  CHECK_RESULT $? 0 0 "Add bb${random} entry to the named set fail"
  CHECK_RESULT $? 0 0 "Rename the named set fail"
  CHECK_RESULT $? 0 0 "Check the named entry set fail"
  CHECK_RESULT $? 0 0 "Swap the named set fail"
  CHECK_RESULT $? 0 0 "Check the named entry set fail after swap"
  CHECK_RESULT $? 0 0 "Check the named entry set fail after swap"
  CHECK_RESULT $? 1 0 "Flus the named set fail"
  CHECK_RESULT $? 1 0 "Flus the named set fail"
```

#### oe_test_service_ipset

- 描述：Test ipset.service restart
- 函数：`pre_test, run_test, post_test`