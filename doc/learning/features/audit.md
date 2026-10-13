# audit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/audit` |
| 注册用例数 | 36 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_audit_monitor_file_access | monitor file access | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_audit_monitor_dictionary_access | monitor dictionary access | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_audit_monitor_system_use | monitor system use | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_audit_monitor_do_command | monitor do command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_audit_monitor_security_event | monitor security event | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_audit_monitor_network_visit | monitor network visit | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_track_designated_access | track designated proc | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_use_d_audit | use -d to audit | pre_test/run_test | 5 | ✔ |  |  |
| oe_test_audit_use_w_audit | use -w to audit | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_audit_rule_contact_strategy | rule contact strategy | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_audit_rule_conflict_strategy | rule conflict strategy | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_audit_rule_fetch_from_rule | rule fetch from file | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_audit_fetch_file_in_order | fetch files in order | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_count_time | collect overall user time statistics | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_audit_count_number_of_event | count number of events | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_audit_show_event_list | show event list | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_user_build_connection | user build connection | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_max_log_file_rotate | set max log file rotate | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_max_log_file_ignore | set max log file action ignore | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_audit_max_log_file_syslog | set max log file syslog | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_audit_max_log_file_suspend | set max log file suspend | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_audit_max_log_file_keep_logs | set max log file keep logs | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_audit_available_disk_space | the available disk space is less than the configured space | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_inject_time_fault | inject time fault | pre_test/log_dump/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_auditd | Test auditd.service restart | pre_test/run_test | 9 | ✔ |  |  |
| oe_test_audit_event_log | Test event logging service auditd | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_audit_other | Other operating auditd testing services | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_start_audit | Start auditd, set the boot to start | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_audit_ausearch | Command audit ausearch | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_audit_augenrules | Command test-augenrules | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_audit_autrace | Command test-autrace | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_aulast | Command test-aulast | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_audit_ausyscall | Command test-ausyscall | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_aulastlog | Command aulastlog | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_audit_monitor_pipe_file | audit monitor socket file | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_audit_monitor_socket_file | audit monitor socket file | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_audit_monitor_file_access

- 描述：monitor file access
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "delete rules failed"
  CHECK_RESULT $? 0 0 "catch failed"
  CHECK_RESULT $? 0 0 "useradd failed"
  CHECK_RESULT $? 0 0 "monitor file access error"
```

- 涉及命令：auditctl×4, userdel×1

#### oe_test_audit_monitor_dictionary_access

- 描述：monitor dictionary access
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "add failed"
  CHECK_RESULT $? 0 0 "change failed"
  CHECK_RESULT $? 0 0 "create failed"
  CHECK_RESULT $? 0 0 "ausearch failed"
```

- 涉及命令：auditctl×4, mkdir×1, ausearch×1

#### oe_test_audit_monitor_system_use

- 描述：monitor system use
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "clean failed"
  CHECK_RESULT $? 0 0 "add rule failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "login failed"
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：auditctl×4, ausearch×1, userdel×1

#### oe_test_audit_monitor_do_command

- 描述：monitor do command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "clean failed"
  CHECK_RESULT $? 0 0 "add rule failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "login failed"
  CHECK_RESULT $? 0 0 "ausearch failed"
```

- 涉及命令：auditctl×4, ausearch×1, userdel×1

#### oe_test_audit_monitor_security_event

- 描述：monitor security event
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "grep failed"
```

- 涉及命令：auditctl×1, ausearch×1

#### oe_test_audit_monitor_network_visit

- 描述：monitor network visit
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 1 0 "ausearch failed"
  CHECK_RESULT $? 1 0 "grep failed"
```

- 涉及命令：auditctl×1, ausearch×1, userdel×1

#### oe_test_audit_track_designated_access

- 描述：track designated proc
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "aureport failed"
```

- 涉及命令：auditctl×1

#### oe_test_audit_use_d_audit

- 描述：use -d to audit
- 函数：`pre_test, run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "add failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 1 0 "grep delete failed"
```

- 涉及命令：auditctl×5

#### oe_test_audit_use_w_audit

- 描述：use -w to audit
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "add failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 1 0 "grep failed"
```

- 涉及命令：auditctl×4

#### oe_test_audit_rule_contact_strategy

- 描述：rule contact strategy
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "add rules failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "cat failed"
  CHECK_RESULT 1 0 0 "contact error"
```

