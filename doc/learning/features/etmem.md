# etmem

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/etmem` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_etmemd_001 | etmem-任务启停 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_etmemd_002 | verification etmem command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_etmemd_001

- 描述：etmem-任务启停
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add project"
  CHECK_RESULT $? 0 0 "Project query failure"
  CHECK_RESULT $? 0 0 "Task start failure"
  CHECK_RESULT $? 0 0 "Task stop failure"
  CHECK_RESULT $? 0 0 "Failed to del project"
```

- 涉及命令：etmemd×1, kill×1

#### oe_test_etmemd_002

- 描述：verification etmem command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "etmemd -h not found"
  CHECK_RESULT $? 0 0 "etmemd -s etmemd_socket failed"
  CHECK_RESULT $? 0 0 "kill -9 failed"
  CHECK_RESULT $? 0 0 "etmemd -s etmemd_socket_test failed"
  CHECK_RESULT $? 0 0 "kill etmemd_socket_test failed"
```

- 涉及命令：etmemd×3, kill×2
