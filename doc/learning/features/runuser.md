# runuser

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/runuser` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_runuser | Test case for runuser command | pre_test/run_test/post_test | 7 |  |  |  |

### 断言与命令明细

#### oe_test_runuser

- 描述：Test case for runuser command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "runuser -u $test_user whoami failed"
  CHECK_RESULT $? 0 0 "Output not as expected: $(cat /tmp/runuser_out1)"
  CHECK_RESULT $? 0 0 "runuser id command failed"
  CHECK_RESULT $? 0 0 "id output mismatch: $(cat /tmp/runuser_out2)"
  CHECK_RESULT $? 0 0 "runuser ls command failed"
  CHECK_RESULT $? 0 0 "runuser touch command failed"
  CHECK_RESULT $? 0 0 "File owner not $test_user"
```

- 涉及命令：runuser×4, grep×2, useradd×1, stat×1, userdel×1
