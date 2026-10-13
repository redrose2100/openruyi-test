# libssh

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libssh` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libssh_01 | Verify libssh package installation and key files check | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_libssh_02 | Test libssh SSH connection and SFTP file transfer | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_libssh_01

- 描述：Verify libssh package installation and key files check
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "libssh package is not installed"
  CHECK_RESULT $? 0 0 "rpm -q libssh failed to retrieve version"
  CHECK_RESULT $? 0 0 "pkg-config version does not match rpm version"
```

- 涉及命令：mkdir×1, rpm×1

#### oe_test_libssh_02

- 描述：Test libssh SSH connection and SFTP file transfer
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "SSH_CMD failed to connect and execute command on remote node"
  CHECK_RESULT $? 0 0 "remote command did not produce expected marker output"
  CHECK_RESULT $? 0 0 "SSH_SCP failed to upload file to remote node"
  CHECK_RESULT $? 0 0 "uploaded file content does not match on remote node"
  CHECK_RESULT $? 0 0 "SSH_SCP failed to download file from remote node"
  CHECK_RESULT $? 0 0 "downloaded file content does not match uploaded content"
```

- 涉及命令：mkdir×1
