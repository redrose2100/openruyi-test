# nodejs-grunt-cli

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nodejs-grunt-cli` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gruntcli_grunt_01 | Test grunt | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gruntcli_grunt_02 | Test grunt | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gruntcli_grunt_01

- 描述：Test grunt
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check grunt --version failed"
  CHECK_RESULT $? 0 0 "Check grunt -h failed"
  CHECK_RESULT $? 0 0 "Check grunt --help failed"
  CHECK_RESULT $? 0 0 "Check grunt -b failed"
  CHECK_RESULT $? 0 0 "Check grunt --base failed"
  CHECK_RESULT $? 0 0 "Check grunt --no-color failed"
  CHECK_RESULT $? 0 0 "Check grunt --gruntfile failed"
  CHECK_RESULT $? 0 0 "Check grunt -d failed"
  CHECK_RESULT $? 0 0 "Check grunt --debug failed"
  CHECK_RESULT $? 0 0 "Check grunt --stack failed"
```

- 涉及命令：grunt×3, tar×1

#### oe_test_gruntcli_grunt_02

- 描述：Test grunt
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check grunt --tasks failed"
  CHECK_RESULT $? 0 0 "Check grunt --npm failed"
  CHECK_RESULT $? 0 0 "Check grunt -v failed"
  CHECK_RESULT $? 0 0 "Check grunt --verbose failed"
  CHECK_RESULT $? 0 0 "Check grunt -f failed"
  CHECK_RESULT $? 0 0 "Check grunt --force failed"
  CHECK_RESULT $? 0 0 "Check grunt --completion failed"
  CHECK_RESULT $? 0 0 "Check grunt --no-write failed"
  CHECK_RESULT $? 0 0 "Check grunt -V failed"
```

- 涉及命令：grunt×3, tar×1
