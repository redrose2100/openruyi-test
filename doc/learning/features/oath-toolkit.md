# oath-toolkit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/oath-toolkit` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_oathtool | test  oathtool | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_oathtool

- 描述：test  oathtool
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to obtain help command"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  CHECK_RESULT $? 0 0 "Generate a one-time verification code error based on time"
  CHECK_RESULT $? 0 0 "Generate one-time verification code error based on events"
  CHECK_RESULT $? 0 0 "Generate specified time step to generate TOTP error message"
```

- 涉及命令：oathtool×2
