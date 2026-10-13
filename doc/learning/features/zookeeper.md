# zookeeper

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/zookeeper` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_zookeeper | Test zookeeper.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_zookeeper | Command zookeeper | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_zookeeper

- 描述：Test zookeeper.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "zookeeper.service reload failed"
  CHECK_RESULT $? 0 0 "zookeeper.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_zookeeper

- 描述：Command zookeeper
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "start failed." 1
  CHECK_RESULT $? 0 0 "get status failed." 1
  CHECK_RESULT $? 0 0 "stop failed." 1
  CHECK_RESULT $? 0 0 "get status failed." 1
  CHECK_RESULT $? 0 0 "stop failed." 1
```

- 涉及命令：sed×1, mkdir×1
