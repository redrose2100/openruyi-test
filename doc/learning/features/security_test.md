# security_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 安全域（security_test） |
| 套件路径 | `$OET_PATH/testcases/security_test` |
| 注册用例数 | 71 |
| 环境约束 | machine num = 2；add disk = 10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_selinux_listuser | list confined and unconfined user | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_selinux_adduser | add user mapped to the selinux user | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_selinux_confining_regular_user | confining regular user | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_selinux_confining_admin_using_role | confining admin using role | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_selinux_confining_admin_to_sysadm_u | confining admin to sysadm_u | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_selinux_http | Customize SELinux strategy for apache http server in non-standard configuration | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_selinux_sharing_nfs_cifs_using_booleans | Adjusted the strategy for sharing nfs and cifs volumes using SELinux booleands | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_selinux_sec_status_mode | selinux status and mode | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_selinux_sec_sestatus | sestatus view selinux status strategy | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_selinux_change_permissive | Permanently change to licensing model | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_selinux_change_enforcing | Permanently change to mandatory mode | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_selinux_disable | Permanently disable SELinux | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_selinux_booleands | Adjusted the strategy for sharing nfs and cifs volumes using SELinux booleands | pre_test/run_test/post_test | 8 | ✔ | ✔ |  |
| oe_test_identify_selinux_rejects | Identify SELinux rejects | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_fix_selinux_reject_messages | Fix SELinux rejections that have been analyzed | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_selinux_semanage_httpd | Modify the HTTP default directory in SELinux | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_selinux_audit | View SELinux logs in audit | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_selinux_chcon | selinux chcon | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_selinux_semanage_user | selinux semanage user manage | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_selinux_semanage_login | selinux semanage login manage | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_scanning_system | Vulnerability scanning system | pre_test/run_test/post_test | 2 | ✔ |  | 60m |
| oe_test_disable_unwanted | Disable unwanted services | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_update_check | System check update | run_test | 1 |  |  |  |
| oe_test_add_new_certificate | Add new certificate | run_test/post_test | 2 |  |  |  |
| oe_test_check_change_system | Support check and change the system encryption policy | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_manage_trusted_certificate | Manage trusted system certificates | run_test | 4 |  |  |  |
| oe_test_use_luks | Encrypting existing data on a block device using LUKS with a detached header | config_params/pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_aide_check_update | Install ADIDE, AIDE integrity check, AIDE library update | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ensure_security_compliance | View configuration files to ensure security compliance | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_encrypt_data | Encrypt data on unencrypted devices | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_check_passwd_shadow | Check passwd and shadow files | run_test/post_test | 8 |  |  |  |
| oe_test_scanning_remote_system | Scanning remote system vulnerabilities | pre_test/run_test/post_test | 1 | ✔ |  | 60m |
| oe_test_security_test_FUN293 | store password with ciphertext | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_security_test_FUN294 | Only root can specify a user name | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_security_test_FUN295 | uniqueness of uid | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_security_test_FUN296 | user identification | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_security_test_FUN297 | set password length | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_security_test_FUN299 | least length of passwd | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_security_test_FUN305 | Take the test ls command as an example | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_security_test_FUN306 | restrict ssh login | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_security_test_FUN336 | Take the test ls command as an example | run_test | 1 |  | ✔ |  |
| oe_test_security_test_FUN309 | ACL | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_security_test_FUN314 | ACL umask control | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_security_test_FUN315 | validity of file execution permission | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_security_test_FUN316 | correctness of file permissions | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_security_test_FUN317 | only root can read and write | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_security_test_FUN323 | record the behavior in a file | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_security_test_FUN324 | demsg | run_test | 1 |  |  |  |
| oe_test_security_test_FUN325 | record login information | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_security_test_FUN332 | Take the test ls command as an example | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_security_test_FUN334 | iproute | run_test | 1 |  |  |  |
| oe_test_security_test_FUN338 | IPsec protocol | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_security_test_FUN339 | kernel firewall management | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_user_management_id | Command id | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_user_management_groupmod | Command groupmod | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_ACL_setfacl_test_mode | Command ACL setfacl test mode | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_openssl_RSA_key | Test openssl_RSA key | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_chage | Command chage | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_authselect | Command authselect | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_authselect_01 | File system common command test-authselect | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_authselect_02 | File system common command test-authselect | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_non-interactive-account | Login is not allowed for a non-interactive account | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_AccessControl_01 | AccessControl_私有数据隔离保护 | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_UserMgmt_username_and_UID | User Management using&modify username&UID include previously used and now exist | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_sm3_encryption_test | sm3 Encryption test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_formats | acl setfacl/chacl sets the difference between acl formats | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_hdf5 | Use hdf5 case | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gpgcheck | gpgkey check for rpms | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_passwd_set_minimum_interval | use passwd set the minimum password modification interval | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_shadow_file_permission | check shadow file's acl permission | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_set_max_uid | set max uid | pre_test/run_test/post_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_selinux_listuser

