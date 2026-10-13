# embedded_security_config_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/security_config_test` |
| 注册用例数 | 20 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_check_file_sys_protect_001 | check mount options of /tmp /var and | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_check_file_sys_protect_002 | check file right part 1 | run_test | 11 |  |  |  |
| oe_test_check_file_sys_protect_003 | check file right part 2 | run_test | 13 |  |  |  |
| oe_test_check_file_sys_protect_004 | check file right part 3 | run_test | 11 |  |  |  |
| oe_test_check_file_sys_protect_005 | check umask default value | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_check_user_account_001 | check system account | run_test | 3 |  |  |  |
| oe_test_check_user_account_002 | check only root has uid 0 | run_test | 2 |  |  |  |
| oe_test_check_user_account_003 | check deny and unlock time fail | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_check_user_account_004 | check check PAM set fail | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_check_user_account_005 | check history password set | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_check_user_account_006 | check password life time | run_test | 4 |  |  |  |
| oe_test_check_user_account_007 | check set TMOUT value | run_test | 4 |  |  |  |
| oe_test_check_user_account_008 | check hello message | run_test | 4 |  |  |  |
| oe_test_check_network_firewall_001 | check log_martians set | run_test | 6 |  |  |  |
| oe_test_check_network_firewall_002 | check accept_redirects | check_version/run_test | 1 |  |  |  |
| oe_test_check_ssh_config_001 | check SSL version | run_test | 7 |  |  |  |
| oe_test_check_ssh_config_002 | check HostbasedAuthentication | run_test | 4 |  |  |  |
| oe_test_check_ssh_config_003 | check SSH Client Alive set | run_test | 9 |  |  |  |
| oe_test_check_runtime_security_001 | check kernel.randomize_va_space set | run_test | 2 |  |  |  |
| oe_test_check_log_001 | check audit.rules set | run_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_check_file_sys_protect_001

- 描述：check mount options of /tmp /var and
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check /var mount options fail"
  CHECK_RESULT $? 0 0 "check /tmp mount options fail"
  CHECK_RESULT $? 0 0 "check /dev/shm mount options fail"
  CHECK_RESULT $? 0 1 "check stickybit fail"
  CHECK_RESULT $? 0 1 "check LD_LIBRARY_PATH set in /etc/profile fail"
  CHECK_RESULT $? 0 1 "check root LD_LIBRARY_PATH value fail"
  CHECK_RESULT $? 0 1 "check tester1 LD_LIBRARY_PATH value fail"
  CHECK_RESULT $? 0 1 "check PATH value fail"
```

- 涉及命令：userdel×1

#### oe_test_check_file_sys_protect_002

- 描述：check file right part 1
- 函数：`run_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "check /dev/mem file right fail"
  CHECK_RESULT $? 0 0 "check /etc/fstab file right fail"
  CHECK_RESULT $? 0 0 "check /etc/group file right fail"
  CHECK_RESULT $? 0 0 "check /etc/init.d/ file right fail"
  CHECK_RESULT $? 0 1 "check /etc/init.d/* file right fail"
  CHECK_RESULT $? 0 0 "check /etc/passwd file right fail"
  CHECK_RESULT $? 0 0 "check /etc/securetty file right fail"
  CHECK_RESULT $? 0 0 "check /etc/security/opasswd file right fail"
  CHECK_RESULT $? 0 0 "check /etc/shadow file right fail"
  CHECK_RESULT $? 0 1 "check /etc/ssh/*key file right fail"
  CHECK_RESULT $? 0 1 "check /etc/ssh/*key.pub file right fail"
