# gnutls

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gnutls` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gnutls | Test python3-httplib2 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gnutls_01 | Test gnutls | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gnutls

- 描述：Test python3-httplib2
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "connection fail"
  CHECK_RESULT $? 0 0 "Failed to get gnutls-cli version"
  CHECK_RESULT $? 0 0 "Failed to retrieve certificate information"
  CHECK_RESULT $? 0 0 "Handshake failed"
  CHECK_RESULT $? 0 0 "Failed to list cipher suites"
  CHECK_RESULT $? 0 0 "Failed to show priority list"
  CHECK_RESULT $? 0 0 "Cipher benchmark failed"
  CHECK_RESULT $? 0 0 "Failed to save certificate"
  CHECK_RESULT $? 0 0 "Saved certificate file is empty"
```

- 涉及命令：rpm×1, test×1

#### oe_test_gnutls_01

- 描述：Test gnutls
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Cipher suite list function fail"
  CHECK_RESULT $? 0 0 "Generate private key fail"
  CHECK_RESULT $? 0 0 "Private key file not created"
  CHECK_RESULT $? 0 0 "Help information check fail"
  CHECK_RESULT $? 0 0 "Generate DH parameters fail"
  CHECK_RESULT $? 0 0 "DH parameters file not created"
  CHECK_RESULT $? 0 0 "Version check fail"
```

- 涉及命令：test×2
