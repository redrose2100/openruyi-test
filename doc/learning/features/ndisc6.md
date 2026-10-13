# ndisc6

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ndisc6` |
| 注册用例数 | 9 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ndisc6_addr2name | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ndisc6_name2addr | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_ndisc6_ndisc6 | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_ndisc6_rdisc6 | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ndisc6_rdnssd | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ndisc6_rltraceroute6 | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_ndisc6_tcpspray | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ndisc6_tcptraceroute6 | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_ndisc6_tracert6 | The usage of commands in ndisc6 package | pre_test/run_test/post_test | 8 |  |  |  |

### 断言与命令明细

#### oe_test_ndisc6_addr2name

- 描述：The usage of commands in ndisc6 package
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

- 涉及命令：addr2name×10

#### oe_test_ndisc6_name2addr

- 描述：The usage of commands in ndisc6 package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

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
```

- 涉及命令：name2addr×8, dnssort×1

#### oe_test_ndisc6_ndisc6

- 描述：The usage of commands in ndisc6 package
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：ndisc6×7

#### oe_test_ndisc6_rdisc6

- 描述：The usage of commands in ndisc6 package
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rdisc6×4

#### oe_test_ndisc6_rdnssd

- 描述：The usage of commands in ndisc6 package
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

- 涉及命令：rdnssd×7, kill×5

#### oe_test_ndisc6_rltraceroute6

- 描述：The usage of commands in ndisc6 package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rltraceroute6×8

#### oe_test_ndisc6_tcpspray

- 描述：The usage of commands in ndisc6 package
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

- 涉及命令：tcpspray×5, tcpspray6×5

#### oe_test_ndisc6_tcptraceroute6

- 描述：The usage of commands in ndisc6 package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：tcptraceroute6×9

#### oe_test_ndisc6_tracert6

- 描述：The usage of commands in ndisc6 package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：tracert6×8