- 涉及命令：auditctl×6, ausearch×2

#### oe_test_audit_rule_conflict_strategy

- 描述：rule conflict strategy
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "add failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "add second failed"
  CHECK_RESULT $? 0 0 "grep second failed"
  CHECK_RESULT $? 0 0 "failed"
  CHECK_RESULT $? 1 0 "ausearch failed"
```

- 涉及命令：auditctl×6, ausearch×1, userdel×1

#### oe_test_audit_rule_fetch_from_rule

- 描述：rule fetch from file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：auditctl×4

#### oe_test_audit_fetch_file_in_order

- 描述：fetch files in order
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "load failed"
  CHECK_RESULT $? 0 0 "add failed"
```

- 涉及命令：auditctl×3

#### oe_test_audit_count_time

- 描述：collect overall user time statistics
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：aureport×1

#### oe_test_audit_count_number_of_event

- 描述：count number of events
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "start failed"
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：aureport×1

#### oe_test_audit_show_event_list

- 描述：show event list
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "aureport --success failed"
  CHECK_RESULT $? 0 0 "aureport --failed failed"
  CHECK_RESULT $? 0 0 "aureport failed"
```

- 涉及命令：aureport×1

#### oe_test_audit_user_build_connection

- 描述：user build connection
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT 1 0 0 "i failed"
  CHECK_RESULT 1 0 0 "grep j failed"
```

- 涉及命令：sed×2, auditctl×2, gcc×1, grep×1

#### oe_test_audit_max_log_file_rotate

- 描述：set max log file rotate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT 1 0 0 "first error"
  CHECK_RESULT 1 0 0 "second error"
  CHECK_RESULT 1 0 0 "third error"
```

- 涉及命令：sed×4

#### oe_test_audit_max_log_file_ignore

- 描述：set max log file action ignore
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "ignore error"
```

- 涉及命令：sed×6

#### oe_test_audit_max_log_file_syslog

- 描述：set max log file syslog
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "search failed"
  CHECK_RESULT $? 0 0 "grep first failed"
  CHECK_RESULT $? 0 0 "grep second failed"
  CHECK_RESULT $? 0 0 "search second failed"
```

- 涉及命令：sed×6, grep×2, auditctl×1

#### oe_test_audit_max_log_file_suspend

- 描述：set max log file suspend
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "grep first failed"
  CHECK_RESULT $? 1 0 "grep first failed"
  CHECK_RESULT $? 0 0 "grep second failed"
  CHECK_RESULT $? 1 0 "search second failed"
```

- 涉及命令：sed×4

#### oe_test_audit_max_log_file_keep_logs

- 描述：set max log file keep logs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "keep_logs error"
```

- 涉及命令：sed×6

#### oe_test_audit_available_disk_space

- 描述：the available disk space is less than the configured space
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "search first"
  CHECK_RESULT $? 0 0 "grep logging first failed"
  CHECK_RESULT $? 0 0 "grep active failed"
  CHECK_RESULT $? 0 0 "grep logging second failed"
```

- 涉及命令：sed×4, grep×1

#### oe_test_inject_time_fault

- 描述：inject time fault
- 函数：`pre_test, log_dump, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "failed"
  CHECK_RESULT $? 0 0 "search second failed"
```

- 涉及命令：sed×2

#### oe_test_service_auditd

- 描述：Test auditd.service restart
- 函数：`pre_test, run_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "${service} disable failed"
  CHECK_RESULT $? 0 0 "${service} enable failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_audit_event_log

- 描述：Test event logging service auditd
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "For '/etc/ssh/sshd_config' file setting auditctl rules failed"
  CHECK_RESULT $? 0 0 "Failed to find 'sshd_config' from '/var/log/audit/audit.log' file"
```

- 涉及命令：auditctl×3

#### oe_test_audit_other

- 描述：Other operating auditd testing services
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start auditd service"
  CHECK_RESULT $? 0 0 "Failed to stop auditd service"
  CHECK_RESULT $? 0 0 "Failed to restart auditd service"
  CHECK_RESULT $? 0 0 "Failed to reload auditd service"
  CHECK_RESULT $? 0 0 "Failed to rotate auditd service"
  CHECK_RESULT $? 0 0 "Failed to resume auditd service"
  CHECK_RESULT $? 0 0 "Failed to condrestart auditd service"
  CHECK_RESULT $? 0 0 "Failed to systemctl auditd services with running status"
