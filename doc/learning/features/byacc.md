# byacc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/byacc` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_byacc_byacc_01 | the test of byacc package | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_byacc_byacc_02 | the test of byacc package | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_byacc_yacc_01 | the test of byacc package | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_byacc_yacc_02 | the test of byacc package | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_byacc_byacc_01

- 描述：the test of byacc package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -V"
  CHECK_RESULT $? 0 0 "Failed option: -b"
  CHECK_RESULT $? 0 0 "Failed option: -o"
  CHECK_RESULT $? 0 0 "Failed option: -H"
  CHECK_RESULT $? 0 0 "Failed option: -g"
  CHECK_RESULT $? 0 0 "Failed option: -p"
  CHECK_RESULT $? 0 "Failed option: -l" 0
  CHECK_RESULT $? 0 "Failed option: --no-lines" 0
```

- 涉及命令：byacc×6, test×5

#### oe_test_byacc_byacc_02

- 描述：the test of byacc package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -t"
  CHECK_RESULT $? 0 0 "Failed option: -r"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 0 0 "Failed option: -i"
  CHECK_RESULT $? 0 0 "Failed option: -s"
  CHECK_RESULT $? 0 0 "Failed option: -P"
```

- 涉及命令：byacc×8, test×1

#### oe_test_byacc_yacc_01

- 描述：the test of byacc package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -V"
  CHECK_RESULT $? 0 0 "Failed option: -b"
  CHECK_RESULT $? 0 0 "Failed option: -o"
  CHECK_RESULT $? 0 0 "Failed option: -H"
  CHECK_RESULT $? 0 0 "Failed option: -g"
  CHECK_RESULT $? 0 0 "Failed option: -p"
  CHECK_RESULT $? 0 "Failed option: -l" 0
  CHECK_RESULT $? 0 "Failed option: --no-lines" 0
```

- 涉及命令：yacc×6, test×5

#### oe_test_byacc_yacc_02

- 描述：the test of byacc package
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -t"
  CHECK_RESULT $? 0 0 "Failed option: -r"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 0 0 "Failed option: -i"
  CHECK_RESULT $? 0 0 "Failed option: -s"
  CHECK_RESULT $? 0 0 "Failed option: -P"
```

- 涉及命令：yacc×7, test×1