```

#### oe_test_check_file_sys_protect_003

- 描述：check file right part 2
- 函数：`run_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "check /etc/ssh/sshd_config file right fail"
  CHECK_RESULT $? 0 0 "check /etc/sysctl.conf file right fail"
  CHECK_RESULT $? 0 0 "check /lib/modules/ file right fail"
  CHECK_RESULT $? 0 0 "check /root/ file right fail"
  CHECK_RESULT $? 0 0 "check /tmp/ file right fail"
  CHECK_RESULT $? 0 0 "check /dev/shm file right fail"
  CHECK_RESULT $? 0 0 "check /var/log/audit/ file right fail"
  CHECK_RESULT $? 0 0 "check /var/log/audit/audit.log file right fail"
  CHECK_RESULT $? 0 0 "check /var/log/ file right fail"
  CHECK_RESULT $? 0 1 "check /var/log/* file right fail"
  CHECK_RESULT $? 0 0 "check /var/log/secure file right fail"
  CHECK_RESULT $? 0 0 "check /var/log/auth.log file right fail"
  ... 共 13 条（其余见源脚本）
```

#### oe_test_check_file_sys_protect_004

- 描述：check file right part 3
- 函数：`run_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "check /bin/ file right fail"
  CHECK_RESULT $? 0 0 "check /etc/ file right fail"
  CHECK_RESULT $? 0 0 "check /home/ file right fail"
  CHECK_RESULT $? 0 0 "check /lib/ file right fail"
  CHECK_RESULT $? 0 0 "check /dev/ file right fail"
  CHECK_RESULT $? 0 0 "check /init file right fail"
  CHECK_RESULT $? 0 0 "check /sbin/init file right fail"
  CHECK_RESULT $? 0 0 "check /var/volatile/log file right fail"
  CHECK_RESULT $? 0 0 "check /etc/motd file right fail"
  CHECK_RESULT $? 0 0 "check /etc/issue file right fail"
  CHECK_RESULT $? 0 0 "check /etc/issue.net file right fail"
```

#### oe_test_check_file_sys_protect_005

- 描述：check umask default value
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0  "check umask default value fail"
  CHECK_RESULT $? 0 0 "check /etc/login.defs set umask value fail"
  CHECK_RESULT $? 0 0 "check /etc/profile set umask value fail"
  CHECK_RESULT $? 0 0 "check /etc/bashrc set umask value fail"
  CHECK_RESULT $? 0 0 "touch failed"
  CHECK_RESULT $? 0 0 "check root new file right faild"
  CHECK_RESULT $? 0 0 "mkdir failed"
  CHECK_RESULT $? 0 0 "check root new dir right faild"
  CHECK_RESULT $? 0 0 "touch failed"
  CHECK_RESULT $? 0 0 "check tester1 new file right faild"
  CHECK_RESULT $? 0 0 "mkdir failed"
  CHECK_RESULT $? 0 0 "check tester1 new dir right faild"
```

- 涉及命令：grep×3, userdel×1

#### oe_test_check_user_account_001

- 描述：check system account
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "Check system account fail"
  CHECK_RESULT $? 0 0 "not set wheel permission in /etc/pam.d/su"
  CHECK_RESULT $? 0 0 "not set sha512 in /etc/pam.d/common-password"
```

#### oe_test_check_user_account_002

- 描述：check only root has uid 0
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "one more uid 0 user have, check fail"
  CHECK_RESULT $? 0 0 "check uid 0 user fail"
```

#### oe_test_check_user_account_003

- 描述：check deny and unlock time fail
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check deny and unlock time fail"
  CHECK_RESULT $? 0 0 "check login fail 3 time lock fail"
  CHECK_RESULT $? 0 0 "check login fail 3 time lock fail"
```

- 涉及命令：userdel×2, expect×1

#### oe_test_check_user_account_004

- 描述：check check PAM set fail
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check PAM set fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 0 "change password fail, need success"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_check_user_account_005

- 描述：check history password set
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check history password set fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 1 "change password success, need fail"
  CHECK_RESULT $? 0 0 "change password fail, need success"
```

- 涉及命令：userdel×1

#### oe_test_check_user_account_006

- 描述：check password life time
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "not set password PASS_MAX_DAYS"
  CHECK_RESULT $? 0 0 "not set password PASS_MIN_DAYS"
  CHECK_RESULT $? 0 0 "not set password PASS_WARN_AGE"
  CHECK_RESULT $? 0 0 "check PMA fail"
