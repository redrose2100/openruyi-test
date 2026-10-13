# embedded_os_basic_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/os_basic_tests` |
| 注册用例数 | 49 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_bashrc_umask | Bashrc configuring umask | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_basic_cmd_acl | File system common command test-acl | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_basic_cmd_cat | File system common command test-cat | run_test | 3 |  |  |  |
| oe_test_basic_cmd_cd | File system common command test-cd | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_basic_cmd_chmod | File system common command test-chmod | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_basic_cmd_chown | File system common command test-chown | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_basic_cmd_cp | File system common command test-cp | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_basic_cmd_date | Date command line test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_basic_cmd_dd | File system common command test-dd | run_test/post_test | 4 |  |  |  |
| oe_test_basic_cmd_df | File system common command test-df | run_test | 8 |  |  |  |
| oe_test_basic_cmd_dmesg | Query boot information-dmesg | run_test | 4 |  |  |  |
| oe_test_basic_cmd_grep | File system common command test-grep | run_test/post_test | 7 |  |  |  |
| oe_test_basic_cmd_groupadd | Create User Group test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_basic_cmd_groupdel | Delete User Group test | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_basic_cmd_groupmod | Modity User Group test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_basic_cmd_gzip | File system common command test-gzip | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_basic_cmd_id | View user and group id | pre_test/run_test | 4 |  |  |  |
| oe_test_basic_cmd_ln | File system common command test-ln | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_basic_cmd_ls | File system common command test -ls | pre_test/run_test | 3 |  |  |  |
| oe_test_basic_cmd_lsof | check basic commond lsof | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_basic_cmd_mkdir | File system common command test-mkdir | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_basic_cmd_mv | File system common command test-mv | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_basic_cmd_pgrep | View process status-pgrep | run_test | 6 |  |  |  |
| oe_test_basic_cmd_ping | Common network command test-ping | run_test/post_test | 2 |  |  |  |
| oe_test_basic_cmd_ps | View process status-ps | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_basic_cmd_pwd | File system common command test-pwd | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_basic_cmd_rm | File system common command test-rm | run_test | 5 |  |  |  |
| oe_test_basic_cmd_rmdir | File system common command test-rmdir | pre_test/run_test | 3 |  |  |  |
| oe_test_basic_cmd_sort | File system common command test-sort | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_basic_cmd_su | Service Management Common Command Test -su | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_basic_cmd_sysctl | SYSCTL modifies kernel parameters | run_test | 5 |  |  |  |
| oe_test_basic_cmd_tar | File system common command test-tar | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_basic_cmd_top | View process status-top | run_test | 2 |  |  |  |
| oe_test_basic_cmd_touch | File system common command test-touch | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_basic_cmd_umask | Umask default configuration check | run_test | 4 |  |  |  |
| oe_test_basic_cmd_uname | File system common command test-uname | run_test | 7 |  |  |  |
| oe_test_basic_cmd_wc | File system common command test-wc | run_test | 6 |  |  |  |
| oe_test_basic_cmd_which | File system common command test-which | run_test | 1 |  |  |  |
| oe_test_continuous_100M | 100M file continuous cp,dd,tar | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_os_release | Query system version info test | run_test | 2 |  |  |  |
| oe_test_system_log_logrotate | test syslog dump-logrotate | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_system_monitor_process | The system supports monitoring and testing each process | run_test | 6 |  |  |  |
| oe_test_system_service_sshd | Restart and stop the OpenSSH service repeatedly | run_test/post_test | 8 |  |  |  |
| oe_test_system_user_options_001 | Add User test | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_system_user_options_002 | Modify User test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_system_user_options_003 | Modify user home directory | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_var_log | Log View | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_basic_cmd_shopt | Command test-shopt | run_test | 4 |  |  |  |
| oe_test_basic_cmd_shopt_002 | bash shopt shell behavior options (globstar, extglob, nullglob) | pre_test/run_test/post_test | 8 |  |  |  |

### 断言与命令明细

#### oe_test_bashrc_umask

- 描述：Bashrc configuring umask
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "no umask set in bashrc"
  CHECK_RESULT $? 0 1 "run umask fail"
  CHECK_RESULT $? 0 0 "umask set value check fail"
