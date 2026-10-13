# auter

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/auter` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_auter | System Management Tools auter | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_auter

- 描述：System Management Tools auter
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Help information printing failed"
  CHECK_RESULT $? 0 0 "Version information printing failed"
  CHECK_RESULT $? 0 0 "Failed to check the status"
  CHECK_RESULT $? 0 0 "Disable the failure"
  CHECK_RESULT $? 0 0 "Enable the failure"
  CHECK_RESULT $? 0 0 "Predownload failed"
  CHECK_RESULT $? 0 0 "Application of failure"
  CHECK_RESULT $? 0 0 "Postreboot of failure"
```

- 涉及命令：auter×2
