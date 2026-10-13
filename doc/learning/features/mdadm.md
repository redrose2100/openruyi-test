# mdadm

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mdadm` |
| 注册用例数 | 4 |
| 环境约束 | add disk = 10,10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_mdmonitor | Test mdmonitor.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_service_mdcheck_continue | Test mdcheck_continue.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_mdcheck_start | Test mdcheck_start.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_mdmonitor-oneshot | Test mdmonitor-oneshot.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_mdmonitor

- 描述：Test mdmonitor.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "check mdadm state failed"
```

- 涉及命令：mdadm×3

#### oe_test_service_mdcheck_continue

- 描述：Test mdcheck_continue.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_mdcheck_start

- 描述：Test mdcheck_start.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_mdmonitor-oneshot

- 描述：Test mdmonitor-oneshot.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mdadm×1
