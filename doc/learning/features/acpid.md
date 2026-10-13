# acpid

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/acpid` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_acpid | Test acpid.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_acpid | Test acpid.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_acpid_01 | Take the test for acpid-option | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_acpid_02 | Take the test for acpid-option | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_acpid_03 | Take the test for acpid-option | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_acpid

- 描述：Test acpid.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_acpid

- 描述：Test acpid.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_acpid_01

- 描述：Take the test for acpid-option
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -f"
  CHECK_RESULT $? 0 0 "Failed option: -l"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 0 0 "Failed option: -n"
  CHECK_RESULT $? 1 0 "Failed option: -n"
  CHECK_RESULT $? 0 0 "acpid.socket is not found"
  CHECK_RESULT $? 0 0 "Failed option: -g"
  CHECK_RESULT $? 0 0 "Failed option: -m"
  CHECK_RESULT $? 0 0 "Failed option: -m"
  CHECK_RESULT $? 0 0 "Failed option: -p"
```

- 涉及命令：acpid×6

#### oe_test_acpid_02

- 描述：Take the test for acpid-option
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: --version"
  CHECK_RESULT $? 0 0 "Failed option: --help"
  CHECK_RESULT $? 0 0 "Failed option: --foreground"
  CHECK_RESULT $? 0 0 "Failed option: --logevents"
  CHECK_RESULT $? 0 0 "Failed option: --debug"
  CHECK_RESULT $? 0 0 "Failed option: --netlink"
  CHECK_RESULT $? 1 0 "Failed option: --netlink"
  CHECK_RESULT $? 0 0 "acpid.socket is not found"
  CHECK_RESULT $? 0 0 "Failed option: --socketgroup"
  CHECK_RESULT $? 0 0 "Failed option: --socketmode"
  CHECK_RESULT $? 0 0 "Failed option: --socketmode"
  CHECK_RESULT $? 0 0 "Failed option: --pidfile"
```

- 涉及命令：acpid×2

#### oe_test_acpid_03

- 描述：Take the test for acpid-option
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: --version"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: --help"
```
