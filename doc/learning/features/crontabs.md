# crontabs

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/crontabs` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_crontabs | Test "crontabs" command | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_crontabs_002 | Test "crontabs" command | pre_test/run_test/post_test | 5 |  |  |  |

### 断言与命令明细

#### oe_test_crontabs

- 描述：Test "crontabs" command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Failed : start"
  CHECK_RESULT $? 0 0 "Failed : restart"
  CHECK_RESULT $? 0 0 "Failed : stop"
  CHECK_RESULT $? 0 0 "Failed : status"
  CHECK_RESULT $? 0 0 "Failed option: -e"
  CHECK_RESULT $? 0 0 "Failed option: -l"
  CHECK_RESULT $? 0 0 "Failed option: run-parts --test"
  CHECK_RESULT $? 0 0 "Failed option: run-parts --list"
  CHECK_RESULT $? 0 0 "Failed option: -x"
  CHECK_RESULT $? 0 0 "Failed option: -s"
  CHECK_RESULT $? 0 0 "Failed option: -r"
  CHECK_RESULT $? 0 0 "Failed option: -i"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：crontab×7

#### oe_test_crontabs_002

- 描述：Test "crontabs" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Service startup failure"
  CHECK_RESULT $? 0 0 "Task creation failure"
  CHECK_RESULT $? 0 0 "Task execution failure"
  CHECK_RESULT $? 0 0 "Command execution failure"
  CHECK_RESULT $? 0 0 "Task deletion failure"
```

- 涉及命令：crontab×3
