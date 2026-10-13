# targetcli

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/targetcli` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_targetcli_01 | verify the uasge of targetcli command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_targetcli_02 | verify the uasge of targetcli command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_targetcli_03 | verify the uasge of targetcli command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_targetcli_04 | verify the uasge of targetcli command | pre_test/run_test/post_test | 46 | ✔ |  |  |
| oe_test_socket_targetclid | Test targetclid.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_targetclid | Test targetclid.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_targetcli_01

- 描述：verify the uasge of targetcli command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：grep×2

#### oe_test_targetcli_02

- 描述：verify the uasge of targetcli command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×3

#### oe_test_targetcli_03

- 描述：verify the uasge of targetcli command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×6

#### oe_test_targetcli_04

- 描述：verify the uasge of targetcli command
- 函数：`pre_test, run_test, post_test`
- 断言（46 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 46 条（其余见源脚本）
```

- 涉及命令：grep×1

#### oe_test_socket_targetclid

- 描述：Test targetclid.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_targetclid

- 描述：Test targetclid.service restart
- 函数：`pre_test, run_test, post_test`