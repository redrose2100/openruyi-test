# junit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/junit` |
| 注册用例数 | 13 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_junit4_ant | Junit+ant integration testing | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_junit4_assert | Assertion interface function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_basic_annotation | Annotation class test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_compare_different_performances | Compare the performance of running multiple test classes with placing the test classes in the test suite,and using the TestSuite class from junit and run it. | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_junit4_execute_control | annotation class @Before+@After,@BeforeClass+AfterClass test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_expected | Use @Test combine its property "expected" to show the exception that we expected;use try/catch,and then use fail() to test if the corresponding operation have thrown the exception;except specifies the exception to be thrown,it can also shows the exception information when the exception to be thrown. | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_maven | Junit4+maven integration testing | pre_test/run_test/post_test | 2 | ✔ |  | 40m |
| oe_test_junit4_parameterized | When a text class needs to test multiple sets of data,configure the data,and then choose corresponding value. | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_performances | If it has specific performance standard for function and can be contained in the tests,also as a measure of whether the function is implemented or not,then @Test(timeout=xxx)can reach this goal.for example:it can tests the running time of calculating the fipolacci sequence function. | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_suite | Use @RunWith and @Suite nesting the test class | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_TestCase_api | @Test+TestCase class test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_TestResult_api |  | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit4_TestSuite_api | @Test+TestSuite class test | pre_test/run_test/post_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_junit4_ant

- 描述：Junit+ant integration testing
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "build failed."
```

#### oe_test_junit4_assert

- 描述：Assertion interface function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_basic_annotation

- 描述：Annotation class test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_compare_different_performances

- 描述：Compare the performance of running multiple test classes with placing the test classes in the test suite,and using the TestSuite class from junit and run it.
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "TestRunnerTotal's actual_result is not expected."
  CHECK_RESULT $? 0 0 "execute_java is not expected."
  CHECK_RESULT $? 0 0 "JunitTestSuite's actual_result is not expected."
```

- 涉及命令：grep×1

#### oe_test_junit4_execute_control

- 描述：annotation class @Before+@After,@BeforeClass+AfterClass test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_expected

- 描述：Use @Test combine its property "expected" to show the exception that we expected;use try/catch,and then use fail() to test if the corresponding operation have thrown the exception;except specifies the exception to be thrown,it can also shows the exception information when the exception to be thrown.
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_maven

- 描述：Junit4+maven integration testing
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "test build failed."
  CHECK_RESULT $? 0 0 "test2 build failed."
```

- 涉及命令：mvn×1

#### oe_test_junit4_parameterized

- 描述：When a text class needs to test multiple sets of data,configure the data,and then choose corresponding value.
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_performances

- 描述：If it has specific performance standard for function and can be contained in the tests,also as a measure of whether the function is implemented or not,then @Test(timeout=xxx)can reach this goal.for example:it can tests the running time of calculating the fipolacci sequence function.
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "actual_result is not expected."
```

#### oe_test_junit4_suite

- 描述：Use @RunWith and @Suite nesting the test class
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed"
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_TestCase_api

- 描述：@Test+TestCase class test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_TestResult_api

- 描述：
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "execute java failed."
```

#### oe_test_junit4_TestSuite_api

- 描述：@Test+TestSuite class test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "compile java failed."
  CHECK_RESULT $? 0 0 "JunitTestSuite execute java failed."
```
