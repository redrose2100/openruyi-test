# recode

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/recode` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_recode | test recode | pre_test/run_test/post_test | 15 | ✔ |  |  |

### 断言与命令明细

#### oe_test_recode

- 描述：test recode
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "recode install fail"
  CHECK_RESULT $? 0 0 "recode execute fail"
  CHECK_RESULT $? 0 0 "recode execute fail"
  CHECK_RESULT $? 0 0 "page.html generation failed"
  CHECK_RESULT $? 0 0 "Version check failed"
  CHECK_RESULT $? 0 0 "recode -l command failed"
  CHECK_RESULT $? 0 0 "Subset detection test failed"
  CHECK_RESULT $? 0 0 "Strict mode with iconv failed"
  CHECK_RESULT $? 0 0 "Combined flags  test failed"
  CHECK_RESULT $? 0 0 "Currency symbol force-recode failed"
  CHECK_RESULT $? 0 0 "Failed to create test.html"
  CHECK_RESULT $? 0 0 "HTML to text conversion failed"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：recode×4, grep×1
