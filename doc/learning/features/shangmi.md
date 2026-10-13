# shangmi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `$OET_PATH/testcases/system-test/shangmi` |
| 注册用例数 | 6 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gm_openssl_001 | openssl sm test | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_gm_cryptsetup_001 | cryptsetup sm test | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_gm_authentication_001 | user identity authentication sm test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_gm_uapi_001 | linux sm userspace api test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_gm_rpm_001 | rpm sm test | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_gm_openssh_001 | ssh sm test | pre_test/run_test/post_test | 1 |  | ✔ |  |

### 断言与命令明细

#### oe_test_gm_openssl_001

- 描述：openssl sm test
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile sm4_openssl program"
  CHECK_RESULT $? 0 0 "sm4 openssl test failed"
  CHECK_RESULT $? 0 0 "check sm cipher algorithms failed"
  CHECK_RESULT $? 0 0 "generate sm2 parameters failed"
  CHECK_RESULT $? 0 0 "generate sm2 request failed"
  CHECK_RESULT $? 0 0 "generate sm3 certificate failed"
  CHECK_RESULT $? 0 0 "generate sm2 request failed"
  CHECK_RESULT $? 0 0 "generate level 2 sm3 certificate failed"
  CHECK_RESULT $? 0 0 "generate sm2 request failed"
  CHECK_RESULT $? 0 0 "generate level 2 sm3 certificate failed"
  CHECK_RESULT $? 0 0 "check certificate info failed"
  CHECK_RESULT $? 0 0 "generate sm2 private key failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：gcc×1, grep×1

#### oe_test_gm_cryptsetup_001

- 描述：cryptsetup sm test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "luks2 model failed"
  CHECK_RESULT $? 0 0 "open dev failed"
  CHECK_RESULT $? 0 0 "format failed"
  CHECK_RESULT $? 0 0 "mount failed"
  CHECK_RESULT $? 0 0 "io write failed"
  CHECK_RESULT $? 0 0 "plain model failed"
  CHECK_RESULT $? 0 0 "format failed"
  CHECK_RESULT $? 0 0 "mount failed"
  CHECK_RESULT $? 0 0 "io write failed"
```

- 涉及命令：losetup×2

#### oe_test_gm_authentication_001

- 描述：user identity authentication sm test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "passwd sm3 test failed"
  CHECK_RESULT $? 0 0 "chpasswd sm3 test failed"
  CHECK_RESULT $? 0 0 "chgpasswd sm3 test failed"
  CHECK_RESULT $? 0 0 "luseradd sm3 test failed"
```

- 涉及命令：sed×6, userdel×2

#### oe_test_gm_uapi_001

- 描述：linux sm userspace api test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "sm2 algorithm is not supported"
  CHECK_RESULT $? 0 0 "sm3 algorithm is not supported"
  CHECK_RESULT $? 1 0 "sm4 algorithm is supported before loading sm4-generic module"
  CHECK_RESULT $? 0 0 "Failed to load sm4-generic module"
  CHECK_RESULT $? 0 0 "sm4 algorithm is not supported after loading sm4-generic module"
  CHECK_RESULT $? 0 0 "Failed to compile uapi_sm4 program"
  CHECK_RESULT $? 0 0 "sm4 uapi test failed"
```

- 涉及命令：gcc×1, grep×1

#### oe_test_gm_rpm_001

- 描述：rpm sm test
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "generate key failed"
  CHECK_RESULT $? 0 0 "export public key failed"
  CHECK_RESULT $? 0 0 "import gpg key to rpm database failed"
  CHECK_RESULT $? 0 0 "check gpg key in rpm database failed"
  CHECK_RESULT $? 0 0 "download package failed"
  CHECK_RESULT $? 0 0 "rename package failed"
  CHECK_RESULT $? 0 0 "sign package failed"
  CHECK_RESULT $? 0 0 "verify package signature failed"
  CHECK_RESULT $? 0 0 "gpg sign package failed"
  CHECK_RESULT $? 0 0 "gpg verify package signature failed"
  CHECK_RESULT $? 0 0 "gpg detach sign package failed"
  CHECK_RESULT $? 0 0 "gpg verify detach signature failed"
```

- 涉及命令：rpm×2, gpg×1

#### oe_test_gm_openssh_001

- 描述：ssh sm test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "ssh sm3 failed"
```
