# spice-vdagent

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/spice-vdagent` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_spice-vdagentd | Test spice-vdagentd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_spice-vdagentd | 测试服务状态 | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_spice-vdagentd

- 描述：Test spice-vdagentd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_spice-vdagentd

- 描述：测试服务状态
- 函数：`pre_test, run_test, post_test`