- 描述：list confined and unconfined user
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check user mapping failed"
  CHECK_RESULT $? 0 0 "Check selinux users failed"
  CHECK_RESULT $? 0 0 "Check selinux roles failed"
```

- 涉及命令：seinfo×2

#### oe_test_selinux_adduser

- 描述：add user mapped to the selinux user
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check unconfined_u failed"
  CHECK_RESULT $? 0 0 "Check staff_r failed"
  CHECK_RESULT $? 0 0 "Check staff_u failed"
```

- 涉及命令：userdel×2, useradd×1

#### oe_test_selinux_confining_regular_user

- 描述：confining regular user
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check user_u failed"
  CHECK_RESULT $? 0 0 "Check id user_u:user_r:user_t failed"
```

- 涉及命令：userdel×1

#### oe_test_selinux_confining_admin_using_role

- 描述：confining admin using role
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check example staff_u failed"
  CHECK_RESULT $? 0 0 "Check id -Z failed"
```

- 涉及命令：adduser×1, userdel×1

#### oe_test_selinux_confining_admin_to_sysadm_u

- 描述：confining admin to sysadm_u
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "set ssh_sysadm_login on failed"
  CHECK_RESULT $? 0 0 "Check example sysadm_u failed"
  CHECK_RESULT $? 0 0 "Check id -Z failed"
```

- 涉及命令：setsebool×2, adduser×1, grep×1, userdel×1

#### oe_test_selinux_http

- 描述：Customize SELinux strategy for apache http server in non-standard configuration
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check httpd status failed"
  CHECK_RESULT $? 0 0 "Check wget failed"
```

- 涉及命令：sed×3, restorecon×1

#### oe_test_selinux_sharing_nfs_cifs_using_booleans

- 描述：Adjusted the strategy for sharing nfs and cifs volumes using SELinux booleands
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check semanage nfs off failed"
  CHECK_RESULT $? 0 0 "Check semanage cifs off failed"
  CHECK_RESULT $? 0 0 "Check getsebool nfs off failed"
  CHECK_RESULT $? 0 0 "Check getsebool cifs off failed"
  CHECK_RESULT $? 0 0 "Check semanage nfs on failed"
  CHECK_RESULT $? 0 0 "Check semanage cifs on failed"
```

- 涉及命令：getsebool×2

#### oe_test_selinux_sec_status_mode

- 描述：selinux status and mode
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_selinux_sec_sestatus

- 描述：sestatus view selinux status strategy
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

#### oe_test_selinux_change_permissive

- 描述：Permanently change to licensing model
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_selinux_change_enforcing

- 描述：Permanently change to mandatory mode
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_selinux_disable

- 描述：Permanently disable SELinux
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_selinux_booleands

- 描述：Adjusted the strategy for sharing nfs and cifs volumes using SELinux booleands
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：getsebool×2

#### oe_test_identify_selinux_rejects

- 描述：Identify SELinux rejects
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：ausearch×2, test×2, journalctl×1, grep×1, semodule×1, sed×1

#### oe_test_fix_selinux_reject_messages

- 描述：Fix SELinux rejections that have been analyzed
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sealert×2, sed×1, auditctl×1, test×1

#### oe_test_selinux_semanage_httpd

- 描述：Modify the HTTP default directory in SELinux
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：restorecon×2, setsebool×2, test×1, matchpathcon×1, getsebool×1

#### oe_test_selinux_audit

- 描述：View SELinux logs in audit
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×1, ausearch×1

#### oe_test_selinux_chcon

- 描述：selinux chcon
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "setting selinux context type fail"
  CHECK_RESULT $? 0 0 "setting selinux context user fail"
  CHECK_RESULT $? 0 0 "setting selinux mode fail"
  CHECK_RESULT $? 0 0 "setting selinux context role fail"
  CHECK_RESULT $? 0 0 "selinux context is error"
```

