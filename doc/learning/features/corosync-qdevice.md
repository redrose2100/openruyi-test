# corosync-qdevice

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/corosync-qdevice` |
| 注册用例数 | 2 |
| 环境约束 | machine num = 3；machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_corosync-qdevice | Test corosync-qdevice.service restart | pre_test/run_test/post_test | 0 | ✔ | ✔ |  |
| oe_test_service_corosync-qnetd | Test corosync-qnetd.service restart | pre_test/run_test/post_test | 0 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_service_corosync-qdevice

- 描述：Test corosync-qdevice.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_corosync-qnetd

- 描述：Test corosync-qnetd.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：corosync-qnetd-certutil×1
