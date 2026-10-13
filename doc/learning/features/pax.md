# pax

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pax` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pax_runtest_01 | The test of pax package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_pax_runtest_02 | The test of pax package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pax_runtest_03 | The test of pax package | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_pax_runtest_04 | The test of pax package | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pax_runtest_01

- 描述：The test of pax package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: pax -w"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -f"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -z"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -v"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -x"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -t"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -X"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -O"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -0"
```

- 涉及命令：pax×9, test×6

#### oe_test_pax_runtest_02

- 描述：The test of pax package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: pax -a"
  CHECK_RESULT $? 1 0 "Failed to run command: pax -d"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -s"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -U"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -G"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -T"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -i"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -r"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -l"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -u"
```

- 涉及命令：pax×9, tar×7, test×2

#### oe_test_pax_runtest_03

- 描述：The test of pax package
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: pax -B"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -p"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -k"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -n"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -c"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -E"
  CHECK_RESULT $? 1 0 "Failed to run command: pax -Z"
  CHECK_RESULT $? 0 0 "Run command successfully: pax -Z"
  CHECK_RESULT $? 1 0 "Failed to run command: pax -D"
  CHECK_RESULT $? 0 0 "Run command successfully: pax -Z"
  CHECK_RESULT $? 1 0 "Failed to run command: pax -Y"
  CHECK_RESULT $? 0 0 "Run command successfully: pax -Z"
```

- 涉及命令：pax×12, test×2

#### oe_test_pax_runtest_04

- 描述：The test of pax package
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: pax -P"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -P"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -H"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -H"
  CHECK_RESULT $? 0 0 "Failed to run command: pax -H"
```

- 涉及命令：test×4, pax×3