- 涉及命令：chcon×3, userdel×1

#### oe_test_selinux_semanage_user

- 描述：selinux semanage user manage
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check selinux user info fail"
  CHECK_RESULT $? 0 0 "add selinux user member fail"
  CHECK_RESULT $? 0 0 "modifing selinux user role fail"
  CHECK_RESULT $? 0 1 "delete selinux user member fail"
```

#### oe_test_selinux_semanage_login

- 描述：selinux semanage login manage
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "check login user and selinux user info fail"
  CHECK_RESULT $? 0 0 "set selinux user of test fail"
  CHECK_RESULT $? 0 0 "modify selinux user of test fail"
  CHECK_RESULT $? 0 0 "delete selinux user of test fail"
  CHECK_RESULT $? 0 1 "selinux login user should not exit"
```

- 涉及命令：userdel×1

#### oe_test_scanning_system

- 描述：Vulnerability scanning system
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "exec 'oscap oval eval --report vulnerability.html /usr/share/xml/scap/ssg/content/ssg-ol7-oval.xml' failed"
  CHECK_RESULT $? 0 0 "oscap failed"
```

#### oe_test_disable_unwanted

- 描述：Disable unwanted services
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "exec 'systemctl start cups' failed"
  CHECK_RESULT $? 0 0 "exec 'systemctl disable cups' failed"
  CHECK_RESULT $? 0 1 "exec 'systemctl stop cups' failed"
```

#### oe_test_update_check

- 描述：System check update
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "yum update failed"
```

#### oe_test_add_new_certificate

- 描述：Add new certificate
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "cp failed"
  CHECK_RESULT $? 0 0 "exec 'update-ca-trust' failed"
```

#### oe_test_check_change_system

- 描述：Support check and change the system encryption policy
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "update-crypto-policies is not DEFAULT"
  CHECK_RESULT $? 0 0 "set update-crypto-policies FUTURE failed"
  CHECK_RESULT $? 0 0 "set update-crypto-policies LEGACY failed"
```

#### oe_test_manage_trusted_certificate

- 描述：Manage trusted system certificates
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "exec 'trust --help' failed"
  CHECK_RESULT $? 0 0 "exec 'trust list' failed"
  CHECK_RESULT $? 0 0 "exec 'trust anchor /etc/pki/tls/certs/ca-bundle.trust.crt' failed"
  CHECK_RESULT $? 0 0 "exec 'trust anchor --remove /etc/pki/tls/certs/ca-bundle.trust.crt' failed"
```

#### oe_test_use_luks

- 描述：Encrypting existing data on a block device using LUKS with a detached header
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "exec 'cryptsetup reencrypt --new' failed"
  CHECK_RESULT $? 0 0 "exec 'cryptsetup open --header' failed"
  CHECK_RESULT $? 0 0 "exec 'mount' failed"
```

#### oe_test_aide_check_update

- 描述：Install ADIDE, AIDE integrity check, AIDE library update
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "exec 'aide --init' failed"
  CHECK_RESULT $? 0 0 "exec 'aide --check' failed"
  CHECK_RESULT $? 0 0 "exec 'aide --update' failed"
```

#### oe_test_ensure_security_compliance

- 描述：View configuration files to ensure security compliance
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "xml not exist"
  CHECK_RESULT $? 0 0 "exec 'oscap info failed'"
  CHECK_RESULT $? 0 0 "exec 'oscap info --profile pci-dss /usr/share/xml/scap/ssg/content/ssg-sl*-xccdf.xml' failed"
