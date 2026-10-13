# haproxy

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/haproxy` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_haproxy | Test haproxy.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_haproxy01 | Test haproxy.service restart | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_haproxy

- 描述：Test haproxy.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "haproxy.service reload failed"
  CHECK_RESULT $? 0 0 "haproxy.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_haproxy01

- 描述：Test haproxy.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "haproxy.service disable failed"
  CHECK_RESULT $? 0 0 "haproxy.service disable failed to change status to disabled"
  CHECK_RESULT $? 0 0 "haproxy.service enable failed"
  CHECK_RESULT $? 0 0 "haproxy.service enable failed to change status to enabled"
  CHECK_RESULT $? 0 0 "haproxy configuration file syntax error"
  CHECK_RESULT $? 0 0 "haproxy.service failed to record logs properly"
```

- 涉及命令：haproxy×1, journalctl×1, sed×1