```

#### oe_test_check_user_account_007

- 描述：check set TMOUT value
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "not set TMOUT in /etc/profile"
  CHECK_RESULT $? 0 1 "set TMOUT is 0"
  CHECK_RESULT $? 0 0 "not set TMOUT in ${bashrcFile}"
  CHECK_RESULT $? 0 1 "set TMOUT is 0"
```

#### oe_test_check_user_account_008

- 描述：check hello message
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "not set /etc/motd hello message"
  CHECK_RESULT $? 0 0 "not set /etc/issue hello message"
  CHECK_RESULT $? 0 0 "not set /etc/issue.net hello message"
  CHECK_RESULT $? 0 0 "not set /etc/ssh/sshd_config hello message"
```

- 涉及命令：egrep×3, grep×1

#### oe_test_check_network_firewall_001

- 描述：check log_martians set
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check net.ipv4.tcp_syncookies set fail"
  CHECK_RESULT $? 0 0 "check net.ipv4.ip_forward set fail"
  CHECK_RESULT $? 0 0 "check net.ipv4.icmp_echo_ignore_broadcasts set fail"
  CHECK_RESULT $? 0 0 "check net.ipv4.icmp_ignore_bogus_error_responses set fail"
  CHECK_RESULT $? 0 0 "check net.ipv4.conf.all.rp_filter set fail"
  CHECK_RESULT $? 0 0 "check net.ipv4.conf.default.rp_filter set fail"
```

#### oe_test_check_network_firewall_002

- 描述：check accept_redirects
- 函数：`check_version, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $1 0 0 "check $2 set fail"
```

#### oe_test_check_ssh_config_001

- 描述：check SSL version
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check SSL version fail"
  CHECK_RESULT $? 0 0 "check SSH SyslogFacility fail"
  CHECK_RESULT $? 0 1 "check SSH SyslogFacility fail"
  CHECK_RESULT $? 0 0 "check SSH X11Forwarding set fail"
  CHECK_RESULT $? 0 0 "check SSH MaxAuthTries set fail"
  CHECK_RESULT $? 0 0 "check SSH MaxAuthTries set number fail"
  CHECK_RESULT $? 0 0 "check SSH IgnoreRhosts set fail"
```

#### oe_test_check_ssh_config_002

- 描述：check HostbasedAuthentication
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check SSH HostbasedAuthentication set fail"
  CHECK_RESULT $? 0 0 "check SSH PermitUserEnvironment set fail"
  CHECK_RESULT $? 0 0 "check SSH MACs not set"
  CHECK_RESULT $? 0 1 "check MACs set fail"
```

#### oe_test_check_ssh_config_003

- 描述：check SSH Client Alive set
- 函数：`run_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check SSH ClientAliveInterval set"
  CHECK_RESULT $? 0 0 "check SSH ClientAliveCountMax set"
  CHECK_RESULT $? 0 0 "check SSH MaxStartups set"
  CHECK_RESULT $? 0 0 "check SSH LoginGraceTime set"
  CHECK_RESULT $? 0 0 "LoginGraceTime set time is 0"
  CHECK_RESULT $? 0 0 "check SSH UsePAM set fail"
  CHECK_RESULT $? 0 0 "check /root/.ssh/known_hosts files permission fail"
  CHECK_RESULT $? 0 0 "check /root/.ssh/authorized_keys files permission fail"
  CHECK_RESULT $? 0 0 "check SSH Banner set fail"
```

#### oe_test_check_runtime_security_001

- 描述：check kernel.randomize_va_space set
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check randomize_va_space set value fail"
  CHECK_RESULT $? 0 0 "check fs.suid_dumpable set value fail"
```

#### oe_test_check_log_001

- 描述：check audit.rules set
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check /etc/audit/audit.rules set fail"
  CHECK_RESULT $? 0 0 "check /etc/audit/audit.rules set fail"
```
