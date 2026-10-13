# crypto-policies

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/crypto-policies` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_crypto_policies_basic | Test crypto-policies package installation and basic command functionality | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_crypto_policies_switch | Test crypto-policies switching and policy application verification | pre_test/run_test/post_test | 24 | ✔ |  |  |

### 断言与命令明细

#### oe_test_crypto_policies_basic

- 描述：Test crypto-policies package installation and basic command functionality
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "crypto-policies package not installed"
  CHECK_RESULT $? 0 0 "update-crypto-policies command not found"
  CHECK_RESULT $? 0 0 "update-crypto-policies --show output is not a valid policy"
  CHECK_RESULT $? 0 0 "update-crypto-policies --is-applied failed"
  CHECK_RESULT $? 0 0 "crypto-policies config file content is not a valid policy"
  CHECK_RESULT $? 0 0 "crypto-policies back-ends directory not found"
  CHECK_RESULT $? 0 0 "crypto-policies state directory not found"
```

- 涉及命令：rpm×1, command×1, grep×1

#### oe_test_crypto_policies_switch

- 描述：Test crypto-policies switching and policy application verification
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 0 "update-crypto-policies --help failed"
  CHECK_RESULT $? 0 0 "update-crypto-policies --set LEGACY failed"
  CHECK_RESULT $? 0 0 "Failed to set LEGACY policy"
  CHECK_RESULT $? 0 0 "LEGACY policy not applied"
  CHECK_RESULT $? 0 0 "OpenSSL backend config not found"
  CHECK_RESULT $? 0 0 "update-crypto-policies --set DEFAULT failed"
  CHECK_RESULT $? 0 0 "Failed to set DEFAULT policy"
  CHECK_RESULT $? 0 0 "DEFAULT policy not applied"
  CHECK_RESULT $? 0 0 "update-crypto-policies --set FUTURE failed"
  CHECK_RESULT $? 0 0 "Failed to set FUTURE policy"
  CHECK_RESULT $? 0 0 "FUTURE policy not applied"
  CHECK_RESULT $? 0 0 "update-crypto-policies --set DEFAULT:NO-SHA1 failed"
  ... 共 24 条（其余见源脚本）
```
