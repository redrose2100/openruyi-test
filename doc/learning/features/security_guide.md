# security_guide

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 文档域（doc-test） |
| 套件路径 | `$OET_PATH/testcases/doc-test/security_guide` |
| 注册用例数 | 49 |
| 环境约束 | machine num = 3 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ssh_warnings | Verify warnings for default network remote login | run_test/post_test | 2 |  |  |  |
| oe_test_set_password_validity | Set password validity | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_set_default_umask | Set the user's default umask value to 022 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_ssh_sftp_across_updir | Restrict SFTP users to access up across directories | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ssh_passwd_dosnot_clear | Password does not echo in clear text when SSH executes command remotely | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_check_passwd_encryption_algorithm | The encryption algorithm of verifying setting password | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_use_su_Initialize_path | Initialize path when switching users with Su | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_access_sudo_commands | Verify restrictions on sudo commands | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ssh_disable_empty_passwd | It is not allowed to log in with an account with blank password | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_use_security_tools | Reinforce with safety reinforcement tools | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ssh_pam_auth | Login authentication with PAM | run_test/post_test | 3 |  |  |  |
| oe_test_ssh_version2 | Test whether SSH protocol version is 2 | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_empty_linked_files | Working with empty linked files | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_set_permissions_and_owner | Set permissions and owner of files | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_ssh_access_login_in_60s | User must be authenticated successfully within 60s | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_set_password_complexity | Set password complexity | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_ssh_disable_parsing_sshpath | Disable parsing ~/.ssh/environment and ~/.ssh/authorized during SSH login_ Environment variables set in keys | pre_test/run_test/post_test | 5 |  | ✔ |  |
| oe_test_ssh_disable_root | Don't allow root account to log in to the system directly using SSH | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_delete_unowned_file | check unowned file | run_test | 2 |  |  |  |
| oe_test_access_at_commands | Verify restrict access to at commands | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_lock_after_login_fail | Allow public key authentication | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_set_exit_time | The terminal stops running for 30 seconds and exits automatically | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_add_sticky_bit_attribute | Add sticky bit attribute for global writable directory | run_test/post_test | 5 |  |  |  |
| oe_test_restrict_accounts_use_su | restrict accounts use su | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_access_cron_commands | Verify restrict access to cron | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_check_global_writable_property | Check global writable property of unauthorized file | run_test/post_test | 2 |  |  |  |
| oe_test_ssh_check_home | SSH checks the permissions and ownership of the user home directory before receiving the login request | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ssh_allow_public_key | Allow public key authentication | run_test/post_test | 4 |  | ✔ |  |
| oe_test_shield_system_account | Shield system account | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_ssh_RSA_auth | Only allow RSA for security authentication | run_test/post_test | 6 |  | ✔ |  |
| oe_test_ssh_disable_agent_forwarding | Disable SSH agent forwarding | pre_test/run_test/post_test | 7 |  | ✔ |  |
| oe_test_ssh_system_reinforcement | sshd system reinforcement test | run_test | 14 |  |  |  |
| oe_test_kernel_parameter_hardening | Kernel parameter hardening | run_test | 18 |  |  |  |
| oe_test_ssh_strong_encryption_algorithm | SSH strong encryption algorithm - enable hardening by default | run_test | 5 |  |  |  |
| oe_test_ssh_client_reinforcement_suggestions | Client SSH hardening recommendations | run_test | 2 |  |  |  |
| oe_test_ssh_character_page_timeout_limit | Character interface waiting timeout limit - reinforcement is not enabled by default | pre_test/run_test | 2 |  |  |  |
| oe_test_password_complexity | Password complexity limit - reinforcement is not enabled by default | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_ssh_login_failed_attempts | Password complexity limit - reinforcement is not enabled by default | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_umask_default | User default umask value limit - enable reinforcement by default | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_ssh_su_permission_restrictions | Su permission restriction - enable reinforcement by default | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_ssh_server_reinforcement_suggestions | Suggestions on server SSH reinforcement | run_test | 24 |  |  |  |
| oe_test_kernel_parameter_reinforcement_description | Kernel parameter reinforcement description | run_test | 19 |  |  |  |
| oe_test_ssh_prohibit_root_login_system_through_ssh | Prohibit the root account from directly SSH logging into the system - reinforcement is not enabled by default | run_test/post_test | 1 |  |  |  |
| oe_test_password_validity | Password validity - reinforcement is not enabled by default | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_passwd_salt_value_unique | Check password salt value unique | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_passwd_ciphertext_unique | Check password ciphertext unique | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_check_default_dictionary_words | check default dictionary words for weak password | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_check_custom_dictionary_words | check custom dictionary words for weak password | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_security_guide_check | check_passwd_encryption_algorithm | pre_test/run_test/post_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_ssh_warnings

