# libcap

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/libcap` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libcap | Check libcap | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_acl_ignore_dal_across | Ignore all DAC access restrictions on files | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_verwrite_previous_rules | Overwrite previous rules | run_test/post_test | 4 |  |  |  |
| oe_test_acl_allow_change_ownership | allow to change the ownership of the file | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_allow_change_nochange | allows to modify the unmodifiable (IMMUTABLE) and only add (APPEND-ONLY) attributes of the file | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_send_kill_notbelong | Allow kill signals to be sent to processes that do not belong to you | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_acl_ordinary_users_setgid | The setting program allows ordinary users to use the setgid function | config_params/pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_acl_bind_port | Allow binding to ports less than 1024 | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_acl_manage_net | Allow network management tasks | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libcap

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

- 涉及命令：setcap×1

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

#### oe_test_acl_allow_change_nochange

- 描述：allows to modify the unmodifiable (IMMUTABLE) and only add (APPEND-ONLY) attributes of the file
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "Authorization succeeded, but it should fail here"
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Privilege grant failed"
  CHECK_RESULT $? 0 0 "Failed to view ----i---------e----- field in file properties"
```

- 涉及命令：setcap×1, userdel×1

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

- 涉及命令：setcap×1, userdel×1

#### oe_test_acl_ordinary_users_setgid

- 描述：The setting program allows ordinary users to use the setgid function
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1 "Failed to chattr"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setcap×1, userdel×1

#### oe_test_acl_bind_port

- 描述：Allow binding to ports less than 1024
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "Getting process PID succeeded, but it should fail here"
  CHECK_RESULT $? 0 0 "Failed to set cap"
  CHECK_RESULT $? 0 0 "Failed to get process PID"
```

- 涉及命令：pgrep×2, kill×1, setcap×1, userdel×1

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
