# os-base-timeout

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-basic-os/oe_test_timeout` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_timeout_01 | test timeout help/version/signal/timeout functions | pre_test/run_test/post_test | 9 |  |  |  |

### 断言与命令明细

#### oe_test_timeout_01

- 描述：test timeout help/version/signal/timeout functions
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "timeout help check failed"
  CHECK_RESULT $? 0 0 "timeout version check failed"
  CHECK_RESULT $? 0 0 "normal execution failed"
  CHECK_RESULT $? 124 0 "timeout execution failed"
  CHECK_RESULT $? 10 0 "preserve-status failed"
  CHECK_RESULT $? 124 0 "timeout signal handling failed"
  CHECK_RESULT $? 0 1 "invalid option should fail"
  CHECK_RESULT $? 124 0 "timeout kill-after failed"
  CHECK_RESULT $? 0 1 "sleep process still exists after timeout"
```

- 涉及命令：timeout×2, pgrep×1