- 描述：Verify warnings for default network remote login
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "remote login failed"
```

#### oe_test_set_password_validity

- 描述：Set password validity
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：date×3, sed×2, userdel×1

#### oe_test_set_default_umask

- 描述：Set the user's default umask value to 022
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "umask error"
  CHECK_RESULT $? 0 0 "dir permission verification failed"
  CHECK_RESULT $? 0 0 "file permission verification failed"
  CHECK_RESULT $? 0 0 "dir permission verification failed"
  CHECK_RESULT $? 0 0 "file permission verification failed"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_ssh_sftp_across_updir

- 描述：Restrict SFTP users to access up across directories
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

- 涉及命令：useradd×1, sed×1, userdel×1

#### oe_test_ssh_passwd_dosnot_clear

- 描述：Password does not echo in clear text when SSH executes command remotely
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：userdel×1

#### oe_test_check_passwd_encryption_algorithm

- 描述：The encryption algorithm of verifying setting password
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "add test failed"
  CHECK_RESULT $? 0 0 "check test encryption algorithm failed"
  CHECK_RESULT $? 0 0 "check root encryption algorithm failed"
```

- 涉及命令：userdel×1

#### oe_test_use_su_Initialize_path

- 描述：Initialize path when switching users with Su
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "check PATH failed"
```

- 涉及命令：userdel×1

#### oe_test_access_sudo_commands

- 描述：Verify restrictions on sudo commands
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "grep %wheel failed"
  CHECK_RESULT $? 0 0 "add testuser failed"
  CHECK_RESULT $? 0 0 "usermod -g wheel testuser failed"
  CHECK_RESULT $? 0 1 "use sudo failed"
  CHECK_RESULT $? 0 0 "grep #%wheel failed"
  CHECK_RESULT $? 0 0 "use sudo failed"
```

- 涉及命令：sed×2, usermod×1, userdel×1

#### oe_test_ssh_disable_empty_passwd

- 描述：It is not allowed to log in with an account with blank password
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "PermitEmptyPasswords is not no"
  CHECK_RESULT $? 0 0 "add testuser failed"
  CHECK_RESULT $? 0 0 "testuser password is not empty"
  CHECK_RESULT $? 0 0 "need password"
```

- 涉及命令：passwd×1, userdel×1

#### oe_test_use_security_tools

- 描述：Reinforce with safety reinforcement tools
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_ssh_pam_auth

- 描述：Login authentication with PAM
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "grep 'UsePAM yes' failed"
  CHECK_RESULT $? 0 0 "grep 'Permission denied' failed"
  CHECK_RESULT $? 0 0 "grep 'Last failed login' failed"
```

- 涉及命令：userdel×1

#### oe_test_ssh_version2

- 描述：Test whether SSH protocol version is 2
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "SSH protocol version is not 2"
  CHECK_RESULT $? 0 0 "SSH protocol version is 1"
  CHECK_RESULT $? 0 0 "login failed"
```

- 涉及命令：ssh×1

#### oe_test_empty_linked_files

- 描述：Working with empty linked files
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "mktemp failed"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $(ls -li ${test_txt} | awk -F' ' '{print $1}') $(ls -li /tmp/test2.txt | awk -F' ' '{print $1}')
```

#### oe_test_set_permissions_and_owner

- 描述：Set permissions and owner of files
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_ssh_access_login_in_60s

- 描述：User must be authenticated successfully within 60s
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×1

#### oe_test_set_password_complexity

- 描述：Set password complexity
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 1 "check passwd(test1) failed"
  CHECK_RESULT $? 0 1 "check passwd(openeuler12) failed"
  CHECK_RESULT $? 0 0 "check passwd(Adminstrator12#$) failed"
  CHECK_RESULT $? 0 1 "check passwd(Adminstrator12#$) failed"
  CHECK_RESULT $? 0 1 "check passwd(test1) failed"
```

- 涉及命令：sed×1, userdel×1

#### oe_test_ssh_disable_parsing_sshpath

- 描述：Disable parsing ~/.ssh/environment and ~/.ssh/authorized during SSH login_ Environment variables set in keys
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
```

#### oe_test_ssh_disable_root

- 描述：Don't allow root account to log in to the system directly using SSH
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×1

#### oe_test_delete_unowned_file

- 描述：check unowned file
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check nouser file failed"
  CHECK_RESULT $? 0 0 "check nogroup file failed"
