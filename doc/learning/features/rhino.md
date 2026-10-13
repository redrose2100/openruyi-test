# rhino

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rhino` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rhino_01 | Test "rhino" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rhino_02 | Test "rhino" command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rhino_01

- 描述：Test "rhino" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -w No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -version No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -opt No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -modules No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -require No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -sandbox No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -debug No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -strict No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -fatal-warnings No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -encoding charset No Pass"
```

#### oe_test_rhino_02

- 描述：Test "rhino" command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -? No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -e No Pass"
```

- 涉及命令：rhino×3
