# cloud-init

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cloud-init` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_cloud-config | Test cloud-config.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_cloud-final | Test cloud-final.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_cloud-init-local | Test cloud-init-local.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_cloud-init | Test cloud-init.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_target_cloud-config | Test cloud-config.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_cloud-init | Test cloud-init.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_cloud-init-hotplugd | Test cloud-init-hotplugd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_cloud-init-hotplugd | Test cloud-init-hotplugd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_cloud-init-main | Test cloud-init-main.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_cloud-init-network | Test cloud-init-network.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_cloud-config

- 描述：Test cloud-config.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_cloud-final

- 描述：Test cloud-final.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_cloud-init-local

- 描述：Test cloud-init-local.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_cloud-init

- 描述：Test cloud-init.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed to configure cloud-init datasource."
```

- 涉及命令：sed×1

#### oe_test_target_cloud-config

- 描述：Test cloud-config.target restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_target_cloud-init

- 描述：Test cloud-init.target restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_cloud-init-hotplugd

- 描述：Test cloud-init-hotplugd.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_socket_cloud-init-hotplugd

- 描述：Test cloud-init-hotplugd.socket restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_cloud-init-main

- 描述：Test cloud-init-main.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_cloud-init-network

- 描述：Test cloud-init-network.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1