```

- 涉及命令：grep×1, userdel×1

#### oe_test_basic_cmd_acl

- 描述：File system common command test-acl
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 1 "check acl01 acl fail"
  CHECK_RESULT $? 0 0 "check after setfacl acl01 acl fail"
  CHECK_RESULT $? 0 1 "check acl02 acl fail"
  CHECK_RESULT $? 0 0 "check after setfacl acl01 acl fail"
  CHECK_RESULT $? 0 0 "check acl03 acl fail"
  CHECK_RESULT $? 0 1 "check acl01 acl fail"
  CHECK_RESULT $? 0 1 "check acl02 acl fail"
  CHECK_RESULT $? 0 0 "check acl03 acl fail"
```

- 涉及命令：getfacl×8, setfacl×3, test×1, mkdir×1, userdel×1

#### oe_test_basic_cmd_cat

- 描述：File system common command test-cat
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check passwd output fail"
  CHECK_RESULT $? 0 0 "check cat commond fail"
  CHECK_RESULT $? 0 0 "check cat help fail"
```

#### oe_test_basic_cmd_cd

- 描述：File system common command test-cd
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "run cd example fail"
  CHECK_RESULT $? 0 0 "after cd example not change to example dir"
  CHECK_RESULT $? 0 0 "run cd .. fail"
  CHECK_RESULT $? 0 0 "after cd .. not change to current_path dir"
  CHECK_RESULT $? 0 0 "run cd - fail"
  CHECK_RESULT $? 0 0 "after cd - not change to example dir"
```

- 涉及命令：test×1

#### oe_test_basic_cmd_chmod

- 描述：File system common command test-chmod
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 1 0 "dir default mod is drwxrwxrwx"
  CHECK_RESULT $? 0 0 "after chmod check /tmp/test01 mod fail"
  CHECK_RESULT $? 0 0 "check chmod only change one dir fail"
  CHECK_RESULT $? 0 0 "check chmod -R change test01 mod fail"
  CHECK_RESULT $? 0 0 "check chmod -R change test02 mod fail"
  CHECK_RESULT $? 0 0 "The access of /tmp/test02/test03/test03.txt is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/test02/test03/test03.txt is error."
  CHECK_RESULT $? 0 0 "The access of /tmp/test02/test03/test03.txt is error."
  CHECK_RESULT $? 0 0 "check chmod help fail"
```

- 涉及命令：mkdir×2, test×1, chmod×1

#### oe_test_basic_cmd_chown

- 描述：File system common command test-chown
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check /tmp/tmp own user fail"
  CHECK_RESULT $? 0 0 "check /tmp/tmp own group fail"
  CHECK_RESULT $? 0 0 "run chown fail"
  CHECK_RESULT $? 0 0 "after chmod check /tmp/tmp own user fail"
  CHECK_RESULT $? 0 0 "after chmod check /tmp/tmp own group fail"
  CHECK_RESULT $? 0 0 "check chown help fail"
```

- 涉及命令：mkdir×1, chown×1, userdel×1

#### oe_test_basic_cmd_cp

- 描述：File system common command test-cp
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "run cp test1 /home fail"
  CHECK_RESULT $? 0 0 "check test1 fail"
  CHECK_RESULT $? 0 0 "run cp -r test2 /home fail"
  CHECK_RESULT $? 0 0 "check /home/test2/test3 fail"
  CHECK_RESULT $? 0 0 "run cp -s test1 test4 fail"
  CHECK_RESULT $? 0 0 "check test4 fail"
  CHECK_RESULT $? 0 0 "check cp help fail"
```

- 涉及命令：test×4

#### oe_test_basic_cmd_date

- 描述：Date command line test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check date fail"
  CHECK_RESULT $? 0 0 "set date 9:30:00 fail"
  CHECK_RESULT $? 0 0 "set date 2015-02-04 9:30:00 fail"
```

- 涉及命令：date×4

#### oe_test_basic_cmd_dd

- 描述：File system common command test-dd
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "run dd if=/dev/zero fail"
  CHECK_RESULT $? 0 0 "run dd test size fail"
  CHECK_RESULT $? 0 0 "run dd if=file fail"
  CHECK_RESULT $? 0 0 "check dd help fail"
