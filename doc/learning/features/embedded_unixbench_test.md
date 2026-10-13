# embedded_unixbench_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/unix_bench_tests` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_unix_bench_test_001 | auto run embedded unix bench test | pre_test/run_test/post_test | 11 |  | ✔ | 1440m |

### 断言与命令明细

#### oe_test_unix_bench_test_001

- 描述：auto run embedded unix bench test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "pre test fail"
  CHECK_RESULT $? 0 0 "get 0.6 ub freq fail"
  CHECK_RESULT $? 0 0 "run ub freq not 600000"
  CHECK_RESULT $? 0 0 "run 0.6 ub fail"
  CHECK_RESULT $? 0 0 "get 1.5 ub freq fail"
  CHECK_RESULT $? 0 0 "run ub freq not 1500000"
  CHECK_RESULT $? 0 0 "run 1.5 ub fail"
  CHECK_RESULT $? 0 0 "set 1.8 ub fail"
  CHECK_RESULT $? 0 0 "get 1.8 ub freq fail"
  CHECK_RESULT $? 0 0 "run ub freq not 1800000"
  CHECK_RESULT $? 0 0 "run 1.8 ub fail"
```

- 涉及命令：unzip×3, sed×2, mkdir×2, zip×1
