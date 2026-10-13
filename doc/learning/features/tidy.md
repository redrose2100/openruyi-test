# tidy

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tidy` |
| 注册用例数 | 17 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tidy_file_manipulation | Test tidy file manipulation | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_tidy_processing_directives | Test tidy processing directives | pre_test/run_test/post_test | 33 | ✔ |  |  |
| oe_test_tidy_character_encodings | Test tidy character encodings | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_tidy_miscellaneous | Test tidy miscellaneous | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_tidy_xml | Test iftop text mode | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_tidy_document_display_options | Test iftop text mode | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_tidy_document_in_and_out_options | Test tidy document in and output | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_tidy_file_input-output_options | Test iftop text mode | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_tidy_diagnostics_options | Test iftop text mode | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_tidy_encoding_options | Test iftop text mode | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_tidy_cleanup_options | Test tidy clean options | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_tidy_entities_options | Test tidy processing directives | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_tidy_repair_options | Test tidy repair options | pre_test/run_test/post_test | 28 | ✔ |  |  |
| oe_test_tidy_transformation_options | Test iftop text mode | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_tidy_teaching_tidy_options | Test iftop text mode | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_tidy_pretty_print_options | Test iftop text mode | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_tidy_output | test tidy | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tidy_file_manipulation

- 描述：Test tidy file manipulation
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: -o"
  CHECK_RESULT $? 0 0 "Failed to use option: -output"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: output-file"
  CHECK_RESULT $? 0 0 "Failed to use option: -config"
  CHECK_RESULT $? 0 0 "Failed to use option: -f"
  CHECK_RESULT $? 0 0 "Failed to use option: -file"
  CHECK_RESULT $? 0 0 "Failed to use option: -file"
  CHECK_RESULT $? 0 0 "Failed to use option: -m"
  CHECK_RESULT $? 0 0 "Failed to use option: -modify"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: write-back"
```

- 涉及命令：tidy×3

#### oe_test_tidy_processing_directives

- 描述：Test tidy processing directives
- 函数：`pre_test, run_test, post_test`
- 断言（33 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: -i"
  CHECK_RESULT $? 0 0 "Failed to use option: -indent"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: indent"
  CHECK_RESULT $? 0 0 "Failed to use option: -w"
  CHECK_RESULT $? 0 0 "Failed to use option: -wrap"
  CHECK_RESULT $? 0 0 "Failed to use option: -u"
  CHECK_RESULT $? 0 0 "Failed to use option: -upper"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: uppercase-tags"
  CHECK_RESULT $? 0 0 "Failed to use option: -c"
  CHECK_RESULT $? 0 0 "Failed to use option: -clean"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: clean"
  CHECK_RESULT $? 0 0 "Failed to use option: -b"
  ... 共 33 条（其余见源脚本）
```

#### oe_test_tidy_character_encodings

- 描述：Test tidy character encodings
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 1 0 "Failed to use option: -raw"
  CHECK_RESULT $? 0 0 "Failed to use option: -ascii"
  CHECK_RESULT $? 0 0 "Failed to use option: -latin0"
  CHECK_RESULT $? 0 0 "Failed to use option: -latin1"
  CHECK_RESULT $? 0 0 "Failed to use option: -iso2022"
  CHECK_RESULT $? 0 0 "Failed to use option: -utf8"
  CHECK_RESULT $? 0 0 "Failed to use option: -mac"
  CHECK_RESULT $? 0 0 "Failed to use option: -win1252"
  CHECK_RESULT $? 0 0 "Failed to use option: -ibm858"
  CHECK_RESULT $? 0 0 "Failed to use option: -utf16le"
  CHECK_RESULT $? 0 0 "Failed to use option: -utf16be"
  CHECK_RESULT $? 0 0 "Failed to use option: -utf16"
  ... 共 14 条（其余见源脚本）
```

#### oe_test_tidy_miscellaneous

