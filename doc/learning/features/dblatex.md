# dblatex

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dblatex` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dblatex_dblatex_01 | Take the test dblatex option | config_params/pre_test/run_test/post_test | 10 |  |  | 60m |
| oe_test_dblatex_dblatex_02 | Take the test dblatex option | config_params/pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_dblatex_dblatex_03 | Take the test dblatex option | config_params/pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_dblatex_dblatex_04 | Take the test dblatex option | config_params/pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_dblatex_dblatex_05 | Take the test dblatex option | config_params/pre_test/run_test/post_test | 9 |  |  | 60m |
| oe_test_dblatex_dblatex_06 | Take the test dblatex option | config_params/pre_test/run_test/post_test | 9 |  |  |  |

### 断言与命令明细

#### oe_test_dblatex_dblatex_01

- 描述：Take the test dblatex option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: -v error"
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "option: -o error"
  CHECK_RESULT $? 0 0 "option: --output=OUTPUT error"
  CHECK_RESULT $? 0 0 "option: -O error"
  CHECK_RESULT $? 0 0 "option: --output-dir error"
  CHECK_RESULT $? 0 0 "option: -b ${backend} error"
  CHECK_RESULT $? 0 0 "option: --backend=${backend} error"
```

- 涉及命令：dblatex×5, test×4

#### oe_test_dblatex_dblatex_02

- 描述：Take the test dblatex option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "option: -c error"
  CHECK_RESULT $? 0 0 "option: -S error"
  CHECK_RESULT $? 0 0 "option: --config error"
  CHECK_RESULT $? 0 0 "option: -C error"
  CHECK_RESULT $? 0 0 "option: --changedir error"
  CHECK_RESULT $? 0 0 "option: -d error"
  CHECK_RESULT $? 0 0 "option: --debug error"
  CHECK_RESULT $? 0 0 "option: -D error"
  CHECK_RESULT $? 0 0 "option: --dump error"
  CHECK_RESULT $? 0 0 "option: -e error"
  CHECK_RESULT $? 0 0 "option: --indexstyle error"
```

- 涉及命令：dblatex×11

#### oe_test_dblatex_dblatex_03

- 描述：Take the test dblatex option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option: -f ${fit_format} error"
  CHECK_RESULT $? 0 0 "option: --fig-format=${fit_format} error"
  CHECK_RESULT $? 0 0 "option: -F xml error"
  CHECK_RESULT $? 0 0 "option: --input-format=${input_format} error"
  CHECK_RESULT $? 0 0 "option: -i error"
  CHECK_RESULT $? 0 0 "option: --texinputs error"
  CHECK_RESULT $? 0 0 "option: -I error"
  CHECK_RESULT $? 0 0 "option: --fig-path error"
  CHECK_RESULT $? 0 0 "option: -l error"
  CHECK_RESULT $? 0 0 "option: --bst-path error"
```

- 涉及命令：dblatex×10

#### oe_test_dblatex_dblatex_04

- 描述：Take the test dblatex option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option: -L error"
  CHECK_RESULT $? 0 0 "option: --bib-path error"
  CHECK_RESULT $? 0 0 "option: -m xsltproc error"
  CHECK_RESULT $? 0 0 "option: --xslt=xsltproc error"
  CHECK_RESULT $? 0 0 "option: -p error"
  CHECK_RESULT $? 0 0 "option: --xsl-user error"
  CHECK_RESULT $? 0 0 "option: -P error"
  CHECK_RESULT $? 0 0 "option: --param error"
  CHECK_RESULT $? 0 0 "option: -q error"
  CHECK_RESULT $? 0 0 "option: --quiet error"
```

- 涉及命令：dblatex×10

#### oe_test_dblatex_dblatex_05

- 描述：Take the test dblatex option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "option: -r error"
  CHECK_RESULT $? 0 0 "option: --texpost error"
  CHECK_RESULT $? 0 0 "option: -s error"
  CHECK_RESULT $? 0 0 "option: --texstyle error"
  CHECK_RESULT $? 0 0 "option: -t ${format} error"
  CHECK_RESULT $? 0 0 "option: --type=${format} error"
  CHECK_RESULT $? 0 0 "option: --${format} error"
  CHECK_RESULT $? 0 0 "option: -T ${style} error"
  CHECK_RESULT $? 0 0 "option: --style=${style} error"
```

- 涉及命令：dblatex×8

#### oe_test_dblatex_dblatex_06

- 描述：Take the test dblatex option
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "option: --tmpdir error"
  CHECK_RESULT $? 0 0 "option: -V error"
  CHECK_RESULT $? 0 0 "option: --verbose error"
  CHECK_RESULT $? 0 0 "option: -x error"
  CHECK_RESULT $? 0 0 "option: --xslt-opts error"
  CHECK_RESULT $? 0 0 "option: -X error"
  CHECK_RESULT $? 0 0 "option: --no-external error"
  CHECK_RESULT $? 0 0 "option: -B error"
  CHECK_RESULT $? 0 0 "option: --no-batch error"
```

- 涉及命令：dblatex×9, mkdir×1
