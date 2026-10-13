# rubygem-asciidoctor

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rubygem-asciidoctor` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rubygem-asciidoctor_asciidoctor_01 | Test asciidoctor | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rubygem-asciidoctor_asciidoctor_02 | Test asciidoctor | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_rubygem-asciidoctor_asciidoctor_03 | Test asciidoctor | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rubygem-asciidoctor_asciidoctor_01

- 描述：Test asciidoctor
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -h"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -V"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -b"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -d"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -e"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -o"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -R"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -S"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -s"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -n"
```

- 涉及命令：asciidoctor×8, tar×1

#### oe_test_rubygem-asciidoctor_asciidoctor_02

- 描述：Test asciidoctor
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -T"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -E"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -I"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -D"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -r"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor --failure-level"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -q"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -a"
```

- 涉及命令：asciidoctor×7, tar×1

#### oe_test_rubygem-asciidoctor_asciidoctor_03

- 描述：Test asciidoctor
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -w"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -t"
  CHECK_RESULT $? 0 0 "Failed option: asciidoctor -v"
```

- 涉及命令：asciidoctor×3, tar×1
