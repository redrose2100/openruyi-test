# embedded_os_basic_extra_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/os_basic_extra_test` |
| 注册用例数 | 35 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_kmod_depmod | verify the uasge of depmod command | run_test | 5 |  |  |  |
| oe_test_kmod_insmod_lsmod | verify the uasge of insmod and lsmod command | run_test | 2 |  |  |  |
| oe_test_kmod_kmod | verify the uasge of kmod command | run_test | 7 |  |  |  |
| oe_test_kmod_modinfo | verify the uasge of modinfo command | run_test | 3 |  |  |  |
| oe_test_kmod_modprobe | verify the uasge of modprobe command | run_test | 8 |  |  |  |
| oe_test_kmod_rmmod | verify the uasge of rmmod command | run_test | 2 |  |  |  |
| oe_test_libcap_libcap | Check libcap | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_acl_allow_change_nochange | allows to modify the unmodifiable (IMMUTABLE) and only add (APPEND-ONLY) attributes of the file | is_qemu_vm/config_params/pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_allow_change_ownership | allow to change the ownership of the file | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_ignore_dal_across | Ignore all DAC access restrictions on files | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_manage_net | Allow network management tasks | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_acl_ordinary_users_setgid | The setting program allows ordinary users to use the setgid function | is_qemu_vm/config_params/pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_acl_send_kill_notbelong | Allow kill signals to be sent to processes that do not belong to you | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_verwrite_previous_rules | Overwrite previous rules | run_test/post_test | 4 |  |  |  |
| oe_test_acl_add_write_permissions | Set ACL rules to add write permissions to a user | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_acl_change_mask | Modify the mask rules to remove user read permissions | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_check_create | View ACL rules for newly created files | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_acl_defaulr_rule | Directory defaulr ACL rules | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_acl_only_root_permission | Only the owner and root administrator of the file have management ACL permissions | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_acl_chacl | Test "chacl" command | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_acl_getfacl | Test "getfacl" command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_acl_setfacl | Test "setfacl" command | config_params/pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_proc_start_kill | Start process / kill process | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_net-tools_test_001 | Run net-tools testsuite | run_test | 28 |  |  |  |
| oe_test_initscripts_test_001 | Run initscripts testsuite | run_test | 7 |  |  |  |
| oe_test_iptables_cli_test | Run iptables testsuite | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_cronie_test_001 | Run cronie testsuite | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_cracklib_test_001 | Run cracklib testsuite | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_pciutils_cli_test | Run pciutils testsuite | is_qemu_vm/config_params/run_test | 12 |  |  |  |
| oe_test_libtool_test_001 | Run libtool testsuite | run_test/post_test | 16 |  |  |  |
| oe_test_strace_test_001 | Run strace testsuite | run_test/post_test | 12 |  |  |  |
| oe_test_squashfs-tools_test_001 | Run squashfs-tools testsuite | run_test/post_test | 12 |  |  |  |
| oe_test_libpwquality_test_001 | Run libpwquality testsuite | run_test | 4 |  |  |  |
| oe_test_curl_test_001 | Test curl | config_params/run_test/post_test | 6 |  |  |  |
| oe_test_rpcbind_test_001 | Test rpcbind | run_test/post_test | 4 |  |  |  |

### 断言与命令明细

#### oe_test_kmod_depmod

- 描述：verify the uasge of depmod command
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：depmod×3

#### oe_test_kmod_insmod_lsmod

- 描述：verify the uasge of insmod and lsmod command
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：insmod×2

#### oe_test_kmod_kmod

- 描述：verify the uasge of kmod command
- 函数：`run_test`
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

- 涉及命令：kmod×2

#### oe_test_kmod_modinfo

- 描述：verify the uasge of modinfo command
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：modinfo×1

#### oe_test_kmod_modprobe

- 描述：verify the uasge of modprobe command
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：modprobe×1

#### oe_test_kmod_rmmod

- 描述：verify the uasge of rmmod command
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_libcap_libcap