```

#### oe_test_basic_cmd_df

- 描述：File system common command test-df
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check df title fail"
  CHECK_RESULT $? 0 0 "check df -h title fail"
  CHECK_RESULT $? 1 0 "df default display error"
  CHECK_RESULT $? 0 0 "df -h didn't find G|M|K"
  CHECK_RESULT $? 0 0 "check df helf fail"
  CHECK_RESULT $? 0 0 "df -i error"
  CHECK_RESULT $? 0 0 "df --total error"
  CHECK_RESULT $? 0 0 "df --type error"
```

#### oe_test_basic_cmd_dmesg

- 描述：Query boot information-dmesg
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check dmesg one time fail"
  CHECK_RESULT $? 0 0 "check dmesg second time fail"
  CHECK_RESULT $? 0 0 "check dmesg one time fail"
  CHECK_RESULT $? 0 0 "check dmesg second time fail"
```

- 涉及命令：grep×2, journalctl×2

#### oe_test_basic_cmd_grep

- 描述：File system common command test-grep
- 函数：`run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check grep -c fail"
  CHECK_RESULT $? 0 0 "check grep -n fail"
  CHECK_RESULT $? 0 0 "check grep whih | fail "
  CHECK_RESULT $? 0 0 "check grep -i fail"
  CHECK_RESULT $? 0 0 "check grep -v fail"
  CHECK_RESULT $? 0 0 "check grep -r fail"
  CHECK_RESULT $? 0 0 "check grep help fail"
```

- 涉及命令：grep×5

#### oe_test_basic_cmd_groupadd

- 描述：Create User Group test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "run groupadd testgroup fail"
  CHECK_RESULT $? 0 0 "check groupadd testgroup fail"
  CHECK_RESULT $? 0 0 "run groupadd -g 6666 testgroup1 fail"
  CHECK_RESULT $? 0 0 "check testgroup1 fail"
  CHECK_RESULT $? 0 0 "run groupadd -g 9999 -o testgroup2 fail"
  CHECK_RESULT $? 0 0 "check testgroup2 fail"
  CHECK_RESULT $? 0 0 "check groupadd help fail"
```

- 涉及命令：grep×3, groupadd×2

#### oe_test_basic_cmd_groupdel

- 描述：Delete User Group test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check testgroup fail"
  CHECK_RESULT $? 0 0 "run groupdel testgroup fail"
  CHECK_RESULT $? 1 0 "check del testgroup fail"
  CHECK_RESULT $? 0 0 "check groupdel help fail"
  CHECK_RESULT $? 6 0 "groupdel should fail for non-existent group"
  CHECK_RESULT $? 8 0 "groupdel should fail when group is primary group"
  CHECK_RESULT $? 0 0 "testuser_secondary should have testgroup_secondary"
  CHECK_RESULT $? 0 0 "groupdel should succeed for secondary group"
```

- 涉及命令：useradd×1, usermod×1

#### oe_test_basic_cmd_groupmod

- 描述：Modity User Group test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check testgroup1 fail"
  CHECK_RESULT $? 0 0 "run groupmod -g 8888 testgroup1 fail"
  CHECK_RESULT $? 0 0 "check mod testgroup1 fail"
  CHECK_RESULT $? 0 0 "run groupmod -n fail"
  CHECK_RESULT $? 0 0 "check testgroup2 fail"
  CHECK_RESULT $? 1 0 "check testgroup1 fail"
  CHECK_RESULT $? 0 0 "run usermod -a -G fail"
  CHECK_RESULT $? 0 0 "check testgroup2 fail"
  CHECK_RESULT $? 0 0 "check groupmod help fail"
```

- 涉及命令：grep×7, groupmod×3, usermod×1, userdel×1

#### oe_test_basic_cmd_gzip

