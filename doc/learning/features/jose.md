# jose

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jose` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jose_01 | Test jose jwk use 01 | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_jose_02 | Test jose jwk use 02 | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_jose_03 | Test jose jwe use | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_jose_04 | Test jose jws use | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_jose_01

- 描述：Test jose jwk use 01
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "jose alg命令失败"
  CHECK_RESULT $? 0 0 "jose jwk gen rsa failed"
  CHECK_RESULT $? 0 0 "rsa.jwk not generated"
  CHECK_RESULT $? 0 0 "jose jwk gen ec failed"
  CHECK_RESULT $? 0 0 "ec.jwk not generated"
  CHECK_RESULT $? 0 0 "生成HS256密钥失败"
  CHECK_RESULT $? 0 0 "HS256密钥文件未生成"
  CHECK_RESULT $? 0 0 "invalid alg not detected"
  CHECK_RESULT $? 0 0 "格式错误未报错"
```

- 涉及命令：test×3

#### oe_test_jose_02

- 描述：Test jose jwk use 02
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "jose jwk gen ec failed"
  CHECK_RESULT $? 0 0 "ec.jwk not generated"
  CHECK_RESULT $? 0 0 "ec.jwk公钥导出PEM失败"
  CHECK_RESULT $? 0 0 "ec.jwk公钥导出JWK失败"
  CHECK_RESULT $? 0 0 "jwk eql命令失败"
  CHECK_RESULT $? 0 0 "jwk thp命令失败"
  CHECK_RESULT $? 0 0 "jwk thp未生成输出"
  CHECK_RESULT $? 0 0 "jose b64 enc命令失败"
  CHECK_RESULT $? 0 0 "base64编码输出格式不正确"
  CHECK_RESULT $? 0 0 "jose b64 dec命令失败"
  CHECK_RESULT $? 0 0 "base64解码结果与原文不一致"
```

- 涉及命令：test×2

#### oe_test_jose_03

- 描述：Test jose jwe use
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "生成RSA私钥失败"
  CHECK_RESULT $? 0 0 "生成RSA公钥失败"
  CHECK_RESULT $? 0 0 "加密失败"
  CHECK_RESULT $? 0 0 "密文文件未生成"
  CHECK_RESULT $? 0 0 "解密失败"
  CHECK_RESULT $? 0 0 "解密内容与原文不一致"
  CHECK_RESULT $? 0 0 "错误密钥解密未报错"
```

- 涉及命令：test×1

#### oe_test_jose_04

- 描述：Test jose jws use
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "JWS签名失败"
  CHECK_RESULT $? 0 0 "JWS签名文件未生成"
  CHECK_RESULT $? 0 0 "JWS验签失败"
  CHECK_RESULT $? 0 0 "验签内容不一致"
  CHECK_RESULT $? 0 0 "错误密钥验签未报错"
```

- 涉及命令：test×1
