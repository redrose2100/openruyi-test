# A-Tune

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-A-Tune` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_A_Tune | A-tune | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_A_Tune

- 描述：A-tune
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 'atuned service status is inactive'
  CHECK_RESULT $? 0 0 'atune-engine service status is inactive'
  CHECK_RESULT $? 0 0 'atuned service status is active'
  CHECK_RESULT $? 0 0 'atune-engine service status is active'
  CHECK_RESULT $? 0 0 'atuned service status is inactive'
  CHECK_RESULT $? 0 0 'atune-engine service status is inactive'
```

- 涉及命令：sed×4
