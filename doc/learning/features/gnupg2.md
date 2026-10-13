# gnupg2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gnupg2` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gnupg2_001 | gnupg2 batch keygen, encrypt, decrypt test | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gnupg2_001

- 描述：gnupg2 batch keygen, encrypt, decrypt test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Create test.txt failed"
  CHECK_RESULT $? 0 0 "Generate GPG key failed"
  CHECK_RESULT $? 0 0 "List public keys failed"
  CHECK_RESULT $? 0 0 "List secret keys failed"
  CHECK_RESULT $? 0 0 "Encrypt file failed"
  CHECK_RESULT $? 0 0 "Decrypt file failed"
  CHECK_RESULT $? 0 0 "Decrypted file inconsistent"
```