```

#### oe_test_encrypt_data

- 描述：Encrypt data on unencrypted devices
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "exec 'cryptsetup reencrypt & cryptsetup' failed"
  CHECK_RESULT $? 0 0 "mount failed"
```

- 涉及命令：test×1

#### oe_test_check_passwd_shadow

- 描述：Check passwd and shadow files
- 函数：`run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check permission of /etc/passwd failed"
  CHECK_RESULT $? 0 0 "check permission of /etc/shadow failed"
  CHECK_RESULT $? 0 1 "exist password in /etc/shadow"
  CHECK_RESULT $? 0 1 "exist password in /var/log"
  CHECK_RESULT $((passwd_count == shadow_count)) 1 0 "passwd/shadow entry mismatch"
  CHECK_RESULT $? 0 0 "invalid password hash format in shadow"
  CHECK_RESULT "$passwd_fields" 6 0 "invalid field count in passwd entry"
  CHECK_RESULT "$shadow_fields" 8 0 "invalid field count in shadow entry"
```

- 涉及命令：grep×2, userdel×1

#### oe_test_scanning_remote_system

- 描述：Scanning remote system vulnerabilities
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "exec 'oscap-ssh' failed"
```

- 涉及命令：expect×1

#### oe_test_security_test_FUN293

- 描述：store password with ciphertext
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "set success"
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_security_test_FUN294

- 描述：Only root can specify a user name
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "set failed"
  CHECK_RESULT $? 0 0 "change failed"
  CHECK_RESULT $? 0 0 "change num failed"
```

- 涉及命令：userdel×1

#### oe_test_security_test_FUN295

- 描述：uniqueness of uid
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "add root failed"
  CHECK_RESULT $? 0 0 "add user failed"
  CHECK_RESULT $(cat /etc/passwd | awk -F ":" '{a[$3]++}END{for(i in a){if(a[i]!=1){print i,a[i]}}}' | wc -l) 0 0 "print failed"
  CHECK_RESULT $? 0 0 "uid is not unique"
```

- 涉及命令：userdel×1

#### oe_test_security_test_FUN296

- 描述：user identification
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_security_test_FUN297

- 描述：set password length
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "failed"
```

- 涉及命令：userdel×1

#### oe_test_security_test_FUN299

- 描述：least length of passwd
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "grep bad failed"
```

- 涉及命令：sed×3, grep×2, userdel×1

#### oe_test_security_test_FUN305

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 涉及命令：userdel×1

#### oe_test_security_test_FUN306

- 描述：restrict ssh login
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "grep failed"
```

- 涉及命令：sed×2

#### oe_test_security_test_FUN336

- 描述：Take the test ls command as an example
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "ssh failed"
```

#### oe_test_security_test_FUN309

- 描述：ACL
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "show failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "set failed"
  CHECK_RESULT $? 0 0 "grep new user failed"
  CHECK_RESULT $? 0 0 "mv failed"
  CHECK_RESULT $? 0 0 "cat file failed"
  CHECK_RESULT $? 0 0 "setb failed"
  CHECK_RESULT $? 1 0 "grep group failed"
  CHECK_RESULT $? 1 0 "visit failed"
  CHECK_RESULT $? 0 0 "set home failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 0 0 "cat failed"
```

- 涉及命令：setfacl×3, getfacl×2, userdel×1

#### oe_test_security_test_FUN314

- 描述：ACL umask control
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "grep first failed"
  CHECK_RESULT $? 0 0 "change failed"
  CHECK_RESULT $? 0 0 "touch failed"
  CHECK_RESULT $? 0 0 "grep second failed"
```

- 涉及命令：grep×1

#### oe_test_security_test_FUN315

- 描述：validity of file execution permission
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "chmod failed"
  CHECK_RESULT $? 0 0 "add failed"
  CHECK_RESULT $? 1 0 "cat failed"
```

- 涉及命令：userdel×1

#### oe_test_security_test_FUN316

- 描述：correctness of file permissions
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "touch failed"
  CHECK_RESULT $? 0 0 "grep faild"
  CHECK_RESULT $? 1 0 "success"
  CHECK_RESULT $? 0 0 "write failed"
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：userdel×2, grep×1

