# FS_Directory

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_Directory` |
| 注册用例数 | 33 |
| 环境约束 | machine num = 2；add disk = 20 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_FSIO_dir_access | Take the test access of directory on rootfs | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_FSIO_dir_access_bin | Take the test access of /bin | run_test | 2 |  |  |  |
| oe_test_FSIO_dir_access_boot | Take the test access of /boot | run_test | 3 |  |  |  |
| oe_test_FSIO_dir_access_dev | Take the test access of /dev | config_params/run_test | 4 |  |  |  |
| oe_test_FSIO_dir_access_etc | Take the test access of /etc | run_test | 6 |  |  |  |
| oe_test_FSIO_dir_access_lib64 | Take the test access of /lib64 | run_test | 2 |  |  |  |
| oe_test_FSIO_dir_access_lostfound | Take the test access of /lost+found | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dir_access_media | Take the test access of /media | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dir_access_mnt | Take the test access of /mnt | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dir_access_opt | Take the test access of /opt | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dir_access_proc | Take the test access of /proc | run_test | 2 |  |  |  |
| oe_test_FSIO_dir_access_root | Take the test access of /root | run_test | 1 |  |  |  |
| oe_test_FSIO_dir_access_run | Take the test access of /run | run_test | 3 |  |  |  |
| oe_test_FSIO_dir_access_sbin | Take the test access of /sbin | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_dir_access_srv | Take the test access of /srv | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dir_access_sys | Take the test access of /sys | run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_dir_access_tmp | Take the test access of /tmp | run_test | 1 |  |  |  |
| oe_test_FSIO_dir_access_usr | Take the test access of /usr | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_dir_access_var | Take the test access of /var | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_dir_bash_umask | Take the test edit umask on /etc/bash | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_dir_check_basic_info | Take the test directory infos | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_FSIO_dir_chmod | Take the test chmod | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_FSIO_dir_chown | Take the test chown | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_dir_create | Take the test mkdir | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_FSIO_dir_create_infs | Take the test mkdir on different file system | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_dir_create_lack_inode | Take the test mkdir without inode | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_dir_create_long_dirname | Take the test mkdir too long name | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dir_modify_name | Take the test modify name | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_dir_mv_cp_1 | Take the test cp/mv directory on same fs | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_FSIO_dir_mv_cp_2 | Take the test cp/mv directory on different fs | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_FSIO_dir_rm | Take the test remove directory | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_FSIO_dir_umask | Take the test umask | run_test/post_test | 4 |  |  |  |
| oe_test_FSIO_dir_umask_exit | Take the test edit umask | run_test | 3 |  | ✔ |  |

### 断言与命令明细

#### oe_test_FSIO_dir_access

- 描述：Take the test access of directory on rootfs
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "The access of /${dir1[$i]} is false."
  CHECK_RESULT $? 0 0 "The access of /${dir2[$i]} is false."
  CHECK_RESULT $? 0 0 "The access of /boot is false."
  CHECK_RESULT $? 0 0 "The access of /proc is false."
  CHECK_RESULT $? 0 0 "The access of /sys is false."
  CHECK_RESULT $? 0 0 "The access of /root is false."
  CHECK_RESULT $? 0 0 "root doesn't have access of /boot directory."
  CHECK_RESULT $? 0 0 "root doesn't have access of /root directory."
  CHECK_RESULT $? 0 0 "admin doesn't have access of /boot directory."
  CHECK_RESULT $? 0 0 "admin doesn't have access of /root directory."
  CHECK_RESULT $? 0 0 "normal user doesn't have access of /boot directory."
  CHECK_RESULT $? 1 0 "normal user has unexpect access of /root directory."
```

- 涉及命令：userdel×2

#### oe_test_FSIO_dir_access_bin

- 描述：Take the test access of /bin
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "/bin is not soft link of /usr/bin "
  CHECK_RESULT $? 0 0 "The /bin doesn't same with /usr/bin."
```

#### oe_test_FSIO_dir_access_boot

- 描述：Take the test access of /boot
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The config on /boot has some errors."
  CHECK_RESULT $? 0 0 "The lost+found on /boot has some errors."
  CHECK_RESULT $? 0 0 "The initramfs on /boot has some errors."
```

#### oe_test_FSIO_dir_access_dev

- 描述：Take the test access of /dev
- 函数：`config_params, run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The file autofs on /dev has some errors."
  CHECK_RESULT $? 0 0 "The file block on /dev has some errors."
  CHECK_RESULT $? 0 0 "The file console on /dev has some errors."
  CHECK_RESULT $? 0 0 "The disk file $disk on /dev has some errors."
```