- 描述：File system common command test-gzip
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 1 0 "check test11 fail"
  CHECK_RESULT $? 0 0 "Check gzip file version failed."
  CHECK_RESULT $? 0 0 "test gzip file by gzip failed."
  CHECK_RESULT $? 0 0 "run gzip -d fail"
  CHECK_RESULT $? 0 0 "check test11 fail"
  CHECK_RESULT $? 0 0 "check gzip help fail"
  CHECK_RESULT $? 0 0 "delete /tmp/test1/testfile1 failed in /test.zip"
  CHECK_RESULT $? 0 0 "add /testfile failed in /test.zip"
  CHECK_RESULT $? 0 1 "-j does not support compressing directories"
```

- 涉及命令：gzip×4, zip×4, test×2, mkdir×1

#### oe_test_basic_cmd_id

- 描述：View user and group id
- 函数：`pre_test, run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check id title fail"
  CHECK_RESULT $? 0 0 "check group id number fail"
  CHECK_RESULT $? 0 0 "check supplementary group ids fail"
  CHECK_RESULT $? 0 0 "check id help fail"
```

- 涉及命令：grep×1

#### oe_test_basic_cmd_ln

- 描述：File system common command test-ln
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check ls dir fail"
  CHECK_RESULT $? 0 0 "check ln help fail"
```

- 涉及命令：mkdir×1

#### oe_test_basic_cmd_ls

- 描述：File system common command test -ls
- 函数：`pre_test, run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check empty dir ls -a show fail"
  CHECK_RESULT $? 0 0 "check empty dir ls -l show fail"
  CHECK_RESULT $? 0 0 "check ls help fail"
```

#### oe_test_basic_cmd_lsof

- 描述：check basic commond lsof
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "run lsof fail"
  CHECK_RESULT $? 0 0 "check lsof sshd fail"
  CHECK_RESULT $? 0 0 "check lsof help fail"
  CHECK_RESULT $? 0 0 "run netstat fail"
  CHECK_RESULT $? 0 0 "check netstat sshd fail"
  CHECK_RESULT $? 0 0 "check netstat help fail"
```

- 涉及命令：lsof×2, netstat×2

#### oe_test_basic_cmd_mkdir

- 描述：File system common command test-mkdir
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check mkdir test1 test2 fail"
  CHECK_RESULT $? 0 0 "check mkdir -p fail"
  CHECK_RESULT $? 0 0 "check mkdir -m fail"
  CHECK_RESULT $? 0 0 "check mkdir help fail"
```

- 涉及命令：test×6, mkdir×2

#### oe_test_basic_cmd_mv

- 描述：File system common command test-mv
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "check mv test1 fail"
  CHECK_RESULT $? 0 0 "mv test1 to test2 fail"
  CHECK_RESULT $? 0 0 "check mv -f fail"
  CHECK_RESULT $? 0 0 "check dir name1 fail"
  CHECK_RESULT $? 0 0 "check dir name2 fail"
  CHECK_RESULT $? 0 1 "check no name1 fail"
  CHECK_RESULT $? 0 0 "check dir name3 fail"
  CHECK_RESULT $? 0 1 "check no name2 fail"
  CHECK_RESULT $? 0 0 "check dir name1 fail"
  CHECK_RESULT $? 0 1 "check no name3 fail"
  CHECK_RESULT $? 0 0 "check mv help fail"
  CHECK_RESULT "$inode1" "$inode3" 0 "Check inode failed."
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：grep×6, mkdir×1

#### oe_test_basic_cmd_pgrep

- 描述：View process status-pgrep
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "pgrep -l ssh fail"
  CHECK_RESULT $? 0 0 "pgrep -o ssh fail"
  CHECK_RESULT $? 0 0 "pgrep -n ssh fail"
  CHECK_RESULT $? 0 0 "pgrep -f sshd fail"
  CHECK_RESULT $? 0 0 "check pgrep -l -o ssh fail"
  CHECK_RESULT $? 0 0 "check pgrep -l -n ssh fail"
```

- 涉及命令：pgrep×6

#### oe_test_basic_cmd_ping

- 描述：Common network command test-ping
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check ping -c fail"
  CHECK_RESULT $? 0 0 "check ping help fail"
```

- 涉及命令：ping×2, sed×1

#### oe_test_basic_cmd_ps

