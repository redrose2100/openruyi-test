# bzip2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/bzip2` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_bzip2 | test bzip2 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bzip2_01 | test bzip2 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bzip2_02 | test bzip2 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_bzip2_03 | test bzip2 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_bzip2_04 | test bzip2 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_bzegrep_001 | bzegrep Basic function verification | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_bzip2

- 描述：test bzip2
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "bzip2 fail"
  CHECK_RESULT $? 0 0 "compress fail"
  CHECK_RESULT $? 0 0 "decompression fail"
  CHECK_RESULT $? 0 0 "bzip2 -v fail"
  CHECK_RESULT $? 0 0 "bzip2 -dv fail"
  CHECK_RESULT $? 0 0 "ls fail"
```

- 涉及命令：bzip2×4, test×1

#### oe_test_bzip2_01

- 描述：test bzip2
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "compress fail"
  CHECK_RESULT $? 0 0 "bzip2 -z command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 -d command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 --stdout command execution failur"
  CHECK_RESULT $? 0 0 "bzip2 -c command execution failure"
  CHECK_RESULT $? 0 0 "ls fail"
```

- 涉及命令：test×4, bzip2×3

#### oe_test_bzip2_02

- 描述：test bzip2
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "compress fail"
  CHECK_RESULT $? 0 0 "bzip2 --compress command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 -L command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 -s command execution failur"
```

- 涉及命令：bzip2×3, test×2

#### oe_test_bzip2_03

- 描述：test bzip2
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "compress fail"
  CHECK_RESULT $? 0 0 "bzip2 --small compress command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 -t command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 --version command execution failur"
```

- 涉及命令：bzip2×2, test×2

#### oe_test_bzip2_04

- 描述：test bzip2
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "compress fail"
  CHECK_RESULT $? 0 0 "bzip2 -s compress command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 --fast command execution failure"
  CHECK_RESULT $? 0 0 "bzip2 --best command execution failur"
```

- 涉及命令：bzip2×3, test×2

#### oe_test_bzegrep_001

- 描述：bzegrep Basic function verification
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Compression failure"
  CHECK_RESULT $? 0 0 "The bzegrep command fails to be executed"
  CHECK_RESULT $? 0 0 "bzegrep count matches failed"
  CHECK_RESULT $? 0 0 "bzegrep line number display failed"
  CHECK_RESULT $? 0 0 "bzegrep invert match failed"
```

- 涉及命令：bzegrep×3, test×1
