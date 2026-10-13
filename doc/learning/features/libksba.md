# libksba

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libksba` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libksba | libksba function test | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libksba

- 描述：libksba function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The libksba.so.8 link in the /usr/bin/gpgsm directory does not exist"
  CHECK_RESULT $? 0 0 "The libksba.so.8 link in the /usr/bin/kbxutil directory does not exist"
  CHECK_RESULT $? 0 0 "Failed to generate private key file and public key certificate using 509 certificate"
  CHECK_RESULT $? 0 0 "The private key file or public key certificate does not exist"
  CHECK_RESULT $? 0 0 "Gpgsm failed to view help"
  CHECK_RESULT $? 0 0 "Kbxutil failed to view help"
```

- 涉及命令：ldd×2, test×1
