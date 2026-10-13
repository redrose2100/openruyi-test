# nvmetcli

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nvmetcli` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_nvmet | Test nvmet.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nvmf-connect-nbft | Test nvmf-connect-nbft.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nvmf-autoconnect | Test nvmf-autoconnect.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nvmefc-boot-connections | Test nvmefc-boot-connections.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_nvmf-connect | Test nvmf-connect.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_nvmet

- 描述：Test nvmet.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nvmf-connect-nbft

- 描述：Test nvmf-connect-nbft.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nvmf-autoconnect

- 描述：Test nvmf-autoconnect.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nvmefc-boot-connections

- 描述：Test nvmefc-boot-connections.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：modprobe×1

#### oe_test_target_nvmf-connect

- 描述：Test nvmf-connect.target restart
- 函数：`pre_test, run_test, post_test`