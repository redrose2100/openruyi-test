# nmon

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nmon` |
| 注册用例数 | 4 |
| 环境约束 | add disk = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nmon_01 | Take the test for nmon | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_nmon_02 | Take the test for nmon | pre_test/run_test/post_test | 32 | ✔ |  |  |
| oe_test_nmon_03 | Take the test for nmon | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_nmon_04 | Take the test for nmon | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nmon_01

- 描述：Take the test for nmon
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -f"
  CHECK_RESULT $? 0 0 "Failed option: -F"
  CHECK_RESULT $? 0 0 "Failed option: -a"
  CHECK_RESULT $? 0 0 "Failed option: -c"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 0 0 "Failed option: -D"
  CHECK_RESULT $? 0 0 "Failed option: -g auto"
  CHECK_RESULT $? 0 0 "Failed option: -g"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -J"
  CHECK_RESULT $? 0 0 "Failed option: -l"
  CHECK_RESULT $? 0 0 "Failed option: -m"
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：nmon×20, grep×13, test×2, kill×1

#### oe_test_nmon_02

- 描述：Take the test for nmon
- 函数：`pre_test, run_test, post_test`
- 断言（32 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -b"
  CHECK_RESULT $? 0 0 "Failed option: -c"
  CHECK_RESULT $? 0 0 "Failed option: -s"
  CHECK_RESULT $? 0 0 "Failed option: a"
  CHECK_RESULT $? 0 0 "Failed option: -b"
  CHECK_RESULT $? 0 0 "Failed option: c"
  CHECK_RESULT $? 0 0 "Failed option: C"
  CHECK_RESULT $? 0 0 "Failed option: d"
  CHECK_RESULT $? 0 0 "Failed option: D"
  CHECK_RESULT $? 0 0 "Failed option: g"
  CHECK_RESULT $? 0 0 "Failed option: G"
  CHECK_RESULT $? 0 1 "Failed option: G"
  ... 共 32 条（其余见源脚本）
```

- 涉及命令：test×40, expect×2, read×1

#### oe_test_nmon_03

- 描述：Take the test for nmon
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -z"
  CHECK_RESULT $? 0 0 "Failed option: -z"
  CHECK_RESULT $? 0 0 "Failed option: -z"
  CHECK_RESULT $? 0 0 "Failed option: -x"
  CHECK_RESULT $? 0 0 "Failed option: -X"
```

- 涉及命令：nmon×3, grep×3, mkdir×1, test×1, pgrep×1

#### oe_test_nmon_04

- 描述：Take the test for nmon
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: +"
  CHECK_RESULT $? 0 0 "Failed option: -"
  CHECK_RESULT $? 0 0 "Failed option: 0"
  CHECK_RESULT $? 0 0 "Failed option: 1"
  CHECK_RESULT $? 0 0 "Failed option: 3"
  CHECK_RESULT $? 0 0 "Failed option: 4"
  CHECK_RESULT $? 0 0 "Failed option: 5"
  CHECK_RESULT $? 0 0 "Failed option: 6"
  CHECK_RESULT $? 0 0 "Failed option: 7"
  CHECK_RESULT $? 0 0 "Failed option: 8"
  CHECK_RESULT $? 0 0 "Failed option: 9"
  CHECK_RESULT $? 0 0 "Failed option: space"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×15
