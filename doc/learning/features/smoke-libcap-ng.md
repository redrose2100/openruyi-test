# smoke-libcap-ng

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-libcap-ng` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_libcap-ng_captest_command_001 | 验证captest参数 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_libcap-ng_captest_normal_user_001 | captest添加capabilities，普通用户执行captest。 | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_libcap-ng_filecap_command_001 | 验证filecap基本命令 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_libcap-ng_filecap_command_002 | 验证filecap参数 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_libcap-ng_filecap_simultane_001 | 单文件并发测试 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_libcap-ng_netcap_command_001 | 验证netcap参数 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_libcap-ng_package_remove_001 | libcap-ng卸载安装测试 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_libcap-ng_ping_remove_cap_001 | ping命令移除capabilities，普通用户执行ping | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_libcap-ng_pscap_command_001 | 验证pscap参数 | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_libcap-ng_captest_command_001

- 描述：验证captest参数
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check captest --drop-all failed"
  CHECK_RESULT $? 0 0 "Check Child capabilities failed"
  CHECK_RESULT $? 0 0 "Check Effective failed"
  CHECK_RESULT $? 0 0 "Check Permitted failed"
  CHECK_RESULT $? 0 0 "Check Inheritable failed"
  CHECK_RESULT $? 0 0 "Check Bounding Set failed"
  CHECK_RESULT $? 0 0 "Check Child Effective failed"
  CHECK_RESULT $? 0 0 "Check Child Permitted failed"
  CHECK_RESULT $? 0 0 "Check Child Inheritable failed"
  CHECK_RESULT $? 0 0 "Check Child Bounding Set failed"
```

- 涉及命令：grep×6

#### oe_libcap-ng_captest_normal_user_001

- 描述：captest添加capabilities，普通用户执行captest。
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check captest_default_cap failed"
  CHECK_RESULT $? 0 0 "Check Current capabilities failed"
  CHECK_RESULT $? 0 0 "Check Child capabilities failed"
  CHECK_RESULT $? 0 0 "Check filecap failed"
  CHECK_RESULT $? 0 0  "Check Effective failed"
  CHECK_RESULT $? 0 0  "Check Permitted failed"
  CHECK_RESULT $? 0 0  "Check Inheritable failed"
  CHECK_RESULT $? 0 0  "Check Bounding Set failed"
```

- 涉及命令：test×1, userdel×1

#### oe_libcap-ng_filecap_command_001

- 描述：验证filecap基本命令
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "mkdir and touch testdir failed"
  CHECK_RESULT $? 0 0 "Check filecap failed"
  CHECK_RESULT $? 0 0 "Check testfile1 capabilities failed"
  CHECK_RESULT $? 0 0  "Check testfile2 capabilities failed"
  CHECK_RESULT $? 0 0 "Check testdir capabilities failed"
  CHECK_RESULT $? 0 0 "Check remove testfile capabilities failed"
```

- 涉及命令：test×1

#### oe_libcap-ng_filecap_command_002

- 描述：验证filecap参数
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check filecap -d failed"
  CHECK_RESULT $? 0 0 "Check filecap -a failed"
  CHECK_RESULT $? 1 0 "Check filecap failed"
  CHECK_RESULT $? 0 0 "After add PATH,check filecap failed"
```

- 涉及命令：filecap×2, grep×1

#### oe_libcap-ng_filecap_simultane_001

- 描述：单文件并发测试
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check filecap failed"
  CHECK_RESULT $? 0 0 "Check sys\_time failed"
```

#### oe_libcap-ng_netcap_command_001

- 描述：验证netcap参数
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check netcap failed"
```

- 涉及命令：grep×1

#### oe_libcap-ng_package_remove_001

- 描述：libcap-ng卸载安装测试
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "Check rpm -e libcap-ng --nodeps failed"
  CHECK_RESULT $? 0 0 "yum install libcap-ng failed"
```

- 涉及命令：rpm×3, test×1

#### oe_libcap-ng_ping_remove_cap_001

- 描述：ping命令移除capabilities，普通用户执行ping
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check testuser failed"
  CHECK_RESULT $? 0 0 "Check Operation not permitted failed"
  CHECK_RESULT $? 0 0 "Check filecap failed"
  CHECK_RESULT $? 0 0 "Check 1 packets transmitted failed"
```

- 涉及命令：test×1, pgrep×1, userdel×1

#### oe_libcap-ng_pscap_command_001

- 描述：验证pscap参数
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check pscap -a failed"
```

- 涉及命令：pscap×1
