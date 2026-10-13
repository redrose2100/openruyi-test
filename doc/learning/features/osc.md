# osc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/osc` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_osc_01 | OSC is a command line tool based on OBS, which is equivalent to the interface of OBS. | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_osc_02 | OSC is a command line tool based on OBS, which is equivalent to the interface of OBS. | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_osc_03 | OSC is a command line tool based on OBS, which is equivalent to the interface of OBS. | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_osc_04 | OSC is a command line tool based on OBS, which is equivalent to the interface of OBS. | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_osc_05 | OSC is a command line tool based on OBS, which is equivalent to the interface of OBS. | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_osc_06 | OSC is a command line tool based on OBS, which is equivalent to the interface of OBS. | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_osc_07 | OSC is a command line tool based on OBS, which is equivalent to the interface of OBS. | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_osc_build | osc build | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_osc_01

- 描述：OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_osc_02

- 描述：OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_osc_03

- 描述：OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_osc_04

- 描述：OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_osc_05

- 描述：OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0 'Package locked failed'
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

#### oe_test_osc_06

- 描述：OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

#### oe_test_osc_07

- 描述：OSC is a command line tool based on OBS, which is equivalent to the interface of OBS.
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_osc_build

- 描述：osc build
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```
