# asciidoc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/asciidoc` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_asciidoc_asciidoc_01 | Take the test asciidoc option | config_params/pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_asciidoc_asciidoc_02 | Take the test asciidoc option | config_params/pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_asciidoc_a2x_01 | Take the test a2x option | config_params/pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_asciidoc_a2x_02 | Take the test a2x option | config_params/pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_asciidoc_a2x_03 | Take the test a2x option | config_params/pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_asciidoc_asciidoc_01

- 描述：Take the test asciidoc option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check asciidoc -h manpage failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --help manpage failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -h syntax failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --help syntax failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --version failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -a failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --attribute failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -o failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --out-file failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -b ${backend} failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --backend ${backend} failed"
```

- 涉及命令：asciidoc×6, test×6

#### oe_test_asciidoc_asciidoc_02

- 描述：Take the test asciidoc option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check asciidoc --doctest failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -d ${doctype} failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --doctype ${doctype} failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -c failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --dump-conf failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -s failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --no-header-footer failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -n failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --section-number failed"
  CHECK_RESULT $? 0 0 "Check asciidoc -v failed"
  CHECK_RESULT $? 0 0 "Check asciidoc --verbose failed"
```

- 涉及命令：test×8, asciidoc×5

#### oe_test_asciidoc_a2x_01

- 描述：Take the test a2x option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check a2x -h failed"
  CHECK_RESULT $? 0 0 "Check a2x --help failed"
  CHECK_RESULT $? 0 0 "Check a2x --version failed"
  CHECK_RESULT $? 0 0 "Check a2x -D failed"
  CHECK_RESULT $? 0 0 "Check a2x --destination-dir failed"
  CHECK_RESULT $? 0 0 "Check a2x --fop failed"
  CHECK_RESULT $? 0 0 "Check a2x -a failed"
  CHECK_RESULT $? 0 0 "Check a2x --attribute failed"
  CHECK_RESULT $? 0 0 "Check a2x -n failed"
  CHECK_RESULT $? 0 0 "Check a2x --dry-run failed"
  CHECK_RESULT $? 0 0 "Check a2x --lynx failed"
  CHECK_RESULT $? 0 0 "Check a2x --stylesheet failed"
```

- 涉及命令：test×9, a2x×6

#### oe_test_asciidoc_a2x_02

- 描述：Take the test a2x option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check a2x --asciidoc-opts failed"
  CHECK_RESULT $? 0 0 "Check a2x -d ${doctype} failed"
  CHECK_RESULT $? 0 0 "Check a2x --doctype ${doctype} failed"
  CHECK_RESULT $? 0 0 "Check a2x -L failed"
  CHECK_RESULT $? 0 0 "Check a2x --no-xmllint failed"
  CHECK_RESULT $? 0 0 "Check a2x -v failed"
  CHECK_RESULT $? 0 0 "Check a2x --verbose failed"
  CHECK_RESULT $? 0 0 "Check a2x -k failed"
  CHECK_RESULT $? 0 0 "Check a2x --keep-artifacts failed"
  CHECK_RESULT $? 0 0 "Check a2x --dblatex-opts failed"
  CHECK_RESULT $? 0 0 "Check a2x --fop-opts failed"
```

- 涉及命令：test×11, a2x×8

#### oe_test_asciidoc_a2x_03

- 描述：Take the test a2x option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check a2x --xsltproc-opts failed"
  CHECK_RESULT $? 0 0 "Check a2x --xsl-file failed"
  CHECK_RESULT $? 0 0 "Check a2x --icons failed"
  CHECK_RESULT $? 0 0 "Check a2x --icons-dir failed"
  CHECK_RESULT $? 0 0 "Check a2x -f ${format} failed"
  CHECK_RESULT $? 0 0 "Check a2x --format ${format} failed"
  CHECK_RESULT $? 0 0 "Check a2x -f pdf failed"
  CHECK_RESULT $? 0 0 "Check a2x --format pdf failed"
  CHECK_RESULT $? 0 0 "Check a2x --copy failed"
  CHECK_RESULT $? 0 0 "Check a2x --safe failed"
  CHECK_RESULT $? 0 0 "Check a2x -s failed"
  CHECK_RESULT $? 0 0 "Check a2x --skip-asciidoc failed"
```

- 涉及命令：a2x×8, test×8, sed×2
