# sssd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sssd` |
| 注册用例数 | 17 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_sssd-autofs | Test sssd-autofs.service restart | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_sssd-ifp | Test sssd-ifp.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_sssd-kcm | Test sssd-kcm.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_sssd-nss | Test sssd-nss.service restart | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_sssd-pac | Test sssd-pac.service restart | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_sssd-pam | Test sssd-pam.service restart | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_sssd | Test sssd.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_service_sssd-ssh | Test sssd-ssh.service restart | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_sssd-sudo | Test sssd-sudo.service restart | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_socket_sssd-autofs | Test sssd-autofs.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_sssd-kcm | Test sssd-kcm.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_sssd-nss | Test sssd-nss.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_sssd-pac | Test sssd-pac.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_sssd-pam-priv | Test sssd-pam-priv.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_sssd-pam | Test sssd-pam.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_sssd-ssh | Test sssd-ssh.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_sssd-sudo | Test sssd-sudo.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_sssd-autofs

- 描述：Test sssd-autofs.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} is not indirect"
```

#### oe_test_service_sssd-ifp

- 描述：Test sssd-ifp.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_sssd-kcm

- 描述：Test sssd-kcm.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_sssd-nss

- 描述：Test sssd-nss.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} is not indirect"
```

#### oe_test_service_sssd-pac

- 描述：Test sssd-pac.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} is not indirect"
```

#### oe_test_service_sssd-pam

- 描述：Test sssd-pam.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} is not indirect"
```

#### oe_test_service_sssd

- 描述：Test sssd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_sssd-ssh

- 描述：Test sssd-ssh.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} is not indirect"
```

#### oe_test_service_sssd-sudo

- 描述：Test sssd-sudo.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "Check ${service} failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} is not indirect"
```

#### oe_test_socket_sssd-autofs

- 描述：Test sssd-autofs.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_sssd-kcm

- 描述：Test sssd-kcm.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_sssd-nss

- 描述：Test sssd-nss.socket restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_socket_sssd-pac

- 描述：Test sssd-pac.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_sssd-pam-priv

- 描述：Test sssd-pam-priv.socket restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_socket_sssd-pam

- 描述：Test sssd-pam.socket restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_socket_sssd-ssh

- 描述：Test sssd-ssh.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_sssd-sudo

- 描述：Test sssd-sudo.socket restart
- 函数：`pre_test, run_test, post_test`