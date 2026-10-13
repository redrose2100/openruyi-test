# cracklib

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cracklib` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_cracklib | Test cracklib command | pre_test/run_test/post_test | 22 |  |  |  |

### 断言与命令明细

#### oe_test_cracklib

- 描述：Test cracklib command
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "cracklib-check failed..."
  CHECK_RESULT $? 0 0 "cracklib-check failed..."
  CHECK_RESULT $? 0 0 "cracklib-check failed..."
  CHECK_RESULT $? 0 0 "cracklib-check failed..."
  CHECK_RESULT $? 0 0 "cracklib-foramt failed..."
  CHECK_RESULT $? 0 0 "cracklib-foramt result error..."
  CHECK_RESULT $? 0 0 "mkdict failed..."
  CHECK_RESULT $? 0 0 "mkdict result error..."
  CHECK_RESULT $? 0 0 "cracklib-packer failed..."
  CHECK_RESULT $? 0 0 "cracklib-packer error: data is not exist..."
  CHECK_RESULT $? 0 0 "packer failed..."
  CHECK_RESULT $? 0 0 "packer error: data is not exist..."
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：test×3, create-cracklib-dict×2
