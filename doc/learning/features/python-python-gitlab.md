# python-python-gitlab

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/python-python-gitlab` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gitlab_01 | Test "python-gitlab" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gitlab_02 | Test "python-gitlab" command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gitlab_01

- 描述：Test "python-gitlab" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check gitlab --version failed"
  CHECK_RESULT $? 0 0 "Check gitlab -c CONFIG_FILE failed"
  CHECK_RESULT $? 0 0 "Check gitlab --config-file CONFIG_FILE failed"
  CHECK_RESULT $? 0 0 "Check gitlab -v failed"
  CHECK_RESULT $? 0 0 "Check gitlab --verbose failed"
  CHECK_RESULT $? 0 0 "Check gitlab --fancy failed"
  CHECK_RESULT $? 0 0 "Check gitlab -d failed"
  CHECK_RESULT $? 0 0 "Check gitlab --debug failed"
  CHECK_RESULT $? 0 0 "Check gitlab -g GITLAB failed"
  CHECK_RESULT $? 0 0 "Check gitlab --gitlab GITLAB failed"
```

- 涉及命令：gitlab×4

#### oe_test_gitlab_02

- 描述：Test "python-gitlab" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check gitlab -o {json,legacy,yaml} failed"
  CHECK_RESULT $? 0 0 "Check gitlab --output {json,legacy,yaml} failed"
  CHECK_RESULT $? 0 0 "Check gitlab -f FIELDS failed"
  CHECK_RESULT $? 0 0 "Check gitlab --fields FIELDS failed"
  CHECK_RESULT $? 0 0 "Check gitlab -h failed"
  CHECK_RESULT $? 0 0 "Check gitlab --help failed"
```

- 涉及命令：gitlab×3
