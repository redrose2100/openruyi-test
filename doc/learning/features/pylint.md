# pylint

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pylint` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pylint_01 | Test "pylint" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pylint_02 | Test "pylint" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pylint_03 | Test "pylint" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pylint_04 | Test "pylint" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_epylint | Test "pylint" command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_symilar | Test "pylint" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_pyreverse_01 | Test "pylint" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyreverse_02 | Test "pylint" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyreverse_03 | Test "pylint" command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pylint_01

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -long-help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --init-hook <code> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -E No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --py3k No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --verbose No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --ignore No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --ignore-patterns No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --persistent <y_or_n> No Pass"
```

- 涉及命令：pylint×3

#### oe_test_pylint_02

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --load-plugins <modules> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --fail-under <score> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -j <n-processes> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --limit-inference-results <number-of-results> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --extension-pkg-whitelist pkg No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --suggestion-mode <yn> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --exit-zero No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --from-stdin No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --rcfile <file> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --help-msg <msg-id> No Pass"
```

- 涉及命令：pylint×1

#### oe_test_pylint_03

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-msgs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-msgs-enabled No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-groups No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-conf-levels No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --list-extensions No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --full-documentation No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --generate-rcfile No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --confidence <levels> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -e <msg ids> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --enable <msg ids> No Pass"
```

- 涉及命令：pylint×1

#### oe_test_pylint_04

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -d <msg ids> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --disable=<msg ids> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -f <format> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -f <format> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -r <y_or_n> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -r <y_or_n> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --evaluation <python_expression> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint -s <y_or_n> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --score <y_or_n> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: pylint --msg-template <template> No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --version No Pass"
```

- 涉及命令：pylint×4

#### oe_test_epylint

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: epylint <filename> No Pass"
```

#### oe_test_symilar

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: symilar -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: symilar -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: symilar -i No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: symilar --ignore-comments No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: symilar --ignore-docstrings No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: symilar --ignore-imports No Pass"
```

- 涉及命令：symilar×2

#### oe_test_pyreverse_01

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --filter-mode No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -class No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --show-ancestors No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --all-ancestors No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -A No Pass"
```

- 涉及命令：pyreverse×5

#### oe_test_pyreverse_02

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: --show-associated No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --all-associated No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -S No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --show-builtin No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --module-names No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --only-classnames No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -k No Pass"
```

- 涉及命令：pyreverse×5

#### oe_test_pyreverse_03

- 描述：Test "pylint" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: --output No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --ignore No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --project No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
```

- 涉及命令：pyreverse×2
