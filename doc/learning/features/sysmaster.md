# sysmaster

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/sysmaster` |
| 注册用例数 | 3 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sysmaster_docker | sysmaster docker 环境测试 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_sysmaster_sctl | sysmaster sctl 命令测试 | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_devmaster_devctl | devmaster devctl trigger 测试 | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_sysmaster_docker

- 描述：sysmaster docker 环境测试
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Build docker image failed"
  CHECK_RESULT $? 0 0 "Run container failed"
  CHECK_RESULT $? 0 0 "sctl start sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl stop sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl restart sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl start sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl stop sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl restart sshd.service failed"
  CHECK_RESULT $? 0 0 "docker stop failed"
  CHECK_RESULT $? 0 0 "docker rm failed"
```

#### oe_test_sysmaster_sctl

- 描述：sysmaster sctl 命令测试
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "sysmaster init boot failed"
  CHECK_RESULT $? 0 0 "sctl start sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl stop sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl restart sshd.service failed"
  CHECK_RESULT $? 0 0 "sctl status sshd.service failed"
```

#### oe_test_devmaster_devctl

- 描述：devmaster devctl trigger 测试
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "udevd stop failed"
  CHECK_RESULT $? 0 0 "SSH_SCP 00-persist-storage.rules failed"
  CHECK_RESULT $? 0 0 "/lib/devmaster/devmaster failed"
  CHECK_RESULT $? 0 0 "test -d /dev/test failed"
```