- 描述：Check libcap
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check capsh --help failed."
  CHECK_RESULT $? 0 0 "Check capsh ping local failed."
  CHECK_RESULT $? 0 0 "Check capsh --user failed."
  CHECK_RESULT $? 0 0 "Check capsh --uid failed."
  CHECK_RESULT $? 0 0 "Check capsh --gid failed."
  CHECK_RESULT $? 0 0 "Check capsh --mode failed."
  CHECK_RESULT $? 0 0 "Check setcap failed."
  CHECK_RESULT $? 0 0 "Check getcap failed."
  CHECK_RESULT $? 0 0 "Check setcap -r failed."
  CHECK_RESULT $? 1 0 "Check getcap after revert failed."
  CHECK_RESULT $? 0 0 "Check capsh --help failed."
  CHECK_RESULT $? 0 0 "Check capsh --usage failed."
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：setcap×1, userdel×1

#### oe_test_acl_allow_change_nochange

- 描述：allows to modify the unmodifiable (IMMUTABLE) and only add (APPEND-ONLY) attributes of the file
- 函数：`is_qemu_vm, config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "Authorization succeeded, but it should fail here"
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Privilege grant failed"
  CHECK_RESULT $? 0 0 "Failed to view ----i---- field in file properties"
```

- 涉及命令：grep×3, setcap×1, userdel×1

#### oe_test_acl_allow_change_ownership

- 描述：allow to change the ownership of the file
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view '/tmp/test' document and obtain 'root root' field"
  CHECK_RESULT $? 0 1 "Switching example user to change the file owner succeeded, but it should fail here"
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Failed to switch example user to change file owner"
```

- 涉及命令：setcap×1, userdel×1

#### oe_test_acl_ignore_dal_across

- 描述：Ignore all DAC access restrictions on files
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to switch example user to view '/etc/shadow' document and obtain 'Permission denied' field"
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Failed to get cap"
  CHECK_RESULT $? 0 0 "Failed to switch example user to view '/etc/shadow' document and obtain 'root' field"
```

- 涉及命令：setcap×1, userdel×1

#### oe_test_acl_manage_net

- 描述：Allow network management tasks
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "Switching example users to view network devices succeeded, but it should fail here"
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Failed to switch example users to view network devices"
  CHECK_RESULT $? 0 0 "Failed to display protocol address"
```

- 涉及命令：setcap×1, userdel×1

#### oe_test_acl_ordinary_users_setgid

- 描述：The setting program allows ordinary users to use the setgid function
- 函数：`is_qemu_vm, config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1 "Failed to chattr"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×3, setcap×1, userdel×1

#### oe_test_acl_send_kill_notbelong

- 描述：Allow kill signals to be sent to processes that do not belong to you
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "Kill process succeeded, but it should fail here"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1 "The viewing process succeeded, but it should fail here"
```

- 涉及命令：setcap×1, kill×1, userdel×1

#### oe_test_acl_verwrite_previous_rules

- 描述：Overwrite previous rules
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Failed to get cap"
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Failed to get cap"
```

- 涉及命令：setcap×1

#### oe_test_acl_add_write_permissions

- 描述：Set ACL rules to add write permissions to a user
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check file default umask failed"
  CHECK_RESULT $? 0 0 "Failed to add a user permission for 'example'"
  CHECK_RESULT  $? 0 0 "Comparison between tmp_log and diff_file failed"
  CHECK_RESULT  $? 0 0 "Check file umask failed"
  CHECK_RESULT  $? 0 0 "Switching to 'example' failed to execute echo command"
```

- 涉及命令：setfacl×1, userdel×1

#### oe_test_acl_change_mask

- 描述：Modify the mask rules to remove user read permissions
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT  $? 0 0 "Failed to switch 'example2' user to view files"
  CHECK_RESULT  $? 0 0 "Failed to set ACL"
  CHECK_RESULT  $? 0 0 "Failed to get ACL"
  CHECK_RESULT $? 0 1 "Failed to switch 'example2' user to view files"
```

- 涉及命令：userdel×2, setfacl×1

#### oe_test_acl_check_create

