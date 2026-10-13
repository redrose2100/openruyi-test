# tbb

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tbb/` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tbb | Verify tbb package installation and parallel computing functionality | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tbb

- 描述：Verify tbb package installation and parallel computing functionality
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install tbb package"
  CHECK_RESULT $? 0 0 "Failed to query tbb version"
  CHECK_RESULT $? 0 0 "tbb main header file tbb.h missing"
  CHECK_RESULT $? 0 0 "tbb shared library libtbb.so missing"
  CHECK_RESULT $? 0 0 "Failed to copy tbb test source file"
  CHECK_RESULT $? 0 0 "Failed to compile tbb test program"
  CHECK_RESULT $? 0 0 "Failed to run tbb test program"
  CHECK_RESULT $? 0 0 "tbb parallel_for test failed"
  CHECK_RESULT $? 0 0 "tbb parallel_reduce test failed"
  CHECK_RESULT $? 0 0 "tbb parallel_sort test failed"
  CHECK_RESULT $? 0 0 "tbb concurrent_vector test failed"
```

- 涉及命令：rpm×2, test×2
