# zerofree

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/zerofree` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_zerofree | Test zerofree | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_zerofree

- 描述：Test zerofree
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: -n"
  CHECK_RESULT $? 0 0 "Failed to achieve expect result, option: -n"
  CHECK_RESULT $? 0 0 "Failed to use option: -v"
  CHECK_RESULT $? 0 0 "Failed to achieve expect result, option: -v"
  CHECK_RESULT $? 0 0 "Failed to use basic funtion."
  CHECK_RESULT $? 0 0 "Failed to use option: -f"
  CHECK_RESULT $? 0 0 "Failed to achieve expect result, option: -f"
```

- 涉及命令：zerofree×3, mkfs.ext3×1
