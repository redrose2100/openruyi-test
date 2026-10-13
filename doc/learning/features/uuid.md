# uuid

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/uuid` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_uuid_1 | Test uuid command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_uuid_2 | command test uuid | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_uuid_1

- 描述：Test uuid command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：uuid×11

#### oe_test_uuid_2

- 描述：command test uuid
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Err:uuid"
  CHECK_RESULT $? 0 0 "Err:uuid -v1"
  CHECK_RESULT $? 0 0 "Err:uuid -v3 ns:URL https://kernel.org"
  CHECK_RESULT $? 0 0 "Err:uuid -v4"
  CHECK_RESULT $? 0 0 "Err:uuid -v5 ns:URL https://kernel.org"
  CHECK_RESULT $? 0 0 "Err:uuid -m"
  CHECK_RESULT $? 0 0 "Err:uuid -n2"
  CHECK_RESULT $? 0 0 "Err:uuid -n3 -1"
  CHECK_RESULT $? 0 0 "Err:uuid -F bin"
  CHECK_RESULT $? 0 0 "Err:uuid -F str"
  CHECK_RESULT $? 0 0 "Err:uuid -F siv"
  CHECK_RESULT $? 0 0 "Err:uuid -o 1.txt"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：uuid×12
