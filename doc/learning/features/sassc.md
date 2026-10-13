# sassc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sassc` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sassc_01 | Test sassc | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_sassc_02 | Test sassc | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sassc_03 | Test sassc | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_sassc_01

- 描述：Test sassc
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: help"
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -s"
  CHECK_RESULT $? 0 0 "Failed option: -t"
  CHECK_RESULT $? 0 0 "Failed option: -l"
  CHECK_RESULT $? 0 0 "Failed option: -I"
  CHECK_RESULT $? 0 0 "Failed option: -P"
  CHECK_RESULT $? 0 0 "Failed option: -m"
  CHECK_RESULT $? 0 0 "Failed option: precision"
```

- 涉及命令：sassc×8, tar×1

#### oe_test_sassc_02

- 描述：Test sassc
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -a"
  CHECK_RESULT $? 0 0 "Failed option: line-numbers"
  CHECK_RESULT $? 0 0 "Failed option: -M"
  CHECK_RESULT $? 0 0 "Failed option: sass"
  CHECK_RESULT $? 0 0 "Failed option: omit-map-comment"
```

- 涉及命令：tar×1

#### oe_test_sassc_03

- 描述：Test sassc
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: version"
  CHECK_RESULT $? 0 0 "Failed option: --stdin"
  CHECK_RESULT $? 0 0 "Failed option: style"
  CHECK_RESULT $? 0 0 "Failed option: line-numbers"
  CHECK_RESULT $? 0 0 "Failed option: load-path"
  CHECK_RESULT $? 0 0 "Failed option: plugin-path"
  CHECK_RESULT $? 0 0 "Failed option: sourcemap"
  CHECK_RESULT $? 0 0 "Failed option: precision"
```

- 涉及命令：tar×1, sassc×1
