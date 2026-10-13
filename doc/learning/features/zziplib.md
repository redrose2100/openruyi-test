# zziplib

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/zziplib` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_zziplib | zziplib formatting test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_unzzip-big | test unzzip-big | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_unzip-mem | test zziplib | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_unzzip | test unzzip | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_zziplib

- 描述：zziplib formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile example.c fail"
  CHECK_RESULT $? 0 0 "execute example.txt fail"
  CHECK_RESULT $? 0 0 "execute example1.txt fail"
```

- 涉及命令：return×1, rpm×1, test×1, unzip×1

#### oe_test_unzzip-big

- 描述：test unzzip-big
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check help information"
  CHECK_RESULT $? 0 0 "Check list function"
  CHECK_RESULT $? 0 0 "Check extraction"
  CHECK_RESULT $? 0 0 "Check pipe output"
```

- 涉及命令：mkdir×2, unzzip-big×2, zip×1

#### oe_test_unzip-mem

- 描述：test zziplib
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "ZIP content listing test failed"
  CHECK_RESULT $? 0 0 "File extraction test failed"
  CHECK_RESULT $? 0 0 "Multi-file content extraction failed"
  CHECK_RESULT $? 0 0 "Junk paths (-j) extraction failed"
  CHECK_RESULT $? 0 0 "Verbose mode output check failed"
```

- 涉及命令：unzip-mem×6, zip×1

#### oe_test_unzzip

- 描述：test unzzip
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check help information"
  CHECK_RESULT $? 0 0 "Check list function"
  CHECK_RESULT $? 0 0 "Check extraction"
  CHECK_RESULT $? 0 0 "Check pipe output"
```

- 涉及命令：mkdir×2, unzzip×2, zip×1
