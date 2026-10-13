# docbook2X

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/docbook2X` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_docbook2X_db2x_manxml | verify the uasge of docbook2X command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook2X_db2x_texixml | verify the uasge of docbook2X command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_docbook2X_db2x_xsltproc | verify the uasge of docbook2X command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook2X_sgml2xml-isoent_01 | verify the uasge of docbook2X command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook2X_sgml2xml-isoent_02 | verify the uasge of docbook2X command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook2X_sgml2xml-isoent_03 | verify the uasge of docbook2X command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook2X_sgml2xml-isoent_04 | verify the uasge of docbook2X command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_docbook2X_utf8trans | verify the uasge of docbook2X command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_docbook2X_db2x_docbook2man | verify the uasge of docbook2X command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook2X_db2x_docbook2texi_01 | verify the uasge of docbook2X command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook2X_db2x_docbook2texi_02 | verify the uasge of docbook2X command | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_docbook2X_db2x_manxml

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check db2x_manxml --to-stdout failed"
  CHECK_RESULT $? 0 0 "Check db2x_manxml --list-files failed"
  CHECK_RESULT $? 0 0 "Check db2x_manxml --symlinks failed"
  CHECK_RESULT $? 0 0 "Check db2x_manxml --solinks failed"
  CHECK_RESULT $? 0 0 "Check db2x_manxml --help failed"
  CHECK_RESULT $? 0 0 "Check db2x_manxml --version failed"
  CHECK_RESULT $? 0 0 "Check db2x_manxml --utf8trans-program --utf8trans-map= --iconv-program failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param custom-localization-file failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param custom-n-data failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param author-othername-in-middle failed"
```

#### oe_test_docbook2X_db2x_texixml

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check db2x_texixml --output-dir --encoding --info --to-stdout failed"
  CHECK_RESULT $? 0 0 "Check db2x_texixml --output-dir --encoding --list-files failed"
  CHECK_RESULT $? 0 0 "Check db2x_texixml --output-dir --encoding --plaintext failed"
  CHECK_RESULT $? 0 0 "Check db2x_texixml --encoding --utf8trans-program --utf8trans-map --iconv-program --makeinfo-program failed"
  CHECK_RESULT $? 0 0 "Check db2x_texixml --help failed"
  CHECK_RESULT $? 0 0 "Check db2x_texixml --version failed"
```

#### oe_test_docbook2X_db2x_xsltproc

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc --version  failed"
  CHECK_RESULT $? 0 0 "Check --help  failed"
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc --version  failed"
  CHECK_RESULT $? 0 0 "Check --help  failed"
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc -s -o -D -C -X -d -I -S -N -P failed"
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc --stylesheet --output --nesting-limit --catalogs --xslt-processor --debug --xinclude --sgml --network --profile failed"
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc -p failed"
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc --param failed"
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc -g failed"
  CHECK_RESULT $? 0 0 "Check db2x_xsltproc -g failed"
```

- 涉及命令：db2x_xsltproc×7

#### oe_test_docbook2X_sgml2xml-isoent_01

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --encoding --error-file failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -b -f failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -v failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --version failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -h failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --help failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -c -E failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --catalog -E failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -C failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --catalogs failed"
```

- 涉及命令：sgml2xml-isoent×7

#### oe_test_docbook2X_sgml2xml-isoent_02

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -D failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --directory failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -R failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --restricted failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -a failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --activate failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -A failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --architecture failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -E failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --max-errors failed"
```

- 涉及命令：sgml2xml-isoent×10

#### oe_test_docbook2X_sgml2xml-isoent_03

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -b -f -e failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -b -f --open-entities failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -g failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --open-entities failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -n failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --error-numbers failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --references failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -i failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --include failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -w failed"
```

- 涉及命令：sgml2xml-isoent×10

#### oe_test_docbook2X_sgml2xml-isoent_04

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --warning failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -x failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --xml-output-option failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -d failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --entity_output_location failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -l failed"
  CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --dtd_location failed"
```

- 涉及命令：sgml2xml-isoent×6, sgml2xml×1

#### oe_test_docbook2X_utf8trans

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check utf8trans -m failed"
  CHECK_RESULT $? 0 0 "Check utf8trans --modify failed"
  CHECK_RESULT $? 0 0 "Check utf8trans -v failed"
  CHECK_RESULT $? 0 0 "Check utf8trans --version failed"
  CHECK_RESULT $? 0 0 "Check utf8trans -h failed"
  CHECK_RESULT $? 0 0 "Check utf8trans --help failed"
```

- 涉及命令：utf8trans×3

#### oe_test_docbook2X_db2x_docbook2man

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param uppercase-headings --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param manvolnum-cite-numeral-only failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param quotes-on-literals failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param show-comments failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param function-parens failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param xref-on-link failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param header-3 failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param header-4 failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param header-5 failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param default-manpage-section failed"
```

#### oe_test_docbook2X_db2x_docbook2texi_01

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --encoding --string-param captions-display-as-headings --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param links-use-pxref --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param explicit-node-names --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param show-comment --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param funcsynopsis-decoration --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param function-parens --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param refentry-display-name --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param manvolnum-in-xref --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param prefer-textobjects --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param semantic-decorations --sgml failed"
```

#### oe_test_docbook2X_db2x_docbook2texi_02

- 描述：verify the uasge of docbook2X command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --encoding --string-param custom-localization-file --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param custom-n-data --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param author-othername-in-middle --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param output-file --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param directory-category --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param directory-description --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param index-category --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param qanda-defaultlabel --sgml failed"
  CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param qandaset-generate-toc --sgml failed"
```
