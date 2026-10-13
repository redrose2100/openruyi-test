# diffutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/diffutils` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_diffutils_001 | test diffutils | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_diffutils_002 | diffutils expand param | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_diffutils_003 | diffutils advanced parameter | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_diffutils_004 | sdiff basic functions | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_diffutils_001

- 描述：test diffutils
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "same files check failed"
  CHECK_RESULT $? 0 1 "different files check failed"
  CHECK_RESULT $? 0 0 "different files check words failed"
```

- 涉及命令：mkdir×1, diff×1

#### oe_test_diffutils_002

- 描述：diffutils expand param
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "diff -c check failed"
  CHECK_RESULT $? 0 0 "diff -u check failed"
  CHECK_RESULT $? 0 0 "diff -y check failed"
  CHECK_RESULT $? 0 0 "diff -n check failed"
```

- 涉及命令：diff×4, mkdir×1

#### oe_test_diffutils_003

- 描述：diffutils advanced parameter
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "diff -i check failed"
  CHECK_RESULT $? 0 1 "diff file test fail"
  CHECK_RESULT $? 0 0 "diff -Z check failed"
  CHECK_RESULT $? 0 0 "diff -b check failed"
  CHECK_RESULT $? 0 0 "diff -w check failed 1"
  CHECK_RESULT $? 0 1 "diff file test failed"
  CHECK_RESULT $? 0 0 "diff -w check failed 2"
```

- 涉及命令：diff×5, mkdir×1

#### oe_test_diffutils_004

- 描述：sdiff basic functions
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "sdiff cannot view version information"
  CHECK_RESULT $? 0 0 "File creation failure"
  CHECK_RESULT $? 0 0 "sdiff cannot detect the difference between the two files"
  CHECK_RESULT $? 0 0 "Description Failed to export diff.log"
  CHECK_RESULT $? 0 0 "There is no difference between the two files in diff.log"
```

- 涉及命令：sdiff×1
