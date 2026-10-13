# acl

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/acl` |
| 注册用例数 | 19 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_acl_add_write_permissions | Set ACL rules to add write permissions to a user | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_acl_change_mask | Modify the mask rules to remove user read permissions | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_check_create | View ACL rules for newly created files | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_acl_defaulr_rule | Directory defaulr ACL rules | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_acl_only_root_permission | Only the owner and root administrator of the file have management ACL permissions | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_acl_chacl | Test "chacl" command | config_params/pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_acl_getfacl | Test "getfacl" command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_acl_setfacl | Test "setfacl" command | config_params/pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_access_providepam | test accesscontrol-providepam | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_acl_file | ACL permission for file | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_acl_default_kernel_setting | ACL default kernel setting | run_test | 3 |  |  |  |
| oe_test_acl_backup_recovery | acl backup and recovery | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_acl_delete_acl | Delete ACL function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_acl_dir_write | ACL dir write permission | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_acl_dir_read | ACL dir read permission | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_acl_file_authorize | ACL file authorization | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_acl_default_inherit_fun01 | default acl inherit | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_acl_default_inherit_fun02 | default acl inherit fun02 | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_libacl | libacl formatting test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

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

#### oe_test_access_providepam

- 描述：test accesscontrol-providepam
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "pam not exist"
  CHECK_RESULT $? 0 0 "pam_systemd.so not exist"
```

- 涉及命令：rpm×1, test×1

#### oe_test_acl_file

- 描述：ACL permission for file
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test1 creat testfile fail"
  CHECK_RESULT $? 0 0 "test1 set testfile permission fail"
  CHECK_RESULT $? 0 1 "test2 should be not execute testfile"
  CHECK_RESULT $? 0 1 "test2 should be not read testfile"
  CHECK_RESULT $? 0 0 "set permission which permit test2 to rx fail"
  CHECK_RESULT $? 0 0 "test2 should be execute testfile"
  CHECK_RESULT $? 0 0 "test2 should be read testfile"
  CHECK_RESULT $? 0 1 "test2 should be not write testfile"
  CHECK_RESULT $? 0 0 "set permission which permit test2 to rwx fail"
  CHECK_RESULT $? 0 0 "test2 should be write testfile"
```

- 涉及命令：userdel×2

#### oe_test_acl_default_kernel_setting

- 描述：ACL default kernel setting
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ACL kernel parameter of xfs file system is not enabled"
  CHECK_RESULT $? 0 0 "ACL kernel parameter of ext4 file system is not enabled"
  CHECK_RESULT $? 0 1 "ACL kernel default parm setting is incorrect"
```

- 涉及命令：grep×3

#### oe_test_acl_backup_recovery

- 描述：acl backup and recovery
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "backup testdir acl fail"
  CHECK_RESULT $? 0 0 "delete testdir acl fail"
  CHECK_RESULT $? 0 0 "recovery testdir acl  fail"
  CHECK_RESULT $? 0 0 "get testdir acl fail"
  CHECK_RESULT $? 0 0 "not fully recovery testdir acl"
  CHECK_RESULT $? 0 0 "backup testfile acl fail"
  CHECK_RESULT $? 0 0 "delete testfile acl fail"
  CHECK_RESULT $? 0 0 "recovery testfile acl  fail"
  CHECK_RESULT $? 0 0 "get testfile acl fail"
  CHECK_RESULT $? 0 0 "not fully recovery testfile acl"
```

- 涉及命令：setfacl×2, userdel×2, chacl×1

#### oe_test_acl_delete_acl

- 描述：Delete ACL function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 1 "ACL_MASK deleted successfully"
  CHECK_RESULT $? 0 0 "ACL_ USER deletion failed"
  CHECK_RESULT $? 0 0 "ACL_GROUP deletion failed"
  CHECK_RESULT $? 0 1 "ACL_MASK deleted failed"
  CHECK_RESULT $? 0 1 "ACL_ALL deleted failed"
  CHECK_RESULT $? 0 1 "ACL_ALL Recursive deletion failed"
```

- 涉及命令：setfacl×6, chacl×1, userdel×1

#### oe_test_acl_dir_write

- 描述：ACL dir write permission
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 1 "uos1 should not have permission to enter"
  CHECK_RESULT $? 0 1 "uos1 should not have permission to creat"
  CHECK_RESULT $? 0 0 "test115217 pemission set fail"
  CHECK_RESULT $? 0 0 "ace enter test115217 fail"
  CHECK_RESULT $? 0 0 "ace creat file fail"
  CHECK_RESULT $? 0 0 "test115217 pemission set fail"
  CHECK_RESULT $? 0 1 "uos1 should not have permission to enter test115217"
  CHECK_RESULT $? 0 1 "uos1 should not have permission to creat file"
```

- 涉及命令：userdel×2

#### oe_test_acl_dir_read

- 描述：ACL dir read permission
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 1 "uos1 should not enter"
  CHECK_RESULT $? 0 1 "uos1 should not creat"
  CHECK_RESULT $? 0 0 "ace enter fail"
  CHECK_RESULT $? 0 0 "ace read dir fail"
  CHECK_RESULT $? 0 0 "ace read file fail"
  CHECK_RESULT $? 0 1 "ace should not enter"
  CHECK_RESULT $? 0 1 "ace should not read dir"
  CHECK_RESULT $? 0 1 "ace should not read file"
```

- 涉及命令：userdel×2

#### oe_test_acl_file_authorize

- 描述：ACL file authorization
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "set testfile1 acl fail"
  CHECK_RESULT $? 0 0 "get testfile1 acl for test1 fail"
  CHECK_RESULT $? 0 0 "get testfile1 acl for test2 fail"
  CHECK_RESULT $? 0 0 "get testfile1 acl for test3 fail"
  CHECK_RESULT $? 0 0 "set testfile2 acl fail"
  CHECK_RESULT $? 0 0 "testfile1 acl error"
  CHECK_RESULT $? 0 0 "testfile2 acl error"
```

- 涉及命令：userdel×4, stat×2

#### oe_test_acl_default_inherit_fun01

- 描述：default acl inherit
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "mkdir subtestdir fail"
  CHECK_RESULT $? 0 0 "touch subtestfile fail"
  CHECK_RESULT $? 0 0 "set testdir acl fail"
  CHECK_RESULT $? 0 0 "subtestdir acl error"
  CHECK_RESULT $? 0 0 "subtestfile acl error"
```

- 涉及命令：setfacl×3, userdel×2

#### oe_test_acl_default_inherit_fun02

- 描述：default acl inherit fun02
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "set testdir default acl fail"
  CHECK_RESULT $? 0 0 "mkdir subtestdir1 fail"
  CHECK_RESULT $? 0 0 "touch subtestfile1 fail"
  CHECK_RESULT $? 0 0 "subtestdir1 acl error"
  CHECK_RESULT $? 0 0 "subtestfile1 acl error"
```

- 涉及命令：setfacl×3, userdel×2

#### oe_test_libacl

- 描述：libacl formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "libacl test fail"
  CHECK_RESULT $? 0 0 "execute libacl_test fail"
```

- 涉及命令：rpm×1, test×1