```

- 涉及命令：test×2

#### oe_test_access_at_commands

- 描述：Verify restrict access to at commands
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "add testuser1 failed"
  CHECK_RESULT $? 0 0 "add testuser2 failed"
  CHECK_RESULT $? 0 0 "su testuser1 failed"
  CHECK_RESULT $? 0 0 "testuser1 exec at failed"
  CHECK_RESULT $? 0 0 "su testuser2 failed"
  CHECK_RESULT $? 0 0 "testuser2 exec at failed"
```

- 涉及命令：userdel×2

#### oe_test_lock_after_login_fail

- 描述：Allow public key authentication
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "grep 'PubkeyAuthentication yes' failed"
  CHECK_RESULT $? 0 0 "grep id_rsa failed"
  CHECK_RESULT $? 0 0 "grep ssh-rsa failed"
  CHECK_RESULT $? 0 0 "login failed"
```

#### oe_test_set_exit_time

- 描述：The terminal stops running for 30 seconds and exits automatically
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "terminal not running"
  CHECK_RESULT $? 0 1 "terminal running"
```

- 涉及命令：bash×1

#### oe_test_add_sticky_bit_attribute

- 描述：Add sticky bit attribute for global writable directory
- 函数：`run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "find global writable directory failed"
  CHECK_RESULT $? 0 0 "exec mktemp failed"
  CHECK_RESULT $? 0 0 "exec chmod failed"
  CHECK_RESULT $? 0 0 "find global writable directory(${testdir}) failed"
  CHECK_RESULT $? 0 0 "add sticky bit attribute failed"
```

- 涉及命令：test×1

#### oe_test_restrict_accounts_use_su

- 描述：restrict accounts use su
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check /etc/pam.d/su failed"
  CHECK_RESULT $? 0 0 "add test2 to group wheel failed"
  CHECK_RESULT $? 0 1 "check su test1 failed"
  CHECK_RESULT $? 0 0 "check su test2 failed"
```

- 涉及命令：userdel×2, usermod×1

#### oe_test_access_cron_commands

- 描述：Verify restrict access to cron
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "add testuser1 failed"
  CHECK_RESULT $? 0 0 "add testuser2 failed"
  CHECK_RESULT $? 0 0 "add testuser1 to /etc/cron.allow failed"
  CHECK_RESULT $? 0 0 "su testuser1 failed"
  CHECK_RESULT $? 0 0 "testuser1 not allowed to use crontab"
  CHECK_RESULT $? 0 0 "su testuser2 failed"
  CHECK_RESULT $? 0 0 "testuser2 allow to use crontab"
```

- 涉及命令：userdel×2, test×1

#### oe_test_check_global_writable_property

- 描述：Check global writable property of unauthorized file
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check global writable directory failed"
  CHECK_RESULT "$?" 0 1 "check global writable file failed"
```

#### oe_test_ssh_check_home

- 描述：SSH checks the permissions and ownership of the user home directory before receiving the login request
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "StrictModes is not yes"
  CHECK_RESULT $? 0 0 "add testuser failed"
  CHECK_RESULT $? 0 0 "chown /home/testuser to root failed"
  CHECK_RESULT $? 0 0 "check the permissions and ownership of the user home directory failed"
  CHECK_RESULT $? 0 0 "check the permission of the user home directory failed"
  CHECK_RESULT $? 0 0 "check Permission failed"
```

- 涉及命令：userdel×1

#### oe_test_ssh_allow_public_key

- 描述：Allow public key authentication
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "grep 'PubkeyAuthentication yes' failed"
  CHECK_RESULT $? 0 0 "grep id_rsa failed"
  CHECK_RESULT $? 0 0 "grep ssh-rsa failed"
  CHECK_RESULT $? 0 0 "login failed"
```

#### oe_test_shield_system_account

- 描述：Shield system account
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：usermod×1, userdel×1

#### oe_test_ssh_RSA_auth

- 描述：Only allow RSA for security authentication
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "id_rsa file is not exist"
  CHECK_RESULT $? 0 0 "NODE2 grep ssh-rsa /root/.ssh/authorized_keys failed"
  CHECK_RESULT $? 0 0 "ssh log failed"
  CHECK_RESULT $? 0 0 "id_dsa file is not exist"
  CHECK_RESULT $? 0 0 "NODE2 grep ssh-dss /root/.ssh/authorized_keys failed"
  CHECK_RESULT $? 0 0 "Need password"
```

#### oe_test_ssh_disable_agent_forwarding

