# luajit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/luajit` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_luajit_print | Test luajit print | pre_test/run_test/ha/post_test | 2 | ✔ |  |  |
| oe_test_luajit_print1 | npm nodejs-jsonpointer test | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_luajit_print

- 描述：Test luajit print
- 函数：`pre_test, run_test, ha, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Execution require1 failure"
  CHECK_RESULT $? 0 0 "Execution require2 failure"
```

- 涉及命令：luajit×1

#### oe_test_luajit_print1

- 描述：npm nodejs-jsonpointer test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The terminal cannot print the bytecode information translated from the source file"
  CHECK_RESULT $? 0 0 "The bytecode information cannot be output to the test.out file"
  CHECK_RESULT $? 0 0 "The test.out file is not generated"
  CHECK_RESULT $? 0 0 "The test.out file is empty"
```

- 涉及命令：luajit×2, test×2
