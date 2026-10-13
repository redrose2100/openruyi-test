# autoconf213

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/autoconf213` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_autoconf213_autoconf-2.13 | Test "autoconf-2.13" command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_autoconf213_autoheader-2.13 | Test "autoheader-2.13" command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_autoconf213_autoreconf-2.13_01 | Test "autoreconf-2.13" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_autoconf213_autoreconf-2.13_02 | Test "autoreconf-2.13" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_autoconf213_autoreconf-2.13_03 | Test "autoreconf-2.13" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_autoconf213_autoreconf-2.13_04 | Test "autoreconf-2.13" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_autoconf213_autoreconf-2.13_05 | Test "autoreconf-2.13" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_autoconf213_autoreconf-2.13_06 | Test "autoreconf-2.13" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_autoconf213_autoupdate-2.13 | Test "autoupdate-2.13" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_autoconf213_ifnames-2.13 | Test "ifnames-2.13" command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_autoconf213_autoconf-2.13

- 描述：Test "autoconf-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 --help run failed"
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 -h run failed"
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 --version run failed"
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 run failed."
  CHECK_RESULT $? 0 0 "Error: configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [--localdir] run failed."
  CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [-l] run failed."
  CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [-m dir] run failed."
  CHECK_RESULT $? 0 0 "Error: [-m dir] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoconf-2.13 [--macrodir] run failed."
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×5, autoconf-2.13×3

#### oe_test_autoconf213_autoheader-2.13

- 描述：Test "autoheader-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 --help run failed"
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 -h run failed"
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 --version run failed"
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 run failed."
  CHECK_RESULT $? 0 0 "Error: config.h.in file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--localdir] run failed."
  CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-l] run failed."
  CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--macrodir] run failed."
  CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-m] run failed."
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×5, autoheader-2.13×3

#### oe_test_autoconf213_autoreconf-2.13_01

- 描述：Test "autoreconf-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 --help run failed"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 -h run failed"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 --version run failed"
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 run failed."
  CHECK_RESULT $? 0 0 "Error: configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf failed to re-config."
```

- 涉及命令：sed×2, test×1

#### oe_test_autoconf213_autoreconf-2.13_02

- 描述：Test "autoreconf-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--localdir] run failed."
  CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--localdir] failed to re-config."
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [-l] run failed."
  CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [-l] failed to re-config."
```

- 涉及命令：sed×4, test×2, autoreconf-2.13×1

#### oe_test_autoconf213_autoreconf-2.13_03

- 描述：Test "autoreconf-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--macrodir] run failed."
  CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--macrodir] failed to re-config."
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--verbose] run failed."
  CHECK_RESULT $? 0 0 "Error: [--verbose] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--verbose] failed to re-config."
```

- 涉及命令：sed×4, test×2

#### oe_test_autoconf213_autoreconf-2.13_04

- 描述：Test "autoreconf-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--force] run failed."
  CHECK_RESULT $? 0 0 "Error: [--force] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--force] failed to re-config."
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--cygnus] run failed."
  CHECK_RESULT $? 0 0 "Error: [--cygnus] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--cygnus] failed to re-config."
```

- 涉及命令：sed×4, test×2

#### oe_test_autoconf213_autoreconf-2.13_05

- 描述：Test "autoreconf-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--foreign] run failed."
  CHECK_RESULT $? 0 0 "Error: [--foreign] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--foreign] failed to re-config."
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--gnits] run failed."
  CHECK_RESULT $? 0 0 "Error: [--gnits] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--gnits] failed to re-config."
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--gnu] run failed."
  CHECK_RESULT $? 0 0 "Error: [--gnu] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--gnu] failed to re-config."
```

- 涉及命令：sed×6, test×3

#### oe_test_autoconf213_autoreconf-2.13_06

- 描述：Test "autoreconf-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [-i] run failed."
  CHECK_RESULT $? 0 0 "Error: [-i] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [-i] failed to re-config."
  CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--include-deps] run failed."
  CHECK_RESULT $? 0 0 "Error: [--include-deps] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoreconf [--include-deps] failed to re-config."
```

- 涉及命令：sed×4, test×2, autoreconf-2.13×1

#### oe_test_autoconf213_autoupdate-2.13

- 描述：Test "autoupdate-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 --help run failed"
  CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 -h run failed"
  CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 --version run failed"
  CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 run failed."
  CHECK_RESULT $? 0 0 "Error: configure~ file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 [--macrodir] run failed."
  CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."
  CHECK_RESULT $? 0 0 "Error: autoupdate-2.13 [-m dir] run failed."
  CHECK_RESULT $? 0 0 "Error: [-m dir] configure file failed to generate."
```

- 涉及命令：test×3, autoupdate-2.13×1

#### oe_test_autoconf213_ifnames-2.13

- 描述：Test "ifnames-2.13" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 --help run failed"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 -h run failed"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 --version run failed"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 run failed"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13 run failed"
  CHECK_RESULT $? 0 0 "Error: ifnames-2.13  run failed"
```

- 涉及命令：ifnames-2.13×1
