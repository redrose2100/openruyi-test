# gdb

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gdb` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gdb_recovery_database | Test test gdb recovery database | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_gdb-breakpoints | gdb-breakpoints formatting test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gdb-bt | gdb-bt formatting test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gdb-list | gdb-list formatting test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gdb-watch | gdb-watch formatting test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gdb_recovery_database

- 描述：Test test gdb recovery database
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Generation failure 1"
  CHECK_RESULT $? 0 1 "Delete failure"
  CHECK_RESULT $? 0 0 "Generation failure 2"
  CHECK_RESULT $? 0 0 "Recovery failure"
```

- 涉及命令：test×3, gdbmtool×1

#### oe_test_gdb-breakpoints

- 描述：gdb-breakpoints formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile test.c fail"
  CHECK_RESULT $? 0 0 "certifi_test file error"
```

- 涉及命令：rpm×1, test×1

#### oe_test_gdb-bt

- 描述：gdb-bt formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile test.c fail"
  CHECK_RESULT $? 0 0 "certifi_test file error"
```

- 涉及命令：rpm×1, test×1

#### oe_test_gdb-list

- 描述：gdb-list formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile add.c fail"
  CHECK_RESULT $? 0 0 "certifi_test file error"
```

- 涉及命令：rpm×1, test×1

#### oe_test_gdb-watch

- 描述：gdb-watch formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile test.c fail"
  CHECK_RESULT $? 0 0 "certifi_test file error"
```

- 涉及命令：rpm×1, test×1
