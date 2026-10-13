# pkgship_service_module

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_service_module` |
| 注册用例数 | 30 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_concurrent_init_1 | Test multiple processes executing pkgship init 10 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_init_large_db | Pkgship items normal function test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_pkgship_init_restart | Query and restart service | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_bedepend_service_1 | pkgship bedepend and restart service | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_bedepend_service_2 | Test the execution time of pkgship bedepend | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_bedepend_service_3 | Test multi process execution of pkgship bedepend 100 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_bedepend_service_4 | Test multi process execution of pkgship bedepend 18 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_builddep_service_1 | pkgship builddep and restart service | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_builddep_service_2 | Test the execution time of pkgship builddep | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_builddep_service_3 | Test multi process execution of pkgship builddep 30 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_builddep_service_4 | Test multi process execution of pkgship builddep 18 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_installdep_service_1 | pkgship installdep and restart service | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_installdep_service_2 | Test the execution time of pkgship installdep | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_installdep_service_3 | Test multi process execution of pkgship  installdep 30 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_installdep_service_4 | Test multi process execution of pkgship installde 18 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_list_service_1 | pkgship list and restart service | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_list_service_3 | Test multi process execution of pkgship list 100 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_list_service_4 | Test multi process execution of pkgship list 18 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_pkginfo_service_1 | pkgship pkginfo and restart service | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_pkginfo_service_2 | Test the execution time of pkgship pkginfo | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_pkginfo_service_3 | Test multi process execution of pkgship pkginfo 100 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_pkginfo_service_4 | Test multi process execution of pkgship pkginfo 18 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_selfdepend_service_1 | pkgship selfdepend and restart service | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_selfdepend_service_2 | Test the execution time of pkgship selfdepend | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_query_selfdepend_service_3 | Test multi process execution of pkgship selfdepend 30 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_query_selfdepend_service_4 | Test multi process execution of pkgship selfdepend 18 times | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_service_down | Close pkgship service | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_service_down_ES | Close ES service | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_service_down_redis | Close redis service | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_set_ES_security | Set ES security | pre_test/run_test/post_test | 9 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_concurrent_init_1

- 描述：Test multiple processes executing pkgship init 10 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Concurrency execute init failed."
```

#### oe_test_pkgship_init_large_db

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "pkgship init failed."
  CHECK_RESULT 1 0 0 "CPU is used with exception."
  CHECK_RESULT 1 0 0 "IO is used with exception."
  CHECK_RESULT 1 0 0 "VMstat is used with exception."
  CHECK_RESULT "$tmp_num" 2 0 "The init temp file doesn't delete."
```

- 涉及命令：kill×1

#### oe_test_pkgship_init_restart

- 描述：Query and restart service
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_pkgship_query_bedepend_service_1

- 描述：pkgship bedepend and restart service
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "Search th result failed."
```

#### oe_test_pkgship_query_bedepend_service_2

- 描述：Test the execution time of pkgship bedepend
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 0 0 0 "Seconde query time less than first time."
  CHECK_RESULT 1 0 0 "Seconde query time does't less than first time."
```

#### oe_test_pkgship_query_bedepend_service_3

- 描述：Test multi process execution of pkgship bedepend 100 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "No limit while concurrency query list more than 20."
```

#### oe_test_pkgship_query_bedepend_service_4

- 描述：Test multi process execution of pkgship bedepend 18 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Query list failed."
```

#### oe_test_pkgship_query_builddep_service_1

- 描述：pkgship builddep and restart service
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "Search th result failed."
  CHECK_RESULT $? 0 0 "Search th result failed."
```

#### oe_test_pkgship_query_builddep_service_2

- 描述：Test the execution time of pkgship builddep
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 0 0 0 "Seconde query time less than first time."
  CHECK_RESULT 1 0 0 "Seconde query time does't less than first time."
```

#### oe_test_pkgship_query_builddep_service_3

- 描述：Test multi process execution of pkgship builddep 30 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "No limit while concurrency query list more than 20."
```

#### oe_test_pkgship_query_builddep_service_4

- 描述：Test multi process execution of pkgship builddep 18 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Query list failed."
```

#### oe_test_pkgship_query_installdep_service_1

- 描述：pkgship installdep and restart service
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Search th result failed."
```

#### oe_test_pkgship_query_installdep_service_2

- 描述：Test the execution time of pkgship installdep
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 0 0 0 "Seconde query time less than first time."
  CHECK_RESULT 1 0 0 "Seconde query time does't less than first time."
```

#### oe_test_pkgship_query_installdep_service_3

- 描述：Test multi process execution of pkgship  installdep 30 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "No limit while concurrency query list more than 20."
```