#### oe_test_security_test_FUN317

- 描述：only root can read and write
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "touch failed"
  CHECK_RESULT $? 0 0 "grep faild"
  CHECK_RESULT $? 1 0 "success"
  CHECK_RESULT $? 0 0 "write failed"
  CHECK_RESULT $? 0 0 "grep failed"
  CHECK_RESULT $? 1 0 "success"
  CHECK_RESULT $? 0 0 "echo failed"
```

- 涉及命令：userdel×2, grep×1

#### oe_test_security_test_FUN323

- 描述：record the behavior in a file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "change failed"
  CHECK_RESULT $? 0 0 "grep failed"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_security_test_FUN324

- 描述：demsg
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "start failed"
```

- 涉及命令：grep×1

#### oe_test_security_test_FUN325

- 描述：record login information
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "root who failed"
  CHECK_RESULT $? 0 0 "user who failed"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_security_test_FUN332

- 描述：Take the test ls command as an example
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "add failed"
  CHECK_RESULT $? 0 0 "delete failed"
  CHECK_RESULT $? 0 0 "clean failed"
```

- 涉及命令：iptables×3

#### oe_test_security_test_FUN334

- 描述：iproute
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "show failed"
```

#### oe_test_security_test_FUN338

- 描述：IPsec protocol
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "start failed"
  CHECK_RESULT $? 0 0 "grep active failed"
```

#### oe_test_security_test_FUN339

- 描述：kernel firewall management
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "start failed"
  CHECK_RESULT $? 0 0 "grep start failed"
  CHECK_RESULT $? 0 0 "stop failed"
  CHECK_RESULT $? 0 0 "grep stop failed"
  CHECK_RESULT $? 0 0 "start failed"
  CHECK_RESULT $? 0 0 "grep start failed"
```

#### oe_test_user_management_id

- 描述：Command id
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "id cmd fail"
  CHECK_RESULT $? 0 0 "参数g不支持"
  CHECK_RESULT $? 0 0 "参数G不支持"
  CHECK_RESULT $? 0 0 "id help fail"
  CHECK_RESULT $? 0 0 "get version info"
  CHECK_RESULT $? 0 1 "get invalid account info"
  CHECK_RESULT $? 0 0 "get valid account info"
  CHECK_RESULT "$(id -G -n account1)" "account1 wheel" 0 "get groups name info"
  CHECK_RESULT "$(id -g -n account1)" "account1" 0 "get group name info"
  CHECK_RESULT "$(id -u -n account1)" "account1" 0 "get user name info"
  CHECK_RESULT "$(id -G -r account1 |awk '{print $2}')" "10" 0 "get groups real id info"
```

- 涉及命令：useradd×1

#### oe_test_user_management_groupmod

- 描述：Command groupmod
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "create user,username is groupA"
  CHECK_RESULT $? 0 0 "groupA is not existent "
  CHECK_RESULT $? 0 0 "groupA id error "
  CHECK_RESULT $? 0 0 "groupB is not existent "
  CHECK_RESULT $? 0 0 "groupB is delete "
  CHECK_RESULT $? 0 1 "Add group for gid unique"
  CHECK_RESULT $? 0 0 "Add group for gid not unique"
  CHECK_RESULT "$(cat /etc/group |grep groupA |awk -F ":" '{print $3}')" "2222" 0 "check GID of groupA"
  CHECK_RESULT "$(cat /etc/group |grep groupB |awk -F ":" '{print $3}')" "2222" 0 "check GID of groupB"
  CHECK_RESULT $? 0 1 "no user in groupA default"
  CHECK_RESULT "$(cat /etc/group |grep groupA |awk -F ":" '{print $4}')" "groupA" 0 "check user of groupA"
  CHECK_RESULT "$(cat /etc/gshadow |grep groupA |awk -F ":" '{print $2}')" "!" 0 "no password of groupA default"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：grep×4, groupmod×4, groupadd×2

#### oe_test_ACL_setfacl_test_mode

- 描述：Command ACL setfacl test mode
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "testdir test mode fail"
  CHECK_RESULT $? 0 0 "testdir modify fail"
  CHECK_RESULT $? 0 0 "testfile test mode fail"
  CHECK_RESULT $? 0 0 "testfile set fail"
  CHECK_RESULT $? 0 1 "testfile can not set success,please check"
```

