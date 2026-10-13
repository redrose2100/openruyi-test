# nspr

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nspr` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nspr_001 | File system common command test-nspr | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nspr_002 | File system common command test-nspr | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nspr-devel | test nspr-devel | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nspr_001

- 描述：File system common command test-nspr
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile testfile fail"
  CHECK_RESULT $? 0 0 "Generate log fail "
  CHECK_RESULT $? 0 0 "information is error"
```

- 涉及命令：test×2, rpm×1

#### oe_test_nspr_002

- 描述：File system common command test-nspr
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile testfile fail"
  CHECK_RESULT $? 0 0 "Generate test fail "
  CHECK_RESULT $? 0 0 "information is error"
```

- 涉及命令：test×2, rpm×1

#### oe_test_nspr-devel

- 描述：test nspr-devel
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Compiler option error in NSPR library"
  CHECK_RESULT $? 0 0 "Error in obtaining linker options for NSPR library"
  CHECK_RESULT $? 0 0 "Error in obtaining version information of NSPR library"
  CHECK_RESULT $? 0 0 "Error getting installation path for NSPR library"
```
