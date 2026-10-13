# byacc2.0

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/byacc` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_byacc2.0_byacc_03 | the test of byacc package | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_byacc2.0_yacc_03 | the test of byacc package | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_byacc2.0_byacc_03

- 描述：the test of byacc package
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: --help"
  CHECK_RESULT $? 0 0 "Failed option: --file-prefix"
  CHECK_RESULT $? 0 0 "Failed option: --defines"
  CHECK_RESULT $? 0 0 "Failed option: --output"
  CHECK_RESULT $? 0 0 "Failed option: --graph"
  CHECK_RESULT $? 0 0 "Failed option: --name-prefix"
```

- 涉及命令：test×5, byacc×3

#### oe_test_byacc2.0_yacc_03

- 描述：the test of byacc package
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: --help"
  CHECK_RESULT $? 0 0 "Failed option: --file-prefix"
  CHECK_RESULT $? 0 0 "Failed option: --defines"
  CHECK_RESULT $? 0 0 "Failed option: --output"
  CHECK_RESULT $? 0 0 "Failed option: --graph"
  CHECK_RESULT $? 0 0 "Failed option: --name-prefix"
```

- 涉及命令：test×5, yacc×3