- 描述：View process status-ps
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT 1 0 0 "check ps show fail"
  CHECK_RESULT $? 0 0 "kill mytrest pid fail"
  CHECK_RESULT $? 0 1 "killed pid not kill"
  CHECK_RESULT $? 0 0 "check ps -ef title fail"
  CHECK_RESULT $? 0 0 "check ps help fail"
```

- 涉及命令：kill×1

#### oe_test_basic_cmd_pwd

- 描述：File system common command test-pwd
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "check pwd output fail"
```

#### oe_test_basic_cmd_rm

- 描述：File system common command test-rm
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "Directory creation failed"
  CHECK_RESULT $? 0 0 "Failed to delete files"
  CHECK_RESULT $? 0 0 "Failed to delete directory"
  CHECK_RESULT $? 0 0 "rm --help failed"
```

#### oe_test_basic_cmd_rmdir

- 描述：File system common command test-rmdir
- 函数：`pre_test, run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "rmdir test1 fail"
  CHECK_RESULT $? 0 1 "rmdir -p test1 fail"
  CHECK_RESULT $? 0 0 "check rmdir help fail"
```

- 涉及命令：mkdir×1, rmdir×1

#### oe_test_basic_cmd_sort

- 描述：File system common command test-sort
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT "$res" "   aa" 0 "sort faild"
  CHECK_RESULT $? 1 0 "sort -c faild"
  CHECK_RESULT $? 0 0 "sort -d faild"
  CHECK_RESULT $? 0 0 "sort -g faild"
  CHECK_RESULT $? 0 0 "sort -f faild"
  CHECK_RESULT $? 0 0 "sort -b faild"
  CHECK_RESULT $? 0 0 "sort -r faild"
  CHECK_RESULT $? 0 0 "sort -u faild"
  CHECK_RESULT $? 0 0 "sort help faild"
```

- 涉及命令：sort×6

#### oe_test_basic_cmd_su

- 描述：Service Management Common Command Test -su
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check su -c user name testuser fail"
  CHECK_RESULT $? 0 0 "check su -c user name root fail"
  CHECK_RESULT $? 0 0 "check ls /root fail"
  CHECK_RESULT $? 0 0 "check su help fail"
```

- 涉及命令：userdel×1

#### oe_test_basic_cmd_sysctl

- 描述：SYSCTL modifies kernel parameters
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT "$(sysctl -a | grep -ioE 'dev|kernel|net' | sort -u | wc -l)" 3 0 "run sysctl -a | grep -ioE 'dev|kernel|net' fail"
  CHECK_RESULT $? 0 0 "run sysctl set ${test_param}=1 fail"
  CHECK_RESULT "$(sysctl -a | grep -w ${test_param} | awk '{print$3}')" 1 0 "check ${test_param} set to 1 fail"
  CHECK_RESULT $? 0 0 "run sysctl -w ${test_param}=0 fail"
  CHECK_RESULT "$(sysctl -a | grep -w ${test_param} | awk '{print$3}')" 0 0 "check ${test_param} set to 0 fail"
```

- 涉及命令：sysctl×1

#### oe_test_basic_cmd_tar

- 描述：File system common command test-tar
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check tar file fail"
  CHECK_RESULT $? 0 0 "check unpack tar fail"
  CHECK_RESULT $? 0 0 "Compress file failed."
  CHECK_RESULT $? 0 0 "Check files  failed."
  CHECK_RESULT $? 0 0 "Compress file failed."
  CHECK_RESULT $? 0 0 "Check files failed."
  CHECK_RESULT $? 0 0 "check tar help fail"
```

- 涉及命令：tar×6, test×1

#### oe_test_basic_cmd_top

- 描述：View process status-top
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check top title fail"
  CHECK_RESULT $? 0 0 "check top help fail"
```

- 涉及命令：top×2

#### oe_test_basic_cmd_touch

- 描述：File system common command test-touch
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check touch test1 fail"
  CHECK_RESULT $? 0 1 "check touch -c test2 fail"
  CHECK_RESULT $? 0 0 "check touch -c fail"
  CHECK_RESULT $? 0 0 "check touch help fail"