#### oe_test_FSIO_dir_access_etc

- 描述：Take the test access of /etc
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The kernel on /etc has some errors."
  CHECK_RESULT $? 0 0 "The openEuler-latest on /etc has some errors."
  CHECK_RESULT $? 0 0 "The openEuler_security on /etc has some errors."
  CHECK_RESULT $? 0 0 "The sudoers on /etc has some errors."
  CHECK_RESULT $? 0 0 "The systemd on /etc has some errors."
  CHECK_RESULT $? 0 0 "The access of /${dir1[$i]} is false."
```

#### oe_test_FSIO_dir_access_lib64

- 描述：Take the test access of /lib64
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "/lib64 is not soft link of /usr/lib64 "
  CHECK_RESULT $? 0 0 "The /lib64 doesn't same with /lib64/lib64."
```

#### oe_test_FSIO_dir_access_lostfound

- 描述：Take the test access of /lost+found
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "check /lost+found directory failed."
```

- 涉及命令：test×1

#### oe_test_FSIO_dir_access_media

- 描述：Take the test access of /media
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "check /media directory failed."
```

#### oe_test_FSIO_dir_access_mnt

- 描述：Take the test access of /mnt
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "check /mnt directory failed."
```

#### oe_test_FSIO_dir_access_opt

- 描述：Take the test access of /opt
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_FSIO_dir_access_proc

- 描述：Take the test access of /proc
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The file under /proc is error."
  CHECK_RESULT $? 0 0 "Check cpu info failed."
```

- 涉及命令：grep×2

#### oe_test_FSIO_dir_access_root

- 描述：Take the test access of /root
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "check /root directory failed."
```

#### oe_test_FSIO_dir_access_run

- 描述：Take the test access of /run
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The initctl on /run has some errors."
  CHECK_RESULT $? 0 0 "The utmp on /run has some errors."
  CHECK_RESULT $? 0 0 "The access of /${dir[$i]} is false."
```

#### oe_test_FSIO_dir_access_sbin

- 描述：Take the test access of /sbin
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "/sbin is not soft link of /usr/sbin "
  CHECK_RESULT $? 0 0 "The /sbin doesn't same with /usr/sbin."
  CHECK_RESULT 1 0 0 "Unexpected permission: $perm"
```

#### oe_test_FSIO_dir_access_srv

- 描述：Take the test access of /srv
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "check /srv directory failed."
```

#### oe_test_FSIO_dir_access_sys

- 描述：Take the test access of /sys
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The directory or file on /sys has some errors."
  CHECK_RESULT $? 0 0 "The access of directory or file on /sys has some errors."
```

#### oe_test_FSIO_dir_access_tmp

- 描述：Take the test access of /tmp
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The systemd-private on /tmp has some errors."
```

#### oe_test_FSIO_dir_access_usr

- 描述：Take the test access of /usr
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The directory or file on /usr has some errors."
  CHECK_RESULT $? 0 0 "The access of directory or file on /usr has some errors."
```

#### oe_test_FSIO_dir_access_var

- 描述：Take the test access of /var
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 1 0 0 "The file under /var is error."
  CHECK_RESULT 1 0 0 "The access of file under /var is error."
```

#### oe_test_FSIO_dir_bash_umask

- 描述：Take the test edit umask on /etc/bash
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The default umask code is not 022."
  CHECK_RESULT $? 0 0 "The default umask code of user is not 0022."
  CHECK_RESULT $? 0 0 "The umask code of user doesn't change."
```

- 涉及命令：grep×1, userdel×1

#### oe_test_FSIO_dir_check_basic_info

- 描述：Take the test directory infos
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The stat info on $point has some errors."
  CHECK_RESULT $? 0 0 "The help of stat has some errors."
```

#### oe_test_FSIO_dir_chmod

- 描述：Take the test chmod
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check access of $var/tmp failed when creating defualt."
  CHECK_RESULT $? 0 0 "Check access of $var/tmp failed."
  CHECK_RESULT $? 0 0 "Check access of $var/tmp/test01 failed."
  CHECK_RESULT $? 0 0 "Check access of $var/tmp/test01/test02 failed."
  CHECK_RESULT $? 0 0 "Check access of $var/tmp/test01/test02/test03 failed."
  CHECK_RESULT $? 0 0 "Check access of $var/tmp/test01/test02/test03 failed."
  CHECK_RESULT $? 0 1 "Successfully accessed $var/tmp/test01/test02/test03 using $user"
  CHECK_RESULT $? 0 0 "Check access of $var/tmp failed."
  CHECK_RESULT $? 0 0 "Check access of $var/tmp/test01 failed."
  CHECK_RESULT $? 0 0 "Check help failed."
