# pbzip2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pbzip2` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pbzip2_01 | Test ppbzip2 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pbzip2_02 | Test ppbzip2 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pbzip2_03 | Test pbzip2 | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pbzip2_01

- 描述：Test ppbzip2
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -V"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 0 0 "Failed option: --decompress"
  CHECK_RESULT $? 0 0 "Failed option: --stdout"
  CHECK_RESULT $? 0 0 "Failed option: -c"
  CHECK_RESULT $? 0 0 "Failed option: -k"
  CHECK_RESULT $? 0 0 "Failed option: --keep"
  CHECK_RESULT $? 0 0 "Failed option: -f"
  CHECK_RESULT $? 0 0 "Failed option: --force"
```

- 涉及命令：pbzip2×6, mkdir×1

#### oe_test_pbzip2_02

- 描述：Test ppbzip2
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: --help"
  CHECK_RESULT $? 0 0 "Failed option: --version"
  CHECK_RESULT $? 0 0 "Faileerbosd option: -z"
  CHECK_RESULT $? 0 0 "Faileerbosd option: --compress"
  CHECK_RESULT $? 0 0 "Faileerbosd option: -v"
  CHECK_RESULT $? 0 0 "Faileerbosd option: --verbose"
  CHECK_RESULT $? 0 0 "Failed option: -q"
  CHECK_RESULT $? 0 0 "Failed option: --quiet"
  CHECK_RESULT $? 0 0 "Failed option: -l"
  CHECK_RESULT $? 0 0 "Failed option: --loadavg "
```

- 涉及命令：pbzip2×2, mkdir×1

#### oe_test_pbzip2_03

- 描述：Test pbzip2
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -b"
  CHECK_RESULT $? 0 0 "Failed option: -1"
  CHECK_RESULT $? 0 0 "Failed option: -m"
  CHECK_RESULT $? 0 0 "Failed option: -p"
  CHECK_RESULT $? 0 0 "Failed option: -r"
  CHECK_RESULT $? 0 0 "Failed option: --read"
  CHECK_RESULT $? 0 0 "Failed option: -S"
  CHECK_RESULT $? 0 0 "Failed option: -t"
  CHECK_RESULT $? 0 0 "Failed option: --test"
  CHECK_RESULT $? 0 0 "Failed option: --ignore-trailing-garbage"
```

- 涉及命令：pbzip2×2
