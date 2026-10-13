# python-junitxml

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/python-junitxml` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pyjunitxml | Test "pyjunitxml" command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pyjunitxml

- 描述：Test "pyjunitxml" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --output-file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --start-directory No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --top-level-directory No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --pattern No Pass"
```

- 涉及命令：pyjunitxml-3×4
