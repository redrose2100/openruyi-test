# smoke-bzip2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-basic-os/oe_test_bzip2` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_bzip2_001 | bzip2 check package complete | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_bzip2_002 | bzip2 check options | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_bzip2_003 | bzip2 check information option | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_bzip2_001

- 描述：bzip2 check package complete
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "test faild with option -t"
```

- 涉及命令：bzip2×2

#### oe_test_bzip2_002

- 描述：bzip2 check options
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT  $? 0 0 "test faild with option -z"
  CHECK_RESULT  $? 0 0 "test faild with option -d"
  CHECK_RESULT  $? 0 0 "test faild with option -zk"
  CHECK_RESULT  $? 0 0 "test faild with option -zkf"
  CHECK_RESULT  $? 0 0 "test faild with option -df"
  CHECK_RESULT  $? 0 0 "test faild with option -zkvf"
  CHECK_RESULT  $? 0 0 "test faild with option -dkvf"
```

- 涉及命令：bzip2×7

#### oe_test_bzip2_003

- 描述：bzip2 check information option
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test faild with option -h"
  CHECK_RESULT  $? 0 0 "test faild with option -L"
  CHECK_RESULT  $? 0 0 "test faild with option -V"
```

- 涉及命令：bzip2×3
