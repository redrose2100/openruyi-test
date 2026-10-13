# easymock

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/easymock` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_easymock_junit4 | Easymock combined with Maven to simulate the unimplemented interface | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_easymock_order_abnormal | The order in which the mock object methods are actually called is not consistent with the set order | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_set_parms | Easymock on parameter matching of numbers | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_spring | Easymock combined with spring to simulate an unimplemented class | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_easymock_createNiceMock | Test interface functions:EasyMock.createNiceMock() | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_junit5 | Easymock with JUnit5 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_easymock_parms_abnormal | The parameters of the actual call to the mock object method do not match the parameters set | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_simulate_interface | Easymock simulates unimplemented interfaces and uses JUnit assertion to verify the return value of mock object method | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_frequency_abnormal | The number of actual calls to the mock object method is inconsistent with the set number | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_mock_abnormal | Test interface functions:MocksControl.andThrow(Throwable throwable) and EasyMock.anyObject() | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_parms_match | Test interface functions:EasyMock.aryEq(X value) and same(X value) | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_easymock_simulate_object | easymock simulates multiple complex objects | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_easymock_junit4

- 描述：Easymock combined with Maven to simulate the unimplemented interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_easymock_order_abnormal

- 描述：The order in which the mock object methods are actually called is not consistent with the set order
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_easymock_set_parms

- 描述：Easymock on parameter matching of numbers
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_easymock_spring

- 描述：Easymock combined with spring to simulate an unimplemented class
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, javac×1, java×1

#### oe_test_easymock_createNiceMock

- 描述：Test interface functions:EasyMock.createNiceMock()
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_easymock_junit5

- 描述：Easymock with JUnit5
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_easymock_parms_abnormal

- 描述：The parameters of the actual call to the mock object method do not match the parameters set
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_easymock_simulate_interface

- 描述：Easymock simulates unimplemented interfaces and uses JUnit assertion to verify the return value of mock object method
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_easymock_frequency_abnormal

- 描述：The number of actual calls to the mock object method is inconsistent with the set number
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_easymock_mock_abnormal

- 描述：Test interface functions:MocksControl.andThrow(Throwable throwable) and EasyMock.anyObject()
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_easymock_parms_match

- 描述：Test interface functions:EasyMock.aryEq(X value) and same(X value)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_easymock_simulate_object

- 描述：easymock simulates multiple complex objects
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```
