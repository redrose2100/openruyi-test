# pkgship_performance

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_performance` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_CPU_compress_init | Test init when set cpu stress | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_CPU_compress_query | Test query when set cpu stress | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_large_data_query | Check init performance | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_pkgship_memory_compress_init | Test init when set memory stress | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_memory_compress_query | Test init when set memory stress | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_resource_init | Check init performance | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_resource_logrotate | Check logrotate performance | pre_test/run_test/post_test | 2 |  |  | 60m |

### 断言与命令明细

#### oe_test_pkgship_CPU_compress_init

- 描述：Test init when set cpu stress
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "pkgship init failed"
  CHECK_RESULT $? 0 0 "pkgship dbs failed."
```

- 涉及命令：kill×1

#### oe_test_pkgship_CPU_compress_query

- 描述：Test query when set cpu stress
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Query list while cpu suppress failed."
  CHECK_RESULT $? 0 0 "Query pkginfo while cpu suppress failed."
  CHECK_RESULT $? 0 0 "Query installdep while cpu suppress failed."
  CHECK_RESULT $? 0 0 "Query builddep while cpu suppress failed."
  CHECK_RESULT $? 0 0 "Query selfdepend while cpu suppress failed."
  CHECK_RESULT $? 0 0 "Query bedepend while cpu suppress failed."
  CHECK_RESULT $? 0 0 "Query compare while cpu suppress failed."
```

- 涉及命令：kill×1

#### oe_test_pkgship_large_data_query

- 描述：Check init performance
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT 1 0 0 "CPU is used with exception."
  CHECK_RESULT 1 0 0 "IO is used with exception."
  CHECK_RESULT 1 0 0 "CPU is used with exception."
```

- 涉及命令：kill×1

#### oe_test_pkgship_memory_compress_init

- 描述：Test init when set memory stress
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "pkgship init failed"
  CHECK_RESULT $? 0 0 "pkgship dbs failed."
```

- 涉及命令：kill×1

#### oe_test_pkgship_memory_compress_query

- 描述：Test init when set memory stress
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Query list while memory suppress failed."
  CHECK_RESULT $? 0 0 "Query pkginfo while memory suppress failed."
  CHECK_RESULT $? 0 0 "Query installdep while memory suppress failed."
  CHECK_RESULT $? 0 0 "Query builddep while memory suppress failed."
  CHECK_RESULT $? 0 0 "Query selfdepend while memory suppress failed."
  CHECK_RESULT $? 0 0 "Query bedepend while memory suppress failed."
  CHECK_RESULT $? 0 0 "Query compare while memory suppress failed."
```

- 涉及命令：kill×1

#### oe_test_pkgship_resource_init

- 描述：Check init performance
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 1 0 0 "The init time is more than 4min."
  CHECK_RESULT 1 0 0 "The init temp file doesn't delete."
```

#### oe_test_pkgship_resource_logrotate

- 描述：Check logrotate performance
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Run uwsgi_logrotate failed."
  CHECK_RESULT $? 0 0 "Check logrotate log failed."
```

- 涉及命令：sed×5
