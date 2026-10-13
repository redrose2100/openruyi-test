# sysfsutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sysfsutils` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_systools | systool command test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_systool_002 | File system common command oe_test_systools | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_systools

- 描述：systool command test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Systool help display failed"
  CHECK_RESULT $? 0 0 "systool information query failed"
  CHECK_RESULT $? 0 0 "Buses information query failed"
  CHECK_RESULT $? 0 0 "classes information query failed"
  CHECK_RESULT $? 0 0 "modules information query failed"
```

- 涉及命令：systool×4, grep×1

#### oe_test_systool_002

- 描述：File system common command oe_test_systools
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0  "Attributes do not exist"
  CHECK_RESULT $? 0 0  "Attributes do not exist"
  CHECK_RESULT $? 0 0  "dm_multipath do not exist"
```

- 涉及命令：systool×3