- 描述：Disable SSH agent forwarding
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "AllowAgentForwarding is not no"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "NODE2 grep ssh-rsa failed"
  CHECK_RESULT $? 0 0 "NODE3 grep ssh-rsa failed"
  CHECK_RESULT $? 0 0 "ForwardAgent is not yes"
  CHECK_RESULT $? 0 0 "check scp failed"
  CHECK_RESULT $? 0 0 "scp failed"
```

- 涉及命令：sed×2, kill×1

#### oe_test_ssh_system_reinforcement

- 描述：sshd system reinforcement test
- 函数：`run_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "SyslogFacility is not AUTH"
  CHECK_RESULT $? 0 0 "LogLevel is not VERBOSE"
  CHECK_RESULT $? 0 0 "X11Forwarding is not no"
  CHECK_RESULT $? 0 0 "IgnoreRhosts is not yes"
  CHECK_RESULT $? 0 0 "grep 'Subsystem sftp /usr/libexec/openssh/sftp-server -l INFO -f AUTH' failed"
  CHECK_RESULT $? 0 0 "HostbasedAuthentication is not no"
  CHECK_RESULT $? 0 0 "grep 'Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com' failed"
  CHECK_RESULT $? 0 0 "ClientAliveCountMax is not 0"
  CHECK_RESULT $? 0 0 "grep 'MACs hmac-sha2-512,hmac-sha2-512-etm@openssh.com,hmac-sha2-256,hmac-sha2-256-etm@openssh.com' failed"
  CHECK_RESULT $? 0 0 "AllowTcpForwarding is not no"
  CHECK_RESULT $? 0 0 "Subsystem is not sftp"
  CHECK_RESULT $? 0 0 "GatewayPorts is not no"
  ... 共 14 条（其余见源脚本）
```

#### oe_test_kernel_parameter_hardening

- 描述：Kernel parameter hardening
- 函数：`run_test`
- 断言（18 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：sysctl×18

#### oe_test_ssh_strong_encryption_algorithm

- 描述：SSH strong encryption algorithm - enable hardening by default
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 1 "Security reinforcement options are set."
  CHECK_RESULT $? 0 1 "Security reinforcement options are set."
  CHECK_RESULT $? 0 1 "Security reinforcement options are set."
```

#### oe_test_ssh_client_reinforcement_suggestions

- 描述：Client SSH hardening recommendations
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "Client SSH hardening is enabled."
  CHECK_RESULT $? 0 1 "Client SSH hardening is enabled."
```

#### oe_test_ssh_character_page_timeout_limit

- 描述：Character interface waiting timeout limit - reinforcement is not enabled by default
- 函数：`pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Security reinforcement is not enabled by default, but security reinforcement is performed here."
  CHECK_RESULT $? 0 0 "The character interface waiting timeout limit is set."
```

- 涉及命令：expect×1

#### oe_test_password_complexity

- 描述：Password complexity limit - reinforcement is not enabled by default
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The password complexity is secured, but it should not be secured here."
  CHECK_RESULT $? 0 0 "The password complexity is secured, but it should not be secured here."
  CHECK_RESULT $? 0 0 "Password setting failed."
```

- 涉及命令：expect×3, userdel×1

#### oe_test_ssh_login_failed_attempts

- 描述：Password complexity limit - reinforcement is not enabled by default
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 1 "Login succeeded, but the login should fail here."
  CHECK_RESULT $? 0 0 "Retry prompt not found."
  CHECK_RESULT $? 0 1 "It should be locked for 1 minute after entering the wrong password for three times, but it is not locked here."
  CHECK_RESULT $? 0 0 "Retry prompt not found."
  CHECK_RESULT $? 0 0 "Login failed."
  CHECK_RESULT $? 0 0 "Login failed."
```

- 涉及命令：expect×3

#### oe_test_umask_default

- 描述：User default umask value limit - enable reinforcement by default
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "The default value of umask is not 0022."
  CHECK_RESULT "$res" 0 0 "The default permission of the folder is not 'drwxr-xr-x'."
  CHECK_RESULT "$res" 0 0 "The default permission of the file is not '-rw-r--r--'."
  CHECK_RESULT "$res" 0 0 "The permission of the folder is not 'drwxrwxr-x'."
  CHECK_RESULT "$res" 0 0 "The permission of the file is not '-rw-rw-r--'."
```

- 涉及命令：expect×1, userdel×1

#### oe_test_ssh_su_permission_restrictions

- 描述：Su permission restriction - enable reinforcement by default
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Login failed."
  CHECK_RESULT $? 0 0 "Login failed."
