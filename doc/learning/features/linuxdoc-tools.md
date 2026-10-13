# linuxdoc-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/linuxdoc-tools` |
| 注册用例数 | 13 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_linuxdoc-tools_01 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_linuxdoc-tools_02 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_linuxdoc-tools_03 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 24 | ✔ |  |  |
| oe_test_linuxdoc-tools_04 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_linuxdoc-tools_05 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_linuxdoc-tools_06 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 24 | ✔ |  |  |
| oe_test_linuxdoc-tools_07 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 24 | ✔ |  |  |
| oe_test_linuxdoc-tools_08 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_linuxdoc-tools_09 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_linuxdoc-tools_10 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_linuxdoc-tools_11 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_linuxdoc-tools_13 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_linuxdoc-tools_14 | Test "linuxdoc-tools" command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_linuxdoc-tools_01

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B check No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgmlcheck No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=html No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=info No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2info No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=latex No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx No Pass"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：linuxdoc×7

#### oe_test_linuxdoc-tools_02

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --papersize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -p No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --papersize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -p No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --language No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --language No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx --language No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx --language No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx -l No Pass"
```

- 涉及命令：linuxdoc×6

#### oe_test_linuxdoc-tools_03

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --charset No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --charset No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info --charset No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2info --charset No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2info -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --charset No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --charset No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -c No Pass"
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：linuxdoc×12

#### oe_test_linuxdoc-tools_04

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --tabsize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --tabsize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --tabsize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --tabsize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf --tabsize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf --tabsize No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf -t No Pass"
```

- 涉及命令：linuxdoc×6

#### oe_test_linuxdoc-tools_05

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --style No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -S No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --style No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -S No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --pass No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -P No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --pass No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -P No Pass"
```

- 涉及命令：linuxdoc×4

#### oe_test_linuxdoc-tools_06

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --debug No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --debug No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info --debug No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2info --debug No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2info -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --debug No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --debug No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -d No Pass"
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：linuxdoc×12

#### oe_test_linuxdoc-tools_07

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --define No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --define No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info --define No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2info --define No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2info -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --define No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B tex -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --define No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -D No Pass"
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：linuxdoc×12

#### oe_test_linuxdoc-tools_08

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --split No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --split No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --toc No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -T No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --toc No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -T No Pass"
```

- 涉及命令：linuxdoc×4

#### oe_test_linuxdoc-tools_09

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --dosnames No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --dosnames No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --imagebuttons No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -I No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --imagebuttons No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -I No Pass"
```

- 涉及命令：linuxdoc×4

#### oe_test_linuxdoc-tools_10

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --footer No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -F No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --footer No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -F No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --header No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -H No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --header No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -H No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --pass No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -P No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --pass No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -P No Pass"
```

- 涉及命令：linuxdoc×6

#### oe_test_linuxdoc-tools_11

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --output No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -o No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --output No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -o No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --makeindex No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --makeindex No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --pagenumber No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -n No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --pagenumber No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -n No Pass"
```

- 涉及命令：linuxdoc×6

#### oe_test_linuxdoc-tools_13

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --manpage No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --manpage No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --filter No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -f No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --filter No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -f No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --blanks No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -b No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --blanks No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -b No Pass"
```

- 涉及命令：linuxdoc×6

#### oe_test_linuxdoc-tools_14

- 描述：Test "linuxdoc-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf --twosplit No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf -2 No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf --twosplit No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf -2 No Pass"
```

- 涉及命令：linuxdoc×2