- 描述：View ACL rules for newly created files
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT  $? 0 0 "Comparison between tmp_log and diff_file failed"
```

#### oe_test_acl_defaulr_rule

- 描述：Directory defaulr ACL rules
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT  $? 0 0 "Comparison between diff_file_log and tmp_file failed"
  CHECK_RESULT  $? 0 0 "Comparison between diff_file_log and tmp_file failed"
```

- 涉及命令：mkdir×1, setfacl×1, userdel×1

#### oe_test_acl_only_root_permission

- 描述：Only the owner and root administrator of the file have management ACL permissions
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT  $? 0 0 "Failed to switch 'example2' user to view files"
  CHECK_RESULT $? 0 1 "Switching to 'example2' failed to execute setfacl command"
  CHECK_RESULT $? 0 1 "Switching to 'example2' failed to execute echo command"
  CHECK_RESULT  $? 0 0 "Failed to add a user permission for 'example2'"
  CHECK_RESULT  $? 0 0 "Switching to 'example2' failed to execute echo command"
```

- 涉及命令：userdel×2, setfacl×1

#### oe_test_acl_chacl

- 描述：Test "chacl" command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: No Options No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -R No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -B No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -r No Pass"
```

- 涉及命令：setfacl×4, chacl×2, mkdir×1

#### oe_test_acl_getfacl

- 描述：Test "getfacl" command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: No Options No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
  CHECK_RESULT $? 1 0 "L$LINENO: -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -e No Pass"
  CHECK_RESULT $? 1 0 "L$LINENO: -E No Pass"
  CHECK_RESULT $? 1 0 "L$LINENO: -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -R No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -L No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -P No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：getfacl×13, mkdir×1, setfacl×1

#### oe_test_acl_setfacl

- 描述：Test "setfacl" command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -M No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -x No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -X No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --set No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --set-file No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --mask No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -k No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：setfacl×8, read×2, mkdir×1

#### oe_test_proc_start_kill

- 描述：Start process / kill process
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：pgrep×5, kill×1

#### oe_test_net-tools_test_001

- 描述：Run net-tools testsuite
- 函数：`run_test`
- 断言（28 条）：

```
  CHECK_RESULT $? 0 0 "check arp failed!"
  CHECK_RESULT $? 0 0 "check arp -afailed!"
  CHECK_RESULT $? 0 0 "check arp -D -v failed!"
  CHECK_RESULT $? 0 0 "check ifconfig failed!"
  CHECK_RESULT $? 0 0 "check ifconfig -a failed!"
  CHECK_RESULT $? 0 0 "check ifconfig tunl0 down failed!"
  CHECK_RESULT $? 1 0 "check ifconfig failed!"
  CHECK_RESULT $? 0 0 "check ifconfig tunl0 up failed!"
  CHECK_RESULT $? 0 0 "check ifconfig failed!"
  CHECK_RESULT $? 0 0 "check iptunnel failed!"
  CHECK_RESULT $? 0 0 "check netstat failed!"
  CHECK_RESULT $? 0 0 "check netstat -a failed!"
  ... 共 28 条（其余见源脚本）
```

- 涉及命令：netstat×12, arp×2, route×2, ifconfig×1

#### oe_test_initscripts_test_001

- 描述：Run initscripts testsuite
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check ifdown failed!"
  CHECK_RESULT $? 0 0 "check ifdown lo failed!"
  CHECK_RESULT $? 1 0 "check ifconfig failed!"
  CHECK_RESULT $? 0 0 "check ifup lo failed!"
  CHECK_RESULT $? 0 0 "check ifconfig failed!"
  CHECK_RESULT $? 0 0 "check initscripts_sendsigs failed!"
  CHECK_RESULT $? 0 0 "check initscripts halt failed!"
