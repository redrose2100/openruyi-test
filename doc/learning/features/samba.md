# samba

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/samba` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_ctdb | Test ctdb.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nmb | Test nmb.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_samba | Test samba.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_smb | Test smb.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_winbind | Test winbind.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_ctdb

- 描述：Test ctdb.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nmb

- 描述：Test nmb.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "nmb.service reload failed"
  CHECK_RESULT $? 0 0 "nmb.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_samba

- 描述：Test samba.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "samba.service restart failed"
  CHECK_RESULT $? 0 0 "samba.service restart failed"
  CHECK_RESULT $? 0 0 "samba.service stop failed"
  CHECK_RESULT $? 0 0 "samba.service stop failed"
  CHECK_RESULT $? 0 0 "samba.service start failed"
  CHECK_RESULT $? 0 0 "samba.service start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of samba.service"
  CHECK_RESULT $? 0 0 "samba.service reload failed"
  CHECK_RESULT $? 0 0 "samba.service reload causes the service status to change"
```

- 涉及命令：sed×6

#### oe_test_service_smb

- 描述：Test smb.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "smb.service reload failed"
  CHECK_RESULT $? 0 0 "smb.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_winbind

- 描述：Test winbind.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "winbind.service reload failed"
  CHECK_RESULT $? 0 0 "winbind.service reload causes the service status to change"
```

- 涉及命令：sed×2