```

- 涉及命令：expect×4, usermod×1, userdel×1

#### oe_test_ssh_server_reinforcement_suggestions

- 描述：Suggestions on server SSH reinforcement
- 函数：`run_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  ... 共 24 条（其余见源脚本）
```

#### oe_test_kernel_parameter_reinforcement_description

- 描述：Kernel parameter reinforcement description
- 函数：`run_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  CHECK_RESULT $? 0 0 "No safety reinforcement."
  ... 共 19 条（其余见源脚本）
```

#### oe_test_ssh_prohibit_root_login_system_through_ssh

- 描述：Prohibit the root account from directly SSH logging into the system - reinforcement is not enabled by default
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Login failed."
```

- 涉及命令：expect×1

#### oe_test_password_validity

- 描述：Password validity - reinforcement is not enabled by default
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The password is not valid for 99999."
  CHECK_RESULT $? 0 0 "Login failed!"
  CHECK_RESULT $? 0 0 "Login failed!"
```

- 涉及命令：expect×3, userdel×2

#### oe_test_passwd_salt_value_unique

- 描述：Check password salt value unique
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT "${salt_root_1}"  "${salt_normal_1}"  1 "salt value check failed"
  CHECK_RESULT "${salt_root_2}"  "${salt_normal_2}"  1 "salt value check failed"
  CHECK_RESULT "${salt_root_2}"  "${salt_root_1}"  1 "salt value check failed"
  CHECK_RESULT "${salt_normal_2}"  "${salt_normal_1}"  1 "salt value check failed"
  CHECK_RESULT "${salt_root_3}"  "${salt_normal_3}"  1 "salt value check failed"
  CHECK_RESULT "${salt_root_3}"  "${salt_root_2}"  1 "salt value check failed"
  CHECK_RESULT "${salt_normal_3}"  "${salt_normal_2}"  1 "salt value check failed"
```

- 涉及命令：userdel×1

#### oe_test_passwd_ciphertext_unique

- 描述：Check password ciphertext unique
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT "${ciphertext_root_1}"  "${ciphertext_normal_1}"  1 "ciphertext check failed"
  CHECK_RESULT "${ciphertext_root_2}"  "${ciphertext_normal_2}"  1 "ciphertext check failed"
  CHECK_RESULT "${ciphertext_root_2}"  "${ciphertext_root_1}"  1 "ciphertext check failed"
  CHECK_RESULT "${ciphertext_normal_2}"  "${ciphertext_normal_1}"  1 "ciphertext check failed"
  CHECK_RESULT "${ciphertext_root_3}"  "${ciphertext_normal_3}"  1 "ciphertext check failed"
  CHECK_RESULT "${ciphertext_root_3}"  "${ciphertext_root_2}"  1 "ciphertext check failed"
  CHECK_RESULT "${ciphertext_normal_3}"  "${ciphertext_normal_2}"  1 "ciphertext check failed"
```

- 涉及命令：userdel×1

#### oe_test_check_default_dictionary_words

- 描述：check default dictionary words for weak password
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Query default dictionary words failed"
  CHECK_RESULT "$(echo '!!65logan' | cracklib-check |awk '{print $NF}')" "word" 0 "Default dictionary words check failed"
  CHECK_RESULT $? 0 1 "Change weak password failed"
  CHECK_RESULT $? 0 1 "Query default dictionary words failed"
  CHECK_RESULT "$(echo 'mugen12#$' | cracklib-check |awk '{print $NF}')" "OK" 0 "Default dictionary words check failed"
  CHECK_RESULT $? 0 0 "Change strong password failed"
```

- 涉及命令：sed×4, userdel×1

#### oe_test_check_custom_dictionary_words

- 描述：check custom dictionary words for weak password
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT "$(echo "mugen12#$" | cracklib-check |awk '{print $NF}')" "OK" 0 "Default dictionary words check failed"
  CHECK_RESULT $? 0 0 "Change strong password failed"
  CHECK_RESULT $? 0 0 "unpacker dictionary failed"
  CHECK_RESULT $? 0 0 "create new dictionary failed"
  CHECK_RESULT $? 0 0 "Custom dictionary words failed"
  CHECK_RESULT "$(echo "mugen12#$" | cracklib-check |awk '{print $NF}')" "word" 0 "Custom dictionary words check failed"
  CHECK_RESULT $? 0 1 "Change weak password failed"
```

- 涉及命令：sed×4, userdel×1

#### oe_test_security_guide_check

- 描述：check_passwd_encryption_algorithm
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "exec 'test_sha512' failed"
  CHECK_RESULT $? 0 0 "exec 'root_sha512' failed"
```

- 涉及命令：userdel×1
