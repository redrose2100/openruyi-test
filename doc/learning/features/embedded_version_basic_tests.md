# embedded_version_basic_tests

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/version_basic_tests` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_version_posix_suite_test_001 | run posix test suite | pre_test/run_test/post_test | 4 |  |  | 180m |
| oe_test_version_ltp_test_001 | run ltp test | pre_test/run_test/post_test | 3 |  |  | 1440m |

### 断言与命令明细

#### oe_test_version_posix_suite_test_001

- 描述：run posix test suite
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "no tmp_test uploaded, all test not run"
  CHECK_RESULT $? 0 0 "no posixtestsuite uploaded, all test not run"
  CHECK_RESULT $? 0 0 "make run-tests failed, check run.log for details"
  CHECK_RESULT $ret 0 0 "run posix testcase fail case name: $line"
```

- 涉及命令：date×2, awk×2

#### oe_test_version_ltp_test_001

- 描述：run ltp test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "no tmp_test uploaded, all test not run"
  CHECK_RESULT $? 0 0 "no ltp_run uploaded, all test not run"
  CHECK_RESULT 1 0 0 "run ltp testcase fail case name: $line"
```

- 涉及命令：tar×3, cat×3, date×2, mkdir×1, grep×1
