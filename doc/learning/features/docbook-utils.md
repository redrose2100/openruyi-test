# docbook-utils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/docbook-utils` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_docbook-utils_jw_01 | verify the uasge of docbook-utils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_docbook-utils_jw_02 | verify the uasge of docbook-utils command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_docbook-utils_sgmldiff | verify the uasge of docbook-utils command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_docbook-utils_jw_01

- 描述：verify the uasge of docbook-utils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check jw -f -b -d -p -c -o -i failed"
  CHECK_RESULT $? 0 0 "Check jw --frontend --backend --dsl --parser --cat --output --include failed"
  CHECK_RESULT $? 0 0 "Check jw -n -c failed"
  CHECK_RESULT $? 0 0 "Check jw --nostd -c failed"
  CHECK_RESULT $? 0 0 "Check jw -l failed"
  CHECK_RESULT $? 0 0 "Check jw --dcl failed"
  CHECK_RESULT $? 0 0 "Check jw -s failed"
  CHECK_RESULT $? 0 0 "Check jw --sgmlbase failed"
  CHECK_RESULT $? 0 0 "Check jw -u -c failed"
  CHECK_RESULT $? 0 0 "Check jw --nochunks -c failed"
```

#### oe_test_docbook-utils_jw_02

- 描述：verify the uasge of docbook-utils command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check jw -w failed"
  CHECK_RESULT $? 0 0 "Check jw --warning failed"
  CHECK_RESULT $? 0 0 "Check jw -e failed"
  CHECK_RESULT $? 0 0 "Check jw --error failed"
  CHECK_RESULT $? 0 0 "Check jw -h failed"
  CHECK_RESULT $? 0 0 "Check jw --help failed"
  CHECK_RESULT $? 0 0 "Check jw -V name failed"
  CHECK_RESULT $? 0 0 "Check jw --version failed"
  CHECK_RESULT $? 0 0 "Check jw -v failed"
```

#### oe_test_docbook-utils_sgmldiff

- 描述：verify the uasge of docbook-utils command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check sgmldiff -a -s -c failed"
  CHECK_RESULT $? 0 0 "Check sgmldiff --attributes --statistics --context failed"
  CHECK_RESULT $? 0 0 "Check sgmldiff -h failed"
  CHECK_RESULT $? 0 0 "Check sgmldiff --help failed"
  CHECK_RESULT $? 0 0 "Check sgmldiff -v failed"
  CHECK_RESULT $? 0 0 "Check sgmldiff --version failed"
```

- 涉及命令：sgmldiff×3
