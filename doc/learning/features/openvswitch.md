# openvswitch

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openvswitch` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_openvswitch | Test openvswitch.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_ovsdb-server | Test ovsdb-server.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_ovs-vswitchd | Test ovs-vswitchd.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_ovn-controller | Test ovn-controller.service restart | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_service_ovn-northd | Test ovn-northd.service restart | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_service_ovn-controller-vtep | Test ovn-controller-vtep.service restart | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_service_openvswitch-ipsec | Test openvswitch-ipsec.service restart | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_service_ovs-delete-transient-ports | Test ovs-delete-transient-ports.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_openvswitch

- 描述：Test openvswitch.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_ovsdb-server

- 描述：Test ovsdb-server.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_ovs-vswitchd

- 描述：Test ovs-vswitchd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_ovn-controller

- 描述：Test ovn-controller.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
```

#### oe_test_service_ovn-northd

- 描述：Test ovn-northd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
```

#### oe_test_service_ovn-controller-vtep

- 描述：Test ovn-controller-vtep.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 "${service} restart failed"
  CHECK_RESULT $? 1 0 "${service} stop failed"
  CHECK_RESULT $? 1 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
```

- 涉及命令：grep×3, userdel×2

#### oe_test_service_openvswitch-ipsec

- 描述：Test openvswitch-ipsec.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 1 0 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
```

#### oe_test_service_ovs-delete-transient-ports

- 描述：Test ovs-delete-transient-ports.service restart
- 函数：`pre_test, run_test, post_test`