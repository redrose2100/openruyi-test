# ltp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `$OET_PATH/testcases/system-test/ltp-test` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ltp | ltp testsuite | pre_test/run_test/post_test | 1 | ✔ |  | 600m |
| oe_test_posix | ltp testsuite | pre_test/run_test/post_test | 2 | ✔ |  | 240m |

### 断言与命令明细

#### oe_test_ltp

- 描述：ltp testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "any case failed"
```

- 涉及命令：grep×2, make×1, tee×1

#### oe_test_posix

- 描述：ltp testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "bin case pass rate lower than 97%"
  CHECK_RESULT $? 0 0 "bin case pass rate lower than 97%"
```

- 涉及命令：awk×2, autoreconf×1
