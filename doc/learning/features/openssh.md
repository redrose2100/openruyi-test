# openssh

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openssh` |
| 注册用例数 | 21 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_openssh_cipher | Cipher configuration in sshd_config | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_openssh_keychecking_no | No strict public key checking | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_openssh_keyscan | Common options of ssh-keyscan | run_test | 4 |  |  |  |
| oe_test_openssh_locked | Lock and unlock SSH agent | run_test/post_test | 9 |  | ✔ |  |
| oe_test_openssh_no_password | login wihout password(create authorized_keys) | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_openssh_port | Specifies the port of the remote service | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_openssh_scp_P | SCP specified port | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_openssh_scp_q | Silent mode of SCP | run_test/post_test | 6 |  | ✔ |  |
| oe_test_openssh_scp_r | Recursive replication of SCP | run_test/post_test | 4 |  | ✔ |  |
| oe_test_openssh_scp | Two modes of SCP | run_test/post_test | 4 |  | ✔ |  |
| oe_test_openssh_sftp | Upload and download based on SFTP | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_openssh_ssh_agent | SSH agent avoids entering private key password | run_test/post_test | 8 |  | ✔ |  |
| oe_test_openssh_ssh_command | Test the SSH login of normal user and root user | run_test/post_test | 4 |  |  |  |
| oe_test_openssh_ssh-copy-id | login wihout password(ssh-copy-id) | run_test/post_test | 4 |  | ✔ |  |
| oe_test_openssh_ssh_user | Test the SSH login of normal user and root user | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_service_sshd | Test sshd.service restart | run_test/post_test | 2 |  |  |  |
| oe_test_socket_sshd | Test sshd.socket restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_sshd-keygen | Test sshd-keygen.target restart | run_test | 0 |  |  |  |
| oe_test_start_ssh | OpenSSH server configuration and startup | run_test | 4 |  |  |  |
| oe_test_sec_ssh | Network security configuration | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_sec_jump_login | jump join | run_test/post_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_openssh_cipher

- 描述：Cipher configuration in sshd_config
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0
  CHECK_RESULT $? 1 0
```

- 涉及命令：sed×2

#### oe_test_openssh_keychecking_no

- 描述：No strict public key checking
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0
```

- 涉及命令：sed×2, ssh-keygen×1

#### oe_test_openssh_keyscan

- 描述：Common options of ssh-keyscan
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：ssh-keyscan×2

#### oe_test_openssh_locked

- 描述：Lock and unlock SSH agent
- 函数：`run_test, post_test`
- 断言（9 条）：

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
```

- 涉及命令：ssh-add×3, ssh-agent×1

#### oe_test_openssh_no_password

- 描述：login wihout password(create authorized_keys)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssh_port

- 描述：Specifies the port of the remote service
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×2

#### oe_test_openssh_scp_P

- 描述：SCP specified port
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×2

#### oe_test_openssh_scp_q

- 描述：Silent mode of SCP
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_openssh_scp_r

- 描述：Recursive replication of SCP
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1

#### oe_test_openssh_scp

- 描述：Two modes of SCP
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssh_sftp

- 描述：Upload and download based on SFTP
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：chown×2, userdel×1

#### oe_test_openssh_ssh_agent

- 描述：SSH agent avoids entering private key password
- 函数：`run_test, post_test`
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

- 涉及命令：ssh-add×3, ssh-keygen×1, ssh-agent×1

#### oe_test_openssh_ssh_command

- 描述：Test the SSH login of normal user and root user
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssh_ssh-copy-id

- 描述：login wihout password(ssh-copy-id)
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssh_ssh_user

- 描述：Test the SSH login of normal user and root user
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_service_sshd

- 描述：Test sshd.service restart
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "sshd.service reload failed"
  CHECK_RESULT $? 0 0 "sshd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_socket_sshd

- 描述：Test sshd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_sshd-keygen

- 描述：Test sshd-keygen.target restart
- 函数：`run_test`
#### oe_test_start_ssh

- 描述：OpenSSH server configuration and startup
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_sec_ssh

- 描述：Network security configuration
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_sec_jump_login

- 描述：jump join
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```
