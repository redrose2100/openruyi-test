# erlang

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/erlang` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_epmd | Test epmd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_epmd | Test epmd.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_erlang_01 | erlang command testing | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_erlang_02 | erlang command testing | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_epmd

- 描述：Test epmd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_epmd

- 描述：Test epmd.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_erlang_01

- 描述：erlang command testing
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get Erlang version"
  CHECK_RESULT $? 0 0 "Failed to perform list operations"
  CHECK_RESULT $? 0 0 "List operation output mismatch"
  CHECK_RESULT $? 0 0 "Failed to run IO formatting"
  CHECK_RESULT $? 0 0 "Output file doesn't contain expected text"
  CHECK_RESULT $? 0 0 "Output file is empty"
  CHECK_RESULT $? 0 0 "Failed to perform arithmetic operations"
  CHECK_RESULT $? 0 0 "Arithmetic result mismatch"
```

- 涉及命令：erl×3, grep×2

#### oe_test_erlang_02

- 描述：erlang command testing
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to perform list operations"
  CHECK_RESULT $? 0 0 "List operation output mismatch"
  CHECK_RESULT $? 0 0 "Failed to spawn process"
  CHECK_RESULT $? 0 0 "Failed to test BIF functions"
  CHECK_RESULT $? 0 0 "Node information not as expected"
  CHECK_RESULT $? 0 0 "Failed to get system information"
  CHECK_RESULT $? 0 0 "Failed to test tuple operations"
  CHECK_RESULT $? 0 0 "Tuple operation output mismatch"
```

- 涉及命令：erl×1, pgrep×1
