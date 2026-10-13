# smoke-openssh

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-openssh` |
| 注册用例数 | 2 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sshd_SCEN.002 | 构造/var/run/sshd.init.pid文件异常，然后重启sshd服务正常 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ssh_mutual_auth | ssh双向认证测试 | pre_test/run_test/post_test | 6 |  | ✔ |  |

### 断言与命令明细

#### oe_test_sshd_SCEN.002

- 描述：构造/var/run/sshd.init.pid文件异常，然后重启sshd服务正常
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "sshd restart failed"
  CHECK_RESULT $? 0 0 "sshd not active after restart"
  CHECK_RESULT $? 0 0 "failed to get sshd pid"
  CHECK_RESULT $? 0 0 "failed to read pid file"
  CHECK_RESULT $? 0 0 "PID mismatch: running pid=${pid}, pidfile=${pid1}"
```

#### oe_test_ssh_mutual_auth

- 描述：ssh双向认证测试
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT "$ssh_dir_perm" "700" 0 ".ssh目录权限不正确，应为700"
  CHECK_RESULT "$auth_keys_perm" "600" 0 "authorized_keys文件权限不正确，应为600"
  CHECK_RESULT $? 0 0 "scp上传文件失败"
  CHECK_RESULT $? 0 0 "远程文件内容验证失败"
```

- 涉及命令：ssh-keygen×1