- 涉及命令：setfacl×4, userdel×1

#### oe_test_openssl_RSA_key

- 描述：Test openssl_RSA key
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Error, No build rsa_private.key"
  CHECK_RESULT $? 0 0 "Error, No build rsa_public.key"
  CHECK_RESULT $? 0 0 "Error, No build rsa_aes_private.key"
  CHECK_RESULT $? 0 0 "Error, No build rsa_aes_private_nopasswd.key"
  CHECK_RESULT $? 0 0 "Error, Encryption rsa_aes_private_nopasswd.key failed"
```

#### oe_test_chage

- 描述：Command chage
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "force password expire fail"
  CHECK_RESULT $? 0 0 "modify the days between two password changes fail"
  CHECK_RESULT $? 0 0 "modify password validity fail"
  CHECK_RESULT $? 0 0 "modify the warning days before password expires fail"
  CHECK_RESULT "$(chage -l normal |grep "Account expires" |awk '{print $NF}')" "never" 0 "account default never expires"
  CHECK_RESULT "$(chage -l normal |grep "Account expires" |awk -F ":" '{print $NF}')" " Jan 01, 1970" 0 "account expires after modify"
  CHECK_RESULT "$(chage -l -i normal |grep "Account expires" |awk '{print $NF}')" "1970-01-01" 0 "account expires use YYYY-MM-DD when printing dates"
  CHECK_RESULT "$(chage -l normal |grep "Password inactive" |awk '{print $NF}')" "never" 0 "default EXPIRE_DATE"
  CHECK_RESULT "$(chage -l normal |grep "Password inactive" |awk '{print $NF}')" "$(chage -l normal |grep "Password expires" |awk '{print $NF}')" 0 "set account expiration date to EXPIRE_DATE"
  CHECK_RESULT $? 0 0 "help info check"
```

- 涉及命令：chage×11, userdel×1

#### oe_test_authselect

- 描述：Command authselect
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "print config info fail"
  CHECK_RESULT $? 0 0 "print effective config info fail"
  CHECK_RESULT $? 0 0 "print the Changes to be written fail"
  CHECK_RESULT $? 0 0 "print config minimal info fail"
```

#### oe_test_authselect_01

- 描述：File system common command test-authselect
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Backup failure"
  CHECK_RESULT $? 0 0 "Validity failure"
  CHECK_RESULT $? 0 0 "Recovery failure"
  CHECK_RESULT $? 0 0 "remove failure"
  CHECK_RESULT $? 0 1 "delete failure"
```

#### oe_test_authselect_02

- 描述：File system common command test-authselect
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Display failure"
  CHECK_RESULT $? 0 0 "Failed to create an empty configuration set. Procedure"
  CHECK_RESULT $? 0 1 "Configuration set display failed"
  CHECK_RESULT $? 0 0 "Failed to create a configuration set. Procedure"
  CHECK_RESULT $? 0 0 "Creation failure"
  CHECK_RESULT $? 0 0 "Failed to print configuration set dependency"
  CHECK_RESULT $? 0 0 "Description Failed to display the configuration set information"
  CHECK_RESULT $? 0 0 "Failed to select a configuration item. Procedure"
  CHECK_RESULT $? 0 0 "Identifier display failed"
```

#### oe_test_non-interactive-account

- 描述：Login is not allowed for a non-interactive account
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "non-interactive account is locked"
  CHECK_RESULT $? 0 0 "password of interactive account is set"
  CHECK_RESULT $? 0 1 "user's password is stored in /etc/shadow"
```

- 涉及命令：test×2, awk×1

#### oe_test_AccessControl_01