```

- 涉及命令：touch×2

#### oe_test_basic_cmd_umask

- 描述：Umask default configuration check
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "set umask 0037 fail"
  CHECK_RESULT $? 0 0 "check umask 0037 fail"
  CHECK_RESULT $? 0 0 "set umask ${umaskValue} fail"
  CHECK_RESULT $? 0 0 "check umask ${umaskValue} fail"
```

#### oe_test_basic_cmd_uname

- 描述：File system common command test-uname
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "uname -s display error"
  CHECK_RESULT $? 0 0 "uname -r display error"
  CHECK_RESULT $? 0 0 "uname -m display error"
  CHECK_RESULT $? 0 0 "uname -a display error"
  CHECK_RESULT $? 0 0 "uname -n display error"
  CHECK_RESULT $? 0 0 "check uname -r display error"
  CHECK_RESULT $? 0 0 "uname --help display error"
```

- 涉及命令：uname×6

#### oe_test_basic_cmd_wc

- 描述：File system common command test-wc
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "run wc /proc/cpuinfo fail"
  CHECK_RESULT $? 0 0 "run wc -l fail"
  CHECK_RESULT $? 0 0 "run wc -w fail"
  CHECK_RESULT $? 0 0 "run wc -c fail"
  CHECK_RESULT $? 0 0 "run wc -m fail"
  CHECK_RESULT $? 0 0 "check wc info fail"
```

#### oe_test_basic_cmd_which

- 描述：File system common command test-which
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "which function failed"
```

#### oe_test_continuous_100M

- 描述：100M file continuous cp,dd,tar
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "make urandom ${testfile1} file count ${i} fail"
  CHECK_RESULT $? 0 0 "check urandom file size fail"
  CHECK_RESULT $? 0 0 "make zero ${testfile1} file count ${i} fail"
  CHECK_RESULT $? 0 0 "check zero file size fail"
  CHECK_RESULT $? 0 0 "copy ${testfile1} fail"
  CHECK_RESULT $? 0 0 "check copy file size fail"
  CHECK_RESULT $? 0 0 "continuous tar file times ${i} fail"
  CHECK_RESULT $? 0 0 "check tar file times ${i} fail"
  CHECK_RESULT $? 0 0 "continuous tar.gz file times ${i} fail"
  CHECK_RESULT $? 0 0 "check tar.gz file times ${i} fail"
  CHECK_RESULT $? 0 0 "uncontinuous tar file times ${i} fail"
  CHECK_RESULT $? 0 0 "check tar file uncontinuous times ${i} fail"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：tar×4

#### oe_test_os_release

- 描述：Query system version info test
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "check os-release NAME ${OS_RELEASE_NAME} fail"
  CHECK_RESULT $? 0 0 "check os-release ID fail"
```

- 涉及命令：grep×1

#### oe_test_system_log_logrotate

- 描述：test syslog dump-logrotate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check /var/log/messages fail"
  CHECK_RESULT $? 0 0 "check logrotate fail"
  CHECK_RESULT $? 0 0 "check messages-*.gz fail"
```

- 涉及命令：logrotate×1

#### oe_test_system_monitor_process

- 描述：The system supports monitoring and testing each process
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check ps -eo 'rsz,pid,comm,args,pcpu' fail"
  CHECK_RESULT $? 0 0 "check ps -eo 'pcpu,pid,comm,args' fail"
  CHECK_RESULT $? 0 0 "check ps -eo 'pmem,pid,comm,args' fail"
  CHECK_RESULT $? 0 0 "check ps -eo 'stat,pid,comm,args,pcpu' fail"
  CHECK_RESULT $? 0 0 "run ipcs -m fail"
  CHECK_RESULT $? 0 0 "run cat /proc/sysvipc/shm fail"
```

- 涉及命令：ipcs×1

#### oe_test_system_service_sshd

- 描述：Restart and stop the OpenSSH service repeatedly
- 函数：`run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "stop sshd fail"
  CHECK_RESULT $? 0 0 "start sshd fail"
  CHECK_RESULT $? 0 0 "restart sshd fail"
  CHECK_RESULT $? 0 0 "stop sshd fail"
  CHECK_RESULT $? 0 0 "start sshd fail"
  CHECK_RESULT $? 0 0 "restart sshd fail"
  CHECK_RESULT $? 0 0 "restart sshd fail"
  CHECK_RESULT $? 0 0 "restart sshd fail"
```

