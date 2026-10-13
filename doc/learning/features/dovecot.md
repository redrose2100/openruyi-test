# dovecot

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dovecot` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_dovecot-init | Test dovecot-init.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_dovecot | Test dovecot.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_socket_dovecot | Test dovecot.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dovecot_basic | Take the test dovecot execution | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_dovecot_doveadm_1 | Take the test dovecot execution | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_dovecot_doveadm_2 | Take the test doveadm execution | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_dovecot_doveadm_3 | Take the test doveadm execution | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_dovecot-init

- 描述：Test dovecot-init.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_dovecot

- 描述：Test dovecot.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "dovecot.service reload failed"
  CHECK_RESULT $? 0 0 "dovecot.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_socket_dovecot

- 描述：Test dovecot.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_dovecot_basic

- 描述：Take the test dovecot execution
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check dovecot version failed."
  CHECK_RESULT $? 0 0 "Check dovecot help failed."
  CHECK_RESULT $? 0 0 "Check dovecot non default config failed."
  CHECK_RESULT $? 0 0 "Check doveconf non default config failed."
  CHECK_RESULT $? 0 0 "Check dovecot all config failed."
  CHECK_RESULT $? 0 0 "Check doveconf failed."
  CHECK_RESULT $? 0 0 "Check dovecot hostdomain failed."
  CHECK_RESULT $? 0 0 "Check dovecot user created failed."
  CHECK_RESULT $? 0 0 "Set dovecot build options failed."
  CHECK_RESULT $? 0 0 "Reload dovecot failed."
  CHECK_RESULT $? 0 0 "Stop dovecot failed."
  CHECK_RESULT $? 0 0 "Set dovecot config file failed."
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：dovecot×3, grep×2, doveconf×1, kill×1

#### oe_test_dovecot_doveadm_1

- 描述：Take the test dovecot execution
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check doveadm who detail failed."
  CHECK_RESULT $? 0 0 "Check doveadm who verbose failed."
  CHECK_RESULT $? 0 0 "Check doveadm who -1 failed."
  CHECK_RESULT $? 0 0 "Check doveadm who ${NODE1_IPV4} failed."
  CHECK_RESULT $? 0 0 "Check doveadm who 0022 failed."
  CHECK_RESULT $? 0 0 "Check doveadm pw failed."
  CHECK_RESULT $? 0 0 "Check doveadm pw -p failed."
  CHECK_RESULT $? 0 0 "Check doveadm pw -r failed."
  CHECK_RESULT $? 0 0 "Check doveadm pw -u failed."
  CHECK_RESULT $? 0 0 "Check doveadm pw -V failed."
  CHECK_RESULT $? 0 0 "Check doveadm pw -s failed."
  CHECK_RESULT $? 0 0 "Check doveadm log errors failed."
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：doveadm×2, sed×1, kill×1

#### oe_test_dovecot_doveadm_2

- 描述：Take the test doveadm execution
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check doveadm config failed."
  CHECK_RESULT $? 0 0 "Check doveadm instance list failed."
  CHECK_RESULT $? 0 0 "Check doveadm instance remove failed."
  CHECK_RESULT $? 0 0 "Check doveadm penalty failed."
  CHECK_RESULT $? 0 0 "Check doveadm proxy list failed."
  CHECK_RESULT $? 0 0 "Check doveadm proxy kick ${NODE1_IPV4} failed."
  CHECK_RESULT $? 0 0 "Check doveadm auth cache flush failed."
  CHECK_RESULT $? 0 0 "Check doveadm auth login failed."
  CHECK_RESULT $? 0 0 "Check doveadm auth test failed."
  CHECK_RESULT $? 0 0 "Check doveadm-sysreport failed."
  CHECK_RESULT $? 0 0 "The report doesn't exist."
  CHECK_RESULT $? 0 0 "Check doveadm reload failed."
  ... 共 13 条（其余见源脚本）
```

#### oe_test_dovecot_doveadm_3

- 描述：Take the test doveadm execution
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check doveadm process status failed."
  CHECK_RESULT $? 0 0 "Check doveadm user failed."
  CHECK_RESULT $? 0 0 "Check doveadm stats dump failed."
  CHECK_RESULT $? 0 0 "Check doveadm zlibconnect failed."
  CHECK_RESULT $? 0 0 "Check doveadm service status failed."
  CHECK_RESULT $? 0 0 "Check doveadm service stop doveadm failed."
  CHECK_RESULT $? 0 0 "Check doveadm oldstats reset failed."
  CHECK_RESULT $? 0 0 "Check doveadm penalty failed."
  CHECK_RESULT $? 0 0 "Check doveadm sievec -c failed."
  CHECK_RESULT $? 0 0 "Check doveadm sievec -d -D failed."
```

- 涉及命令：sievec×2, userdel×1
