# virtCCA_sdk

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/virtCCA_sdk` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_virtcca-computer | Test virtcca-compute.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_virtcca-guest-agent | Test virtcca-guest-agent.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_virtcca-manager | Test virtcca-manager.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_virtcca-computer

- 描述：Test virtcca-compute.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×1

#### oe_test_service_virtcca-guest-agent

- 描述：Test virtcca-guest-agent.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×1

#### oe_test_service_virtcca-manager

- 描述：Test virtcca-manager.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×1
