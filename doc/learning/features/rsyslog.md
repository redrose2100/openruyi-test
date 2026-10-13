# rsyslog

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rsyslog` |
| 注册用例数 | 27 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rsyslog_abnormal_config | -N1 command | run_test/post_test | 1 |  |  |  |
| oe_test_rsyslog_abnormal_template | TCP forwarding, using custom template transports | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_function_attribute | Use properties instead of filtering logs | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_function_discard | Support filter discard | run_test/post_test | 3 |  |  |  |
| oe_test_rsyslog_function_facility | Loop configuration rsyslog to filter different Facility logs | run_test/post_test | 2 |  |  |  |
| oe_test_rsyslog_function_httpd | Forward HTTPD logs to other virtual machines | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_function_imfile | Support for local file write | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_rsyslog_function_postgreSQL | Support for log writing to PostgreSQL | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_rsyslog_function_priority | The loop configures rsyslog to filter different priority logs | run_test/post_test | 2 |  |  |  |
| oe_test_rsyslog_function_rainerscript | Use rainerscript to filter logs | run_test/post_test | 3 |  |  |  |
| oe_test_rsyslog_function_relp | Close the firewall, support relp protocol | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_function_shell | Shell execution support | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_rsyslog_function_tcp | Close the firewall, support TCP protocol | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_function_tcp_firewall | Open the firewall, support TCP protocol | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_rsyslog_function_template | Use templates to filter logs | run_test/post_test | 3 |  |  |  |
| oe_test_rsyslog_function_udp | Close the firewall, support UCP protocol | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_function_wildcard | Use of wildcards to filter logs | run_test/post_test | 6 |  |  |  |
| oe_test_rsyslog_parameter01 | -d/-v/-o/-n command parameters used | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_rsyslog_parameter02 | -N/-D command parameters used | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_rsyslog_parameter03 | -i/-f command parameters used | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_rsyslog_parameter04 | Systemctl initiates the service command and Rsyslogd is executing simultaneously | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_rsyslog_reliability_lenght | The default message length is 2k, exceeding the message length will be discarded | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_reliability_network | Configure TCP forwarding, set simulated 2S network delay at the client side, and write 100 logs in a loop | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_rsyslog_reliability_operation | restart/start/close operation is normal | run_test/post_test | 6 |  |  |  |
| oe_test_rsyslog_reliability_restart | Restart repeatedly (50), service is normal | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_rsyslog_reliability_tcp | Configure TCP forwarding, server side failure, after recovery, the message normal forwarding | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_service_rsyslog | Test rsyslog.service restart | run_test | 0 |  |  |  |

### 断言与命令明细

#### oe_test_rsyslog_abnormal_config

- 描述：-N1 command
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：rsyslogd×1

#### oe_test_rsyslog_abnormal_template

- 描述：TCP forwarding, using custom template transports
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×1, netstat×1, logger×1

#### oe_test_rsyslog_function_attribute

- 描述：Use properties instead of filtering logs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, netstat×1, logger×1, grep×1

#### oe_test_rsyslog_function_discard

- 描述：Support filter discard
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：logger×1

#### oe_test_rsyslog_function_facility

- 描述：Loop configuration rsyslog to filter different Facility logs
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：logger×1

#### oe_test_rsyslog_function_httpd

- 描述：Forward HTTPD logs to other virtual machines
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×2, sed×2

#### oe_test_rsyslog_function_imfile

- 描述：Support for local file write
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(cat /var/log/test | wc -l)" 2
```

#### oe_test_rsyslog_function_postgreSQL

- 描述：Support for log writing to PostgreSQL
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：psql×1

#### oe_test_rsyslog_function_priority

- 描述：The loop configures rsyslog to filter different priority logs
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：logger×1

#### oe_test_rsyslog_function_rainerscript

- 描述：Use rainerscript to filter logs
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：logger×1

#### oe_test_rsyslog_function_relp

- 描述：Close the firewall, support relp protocol
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, netstat×1, logger×1, sed×1

#### oe_test_rsyslog_function_shell

- 描述：Shell execution support
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2, logger×2

#### oe_test_rsyslog_function_tcp

- 描述：Close the firewall, support TCP protocol
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×2, iptables×1, netstat×1, logger×1

#### oe_test_rsyslog_function_tcp_firewall

- 描述：Open the firewall, support TCP protocol
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×2, netstat×1, logger×1

#### oe_test_rsyslog_function_template

- 描述：Use templates to filter logs
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：logger×1

#### oe_test_rsyslog_function_udp

- 描述：Close the firewall, support UCP protocol
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, netstat×1, logger×1

#### oe_test_rsyslog_function_wildcard

- 描述：Use of wildcards to filter logs
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：logger×4, grep×1

#### oe_test_rsyslog_parameter01

- 描述：-d/-v/-o/-n command parameters used
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

- 涉及命令：rsyslogd×4, pgrep×2

#### oe_test_rsyslog_parameter02

- 描述：-N/-D command parameters used
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rsyslogd×2, pgrep×2

#### oe_test_rsyslog_parameter03

- 描述：-i/-f command parameters used
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rsyslogd×2, pgrep×2

#### oe_test_rsyslog_parameter04

- 描述：Systemctl initiates the service command and Rsyslogd is executing simultaneously
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(pgrep -cf rsyslogd)" 2
  CHECK_RESULT "$(cat /var/log/test | wc -l)" 2
```

- 涉及命令：pgrep×2, logger×1

#### oe_test_rsyslog_reliability_lenght

- 描述：The default message length is 2k, exceeding the message length will be discarded
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：netstat×1

#### oe_test_rsyslog_reliability_network

- 描述：Configure TCP forwarding, set simulated 2S network delay at the client side, and write 100 logs in a loop
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(grep -ac "servertest$time" /var/log/messages)" 100
```

- 涉及命令：netstat×1

#### oe_test_rsyslog_reliability_operation

- 描述：restart/start/close operation is normal
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_rsyslog_reliability_restart

- 描述：Restart repeatedly (50), service is normal
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：logger×1

#### oe_test_rsyslog_reliability_tcp

- 描述：Configure TCP forwarding, server side failure, after recovery, the message normal forwarding
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：iptables×2, netstat×1, logger×1, grep×1

#### oe_test_service_rsyslog

- 描述：Test rsyslog.service restart
- 函数：`run_test`