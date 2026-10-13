# lksctp-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lksctp-tools` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_lksctp-tools_checksctp | Test checksctp, withsctp | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_lksctp-tools_sctp_darn_01 | Test sctp_darn | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_lksctp-tools_sctp_darn_02 | Test sctp_darn | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_lksctp-tools_sctp_status | Test sctp_status | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_lksctp-tools_sctp_test | Test sctp_test | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_lksctp-tools_checksctp

- 描述：Test checksctp, withsctp
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "checksctp: failed to test checksctp"
  CHECK_RESULT $? 0 0 "withsctp: failed to test withsctp"
```

#### oe_test_lksctp-tools_sctp_darn_01

- 描述：Test sctp_darn
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test options: -H, -P, -h, -p, -s, -l, -B, -b, -c"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test options: -t, -z, --interface"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test options: -m, -i, --use-poll"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command '?'"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'snd=<int>'"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'stats'"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'rcv=<int>'"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'shutdown'"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'abort'"
  CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'bindx-add=<addr>'"
```

- 涉及命令：kill×5, tail×1

#### oe_test_lksctp-tools_sctp_darn_02

- 描述：Test sctp_darn
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'bindx-add=<addr>'"
  CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'rcvbuf=<int>'"
  CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'sndbuf=<int>'"
  CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'primary=<addr>'"
  CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'peer_primary=<addr>'"
  CHECK_RESULT $? 1 0 "sctp_darn: failed to test interactive command 'heartbeat=<addr>'"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'maxseg=<int>'"
  CHECK_RESULT $? 0 0 "sctp_darn: failed to test interactive command 'nodelay=<0|1>'"
```

#### oe_test_lksctp-tools_sctp_status

- 描述：Test sctp_status
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -i, -d, -f"
  CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -c, -o, -f"
  CHECK_RESULT $? 0 0 "sctp_status: failed to test option: -x"
  CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -M, -m, -o"
  CHECK_RESULT $? 0 0 "sctp_status: failed to test options: -I, -i, -d"
```

- 涉及命令：kill×7, sctp_status×5, sctp_darn×1

#### oe_test_lksctp-tools_sctp_test

- 描述：Test sctp_test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "sctp_test: failed to test server"
  CHECK_RESULT $? 0 0 "sctp_test: failed to test server options: -L, -S, -a"
  CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -c, -o, -d"
  CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -L, -S, -a"
  CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -m, -t, -M"
  CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -r, -D, -T"
  CHECK_RESULT $? 0 0 "sctp_test: failed to test client options: -B, -O, -i"
  CHECK_RESULT $? 0 0 "sctp_test: failed to test client option: -x"
```

- 涉及命令：kill×9, sctp_test×8
