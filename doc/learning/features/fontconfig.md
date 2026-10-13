# fontconfig

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fontconfig` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fc-list | Use fc-list case | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_fc-cat | Use fc-cat case | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_fc-match | Use fc-match case | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_fc-conflist | Use fc-conflist case | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_fc-pattern | Use fc-pattern case | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_fc-cache | Use fc-cache case | pre_test/run_test/post_test | 5 |  |  |  |

### 断言与命令明细

#### oe_test_fc-list

- 描述：Use fc-list case
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view the system font"
  CHECK_RESULT $? 0 0 "Failed to display the entire font matching mode in detail"
  CHECK_RESULT $? 0 0  "Exhaustive Simple entire font matching mode failed"
  CHECK_RESULT $? 0 0  "Failed to print the Chinese font"
  CHECK_RESULT $? 0 0  "Description Failed to view the version information"
  CHECK_RESULT $? 0 0  "Description Failed to view the help information"
```

- 涉及命令：fc-list×5

#### oe_test_fc-cat

- 描述：Use fc-cat case
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Recursive entry to the subdirectory failed"
  CHECK_RESULT $? 0 0 "Description Failed to output details"
  CHECK_RESULT $? 0 0  "Description Failed to view the version information"
  CHECK_RESULT $? 0 0  "Description Failed to view the help information"
```

- 涉及命令：fc-cat×4

#### oe_test_fc-match

- 描述：Use fc-match case
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list the best font matching the pattern"
  CHECK_RESULT $? 0 0 "Failed to display the sorted match list"
  CHECK_RESULT $? 0 0 "Failed to display an unpruned sorted match list"
  CHECK_RESULT $? 0 0 "Failed to display the entire font matching mode in detail"
  CHECK_RESULT $? 0 0 "Summary shows that the entire font matching mode failed"
  CHECK_RESULT $? 0 0 "Failed to use the specified output format"
  CHECK_RESULT $? 0 0  "Description Failed to view the version information"
  CHECK_RESULT $? 0 0  "Description Failed to view the help information"
```

- 涉及命令：fc-match×7

#### oe_test_fc-conflist

- 描述：Use fc-conflist case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display the rule set file in the current system"
  CHECK_RESULT $? 0 0  "Description Failed to view the version information"
  CHECK_RESULT $? 0 0  "Description Failed to view the help information"
```

- 涉及命令：fc-conflist×2

#### oe_test_fc-pattern

- 描述：Use fc-pattern case
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Description Failed to configure the replacement based on the matching mode"
  CHECK_RESULT $? 0 0 "Failed to replace the default value according to the matching mode"
  CHECK_RESULT $? 0 0 "Failed to use the specified output format"
  CHECK_RESULT $? 0 0  "Description Failed to view the version information"
  CHECK_RESULT $? 0 0  "Description Failed to view the help information"
```

- 涉及命令：fc-pattern×5

#### oe_test_fc-cache

- 描述：Use fc-cache case
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Build cache failure"
  CHECK_RESULT $? 0 0 "There is no font in the directory"
  CHECK_RESULT $? 0 0  "Failed to scan the home directory. Procedure"
  CHECK_RESULT $? 0 0  "Description Failed to view the version information"
  CHECK_RESULT $? 0 0  "Description Failed to view the help information"
```

- 涉及命令：fc-cache×3, fc-list×2