```

#### oe_test_iptables_cli_test

- 描述：Run iptables testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "check iptables -A INPUT -t filter -p tcp --dport 80 -j DROP failed!"
  CHECK_RESULT $? 0 0 "check iptables -L -n failed!"
  CHECK_RESULT $? 0 0 "check iptables -D INPUT -t filter -p tcp --dport 80 -j DROP failed!"
  CHECK_RESULT $? 0 0 "check iptables -N dropchain failed!"
  CHECK_RESULT $? 0 0 "check iiptables -L -n failed!"
  CHECK_RESULT $? 0 0 "check iptables -A INPUT --tcp-flags SYN,RST,ACK SYN failed!"
  CHECK_RESULT $? 0 0 "check iptables-save failed!"
  CHECK_RESULT $? 0 0 "check iptables failed!"
  CHECK_RESULT $? 0 0 "check iptables-save failed!"
  CHECK_RESULT $? 1 0 "check iptables-save failed!"
  CHECK_RESULT $? 0 0 "check iptables-restore -t fail"
  CHECK_RESULT $? 0 0 "check iptables-restore -n fail"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：iptables×11, iptables-restore×4, ip6tables-restore×4, ip6tables-save×1

#### oe_test_cronie_test_001

- 描述：Run cronie testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -V"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: echo \"* * * * * \$(pwd)/test.sh\" >>./cron.test && crontab ./cron.test"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -l"
  CHECK_RESULT $? 0 0 "log message: The service may not be running properly"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -r"
  CHECK_RESULT $? 1 0 "log message: Failed to remove the current crontab"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: echo \"* * * * * /home/\"\"\$USER_NAME\"\"/test.sh\" >> /home/\"\$USER_NAME\"/cron.test && crontab /home/\"\$USER_NAME\"/cron.test"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -u \"\$USER_NAME\" -l"
  CHECK_RESULT $? 0 0 "log message: The service may not be running properly"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: echo -ne 'Y' | crontab -u \"\$USER_NAME\" -ri"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crond -V"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: cronnext -h"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：crontab×8, userdel×2, grep×2, cronnext×2, crond×1

#### oe_test_cracklib_test_001

- 描述：Run cracklib testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "check cracklib-check failed"
  CHECK_RESULT $? 0 0 "check cracklib-check failed"
  CHECK_RESULT $? 0 0 "check cracklib-check failed"
  CHECK_RESULT $? 0 0 "cracklib-check failed"
  CHECK_RESULT $? 0 0 "check cracklib-foramt failed"
  CHECK_RESULT $? 0 0 "check cracklib-foramt result error"
  CHECK_RESULT $? 0 0 "check cracklib-packer failed"
  CHECK_RESULT $? 0 0 "check cracklib-packer failed"
  CHECK_RESULT $? 0 0 "check cracklib-unpacker failed"
  CHECK_RESULT $? 0 0 "check cracklib-unpacker result error"
  CHECK_RESULT $? 0 0 "check cracklib-unpacker failed"
  CHECK_RESULT $? 0 0 "check create-cracklib-dict failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：create-cracklib-dict×2

#### oe_test_pciutils_cli_test

- 描述：Run pciutils testsuite
- 函数：`is_qemu_vm, config_params, run_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "check lspci fail"
  CHECK_RESULT $? 0 0 "check lspci -v fail"
  CHECK_RESULT $? 0 0 "check lspci -v -nn fail"
  CHECK_RESULT $? 0 0 "check lspci -t fail"
  CHECK_RESULT $? 0 0 "check lspci -b fail"
  CHECK_RESULT $? 0 0 "check lspci -x fail"
  CHECK_RESULT $? 0 0 "check lspci -D fail"
  CHECK_RESULT $? 0 0 "check lspci -P fail"
  CHECK_RESULT $? 0 0 "check lspci -PP fail"
  CHECK_RESULT $? 0 0 "check setpci --help fail"
  CHECK_RESULT $? 0 0 "check setpci --dumpregs fail"
  CHECK_RESULT $? 0 0 "check update-pciids fail"
