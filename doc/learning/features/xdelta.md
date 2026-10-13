# xdelta

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/xdelta` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_xdelta_001 | Test xdelta | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_xdelta_002 | Test xdelta | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xdelta_003 | Test xdelta | pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_xdelta_001

- 描述：Test xdelta
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test failed on config"
  CHECK_RESULT $? 0 0 "test failed on encode"
  CHECK_RESULT $? 0 0 "test failed on decode"
  CHECK_RESULT $? 0 0 "test failed on test"
  CHECK_RESULT $? 0 0 "test failed on printdelta"
  CHECK_RESULT $? 0 0 "test failed on printhdr"
  CHECK_RESULT $? 0 0 "test failed on printhdrs"
  CHECK_RESULT $? 0 0 "test failed on recode"
  CHECK_RESULT $? 0 0 "test failed on merge"
```

- 涉及命令：xxd×2, userdel×1

#### oe_test_xdelta_002

- 描述：Test xdelta
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test failed with -e"
  CHECK_RESULT $? 0 0 "test failed with -0..9"
  CHECK_RESULT $? 0 0 "test failed with -d"
  CHECK_RESULT $? 0 0 "test failed with -c"
  CHECK_RESULT $? 0 0 "test failed with -f"
  CHECK_RESULT $? 0 0 "test failed with -F"
  CHECK_RESULT $? 0 0 "test failed with -h"
  CHECK_RESULT $? 1 0 "test failed with -q"
  CHECK_RESULT $? 0 0 "test failed with -v"
  CHECK_RESULT $? 0 0 "test failed with -V"
```

- 涉及命令：xdelta3×10, xxd×1, xdelta×1

#### oe_test_xdelta_003

- 描述：Test xdelta
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "failed to test -B"
  CHECK_RESULT $? 0 0 "failed to test -W"
  CHECK_RESULT $? 0 0 "failed to test -P"
  CHECK_RESULT $? 0 0 "failed to test -I"
  CHECK_RESULT $? 0 0 "failed to test -s"
  CHECK_RESULT $? 0 0 "failed to test -S"
  CHECK_RESULT $? 0 0 "failed to test -N"
  CHECK_RESULT $? 0 0 "failed to test -D"
  CHECK_RESULT $? 0 0 "failed to test -R"
  CHECK_RESULT $? 0 0 "failed to test -n"
  CHECK_RESULT $? 0 0 "failed to test -C"
  CHECK_RESULT $? 0 0 "failed to test -A"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：xdelta3×13
