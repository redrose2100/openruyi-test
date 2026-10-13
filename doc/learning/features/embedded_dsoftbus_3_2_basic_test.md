# embedded_dsoftbus_3_2_basic_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/dsoftbus_3_2_basic_test` |
| 注册用例数 | 19 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_PublishServiceInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_UnPublishServiceInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_DiscoveryInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_StopDiscoveryInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_GetAllNodeDeviceInfoInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_FreeNodeInfoInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_CreateSessionServerInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_RemoveSessionServerInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_OpenSessionInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_CloseSessionInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_CloseSessionInterface_002 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_SendBytesInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_SendMessageInterface_001 | Test dsoftbus interface | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_FunctionDiscovery_001 | Test dsoftbus function | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_FunctionNetwork_002 | Test dsoftbus function | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_FunctionNetwork_003 | Test dsoftbus function | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_FunctionSession_004 | Test dsoftbus function | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_FunctionTransmission_005 | Test dsoftbus function | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_FunctionTransmission_006 | Test dsoftbus function | pre_test/run_test/post_test | 1 |  | ✔ |  |

### 断言与命令明细

#### oe_test_PublishServiceInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the PublishServiceInterface_001 test case."
```

#### oe_test_UnPublishServiceInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the UnPublishServiceInterface_001 test case."
```

#### oe_test_DiscoveryInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the DiscoveryInterface_001 test case."
```

#### oe_test_StopDiscoveryInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the StopDiscoveryInterface_001 test case."
```

#### oe_test_GetAllNodeDeviceInfoInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the GetAllNodeDeviceInfoInterface_001 test case."
```

#### oe_test_FreeNodeInfoInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the FreeNodeInfoInterface_001 test case."
```

#### oe_test_CreateSessionServerInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the CreateSessionServerInterface test case."
```

#### oe_test_RemoveSessionServerInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the RemoveSessionServerInterface test case."
```

#### oe_test_OpenSessionInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute the OpenSessionInterface_001 test case."
```

#### oe_test_CloseSessionInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "CloseSessionInterface_001 fail"
```

#### oe_test_CloseSessionInterface_002

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "CloseSessionInterface_002 fail"
```

#### oe_test_SendBytesInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "SendBytesInterface_001 fail"
```

#### oe_test_SendMessageInterface_001

- 描述：Test dsoftbus interface
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "SendMessageInterface_001 fail"
```

#### oe_test_FunctionDiscovery_001

- 描述：Test dsoftbus function
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "FunctionDiscovery_001 fail"
```

#### oe_test_FunctionNetwork_002

- 描述：Test dsoftbus function
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "FunctionNetwork_002 fail"
```

#### oe_test_FunctionNetwork_003

- 描述：Test dsoftbus function
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "FunctionNetwork_003 fail"
```

#### oe_test_FunctionSession_004

- 描述：Test dsoftbus function
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "FunctionSession_004 fail"
```

#### oe_test_FunctionTransmission_005

- 描述：Test dsoftbus function
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "FunctionTransmission_005 fail"
```

#### oe_test_FunctionTransmission_006

- 描述：Test dsoftbus function
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "FunctionTransmission_006 fail"
```
