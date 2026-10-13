# linuxconsoletools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/linuxconsoletools` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_linuxconsoletools_evdev-joystick | Test "linuxconsoletools" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_linuxconsoletools | Test "linuxconsoletools" command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_linuxconsoletools_evdev-joystick

- 描述：Test "linuxconsoletools" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: --help, --h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --listdevs, --l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --showcal, --s [path] No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --evdev, --e [path] No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --minimum, --m [val] No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --maximum, --M [val] No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --deadzone, --d [val] No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --fuzz, --f [val] No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --axis, --a [val] No Pass"
```

#### oe_test_linuxconsoletools

- 描述：Test "linuxconsoletools" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: ffcfstress -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ffcfstress --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: ffset --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: fftest --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: inputattach --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: jscal -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: jscal --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: jstest --help No Pass"
```

- 涉及命令：ffcfstress×1, jscal×1
