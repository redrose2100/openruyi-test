# rasqal

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rasqal` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_roqet_base_01 | verify the uasge of rasqal command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_roqet_base_02 | verify the uasge of rasqal command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_roqet_base_03 | verify the uasge of rasqal command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_roqet_base_04 | verify the uasge of rasqal command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_roqet_base_01

- 描述：verify the uasge of rasqal command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check roqet -e failed."
  CHECK_RESULT $? 0 0 "Check roqet -p failed."
  CHECK_RESULT $? 0 0 "Check roqet -i sparql10 failed."
  CHECK_RESULT $? 0 0 "Check roqet -i sparql failed."
  CHECK_RESULT $? 0 0 "Check roqet -i sparql11-query failed."
  CHECK_RESULT $? 0 0 "Check roqet -i laqrs failed."
  CHECK_RESULT $? 0 0 "Check roqet -r simple failed."
  CHECK_RESULT $? 0 0 "Check roqet -r xml failed."
  CHECK_RESULT $? 0 0 "Check roqet -r csv failed."
  CHECK_RESULT $? 0 0 "Check roqet -r mkr failed."
```

- 涉及命令：roqet×10

#### oe_test_roqet_base_02

- 描述：verify the uasge of rasqal command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check roqet -R mkr failed."
  CHECK_RESULT $? 0 0 "Check roqet -R tsv failed."
  CHECK_RESULT $? 0 0 "Check roqet -R turtle failed."
  CHECK_RESULT $? 0 0 "Check roqet -R rdfxml failed."
  CHECK_RESULT $? 0 0 "Check roqet -r turtle failed."
  CHECK_RESULT $? 0 0 "Check roqet -r rdfxml failed."
  CHECK_RESULT $? 0 0 "Check roqet -p rdfxml failed."
  CHECK_RESULT $? 0 0 "Check roqet -t rdfxml failed."
  CHECK_RESULT $? 0 0 "Check roqet -R xml rdfxml failed."
  CHECK_RESULT $? 0 0 "Check roqet -R csv failed."
```

- 涉及命令：roqet×10, test×1

#### oe_test_roqet_base_03

- 描述：verify the uasge of rasqal command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check roqet -c failed."
  CHECK_RESULT $? 0 0 "Check roqet -d none failed."
  CHECK_RESULT $? 0 0 "Check roqet -d debug failed."
  CHECK_RESULT $? 0 0 "Check roqet -d structure failed."
  CHECK_RESULT $? 0 0 "Check roqet -d sparql failed."
  CHECK_RESULT $? 0 0 "Check roqet -D none failed."
  CHECK_RESULT $? 0 0 "Check roqet -E failed."
  CHECK_RESULT $? 0 0 "Check roqet -f failed."
  CHECK_RESULT $? 0 0 "Check roqet -F failed."
  CHECK_RESULT $? 0 0 "Check roqet -G failed."
```

- 涉及命令：roqet×10

#### oe_test_roqet_base_04

- 描述：verify the uasge of rasqal command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check roqet -help failed."
  CHECK_RESULT $? 0 0 "Check roqet -n failed."
  CHECK_RESULT $? 0 0 "Check roqet -q failed."
  CHECK_RESULT $? 0 0 "Check roqet -s failed."
  CHECK_RESULT $? 0 0 "Check roqet -v failed."
  CHECK_RESULT $? 0 0 "Check roqet --store-results yes failed."
```

- 涉及命令：roqet×5
