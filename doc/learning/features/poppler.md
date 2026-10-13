# poppler

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/poppler` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_poppler | test poppler | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_pdfinfo | pdfinfo functional testing | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_pdfinfo_01 | pdfinfo functional testing | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_poppler

- 描述：test poppler
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "txt not exist"
  CHECK_RESULT $? 0 0 "html not exist"
```

- 涉及命令：test×2

#### oe_test_pdfinfo

- 描述：pdfinfo functional testing
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Pdfinfo command failed to view help manual"
  CHECK_RESULT $? 0 0 "Pdfinfo command failed to match PDF file information"
  CHECK_RESULT $? 0 1 "The pdfinfo command failed to print the date in ISO-8601 format"
  CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
  CHECK_RESULT $? 0 0 "The pdfinfo command does not support UTF-8 format encoding"
  CHECK_RESULT $? 0 0 "The pdfinfo command failed to query version information"
```

- 涉及命令：pdfinfo×5

#### oe_test_pdfinfo_01

- 描述：pdfinfo functional testing
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
  CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
  CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
  CHECK_RESULT $? 0 0 "The pdfinfo command failed to print all named destinations in the PDF"
```

- 涉及命令：pdfinfo×4
