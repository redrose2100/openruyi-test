# libssh2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libssh2` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libssh2_install | libssh2 install verification and version check | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_libssh2_api | libssh2 SSH connection and authentication API test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_libssh2_sftp | libssh2 SFTP functionality test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_libssh2_scp | libssh2 SCP functionality test | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_libssh2_install

- 描述：libssh2 install verification and version check
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "libssh2 package not installed"
  CHECK_RESULT $? 0 0 "libssh2-devel package not installed"
  CHECK_RESULT $? 0 0 "pkg-config libssh2 module not found"
  CHECK_RESULT $? 0 0 "libssh2.so not found"
  CHECK_RESULT $? 0 0 "libssh2.h header not found"
```

- 涉及命令：rpm×2

#### oe_test_libssh2_api

- 描述：libssh2 SSH connection and authentication API test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create test_ssh_api.c"
  CHECK_RESULT $? 0 0 "Failed to compile SSH API test program"
  CHECK_RESULT $? 0 0 "SSH API test failed"
```

#### oe_test_libssh2_sftp

- 描述：libssh2 SFTP functionality test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create test_sftp.c"
  CHECK_RESULT $? 0 0 "Failed to compile SFTP test program"
  CHECK_RESULT $? 0 0 "SFTP test failed"
```

#### oe_test_libssh2_scp

- 描述：libssh2 SCP functionality test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create test_scp.c"
  CHECK_RESULT $? 0 0 "Failed to compile SCP test program"
  CHECK_RESULT $? 0 0 "SCP test failed"
```
