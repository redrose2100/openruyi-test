# ntp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ntp` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_ntpdate | Test ntpdate.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ntpd | Test ntpd.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_service_ntp-wait | Test ntp-wait.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_sntp | Test sntp.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_ntpdc_basic | Test ntpdc help, version, basic flags | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ntpd_basic | Test ntpd help, version, daemon flags | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ntpq_peers | Test ntpq -p/-n peers and -c interactive commands | wait_for_ntp/pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_ntpdate

- 描述：Test ntpdate.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×7

#### oe_test_service_ntpd

- 描述：Test ntpd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_ntp-wait

- 描述：Test ntp-wait.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_sntp

- 描述：Test sntp.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×6

#### oe_test_ntpdc_basic

- 描述：Test ntpdc help, version, basic flags
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check ntpdc --help failed"
  CHECK_RESULT $? 0 0 "check ntpdc -c version failed"
  CHECK_RESULT $? 0 0 "check ntpdc -4 flag failed"
```

- 涉及命令：ntpdc×2

#### oe_test_ntpd_basic

- 描述：Test ntpd help, version, daemon flags
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check ntpd --help failed"
  CHECK_RESULT $? 0 0 "check ntpd --version failed"
  CHECK_RESULT $? 0 0 "check ntpd -4 flag failed"
```

- 涉及命令：ntpd×1

#### oe_test_ntpq_peers

- 描述：Test ntpq -p/-n peers and -c interactive commands
- 函数：`wait_for_ntp, pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "ntpq -c version failed"
  CHECK_RESULT $? 0 0 "ntpq -c help failed"
  CHECK_RESULT $? 0 0 "ntpq -p execution failed"
  CHECK_RESULT 1 0 0 "ntpq -p invalid output"
  CHECK_RESULT $? 0 0 "ntpq -n -p execution failed"
  CHECK_RESULT $? 0 0 "ntpq -c peers execution failed"
  CHECK_RESULT 1 0 0 "ntpq -c peers invalid output"
  CHECK_RESULT $? 0 0 "ntpq -c rv execution failed"
  CHECK_RESULT $? 0 0 "ntpq -c associations execution failed"
  CHECK_RESULT 1 0 0 "ntpq -c associations invalid output"
  CHECK_RESULT $? 0 0 "readvar assoc $first_assoc failed"
```

- 涉及命令：ntpq×3, ntpd×1
