# libwmf

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libwmf` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libwmf_libwmf-fontmap | Test "libwmf libwmf-fontmap" command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_libwmf_wmf2eps_01 | Test "wmf2eps" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libwmf_wmf2eps_02 | Test "wmf2eps" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libwmf_wmf2eps_03 | Test "wmf2eps" command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_libwmf_wmf2gd_01 | Test "libwmf wmf2gd" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libwmf_wmf2gd_02 | Test "libwmf wmf2gd" command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_libwmf_wmf2fig_01 | Test "wmf2fig" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libwmf_wmf2fig_02 | Test "wmf2fig" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libwmf_wmf2fig_03 | Test "wmf2fig" command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_libwmf_wmf2svg_01 | Test "libwmf wmf2svg" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libwmf_wmf2svg_02 | Test "libwmf wmf2svg" command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libwmf_libwmf-fontmap

- 描述：Test "libwmf libwmf-fontmap" command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "common libwmf-fontmap error"
```

#### oe_test_libwmf_wmf2eps_01

- 描述：Test "wmf2eps" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option --eps error"
  CHECK_RESULT $? 0 0 "option --ps error"
  CHECK_RESULT $? 0 0 "option --page error"
  CHECK_RESULT $? 0 0 "option --landscape error"
  CHECK_RESULT $? 0 0 "option --portrait error"
  CHECK_RESULT $? 0 0 "option --bbox error"
  CHECK_RESULT $? 0 0 "option --centre error"
  CHECK_RESULT $? 0 0 "option --maxpect error"
  CHECK_RESULT $? 0 0 "option --title --creator --date error"
  CHECK_RESULT $? 0 0 "option --for error"
```

- 涉及命令：test×2

#### oe_test_libwmf_wmf2eps_02

- 描述：Test "wmf2eps" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option --version error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --wmf-error error"
  CHECK_RESULT $? 0 0 "option --wmf-debug error"
  CHECK_RESULT $? 0 0 "option --wmf-ignore-nonfatal error"
  CHECK_RESULT $? 0 0 "option --wmf-diagnostics error"
  CHECK_RESULT $? 0 0 "option --wmf-fontdir error"
  CHECK_RESULT $? 0 0 "option --wmf-sys-fontmap and --wmf-sys-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-xtra-fontmap and --wmf-xtra-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-gs-fontmap error"
```

- 涉及命令：test×8

#### oe_test_libwmf_wmf2eps_03

- 描述：Test "wmf2eps" command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "option --wmf-write error"
```

#### oe_test_libwmf_wmf2gd_01

- 描述：Test "libwmf wmf2gd" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option -t error"
  CHECK_RESULT $? 0 0 "option --maxwidth error"
  CHECK_RESULT $? 0 0 "option --maxheight error"
  CHECK_RESULT $? 0 0 "option --maxpect error"
  CHECK_RESULT $? 0 0 "option --maxsize error"
  CHECK_RESULT $? 0 0 "option --version error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --wmf-error error"
  CHECK_RESULT $? 0 0 "option --wmf-debug error"
  CHECK_RESULT $? 0 0 "option --wmf-ignore-nonfatal error"
```

- 涉及命令：test×8, wmf2gd×1

#### oe_test_libwmf_wmf2gd_02

- 描述：Test "libwmf wmf2gd" command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "option --wmf-diagnostics error"
  CHECK_RESULT $? 0 0 "option --wmf-fontdir error"
  CHECK_RESULT $? 0 0 "option --wmf-sys-fontmap and --wmf-sys-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-xtra-fontmap and --wmf-xtra-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-gs-fontmap error"
  CHECK_RESULT $? 0 0 "option --wmf-write error"
```

- 涉及命令：test×5

#### oe_test_libwmf_wmf2fig_01

- 描述：Test "wmf2fig" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option --figunit error"
  CHECK_RESULT $? 0 0 "option --page error"
  CHECK_RESULT $? 0 0 "option --landscape error"
  CHECK_RESULT $? 0 0 "option --portrait error"
  CHECK_RESULT $? 0 0 "option --maxpect error"
  CHECK_RESULT $? 0 0 "option --no-margins error"
  CHECK_RESULT $? 0 0 "option --flat error"
  CHECK_RESULT $? 0 0 "option --image error"
  CHECK_RESULT $? 0 0 "option --title --creator --date error"
  CHECK_RESULT $? 0 0 "option --for error"
```

- 涉及命令：test×1

#### oe_test_libwmf_wmf2fig_02

- 描述：Test "wmf2fig" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option --version error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --wmf-error error"
  CHECK_RESULT $? 0 0 "option --wmf-debug error"
  CHECK_RESULT $? 0 0 "option --wmf-ignore-nonfatal error"
  CHECK_RESULT $? 0 0 "option --wmf-diagnostics error"
  CHECK_RESULT $? 0 0 "option --wmf-fontdir error"
  CHECK_RESULT $? 0 0 "option --wmf-sys-fontmap and --wmf-sys-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-xtra-fontmap and --wmf-xtra-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-gs-fontmap error"
```

- 涉及命令：test×8

#### oe_test_libwmf_wmf2fig_03

- 描述：Test "wmf2fig" command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "option --wmf-write error"
```

#### oe_test_libwmf_wmf2svg_01

- 描述：Test "libwmf wmf2svg" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option -z error"
  CHECK_RESULT $? 0 0 "option --inline error"
  CHECK_RESULT $? 0 0 "option --desc error"
  CHECK_RESULT $? 0 0 "option --maxwidth error"
  CHECK_RESULT $? 0 0 "option --maxheight error"
  CHECK_RESULT $? 0 0 "option --maxpect error"
  CHECK_RESULT $? 0 0 "option --maxsize error"
  CHECK_RESULT $? 0 0 "option --version error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --wmf-error error"
```

- 涉及命令：test×4, wmf2svg×1

#### oe_test_libwmf_wmf2svg_02

- 描述：Test "libwmf wmf2svg" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "option --wmf-debug error"
  CHECK_RESULT $? 0 0 "option --wmf-ignore-nonfatal error"
  CHECK_RESULT $? 0 0 "option --wmf-diagnostics error"
  CHECK_RESULT $? 0 0 "option --wmf-fontdir error"
  CHECK_RESULT $? 0 0 "option --wmf-sys-fontmap and --wmf-sys-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-xtra-fontmap and --wmf-xtra-fonts error"
  CHECK_RESULT $? 0 0 "option --wmf-gs-fontmap error"
  CHECK_RESULT $? 0 0 "option --wmf-write error"
```

- 涉及命令：test×7
