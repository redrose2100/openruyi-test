# ant

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ant` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ant_001 | Test ant | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_ant_002 | Test ant | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_ant_003 | Test ant | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_ant_004 | Test ant | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_ant_005 | ant run java | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ant_001

- 描述：Test ant
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test failed with option --h"
  CHECK_RESULT $? 0 0 "test failed with option --help"
  CHECK_RESULT $? 0 0 "test failed with option --noconfig"
  CHECK_RESULT $? 0 0 "test failed with option --usejikes"
  CHECK_RESULT $? 0 0 "test failed with option --execdebug"
  CHECK_RESULT $? 0 0 "test failed with option -h"
  CHECK_RESULT $? 0 0 "test failed with option -help"
  CHECK_RESULT $? 0 0 "test failed with option -projecthelp"
  CHECK_RESULT $? 0 0 "test failed with option -p"
  CHECK_RESULT $? 0 0 "test failed with option -version"
```

- 涉及命令：ant×5

#### oe_test_ant_002

- 描述：Test ant
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "test failed with option -diagnostics"
  CHECK_RESULT $? 0 0 "test failed with option -quiet"
  CHECK_RESULT $? 0 0 "test failed with option -q"
  CHECK_RESULT $? 0 0 "test failed with option -silent"
  CHECK_RESULT $? 0 0 "test failed with option -S"
  CHECK_RESULT $? 0 0 "test failed with option -verbose"
  CHECK_RESULT $? 0 0 "test failed with option -v"
  CHECK_RESULT $? 0 0 "test failed with option -debug"
  CHECK_RESULT $? 0 0 "test failed with option -d"
  CHECK_RESULT $? 0 0 "test failed with option -e"
  CHECK_RESULT $? 0 0 "test failed with option -emacs"
```

- 涉及命令：ant×11

#### oe_test_ant_003

- 描述：Test ant
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test failed with option -lib"
  CHECK_RESULT $? 0 0 "test failed with option -logfile"
  CHECK_RESULT $? 0 0 "test failed with option -l"
  CHECK_RESULT $? 0 0 "test failed with option -logger"
  CHECK_RESULT $? 0 0 "test failed with option -listener"
  CHECK_RESULT $? 0 0 "test failed with option -f"
  CHECK_RESULT $? 0 0 "test failed with option -file"
  CHECK_RESULT $? 0 0 "test failed with option -buildfile"
  CHECK_RESULT $? 0 0 "test failed with option -noinput"
```

- 涉及命令：ant×6

#### oe_test_ant_004

- 描述：Test ant
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "test failed with option -D"
  CHECK_RESULT $? 0 0 "test failed with option -k"
  CHECK_RESULT $? 0 0 "test failed with option -keep-going"
  CHECK_RESULT $? 0 0 "test failed with option -propertyfile"
  CHECK_RESULT $? 0 0 "test failed with option -inputhandler"
  CHECK_RESULT $? 0 0 "test failed with option -find"
  CHECK_RESULT $? 0 0 "test failed with option -s"
  CHECK_RESULT $? 0 0 "test failed with option -nice"
  CHECK_RESULT $? 1 0 "test failed with option -nouserlib"
  CHECK_RESULT $? 1 0 "test failed with option -noclasspath"
  CHECK_RESULT $? 0 0 "test failed with option -autoproxy"
  CHECK_RESULT $? 0 0 "test failed with option -main"
```

- 涉及命令：ant×9, mkdir×2, javac×2

#### oe_test_ant_005

- 描述：ant run java
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Ant failed to execute javac and could not generate the class file"
  CHECK_RESULT $? 0 0 "ant run fails"
```

- 涉及命令：test×1
