# jython

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jython` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jython_01 | the test of pngcrush package | pre_test/run_test/post_test | 12 | ✔ |  | 60m |
| oe_test_jython_02 | the test of pngcrush package | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_jython_03 | the test of pngcrush package | pre_test/run_test/post_test | 5 | ✔ |  | 60m |

### 断言与命令明细

#### oe_test_jython_01

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: jython --help"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -h"
  CHECK_RESULT $? 0 0 "Failed to run command: jython --version"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -V"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -c"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -i"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -S"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -Q"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -B"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -v"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -vv"
  CHECK_RESULT $? 0 0 "Failed to run command: jython [file]"
```

- 涉及命令：jython×9

#### oe_test_jython_02

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: jython -D"
  CHECK_RESULT $? 0 0 "Failed to run command: jython (interactive mode)"
  CHECK_RESULT $? 0 0 "Failed to run command: jython arg"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -m"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -3"
  CHECK_RESULT $? 0 1 "Failed to run command: jython -W"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -s"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -u"
```

- 涉及命令：jython×7

#### oe_test_jython_03

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: jython --print"
  CHECK_RESULT $? 0 0 "Failed to run command: jython -Jarg"
  CHECK_RESULT $? 0 0 "Failed to run command: jython --profile"
  CHECK_RESULT $? 0 0 "Failed to run command: jython --boot"
  CHECK_RESULT $? 0 0 "Failed to run command: jython --jdb"
```

- 涉及命令：jython×2, javac×1, expect×1