- 描述：Test tidy miscellaneous
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: -v"
  CHECK_RESULT $? 0 0 "Failed to use option: -version"
  CHECK_RESULT $? 0 0 "Failed to use option: -h"
  CHECK_RESULT $? 0 0 "Failed to use option: -help"
  CHECK_RESULT $? 0 0 "Failed to use option: -?"
  CHECK_RESULT $? 0 0 "Failed to use option: -help-config"
  CHECK_RESULT $? 0 0 "Failed to use option: -help-env"
  CHECK_RESULT $? 0 0 "Failed to use option: -help-option"
  CHECK_RESULT $? 0 0 "Failed to use option: -export-default-config"
  CHECK_RESULT $? 0 0 "Failed to use option: -show-config"
  CHECK_RESULT $? 0 0 "Failed to use option: -export-config"
  CHECK_RESULT $? 0 0 "Failed to use option: -language"
```

- 涉及命令：tidy×10

#### oe_test_tidy_xml

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: -xml-help"
  CHECK_RESULT $? 0 0 "Failed to use option: -xml-config"
  CHECK_RESULT $? 0 0 "Failed to use option: -xml-strings"
  CHECK_RESULT $? 0 0 "Failed to use option: -xml-error-string"
  CHECK_RESULT $? 0 0 "Failed to use option: -xml-options-strings"
```

- 涉及命令：tidy×5

#### oe_test_tidy_document_display_options

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --gnu-emacs"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: gnu-emacs"
  CHECK_RESULT $? 1 0 "Failed to use option: --markup"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: markup"
  CHECK_RESULT $? 1 0 "Failed to use option: --mute"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: mute"
  CHECK_RESULT $? 1 0 "Failed to use option:--quiet"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: quiet"
  CHECK_RESULT $? 1 0 "Failed to use option: --show-body-only"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: show-body-only"
  CHECK_RESULT $? 1 0 "Failed to use option: --show-errors"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: show-errors"
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：tidy×3

#### oe_test_tidy_document_in_and_out_options

- 描述：Test tidy document in and output
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --add-meta-charset"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: add-meta-charset"
  CHECK_RESULT $? 0 0 "Failed to use option: --add-xml-decl"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: add-xml-decl"
  CHECK_RESULT $? 0 0 "Failed to use option: --add-xml-space"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: add-xml-space"
  CHECK_RESULT $? 0 0 "Failed to use option: --doctype"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: doctype"
  CHECK_RESULT $? 0 0 "Failed to use option: --input-xml"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: input-xml"
  CHECK_RESULT $? 0 0 "Failed to use option: --input-xml"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: output-html"
  ... 共 16 条（其余见源脚本）
```

#### oe_test_tidy_file_input-output_options

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: error-file"
  CHECK_RESULT $? 0 0 "Failed to use option: --keep-time"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: keep-time"
  CHECK_RESULT $? 0 0 "Failed to use option: --output-file"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: output-file"
  CHECK_RESULT $? 0 0 "Failed to use option: --write-back"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: write-back"
```

- 涉及命令：tidy×2

#### oe_test_tidy_diagnostics_options

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --accessibility-check"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: accessibility-check"
  CHECK_RESULT $? 0 0 "Failed to use option: --force-output"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: force-output"
  CHECK_RESULT $? 0 0 "Failed to use option: --show-meta-change"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: show-meta-change"
  CHECK_RESULT $? 1 0 "Failed to use option: --warn-proprietary-attributes"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: warn-proprietary-attributes"
```

#### oe_test_tidy_encoding_options

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --char-encoding"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: char-encoding"
  CHECK_RESULT $? 0 0 "Failed to use option: --input-encoding"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: input-encoding"
  CHECK_RESULT $? 0 0 "Failed to use option: --newline"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: newline"
  CHECK_RESULT $? 0 0 "Failed to use option: --output-bom"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: output-bom"
  CHECK_RESULT $? 0 0 "Failed to use option: --output-encoding"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: output-encoding"
```

#### oe_test_tidy_cleanup_options