```

- 涉及命令：mkdir×1, chmod×1, userdel×1

#### oe_test_FSIO_dir_chown

- 描述：Take the test chown
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check dir user failed."
  CHECK_RESULT $? 0 0 "Check dir group failed."
  CHECK_RESULT $? 0 0 "chown failed."
  CHECK_RESULT $? 0 0 "Check user after chown failed."
  CHECK_RESULT $? 0 0 "Check group agter chown failed."
  CHECK_RESULT $? 0 0 "Check help failed."
```

- 涉及命令：mkdir×1, chown×1, userdel×1

#### oe_test_FSIO_dir_create

- 描述：Take the test mkdir
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "User A mkdir failed."
  CHECK_RESULT $? 0 0 "User B ls dir failed."
  CHECK_RESULT $? 0 0 "User B mkdir failed."
  CHECK_RESULT $? 1 0 "User C ls dir succeed."
  CHECK_RESULT $? 1 0 "User C mkdir succeed."
```

- 涉及命令：userdel×3

#### oe_test_FSIO_dir_create_infs

- 描述：Take the test mkdir on different file system
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "mkdir on $var failed."
  CHECK_RESULT $? 0 0 "mkdir -p on $var failed."
  CHECK_RESULT $? 0 0 "mkdir -m on $var failed."
```

- 涉及命令：mkdir×2

#### oe_test_FSIO_dir_create_lack_inode

- 描述：Take the test mkdir without inode
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The error msg of $point is false."
```

- 涉及命令：read×1

#### oe_test_FSIO_dir_create_long_dirname

- 描述：Take the test mkdir too long name
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "File can be created when length of file name is more than 255."
```

#### oe_test_FSIO_dir_modify_name

- 描述：Take the test modify name
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "mv file in ext3 failed."
  CHECK_RESULT $? 0 0 "Check file in ext3 failed."
  CHECK_RESULT $? 0 0 "mv file in ext4 failed."
  CHECK_RESULT $? 0 0 "Check file in ext4 failed."
  CHECK_RESULT $? 0 0 "mv file in xfs failed."
  CHECK_RESULT $? 0 0 "Check file in xfs failed."
```

- 涉及命令：test×3, mapfile×1

#### oe_test_FSIO_dir_mv_cp_1

- 描述：Take the test cp/mv directory on same fs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The directory on ext3 was copied failed."
  CHECK_RESULT $? 0 0 "The directory on ext3 was moved failed."
  CHECK_RESULT $? 0 0 "The directory on ext4 was copied failed."
  CHECK_RESULT $? 0 0 "The directory on ext4 was moved failed."
  CHECK_RESULT $? 0 0 "The directory on xfs was copied failed."
  CHECK_RESULT $? 0 0 "The directory on xfs was moved failed."
```

- 涉及命令：test×6

#### oe_test_FSIO_dir_mv_cp_2

- 描述：Take the test cp/mv directory on different fs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The directory copied from ext3 to ext4 failed."
  CHECK_RESULT $? 0 0 "The directory moved from ext3 to ext4 failed."
  CHECK_RESULT $? 0 0 "The directory copied from ext4 to xfs failed."
  CHECK_RESULT $? 0 0 "The directory moved from ext4 to xfs failed."
```

- 涉及命令：grep×4, read×1

#### oe_test_FSIO_dir_rm

- 描述：Take the test remove directory
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 1 0 "The empty directory was not removed."
  CHECK_RESULT $? 1 0 "The directory which has file was not removed."
  CHECK_RESULT $? 1 0 "The /sys was removed."
  CHECK_RESULT $? 1 0 "The /proc was removed."
  CHECK_RESULT $? 1 0 "The /proc was removed."
```

- 涉及命令：test×2, chattr×1

#### oe_test_FSIO_dir_umask

- 描述：Take the test umask
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The default umask is error."
  CHECK_RESULT $? 0 0 "Change umask failed."
  CHECK_RESULT $? 0 0 "The change umask of is error."
  CHECK_RESULT $? 0 0 "Check help failed."
```

#### oe_test_FSIO_dir_umask_exit

- 描述：Take the test edit umask
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check default umask failed."
  CHECK_RESULT $? 0 0 "Change default umask failed."
  CHECK_RESULT $? 0 0 "Check default umask failed."
```
