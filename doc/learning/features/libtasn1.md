# libtasn1

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libtasn1` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libtasn1_coding | libtasn1 asn1Coding command test | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_libtasn1_decoding | libtasn1 asn1Decoding command test | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_libtasn1_parser | libtasn1 asn1Parser command test | pre_test/run_test/post_test | 23 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libtasn1_coding

- 描述：libtasn1 asn1Coding command test
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "asn1Coding --help failed"
  CHECK_RESULT $? 0 0 "asn1Coding -h failed"
  CHECK_RESULT $? 0 0 "asn1Coding --version failed"
  CHECK_RESULT $? 0 0 "asn1Coding -v failed"
  CHECK_RESULT $? 0 0 "asn1Coding -c valid failed"
  CHECK_RESULT $? 1 0 "asn1Coding -c should fail for invalid input"
  CHECK_RESULT $? 0 0 "asn1Coding -c should output error message"
  CHECK_RESULT $? 0 0 "asn1Coding --check valid failed"
  CHECK_RESULT $? 1 0 "asn1Coding --check should fail for invalid input"
  CHECK_RESULT $? 0 0 "asn1Coding --check should output error message"
  CHECK_RESULT $? 0 0 "asn1Coding -o failed"
  CHECK_RESULT $? 0 0 "asn1Coding -o Coding SUCCESS failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：grep×6, asn1Coding×4, set×1

#### oe_test_libtasn1_decoding

- 描述：libtasn1 asn1Decoding command test
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "asn1Decoding --help failed"
  CHECK_RESULT $? 0 0 "asn1Decoding -h failed"
  CHECK_RESULT $? 0 0 "asn1Decoding --version failed"
  CHECK_RESULT $? 0 0 "asn1Decoding -v failed"
  CHECK_RESULT $? 0 0 "asn1Decoding basic failed"
  CHECK_RESULT $? 0 0 "asn1Decoding basic success failed"
  CHECK_RESULT $? 0 0 "asn1Decoding basic integer failed"
  CHECK_RESULT $? 0 0 "asn1Decoding basic string failed"
  CHECK_RESULT $? 0 0 "asn1Decoding basic time type failed"
  CHECK_RESULT $? 0 0 "asn1Decoding basic time value failed"
  CHECK_RESULT $? 0 0 "asn1Decoding -s valid failed"
  CHECK_RESULT $? 1 0 "asn1Decoding -s bad_time should fail"
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：asn1Decoding×7, grep×5, set×1

#### oe_test_libtasn1_parser

- 描述：libtasn1 asn1Parser command test
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

```
  CHECK_RESULT $? 0 0 "asn1Parser --help failed"
  CHECK_RESULT $? 0 0 "asn1Parser -h failed"
  CHECK_RESULT $? 0 0 "asn1Parser --version failed"
  CHECK_RESULT $? 0 0 "asn1Parser -v failed"
  CHECK_RESULT $? 0 0 "asn1Parser basic failed"
  CHECK_RESULT $? 0 0 "asn1Parser output file empty"
  CHECK_RESULT $? 0 0 "asn1Parser output missing module name"
  CHECK_RESULT $? 0 0 "asn1Parser output missing TestType"
  CHECK_RESULT $? 0 0 "asn1Parser output missing id field"
  CHECK_RESULT $? 0 0 "asn1Parser output missing name field"
  CHECK_RESULT $? 0 0 "asn1Parser output missing array definition"
  CHECK_RESULT $? 0 0 "asn1Parser -c valid failed"
  ... 共 23 条（其余见源脚本）
```

- 涉及命令：grep×7, asn1Parser×6, set×1