#### oe_test_system_user_options_001

- 描述：Add User test
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "set user passwd fail"
  CHECK_RESULT $? 0 0  "check testuser passwd fail"
  CHECK_RESULT $? 0 0 "run useradd -e fail"
  CHECK_RESULT $? 0 0 "check testuser1 info fail"
  CHECK_RESULT $? 0 0 "check chage -M fail"
  CHECK_RESULT $? 0 0 "check testuser1 info after chage -M fail"
  CHECK_RESULT $? 0 0 "check useradd help fail"
  CHECK_RESULT $? 0 0 "run chpassed fail"
  CHECK_RESULT $? 0 0 "check useradd testuser2 fail"
  CHECK_RESULT $? 0 0 "change testuser3 group fail"
  CHECK_RESULT $? 0 0 "check grep testuser3 /etc/passwd fail"
  CHECK_RESULT $? 0 0 "check /home/testuser3 fail"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：userdel×4, chage×3, test×3, useradd×2

#### oe_test_system_user_options_002

- 描述：Modify User test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check testuser mod fail"
  CHECK_RESULT $? 0 0 "run usermod -g fail"
  CHECK_RESULT $? 0 0 "check testuser mod fail"
  CHECK_RESULT $? 0 0 "check myproj info fail"
  CHECK_RESULT $? 0 0 "run usermod -aG fail"
  CHECK_RESULT $? 0 0 "run testuser1 -c fail"
  CHECK_RESULT $? 0 0 "check usermod help fail"
```

- 涉及命令：grep×3, usermod×3, userdel×2, test×1, useradd×1, groupmod×1, groupadd×1

#### oe_test_system_user_options_003

- 描述：Modify user home directory
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "check testuser passed fail"
  CHECK_RESULT $? 0 0 "run usermod -d fail"
  CHECK_RESULT $? 0 0 "check mod grep new_test fail"
  CHECK_RESULT $? 1 0 "check testfile.txt not find fail"
  CHECK_RESULT $? 0 0 "run usermod -d testuser fail"
  CHECK_RESULT $? 0 0 "check mod grep testuser fail"
  CHECK_RESULT $? 0 0 "run rm fail"
  CHECK_RESULT $? 0 0 "run usermod -d -m testuser fail"
  CHECK_RESULT $? 0 0 "check grep /home/new_test fail"
  CHECK_RESULT $? 0 0 "check testfile.txt fail"
```

- 涉及命令：usermod×3, userdel×2, test×2

#### oe_test_var_log

- 描述：Log View
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "check /vat/log dir fail"
  CHECK_RESULT $? 0 0 "check log message file line fail"
  CHECK_RESULT $? 0 0 "check log message file fail"
```

- 涉及命令：tail×1, kill×1

#### oe_test_basic_cmd_shopt

- 描述：Command test-shopt
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "run shopt failed"
  CHECK_RESULT $? 0 0 "run shopt --help failed"
  CHECK_RESULT $? 0 0 "run shopt -s cdspell failed"
  CHECK_RESULT $? 0 0 "run shopt -s cdspell failed"
```

- 涉及命令：shopt×3

#### oe_test_basic_cmd_shopt_002

- 描述：bash shopt shell behavior options (globstar, extglob, nullglob)
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "shopt globstar execution failed"
  CHECK_RESULT $? 0 0 "globstar should find root-level file f1.txt"
  CHECK_RESULT $? 0 0 "globstar should find deeply nested file f4.txt"
  CHECK_RESULT $? 0 0 "extglob should match pattern f[0-9].txt"
  CHECK_RESULT $? 0 0 "nullglob should expand unmatched glob to empty"
  CHECK_RESULT $? 0 1 "failglob should return non-zero on unmatched glob"
  CHECK_RESULT $? 0 0 "shopt -q extglob should report set after enable"
  CHECK_RESULT $? 0 0 "dotglob should include hidden files"
```

- 涉及命令：bash×4, grep×4, mkdir×1, test×1
