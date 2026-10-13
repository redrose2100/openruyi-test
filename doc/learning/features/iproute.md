# iproute

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/iproute` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_iproute_tc_01 | File system common command test-iproute_tc | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_iproute_tc_02 | File system common command test-iproute_tc | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_netns | system common command ip netns | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_iproute_tc_01

- 描述：File system common command test-iproute_tc
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "queue status display failure"
  CHECK_RESULT $? 0 0 "The NIC status fails to be displayed"
  CHECK_RESULT $? 0 0 "Failed to delay setting for 100 milliseconds"
  CHECK_RESULT $? 0 0 "Failed to delete the 100ms delay setting"
  CHECK_RESULT $? 0 0 "Failed to set the delay value with volatility"
  CHECK_RESULT $? 0 0 "Failed to delete a delay value setting with volatility"
  CHECK_RESULT $? 0 0 "set 30% packets, the delay fails"
  CHECK_RESULT $? 0 0 "Deleting 30% packets fails. Procedure"
```

#### oe_test_iproute_tc_02

- 描述：File system common command test-iproute_tc
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "add netem loss 1% fail"
  CHECK_RESULT $? 0 0 "del netem loss 1% fail"
  CHECK_RESULT $? 0 0 "add netem loss 1%-3% fail"
  CHECK_RESULT $? 0 0 "del netem loss 1%-3% fail"
  CHECK_RESULT $? 0 0 "add netem duplicate 1% fail"
  CHECK_RESULT $? 0 0 "del netem duplicate 1% fail"
  CHECK_RESULT $? 0 0 "add netem corrupt 0.2% fail"
  CHECK_RESULT $? 0 0 "del netem corrupt 0.2% fail"
```

#### oe_test_netns

- 描述：system common command ip netns
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "netns1 add failed"
  CHECK_RESULT $? 0 0 "Description Failed to enter the virtual network"
  CHECK_RESULT $? 0 0 "up netns1 failed"
  CHECK_RESULT $? 0 0 "ping 127.0.0.1 failed"
  CHECK_RESULT $? 0 0 "netns1 not found"
```
