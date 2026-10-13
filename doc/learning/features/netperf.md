# netperf

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/netperf` |
| 注册用例数 | 3 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_netperf_basic_command | netperf basic command line test | pre_test/run_test/post_test | 24 |  | ✔ |  |
| oe_test_netperf_diff_connect_model | netperf test different connect models | pre_test/run_test/post_test | 7 |  | ✔ |  |
| oe_test_netperf_remote_command | netperf test remote command-netserver | pre_test/run_test/post_test | 10 |  | ✔ |  |

### 断言与命令明细

#### oe_test_netperf_basic_command

- 描述：netperf basic command line test
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "netserver execution failed."
  CHECK_RESULT $? 0 0 "netperf -V execution failed."
  CHECK_RESULT $? 0 0 "netperf -h execution failed."
  CHECK_RESULT $? 0 0 "netperf -H execution failed."
  CHECK_RESULT $? 0 0 "netperf -a -A execution failed."
  CHECK_RESULT $? 0 0 "netperf -c -C execution failed."
  CHECK_RESULT $? 0 0 "netperf -d execution failed."
  CHECK_RESULT $? 0 0 "netperf -F file execution failed."
  CHECK_RESULT $? 0 0 "netperf -i -I execution failed."
  CHECK_RESULT $? 0 0 "netperf -r execution failed."
  CHECK_RESULT $? 0 0 "netperf -j -L execution failed."
  CHECK_RESULT $? 0 0 "netperf -o -n 2 execution failed."
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：netperf×22, netstat×1

#### oe_test_netperf_diff_connect_model

- 描述：netperf test different connect models
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "netserver execution failed."
  CHECK_RESULT $? 0 0 "netperf -t UDP_STREAM execution failed."
  CHECK_RESULT $? 0 0 "netperf -t TCP_STREAM execution failed."
  CHECK_RESULT $? 0 0 "netperf -t TCP_RR execution failed."
  CHECK_RESULT $? 0 0 "netperf -t TCP_CRR execution failed."
  CHECK_RESULT $? 0 0 "netperf -t UDP_RR execution failed."
  CHECK_RESULT $? 0 1 "pkill -9 netserver execution failed."
```

- 涉及命令：netperf×5, netstat×1

#### oe_test_netperf_remote_command

- 描述：netperf test remote command-netserver
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "netserver -h failed."
  CHECK_RESULT $? 0 0 "netserver -V failed."
  CHECK_RESULT $? 0 0 "netserver -d failed."
  CHECK_RESULT $? 0 0 "netserver -f -N -v 2 failed."
  CHECK_RESULT $? 0 0 "netserver -L name,family failed."
  CHECK_RESULT $? 0 0 "netserver -4 failed."
  CHECK_RESULT $? 0 0 "netserver -6 failed."
  CHECK_RESULT $? 0 0 "netserver -Z 123 failed."
  CHECK_RESULT $? 0 0 "after netserver -Z 123,netperf -Z execution failed."
  CHECK_RESULT $? 0 1 "pkill -9 netserver execution failed."
```

- 涉及命令：netperf×1, netstat×1
