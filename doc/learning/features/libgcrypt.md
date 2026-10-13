# libgcrypt

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libgcrypt/` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libgcrypt | Verify libgcrypt package and basic encryption functions | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libgcrypt

- 描述：Verify libgcrypt package and basic encryption functions
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "libgcrypt package not installed"
  CHECK_RESULT $? 0 0 "libgcrypt package verification failed"
  CHECK_RESULT $? 0 0 "libgcrypt header file gcrypt.h missing"
  CHECK_RESULT $? 0 0 "libgcrypt shared library missing"
  CHECK_RESULT $? 0 0 "Failed to compile libgcrypt test program"
  CHECK_RESULT $? 0 0 "libgcrypt version test failed"
  CHECK_RESULT $? 0 0 "libgcrypt MD5 hash test failed"
  CHECK_RESULT $? 0 0 "libgcrypt SHA256 hash test failed"
  CHECK_RESULT $? 0 0 "libgcrypt AES encryption test failed"
  CHECK_RESULT $? 0 0 "libgcrypt DES encryption test failed"
  CHECK_RESULT $? 0 0 "libgcrypt HMAC test failed"
  CHECK_RESULT $? 0 0 "libgcrypt RSA test failed"
```

- 涉及命令：rpm×3, test×1
