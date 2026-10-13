# python-cryptography

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/python-cryptography` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_python3-cryptography | Use oe_test_python3-cryptography case | run_test/post_test | 2 |  |  |  |
| oe_test_python-cryptography | test sox | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_hasher_python3-cryptography | test hasher | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_python3-cryptography

- 描述：Use oe_test_python3-cryptography case
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Error,Please check the file 'test.py'"
  CHECK_RESULT $? 0 0 "Error,Please check test.py"
```

#### oe_test_python-cryptography

- 描述：test sox
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error,Please check the file 'test.py'"
  CHECK_RESULT $? 0 0 "Encryption failure"
  CHECK_RESULT $? 0 0 "Decryption failure"
```

#### oe_test_hasher_python3-cryptography

- 描述：test hasher
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "hasher failure"
```
