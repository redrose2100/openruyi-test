# rubygem-ZenTest_4.12.1

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rubygem-ZenTest` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_zentest-4.12.1_autotest | Test autotest | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_zentest-4.12.1_zentest | Test zentest | pre_test/run_test/post_test | 6 | ✔ |  | 240m |

### 断言与命令明细

#### oe_test_zentest-4.12.1_autotest

- 描述：Test autotest
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check unit_diff -h failed"
  CHECK_RESULT $? 0 0 "Check unit_diff -v failed"
  CHECK_RESULT $? 0 0 "Check unit_diff -b failed"
  CHECK_RESULT $? 0 0 "Check unit_diff -c failed"
  CHECK_RESULT $? 0 0 "Check unit_diff -k failed"
  CHECK_RESULT $? 0 0 "Check unit_diff -u failed"
  CHECK_RESULT $? 0 0 "Check unit_diff -p failed"
  CHECK_RESULT $? 0 0 "Check multigem failed"
  CHECK_RESULT $? 0 0 "Check multiruby failed"
```

- 涉及命令：unit_diff×2, tar×1, sed×1

#### oe_test_zentest-4.12.1_zentest

- 描述：Test zentest
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check zentest -h failed"
  CHECK_RESULT $? 0 0 "Check zentest -v failed"
  CHECK_RESULT $? 0 0 "Check zentest basic failed"
  CHECK_RESULT $? 0 0 "Check zentest -e failed"
  CHECK_RESULT $? 0 0 "Check zentest -t failed"
  CHECK_RESULT $? 0 0 "Check zentest -r failed"
```

- 涉及命令：zentest×5, tar×1
