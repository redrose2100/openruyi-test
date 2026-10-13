# powertop

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/powertop` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_powertop | Test powertop.service restart | pre_test/run_test | 2 |  |  |  |
| oe_test_powertop | package powertop test | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_powertop

- 描述：Test powertop.service restart
- 函数：`pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_powertop

- 描述：package powertop test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The system does not install powertop"
  CHECK_RESULT $? 0 0 "No file or directory"
  CHECK_RESULT $? 0 0 "No file or directory"
  CHECK_RESULT $? 0 0 "No file or directory"
```

- 涉及命令：rpm×1