```

- 涉及命令：lspci×8, grep×3

#### oe_test_libtool_test_001

- 描述：Run libtool testsuite
- 函数：`run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "check libtool --config failed!"
  CHECK_RESULT $? 0 0 "check libtool --features failed!"
  CHECK_RESULT $? 0 0 "check libtool --version failed!"
  CHECK_RESULT $? 0 0 "check libtool --help failed!"
  CHECK_RESULT $? 0 0 "check libtoolize -c failed!"
  CHECK_RESULT $? 0 0 "check libtoolize --debug failed!"
  CHECK_RESULT $? 0 0 "check libtoolize -f failed!"
  CHECK_RESULT $? 0 0 "check libtoolize -n failed!"
  CHECK_RESULT $? 0 0 "check libtoolize -h failed!"
  CHECK_RESULT $? 0 0 "check libtoolize --version failed!"
  CHECK_RESULT $? 0 0 "check libtoolize -i failed!"
  CHECK_RESULT $? 0 0 "check libtoolize -q failed!"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：libtoolize×8

#### oe_test_strace_test_001

- 描述：Run strace testsuite
- 函数：`run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "check strace ls fail"
  CHECK_RESULT $? 0 0 "check strace -e fail"
  CHECK_RESULT $? 0 0 "check strace -u fail"
  CHECK_RESULT $? 0 0 "check strace -p fail"
  CHECK_RESULT $? 0 0 "check strace -o fail"
  CHECK_RESULT $? 0 0 "check strace -t fail"
  CHECK_RESULT $? 0 0 "check strace -f fail"
  CHECK_RESULT $? 0 0 "check strace -c fail"
  CHECK_RESULT $? 0 0 "check strace -x fail"
  CHECK_RESULT $? 0 0 "check strace -i fail"
  CHECK_RESULT $? 0 0 "check strace -n fail"
  CHECK_RESULT "$num" 3 0 "check strace -n fail"
```

- 涉及命令：strace×14, kill×1

#### oe_test_squashfs-tools_test_001

- 描述：Run squashfs-tools testsuite
- 函数：`run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "check mksquashfs fail"
  CHECK_RESULT $? 0 0 "check mksquashfs -comp xz fail"
  CHECK_RESULT $? 0 0 "check mksquashfs -b 1M fail"
  CHECK_RESULT $? 0 0 "check mksquashfs -reproducible fail"
  CHECK_RESULT $? 0 0 "check mksquashfs -tarstyle fail"
  CHECK_RESULT $? 0 0 "check mksquashfs -exports fail"
  CHECK_RESULT $? 0 0 "check unsquashfs fail"
  CHECK_RESULT $? 0 0 "check unsquashfs -d fail"
  CHECK_RESULT $? 0 0 "check unsquashfs -q fail"
  CHECK_RESULT $? 0 0 "check unsquashfs -f fail"
  CHECK_RESULT $? 0 0 "check unsquashfs -excludes fail"
  CHECK_RESULT $? 0 0 "check unsquashfs -n fail"
```

- 涉及命令：unsquashfs×5

#### oe_test_libpwquality_test_001

- 描述：Run libpwquality testsuite
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check pwmake failed!"
  CHECK_RESULT $? 0 0 "check pwmake failed!"
  CHECK_RESULT $? 0 0 "check pwscore failed!"
  CHECK_RESULT $? 0 0 "check pwscore failed!"
```

#### oe_test_curl_test_001

- 描述：Test curl
- 函数：`config_params, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check curl -o test.html www.baidu.com failed"
  CHECK_RESULT $? 0 0 "check curl -i -r 0-1024 http://www.sina.com.cn -o sina_part1.html  failed"
  CHECK_RESULT $? 0 0 "check curl -v www.baidu.com failed"
  CHECK_RESULT $? 0 0 "check curl -V failed"
  CHECK_RESULT $? 0 0 "check curl -y 30 www.baidu.com failed"
  CHECK_RESULT $? 0 0 "check curl -q www.baidu.com failed"
```

- 涉及命令：curl×6

#### oe_test_rpcbind_test_001

- 描述：Test rpcbind
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check rpcbind"
  CHECK_RESULT $? 0 0 "Failed to execute netstat"
  CHECK_RESULT $? 0 0 "Failed to execute rpcbind"
  CHECK_RESULT $? 0 0 "Failed to display rpcbind"
```

- 涉及命令：netstat×1, rpcinfo×1
