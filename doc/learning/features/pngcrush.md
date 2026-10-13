# pngcrush

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pngcrush` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pngcrush_01 | the test of pngcrush package | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_pngcrush_02 | the test of pngcrush package | pre_test/run_test/post_test | 23 | ✔ |  |  |
| oe_test_pngcrush_03 | the test of pngcrush package | pre_test/run_test/post_test | 24 | ✔ |  |  |
| oe_test_pngcrush_04 | the test of pngcrush package | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_pngcrush_05 | the test of pngcrush package | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pngcrush_01

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush --help"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -h"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -version"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -blacken"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -blacken"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -brute"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -brute"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -check"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -check"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -c"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -c"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -d"
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：pngcrush×13, test×10

#### oe_test_pngcrush_02

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

```
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -huffman"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -huffman"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -keep"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -keep"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -l"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -l"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -m"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -m"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -max"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -max"
  CHECK_RESULT $? 0 1"Failed to run command: pngcrush -n"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -new"
  ... 共 23 条（其余见源脚本）
```

- 涉及命令：test×12, pngcrush×12

#### oe_test_pngcrush_03

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -nolimits"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -nolimits"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -noreduce"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -noreduce"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -noreduce_palette"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -noreduce_palette"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -old"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -old"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -oldtimestamp"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -oldtimestamp"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -q"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -q"
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：test×13, pngcrush×10

#### oe_test_pngcrush_04

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -save"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -save"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -speed"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -speed"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -srgb"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -srgb"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -ster"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -ster"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -z"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -z"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -w"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -w"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：pngcrush×11, test×10

#### oe_test_pngcrush_05

- 描述：the test of pngcrush package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -zitxt"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -zitxt"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -trns"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -trns"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -itxt"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -itxt"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -iccp"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -iccp"
  CHECK_RESULT $? 0 0 "Failed to run command: pngcrush -p"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -loco"
  CHECK_RESULT $? 0 1 "Failed to run command: pngcrush -mng"
```

- 涉及命令：pngcrush×6, test×5
