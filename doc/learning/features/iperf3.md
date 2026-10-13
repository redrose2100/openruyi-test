# iperf3

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/iperf3` |
| 注册用例数 | 4 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_iperf3_command_client | iperf3 command parameter automation use case | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_iperf3_command_clientAndShared | iperf3 command parameter automation use case | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_iperf3_command_serverAndBase | iperf3 command parameter automation use case,use server execution | pre_test/run_test/post_test | 9 | ✔ | ✔ |  |
| oe_test_iperf3_client | Test "iperf3 -c 127.0.0.1 -t 3 -i 1 -p 51314" command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_iperf3_command_client

- 描述：iperf3 command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "iperf3 -n execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -k execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -P execution failed."
  CHECK_RESULT $? 0 0 "iperf3 --get-server-output execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -w execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -R execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -T execution failed."
```

- 涉及命令：iperf3×6

#### oe_test_iperf3_command_clientAndShared

- 描述：iperf3 command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "iperf3 -d execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -f execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -V execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -J execution failed."
  CHECK_RESULT $? 0 0 "iperf3 --logfile execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -u execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -t 2 execution failed."
```

- 涉及命令：iperf3×6, time×1

#### oe_test_iperf3_command_serverAndBase

- 描述：iperf3 command parameter automation use case,use server execution
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "iperf3 -v execution failed."
  CHECK_RESULT $? 0 0 "iperf3 --version execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -h execution failed."
  CHECK_RESULT $? 0 0 "iperf3 --help execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -s execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -c serverIP execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -s -p execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -s -I execution failed."
  CHECK_RESULT $? 0 0 "iperf3 -s -1 execution failed."
```

- 涉及命令：iperf3×6, kill×3, netstat×2

#### oe_test_iperf3_client

- 描述：Test "iperf3 -c 127.0.0.1 -t 3 -i 1 -p 51314" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "CHECK iperf3 -s -p 51314 -i 1 -D FAILED"
  CHECK_RESULT $? 0 0 "Error: iperf3 -c ... run failed"
  CHECK_RESULT $? 0 0 "CHECK iperf3 -s -p 51314 -D FAILED"
  CHECK_RESULT $? 0 0 "Error: iperf3 -P ... run failed"
  CHECK_RESULT $? 0 0 "CHECK iperf3 -s -p 51314 -D FAILED"
  CHECK_RESULT $? 0 0 "Error: iperf3 -s ... run failed"
  CHECK_RESULT $? 0 0 "CHECK iperf3 -s -p 51314 -D FAILED"
  CHECK_RESULT $? 0 0 "Error: iperf3 -u -b ... run failed"
  CHECK_RESULT $? 0 0 "Error: iperf3 -v run failed"
  CHECK_RESULT $? 0 0 "Error: iperf3 --version run failed"
```

- 涉及命令：iperf3×8