#### oe_test_pkgship_query_installdep_service_4

- 描述：Test multi process execution of pkgship installde 18 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Query list failed."
```

#### oe_test_pkgship_query_list_service_1

- 描述：pkgship list and restart service
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "Search the result failed."
```

#### oe_test_pkgship_query_list_service_3

- 描述：Test multi process execution of pkgship list 100 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "No limit while concurrency query list more than 20."
```

#### oe_test_pkgship_query_list_service_4

- 描述：Test multi process execution of pkgship list 18 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Query list failed."
```

#### oe_test_pkgship_query_pkginfo_service_1

- 描述：pkgship pkginfo and restart service
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "Search th result failed."
  CHECK_RESULT $? 0 0 "Search th result failed."
```

#### oe_test_pkgship_query_pkginfo_service_2

- 描述：Test the execution time of pkgship pkginfo
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 0 0 0 "Seconde query time less than first time."
  CHECK_RESULT 1 0 0 "Seconde query time does't less than first time."
```

#### oe_test_pkgship_query_pkginfo_service_3

- 描述：Test multi process execution of pkgship pkginfo 100 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "No limit while concurrency query pkginfo coreutils more than 20."
```

#### oe_test_pkgship_query_pkginfo_service_4

- 描述：Test multi process execution of pkgship pkginfo 18 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Query pkginfo git-daemon failed."
```

#### oe_test_pkgship_query_selfdepend_service_1

- 描述：pkgship selfdepend and restart service
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "Search th result failed."
```

#### oe_test_pkgship_query_selfdepend_service_2

- 描述：Test the execution time of pkgship selfdepend
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 0 0 0 "Seconde query time less than first time."
  CHECK_RESULT 1 0 0 "Seconde query time does't less than first time."
```

#### oe_test_pkgship_query_selfdepend_service_3

- 描述：Test multi process execution of pkgship selfdepend 30 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "No limit while concurrency query list more than 20."
```

#### oe_test_pkgship_query_selfdepend_service_4

- 描述：Test multi process execution of pkgship selfdepend 18 times
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Query list failed."
```

#### oe_test_pkgship_service_down

- 描述：Close pkgship service
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Init db unexpectly while pkgship down."
  CHECK_RESULT $? 0 0 "Query list unexpectly while pkgship down."
  CHECK_RESULT $? 0 0 "Query pkginfo unexpectly while pkgship down."
  CHECK_RESULT $? 0 0 "Query installdep unexpectly while pkgship down."
  CHECK_RESULT $? 0 0 "Query builddep unexpectly while pkgship down."
  CHECK_RESULT $? 0 0 "Query selfdepend unexpectly while pkgship down."
  CHECK_RESULT $? 0 0 "Query bedepend unexpectly while pkgship down."
```

#### oe_test_pkgship_service_down_ES

- 描述：Close ES service
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Query list unexpectly while ES down."
  CHECK_RESULT $? 0 0 "Query pkginfo unexpectly while ES down."
  CHECK_RESULT $? 0 0 "Query installdep unexpectly while ES down."
  CHECK_RESULT $? 0 0 "Query builddep unexpectly while ES down."
  CHECK_RESULT $? 0 0 "Query selfdepend unexpectly while ES down."
  CHECK_RESULT $? 0 0 "Query bedepend unexpectly while ES down."
```

- 涉及命令：kill×1

#### oe_test_pkgship_service_down_redis

- 描述：Close redis service
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Query list failed while redis down."
  CHECK_RESULT $? 0 0 "Query pkginfo failed while redis down."
  CHECK_RESULT $? 0 0 "Query installdep failed while redis down."
  CHECK_RESULT $? 0 0 "Query builddep failed while redis down."
  CHECK_RESULT $? 0 0 "Query selfdepend failed while redis down."
  CHECK_RESULT $? 0 0 "Query bedepend failed while redis down."
```

- 涉及命令：kill×1

#### oe_test_pkgship_set_ES_security

- 描述：Set ES security
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Query dbs unexpectly while ES sets security."
  CHECK_RESULT $? 0 0 "Query list unexpectly while ES sets security."
  CHECK_RESULT $? 0 0 "Query pkginfo unexpectly while ES sets security."
  CHECK_RESULT $? 0 0 "Query installdep unexpectly while ES sets security."
  CHECK_RESULT $? 0 0 "Query builddep unexpectly while ES sets security."
  CHECK_RESULT $? 0 0 "Query selfdepend unexpectly while ES sets security."
  CHECK_RESULT $? 0 0 "Query bedepend unexpectly while ES sets security."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set es security"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set es security"
```

- 涉及命令：kill×1, journalctl×1
