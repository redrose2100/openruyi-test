# texi2html

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/texi2html` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_texi2html_01 | Test "texi2html" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_texi2html_02 | Test "texi2html" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_texi2html_03 | Test "texi2html" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_texi2html_04 | Test "texi2html" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_texi2html_05 | Test "texi2html" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_texi2html_06 | Test "texi2html" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_texi2html_07 | Test "texi2html" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_texi2html_08 | Test "texi2html" command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_texi2html_01

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -version No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -docbook No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -menu No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -info No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -xml No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -ifdocbook No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -ifhtml No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -ifinfo No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -ifplaintext No Pass"
```

- 涉及命令：texi2html×9

#### oe_test_texi2html_02

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -iftex No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -ifxml No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -force No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -headers No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -css-include No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -disable-encoding No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -enable-encoding No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -no-warn No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -output|out|o=s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -prefix=s No Pass"
```

- 涉及命令：texi2html×10

#### oe_test_texi2html_03

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -transliterate-file-names No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -verbose No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -raw-text No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -toc-links No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -use-nodes No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -top-file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -toc-file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -split-size No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -short-ext No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -short-ref No Pass"
```

- 涉及命令：texi2html×10

#### oe_test_texi2html_04

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -css-ref No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -conf-dir No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -split=section No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -split=chapter No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -split=node No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -split=s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -init-file=s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -I=s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -P=s No Pass"
```

- 涉及命令：texi2html×9

#### oe_test_texi2html_05

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: --l2h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -internal-links No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -fill-column No Pass"l
  CHECK_RESULT $? 0 0 "L$LINENO: -error-limit No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -debug=-1 No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -debug=0 No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -debug=1 No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -document-language=s No Pass"
```

- 涉及命令：texi2html×10

#### oe_test_texi2html_06

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -program No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -output-indent No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -number-sections No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -number-footnotes No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -number-sections No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -no-validate|no-pointer-validate No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -macro-expand No Pass"
```

- 涉及命令：texi2html×10

#### oe_test_texi2html_07

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -F No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -output=s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -out=s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -e No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -no-pointer-validate No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -macro-expand No Pass"
```

- 涉及命令：texi2html×10

#### oe_test_texi2html_08

- 描述：Test "texi2html" command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
```

- 涉及命令：texi2html×4
