# perl-Pod-Markdown

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/perl-Pod-Markdown` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_perl-Pod-Markdown_pod2markdown | TEST pod2markdown | config_params/pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_perl-Pod-Markdown_pod2markdown

- 描述：TEST pod2markdown
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "pod2markdown help error"
  CHECK_RESULT $? 0 0 "option: STDIO error"
  CHECK_RESULT $? 0 0 "option: FILEIO error"
  CHECK_RESULT $? 0 0 "option: STDIN FILEOUT error"
  CHECK_RESULT $? 0 0 "option: -u error"
  CHECK_RESULT $? 0 0 "option: --utf8 error"
  CHECK_RESULT $? 0 0 "option: -e error"
  CHECK_RESULT $? 0 0 "option: --output-encoding error"
  CHECK_RESULT $? 0 0 "option: -m error"
  CHECK_RESULT $? 0 0 "option: --match-encoding error"
  CHECK_RESULT $? 0 0 "command --html-encode-chars 1"
  CHECK_RESULT $? 0 0 "command --html-encode-chars <char>"
```

- 涉及命令：pod2markdown×4, mkdir×1
