# smoke-oeaware

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-oeaware` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| plugin_load_test | oeAware test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| plugin_remove_test | oeAware test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| plugin_query_test | oeAware test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| plugin_list_test | oeAware test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| plugin_install_test | oeAware test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| plugin_enable_test | oeAware test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| plugin_disable_test | oeAware test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| plugin_query_dep_test | oeAware test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### plugin_load_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$test1" "Plugin loaded failed, because plugin file does not exist." 0 "test1 failed"
  CHECK_RESULT "$test2" "Plugin loaded failed, because plugin already loaded." 0 "test2 failed"
  CHECK_RESULT "$test3" "Plugin loaded failed, because file is not a plugin file." 0 "test3 failed"
  CHECK_RESULT "$test4" "Plugin remove successfully." 0 "test4 failed"
  CHECK_RESULT "$test5" "Plugin loaded successfully." 0 "test5 failed"
  CHECK_RESULT "$test6" "libsystem_tune.so" 0 "test6 failed"
```

#### plugin_remove_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$test1" "Plugin remove failed, because plugin does not exist." 0 "test1 failed"
  CHECK_RESULT "$test2" "Plugin remove successfully." 0 "test2 failed"
  CHECK_RESULT "$test3" "Plugin remove successfully." 0 "test3 failed"
```

#### plugin_query_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$test1" "Plugin query failed, because plugin does not exist." 0 "test1 failed"
  CHECK_RESULT "$test2" "libsystem_collector.so" 0 "test2 failed"
  CHECK_RESULT "$test2" "	thread_collector(available, close, count: 0)" 0 "test2 failed"
  CHECK_RESULT "$test3" "libsystem_tune.so" 0 "test3 failed"
  CHECK_RESULT "$test3" "libthread_scenario.so" 0 "test3 failed"
  CHECK_RESULT "$test3" "libsystem_collector.so" 0 "test3 failed"
```

#### plugin_list_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT "$test1" "numafast" 0 "test1 failed"
  CHECK_RESULT "$test2" "libsystem_collector.so" 0 "test2 failed"
  CHECK_RESULT "$test3" "libthread_scenario.so" 0 "test3 failed"
  CHECK_RESULT "$test4" "libsystem_tune.so" 0 "test4 failed"
  CHECK_RESULT "$test5" "libpmu.so" 0 "test5 failed"
```

#### plugin_install_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$test1" "Download failed, because download not found: test" 0 "test1 failed"
  CHECK_RESULT $? 0 0 "Download numafast failed"
```

- 涉及命令：oeawarectl×1

#### plugin_enable_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "thread_collector plugin enable failed"
  CHECK_RESULT $? 0 0 "thread_collector plugin repeat enable failed"
  CHECK_RESULT $? 0 0 "test plugin enable failed"
  CHECK_RESULT $? 0 0 "stealtask_tune plugin enable failed"
  CHECK_RESULT $? 0 0 "stealtask_tune plugin enable failed"
```

- 涉及命令：oeawarectl×5

#### plugin_disable_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$test1" "Instance disabled failed, because instance is not loaded." 0 "test1 failed"
  CHECK_RESULT "$test2" "Instance disabled failed, because instance is already disabled." 0 "test2 failed"
  CHECK_RESULT "$test3" "Instance disabled successfully." 0 "test3 failed"
```

- 涉及命令：oeawarectl×1

#### plugin_query_dep_test

- 描述：oeAware test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$test1" "Query instance dependencies failed, because instance does not exist." 0 "test1 failed"
  CHECK_RESULT "$test2" "Generate dependencies graph dep.png." 0 "test2 failed"
  CHECK_RESULT "$test3" "Generate dependencies graph dep.png." 0 "test3 failed"
```
