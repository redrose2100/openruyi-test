# abseil-cpp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/abseil-cpp` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_abseil-cpp_basic | abseil-cpp installation and logging test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_abseil-cpp_strings | abseil-cpp strings, status, flags test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_abseil-cpp_hash | abseil-cpp hash and random test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_abseil-cpp_synchronization | abseil-cpp synchronization test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_abseil-cpp_time | abseil-cpp time and timezone test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_abseil-cpp_cord | abseil-cpp cord, span, any test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_abseil-cpp_container | abseil-cpp container and int128 test | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_abseil-cpp_basic

- 描述：abseil-cpp installation and logging test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "abseil-cpp package not installed"
  CHECK_RESULT $? 0 0 "libabsl_base library not found"
  CHECK_RESULT $? 0 0 "libabsl_log_sink library not found"
  CHECK_RESULT $? 0 0 "abseil-cpp library count is less than expected: $lib_count"
  CHECK_RESULT $? 0 0 "abseil-cpp documentation not found"
  CHECK_RESULT $? 0 0 "abseil-cpp license not found"
  CHECK_RESULT $? 0 0 "Failed to compile logging test"
  CHECK_RESULT $? 0 0 "Logging test failed"
```

- 涉及命令：ldconfig×2, rpm×1

#### oe_test_abseil-cpp_strings

- 描述：abseil-cpp strings, status, flags test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile string_view test"
  CHECK_RESULT $? 0 0 "string_view test failed"
  CHECK_RESULT $? 0 0 "Failed to compile strings test"
  CHECK_RESULT $? 0 0 "strings test failed"
  CHECK_RESULT $? 0 0 "Failed to compile status test"
  CHECK_RESULT $? 0 0 "Status test failed"
  CHECK_RESULT $? 0 0 "Failed to compile StatusOr test"
  CHECK_RESULT $? 0 0 "StatusOr test failed"
  CHECK_RESULT $? 0 0 "Failed to compile flags test"
  CHECK_RESULT $? 0 0 "flags test failed"
```

#### oe_test_abseil-cpp_hash

- 描述：abseil-cpp hash and random test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile hash test"
  CHECK_RESULT $? 0 0 "Hash test failed"
  CHECK_RESULT $? 0 0 "Failed to compile random test"
  CHECK_RESULT $? 0 0 "Random test failed"
```

#### oe_test_abseil-cpp_synchronization

- 描述：abseil-cpp synchronization test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile mutex test"
  CHECK_RESULT $? 0 0 "Mutex test failed"
  CHECK_RESULT $? 0 0 "Failed to compile notification test"
  CHECK_RESULT $? 0 0 "Notification test failed"
```

#### oe_test_abseil-cpp_time

- 描述：abseil-cpp time and timezone test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile time test"
  CHECK_RESULT $? 0 0 "Time test failed"
  CHECK_RESULT $? 0 0 "Failed to compile timezone test"
  CHECK_RESULT $? 0 0 "TimeZone test failed"
```

#### oe_test_abseil-cpp_cord

- 描述：abseil-cpp cord, span, any test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile Cord test"
  CHECK_RESULT $? 0 0 "Cord test failed"
  CHECK_RESULT $? 0 0 "Failed to compile Span test"
  CHECK_RESULT $? 0 0 "Span test failed"
  CHECK_RESULT $? 0 0 "Failed to compile any test"
  CHECK_RESULT $? 0 0 "any test failed"
```

#### oe_test_abseil-cpp_container

- 描述：abseil-cpp container and int128 test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile HashMap test"
  CHECK_RESULT $? 0 0 "HashMap test failed"
  CHECK_RESULT $? 0 0 "Failed to compile HashSet test"
  CHECK_RESULT $? 0 0 "HashSet test failed"
  CHECK_RESULT $? 0 0 "Failed to compile int128 test"
  CHECK_RESULT $? 0 0 "int128 test failed"
```
