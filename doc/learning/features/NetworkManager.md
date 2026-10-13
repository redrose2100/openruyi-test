# NetworkManager

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/NetworkManager` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_NetworkManager-dispatcher | Test NetworkManager-dispatcher.service restart | run_test | 0 |  |  |  |
| oe_test_service_NetworkManager | Test NetworkManager.service restart | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_service_NetworkManager-wait-online | Test NetworkManager-wait-online.service restart | run_test | 0 |  |  |  |
| oe_test_service_nm-cloud-setup | Test nm-cloud-setup.service restart | pre_test/run_test | 0 |  |  |  |
| oe_test_libnetfilter_conntrack | the function of libnetfilter_conntrack | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_nmcli_config_invalid_static_IP | Verify nmcli rejects invalid static IP configuration | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_NetworkManager-dispatcher

- 描述：Test NetworkManager-dispatcher.service restart
- 函数：`run_test`
#### oe_test_service_NetworkManager

- 描述：Test NetworkManager.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2, grep×1

#### oe_test_service_NetworkManager-wait-online

- 描述：Test NetworkManager-wait-online.service restart
- 函数：`run_test`
#### oe_test_service_nm-cloud-setup

- 描述：Test nm-cloud-setup.service restart
- 函数：`pre_test, run_test`
#### oe_test_libnetfilter_conntrack

- 描述：the function of libnetfilter_conntrack
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "compile test_api"
  CHECK_RESULT $? 0 0 "test_api run"
  CHECK_RESULT "$(cat test_api.log |grep -v ^== |grep -v OK |wc -l)" "0" 0 "check log of test_api"
```

- 涉及命令：test×5, gcc×1

#### oe_test_nmcli_config_invalid_static_IP

- 描述：Verify nmcli rejects invalid static IP configuration
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "nmcli should reject invalid IPv4 address 300.0.2.100/24"
  CHECK_RESULT $? 0 1 "connection ${con_name_1} must not be created after invalid IPv4 input"
  CHECK_RESULT $? 0 1 "nmcli should reject invalid prefix length 99"
  CHECK_RESULT $? 0 1 "connection ${con_name_2} must not be created after invalid prefix input"
```
