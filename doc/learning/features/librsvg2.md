# librsvg2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/librsvg2` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_librsvg2-tools | test librsvg2-tools | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_librsvg2-tools

- 描述：test librsvg2-tools
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "display help information failed"
  CHECK_RESULT $? 0 0 "switch PNG type failed"
  CHECK_RESULT $? 0 0 "The converted file PNG type is incorrect"
  CHECK_RESULT $? 0 0 "switch PNG type with -w option failed"
  CHECK_RESULT $? 0 0 "The converted file PNG type with -w option is incorrect"
  CHECK_RESULT $? 0 0 "switch PNG type with -w/-h options failed"
  CHECK_RESULT $? 0 0 "The converted file PNG type with -w/-h options is incorrect"
  CHECK_RESULT $? 0 0 "switch PDF type failed"
  CHECK_RESULT $? 0 0 "The converted file PDF type is incorrect"
  CHECK_RESULT $? 0 0 "switch EPS type failed"
  CHECK_RESULT $? 0 0 "The converted file EPS type is incorrect"
```