- 描述：Test tidy clean options
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --bare"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: bare"
  CHECK_RESULT $? 0 0 "Failed to use option: --clean"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: clean"
  CHECK_RESULT $? 0 0 "Failed to use option: --drop-empty-elements"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: drop-empty-elements"
  CHECK_RESULT $? 0 0 "Failed to use option: --drop-empty-paras"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: drop-empty-paras"
  CHECK_RESULT $? 1 0 "Failed to use option: --drop-proprietary-attributes"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: drop-proprietary-attributes"
  CHECK_RESULT $? 0 0 "Failed to use option: --gdoc"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: gdoc"
  ... 共 18 条（其余见源脚本）
```

#### oe_test_tidy_entities_options

- 描述：Test tidy processing directives
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --ascii-chars"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: ascii-chars"
  CHECK_RESULT $? 0 0 "Failed to use option: --ncr"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: ncr"
  CHECK_RESULT $? 0 0 "Failed to use option: --numeric-entities"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: numeric-entities"
  CHECK_RESULT $? 0 0 "Failed to use option: --preserve-entities"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: preserve-entities"
  CHECK_RESULT $? 0 0 "Failed to use option: --quote-ampersand"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: quote-ampersand"
  CHECK_RESULT $? 0 0 "Failed to use option: --quote-marks"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: quote-marks"
  ... 共 14 条（其余见源脚本）
```

#### oe_test_tidy_repair_options

- 描述：Test tidy repair options
- 函数：`pre_test, run_test, post_test`
- 断言（28 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --alt-text"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: alt-text"
  CHECK_RESULT $? 0 0 "Failed to use option: --anchor-as-name"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: anchor-as-name"
  CHECK_RESULT $? 0 0 "Failed to use option: --coerce-endtags"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: coerce-endtags"
  CHECK_RESULT $? 0 0 "Failed to use option: --css-prefix"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: css-prefix"
  CHECK_RESULT $? 0 0 "Failed to use option: --enclose-block-text"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: enclose-block-text"
  CHECK_RESULT $? 0 0 "Failed to use option: --enclose-text"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: enclose-text"
  ... 共 28 条（其余见源脚本）
```

- 涉及命令：tidy×1

#### oe_test_tidy_transformation_options

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --escape-cdata"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: escape-cdata"
  CHECK_RESULT $? 1 0 "Failed to use option: --hide-comments"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: hide-comments"
  CHECK_RESULT $? 0 0 "Failed to use option: --join-classes"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: join-classes"
  CHECK_RESULT $? 1 0 "Failed to use option: --join-styles"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: join-styles"
  CHECK_RESULT $? 1 0 "Failed to use option: --join-styles"
  CHECK_RESULT $? 1 0 "Failed to use option in configuration: join-styles"
  CHECK_RESULT $? 0 0 "Failed to use option: --merge-emphasis"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: merge-emphasis"
  ... 共 14 条（其余见源脚本）
```

#### oe_test_tidy_teaching_tidy_options

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --new-blocklevel-tags"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: new-blocklevel-tags"
  CHECK_RESULT $? 0 0 "Failed to use option: --new-empty-tags"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: new-empty-tags"
  CHECK_RESULT $? 0 0 "Failed to use option: --new-inline-tags"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: new-inline-tags"
  CHECK_RESULT $? 0 0 "Failed to use option: --new-pre-tags"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: new-pre-tags"
```

#### oe_test_tidy_pretty_print_options

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: --break-before-br"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: break-before-br"
  CHECK_RESULT $? 0 0 "Failed to use option: --indent"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: indent"
  CHECK_RESULT $? 0 0 "Failed to use option: --indent-attributes"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: indent-attributes"
  CHECK_RESULT $? 0 0 "Failed to use option: --indent-spaces"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: indent-spaces"
  CHECK_RESULT $? 0 0 "Failed to use option: --indent-with-tabs"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: indent-with-tabs"
  CHECK_RESULT $? 0 0 "Failed to use option: --omit-optional-tags"
  CHECK_RESULT $? 0 0 "Failed to use option in configuration: omit-optional-tags"
  ... 共 22 条（其余见源脚本）
```

#### oe_test_tidy_output

- 描述：test tidy
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "tidy recover"
  CHECK_RESULT $? 0 0 "index.html.new not exist"
  CHECK_RESULT $? 0 0 "Cropping audio failed"
```

- 涉及命令：tidy×2, test×2