- 描述：AccessControl_私有数据隔离保护
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "su - adm_737709 failed !"
  CHECK_RESULT $? 0 0 "su - normal_737709 failed !"
  CHECK_RESULT $? 0 0 "cd root  adm Permission isolation failure"
  CHECK_RESULT $? 0 0 "cd /home/normal_737709 adm Permission isolation failure"
  CHECK_RESULT $? 0 0 "cd /root normal Permission isolation failure"
  CHECK_RESULT $? 0 0 "cd /home/adm_737709 normal Permission isolation failure"
```

- 涉及命令：userdel×2, useradd×1

#### oe_test_UserMgmt_username_and_UID

- 描述：User Management using&modify username&UID include previously used and now exist
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 1 "test1 could not be created because test1 is already existed"
  CHECK_RESULT $? 0 0 "test1 delete fail"
  CHECK_RESULT $? 0 0 "creating test1 fail"
  CHECK_RESULT $? 0 1 "test2 could not be created because UIS 1020 is already used"
  CHECK_RESULT $? 0 0 "test1 delete fail"
  CHECK_RESULT $? 0 0 "creating test2 with UID 1020 fail"
  CHECK_RESULT $? 0 1 "tom1 name could not be modified because test2 is already used "
  CHECK_RESULT $? 0 0 "test2 delete fail"
  CHECK_RESULT $? 0 0 "modify tom1 name to test2 fail"
```

- 涉及命令：useradd×5, userdel×5, usermod×2, groupdel×1

#### oe_test_sm3_encryption_test

- 描述：sm3 Encryption test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Default encryption is not sha512"
  CHECK_RESULT $? 0 0 "Description Failed to modify the configuration file"
  CHECK_RESULT $? 0 0 "Password change failed"
  CHECK_RESULT $? 0 0 "sm3 encryption fails"
```

- 涉及命令：sed×1, userdel×1

#### oe_test_acl_formats

- 描述：acl setfacl/chacl sets the difference between acl formats
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "setfacl failed to change permissions for testfileA"
  CHECK_RESULT $? 0 0 "setfacl failed to change permissions for testfileB"
  CHECK_RESULT $? 0 0 "test.txt and setfacl.txt have different contents"
  CHECK_RESULT $? 0 0 "chacl failed to change permissions for testfileA"
  CHECK_RESULT $? 0 1 "chacl seccess to change permissions for testfileB"
  CHECK_RESULT $? 0 0 "test.txt and chacl.txt have different contents"
```

- 涉及命令：setfacl×2

#### oe_test_hdf5

- 描述：Use hdf5 case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error,Fail to create hdf5_example.c"
  CHECK_RESULT $? 0 0 "Error,Fail to create hdf5_example"
  CHECK_RESULT $? 0 0 "Error,Please check the file 'hdf5_example'"
```

#### oe_test_gpgcheck

- 描述：gpgkey check for rpms
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check RPM signature"
  CHECK_RESULT $? 0 0 "Failed to localinstall rpm"
  CHECK_RESULT $? 0 0 "Failed to check RPM signature"
  CHECK_RESULT $? 0 0 "Failed to localinstall rpm"
  CHECK_RESULT $? 0 1 "Failed to check rpm gpgkey"
  CHECK_RESULT $? 0 0 "Failed to check rpm gpgkey"
```

- 涉及命令：rpm×4, sed×2

#### oe_test_passwd_set_minimum_interval

- 描述：use passwd set the minimum password modification interval
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Change password successful"
  CHECK_RESULT $? 0 0 "Set system's time failed"
  CHECK_RESULT $? 0 0 "Change password failed"
```

- 涉及命令：grep×2, useradd×1, passwd×1, date×1, userdel×1

#### oe_test_shadow_file_permission

- 描述：check shadow file's acl permission
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "Can change /etc/shadow file's owner to Permission user."
  CHECK_RESULT $? 0 0 "Failed to create /etc/shadow link file."
  CHECK_RESULT $? 0 1 "Can read /etc/shadow link file."
  CHECK_RESULT $? 0 1 "Can create /etc/shadow hard link file."
```

- 涉及命令：userdel×1

#### oe_test_set_max_uid

- 描述：set max uid
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Fail to set max uid."
  CHECK_RESULT $? 0 1 "Still has available UIDs."
```

- 涉及命令：sed×2, userdel×1