```

#### oe_test_start_audit

- 描述：Start auditd, set the boot to start
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start auditd service"
  CHECK_RESULT $? 0 0 "Failed to chkconfig auditd service with status enable"
  CHECK_RESULT $? 0 0 "Failed to chkconfig auditd service with status disable"
  CHECK_RESULT $? 0 0 "Failed to chkconfig auditd service with status enable"
```

#### oe_test_audit_ausearch

- 描述：Command audit ausearch
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? -1 1 "format check fail"
  CHECK_RESULT $? -1 1 "AVC check fail"
  CHECK_RESULT $? -1 1 "ua check fail"
  CHECK_RESULT $? -1 1 "ausearch -f fail"
  CHECK_RESULT $? -1 1 "testfile_audit check fail"
  CHECK_RESULT $? -1 1 "sv yes check fail"
  CHECK_RESULT $? -1 1 "sv no check fail"
```

- 涉及命令：ausearch×6, auditctl×3, userdel×1

#### oe_test_audit_augenrules

- 描述：Command test-augenrules
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "file write failure"
  CHECK_RESULT $? 0 0 "load rule failure"
  CHECK_RESULT $? 0 0 "rule write failure"
  CHECK_RESULT $? 0 0 "rule check failure"
  CHECK_RESULT $? 0 0 "description Failed to view the help information"
```

- 涉及命令：sed×2

#### oe_test_audit_autrace

- 描述：Command test-autrace
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "file write failure"
  CHECK_RESULT $? 0 0 "load rule failure"
  CHECK_RESULT $? 0 0 "rule write failure"
```

- 涉及命令：auditctl×3, autrace×1, ausearch×1

#### oe_test_audit_aulast

- 描述：Command test-aulast
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "failed to print the user login list. Procedure"
  CHECK_RESULT $? 0 0 "description failed to generate log files"
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "failed to enter using the file"
  CHECK_RESULT $? 0 0 "only the root user fails to be displayed"
  CHECK_RESULT $? 0 0 "failed to filter tty login users. Procedure"
  CHECK_RESULT $? 0 0 "failed to print the audit event sequence number used to determine a row on the report"
  CHECK_RESULT $? 0 0 "the command bad failed to execute"
  CHECK_RESULT $? 0 0 "the command debug failed to execute"
  CHECK_RESULT $? 0 0 "the command stdin  failed to execute"
```

- 涉及命令：sshpass×2, grep×1, test×1, aulast×1

#### oe_test_audit_ausyscall

- 描述：Command test-ausyscall
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "failed to view all SYSCALL options supported by auditd"
  CHECK_RESULT $? 0 0 "failed to list the system calls supported by the current system"
  CHECK_RESULT $? 0 0 "100 command execution failed"
  CHECK_RESULT $? 0 0 "exact command execution failed"
  CHECK_RESULT $? 0 0 "retrieval failed open"
  CHECK_RESULT $? 0 0 "retrieval failed read"
  CHECK_RESULT $? 0 0 "retrieval failed write"
  CHECK_RESULT $? 0 0 "--dump command execution failed"
  CHECK_RESULT $? 0 0 "failed to retrieve system call for 'open'"
```

#### oe_test_aulastlog

- 描述：Command aulastlog
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "auditd.service is not running"
  CHECK_RESULT $? 0 0 "all login log is not find"
  CHECK_RESULT $? 0 0 "test1 login log is not find"
  CHECK_RESULT $? 0 0 "test2 login log is not find"
```

- 涉及命令：aulastlog×2, userdel×2

#### oe_test_audit_monitor_pipe_file

- 描述：audit monitor socket file
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Fail to set audit rule."
  CHECK_RESULT $? 0 0 "Fail to create pipe file."
  CHECK_RESULT $? 0 0 "Fail to audit pipe file."
```

- 涉及命令：ausearch×1, auditctl×1

#### oe_test_audit_monitor_socket_file

- 描述：audit monitor socket file
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Fail to set audit rule."
  CHECK_RESULT $? 0 0 "Fail to create socket file."
  CHECK_RESULT $? 0 0 "Fail to audit socket file."
```

- 涉及命令：auditctl×2, python3×1, ausearch×1
