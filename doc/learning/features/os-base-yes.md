# os-base-yes

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-basic-os/oe_test_yes` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_yes_01 | test yes help/version/default/custom output functions | pre_test/run_test/post_test | 7 |  |  |  |

### 断言与命令明细

#### oe_test_yes_01

- 描述：test yes help/version/default/custom output functions
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "yes help check failed"
  CHECK_RESULT $? 0 0 "yes version check failed"
  CHECK_RESULT $? 0 0 "default output failed"
  CHECK_RESULT $? 0 0 "custom string output failed"
  CHECK_RESULT $? 0 0 "multiple arguments output failed"
  CHECK_RESULT $? 0 0 "special string output failed"
  CHECK_RESULT $? 0 1 "invalid option should fail"
```

- 涉及命令：grep×3, head×1
