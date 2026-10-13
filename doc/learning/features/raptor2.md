# raptor2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/raptor2` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_raptor2_rapper_base_01 | verify the uasge of raptor2 command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_raptor2_rapper_base_02 | verify the uasge of raptor2 command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_raptor2_rapper_base_03 | verify the uasge of raptor2 command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_raptor2_rapper_base_04 | verify the uasge of raptor2 command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_raptor2_rapper_base_01

- 描述：verify the uasge of raptor2 command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check rapper -i failed"
  CHECK_RESULT $? 0 0 "Check rapper -i rdfxml failed"
  CHECK_RESULT $? 0 0 "Check rapper -i turtle failed"
  CHECK_RESULT $? 0 0 "Check rapper -i trig failed"
  CHECK_RESULT $? 0 0 "Check rapper -i grddl failed"
  CHECK_RESULT $? 0 0 "Check rapper -i guess failed"
  CHECK_RESULT $? 0 0 "Check rapper -i rdfa failed"
  CHECK_RESULT $? 0 0 "Check rapper -i json failed"
  CHECK_RESULT $? 0 0 "Check rapper -i nquads failed"
```

- 涉及命令：rapper×9

#### oe_test_raptor2_rapper_base_02

- 描述：verify the uasge of raptor2 command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check rapper -I failed"
  CHECK_RESULT $? 0 0 "Check rapper -o ntriples failed"
  CHECK_RESULT $? 0 0 "Check rapper -O INPUT-BASE-URI failed"
  CHECK_RESULT $? 0 0 "Check rapper -o turtle  failed"
  CHECK_RESULT $? 0 0 "Check rapper -o rdfxml-xmp failed"
  CHECK_RESULT $? 0 0 "Check rapper -o rdfxml-abbrev failed"
  CHECK_RESULT $? 0 0 "Check rapper -o rdfxml failed"
  CHECK_RESULT $? 0 0 "Check rapper -o rss-1.0 failed"
  CHECK_RESULT $? 0 0 "Check rapper -o atom failed"
```

- 涉及命令：rapper×9

#### oe_test_raptor2_rapper_base_03

- 描述：verify the uasge of raptor2 command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check rapper -O failed"
  CHECK_RESULT $? 0 0 "Check rapper -O failed"
  CHECK_RESULT $? 0 0 "Check rapper -O failed"
  CHECK_RESULT $? 0 0 "Check rapper -O failed"
  CHECK_RESULT $? 0 0 "Check rapper -O failed"
  CHECK_RESULT $? 0 0 "Check rapper --count failed"
  CHECK_RESULT $? 0 0 "Check rapper -c failed"
  CHECK_RESULT $? 0 0 "Check rapper --ignore-errors failed"
  CHECK_RESULT $? 0 0 "Check rapper -f failed"
  CHECK_RESULT $? 0 0 "Check rapper --feature failed"
  CHECK_RESULT $? 0 0 "Check rapper -q -o -f failed"
  CHECK_RESULT $? 0 0 "Check rapper -q failed"
```

- 涉及命令：rapper×9

#### oe_test_raptor2_rapper_base_04

- 描述：verify the uasge of raptor2 command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check rapper -r  failed"
  CHECK_RESULT $? 0 0 "Check rapper -t  failed"
  CHECK_RESULT $? 0 0 "Check rapper -w  failed"
  CHECK_RESULT $? 0 0 "Check rapper -version  failed"
  CHECK_RESULT $? 0 0 "Check rapper -v  failed"
  CHECK_RESULT $? 0 0 "Check rapper -g failed"
  CHECK_RESULT $? 0 0 "Check rapper -h failed"
  CHECK_RESULT $? 0 0 "Check rapper --help failed"
```

- 涉及命令：rapper×7
