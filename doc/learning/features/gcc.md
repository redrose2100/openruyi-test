# gcc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gcc` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libasan | Basic functionality verification of libasan | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_liblsan | Basic functional verification of liblsan | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_dejagnu | DejaGnu test of all self-developed features in openEuler GCC | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sendfile | glibc sendfile system call test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sendfile_01 | glibc sendfile system call test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libasan

- 描述：Basic functionality verification of libasan
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "Execution failed"
```

- 涉及命令：test×2, gcc×1, grep×1

#### oe_test_liblsan

- 描述：Basic functional verification of liblsan
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 " File generation failed"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 1 "File generation failed"
```

- 涉及命令：test×2, gcc×1

#### oe_test_dejagnu

- 描述：DejaGnu test of all self-developed features in openEuler GCC
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Some tests failed, but test execution was successful"
```

- 涉及命令：grep×1

#### oe_test_sendfile

- 描述：glibc sendfile system call test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "sys/sendfile.h not found"
  CHECK_RESULT $? 0 0 "sendfile symbol not in libc"
  CHECK_RESULT $? 0 0 "create test_sendfile.c failed"
  CHECK_RESULT $? 0 0 "compile test_sendfile.c failed"
  CHECK_RESULT $? 0 0 "run test_sendfile failed"
```

#### oe_test_sendfile_01

- 描述：glibc sendfile system call test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "sendfile file copy failed"
  CHECK_RESULT $? 0 0 "sendfile return value verification failed"
  CHECK_RESULT $? 0 0 "sendfile error handling failed"
```

- 涉及命令：grep×1
