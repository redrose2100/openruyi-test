# network_virtual

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/network-test/network_virtual` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_check_tuntap_support | Check kernel support for tun/tap | run_test | 2 |  |  |  |
| oe_test_config_tun | Create tap service to start | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_create_tap | Create tap by tunctl | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_create_tun | Create tun by tunctl | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ip_tuntap_create_tap | Check ip tuntap | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ip_tuntap_create_tun | Create tap by ip tuntap | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_modprobe_tun | tunctl only for x86 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_send_data_by_tun | Send data to test tun | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_veth_config | Create namespace and veth | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_veth_connect_bridge | Connect two netns by bridge | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_veth_create | Create namespace and veth | run_test | 9 |  |  |  |

### 断言与命令明细

#### oe_test_check_tuntap_support

- 描述：Check kernel support for tun/tap
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The kernel doesn't suppor tun."
  CHECK_RESULT $? 0 0 "The kernel doesn't suppor tap."
```

#### oe_test_config_tun

- 描述：Create tap service to start
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Start config_tap failed."
  CHECK_RESULT $? 0 0 "Check config_tap start failed."
  CHECK_RESULT $? 0 0 "Restart config_tap failed."
  CHECK_RESULT $? 0 0 "Check config_tap restart failed."
  CHECK_RESULT $? 0 0 "Stop config_tap failed."
  CHECK_RESULT $? 0 0 "Check config_tap stop failed."
```

- 涉及命令：rpm×3

#### oe_test_create_tap

- 描述：Create tap by tunctl
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Create tap0 failed."
  CHECK_RESULT $? 0 0 "Check tap0 failed."
  CHECK_RESULT $? 0 0 "Create tap1 for testuser failed."
  CHECK_RESULT $? 0 0 "Check tap1 failed."
  CHECK_RESULT $? 0 0 "Delete tap0 failed."
  CHECK_RESULT $? 0 0 "Delete tap1 failed."
  CHECK_RESULT $? 1 0 "Check tap is deleted failed."
```

- 涉及命令：rpm×3, tunctl×3

#### oe_test_create_tun

- 描述：Create tun by tunctl
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Create tun failed."
  CHECK_RESULT $? 0 0 "Check tun0 failed."
  CHECK_RESULT $? 0 0 "Add ip for tun0 failed."
  CHECK_RESULT $? 0 0 "Add host for tun0 failed."
  CHECK_RESULT $? 0 0 "Delete tun failed."
  CHECK_RESULT $? 1 0 "Check tun0 failed."
```

- 涉及命令：rpm×3, tunctl×2

#### oe_test_ip_tuntap_create_tap

- 描述：Check ip tuntap
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ip support tuntap failed."
  CHECK_RESULT $? 0 0 "Check ip tuntap help failed."
  CHECK_RESULT $? 0 0 "Add ip for tap0 failed."
  CHECK_RESULT $? 0 0 "Up tap0 failed."
  CHECK_RESULT $? 0 0 "Add route for tap0 failed."
  CHECK_RESULT $? 0 0 "Add route for tap0 failed."
  CHECK_RESULT $? 0 0 "Delete tap0 failed."
  CHECK_RESULT $? 0 1 "Delete tap0 failed."
```

#### oe_test_ip_tuntap_create_tun

- 描述：Create tap by ip tuntap
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Add ip for tun0 failed."
  CHECK_RESULT $? 0 0 "Up tun0 failed."
  CHECK_RESULT $? 0 0 "Add route for tun0 failed."
  CHECK_RESULT $? 0 0 "Add route for tun0 failed."
  CHECK_RESULT $? 0 0 "Delete tun0 failed."
  CHECK_RESULT $? 0 1 "Delete tun0 failed."
```

#### oe_test_modprobe_tun

- 描述：tunctl only for x86
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "modprobe tun failed."
  CHECK_RESULT $? 0 0 "Check mod tun failed."
  CHECK_RESULT $? 0 0 "Create tap failed."
  CHECK_RESULT $? 0 0 "Create tap failed."
  CHECK_RESULT $? 0 0 "Remove tap failed."
  CHECK_RESULT $? 1 0 "tap0 is removed failed."
```

- 涉及命令：rpm×3, grep×1, tunctl×1, modprobe×1

#### oe_test_send_data_by_tun

- 描述：Send data to test tun
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Create new tun failed."
  CHECK_RESULT $? 0 0 "Add ip for tun0 failed."
  CHECK_RESULT $? 0 0 "ip link set dev tun0 up failed."
  CHECK_RESULT $? 0 0 "ping tun0 failed."
  CHECK_RESULT $? 1 0 "The tun0 is deleted failed."
```

- 涉及命令：ping×1, pgrep×1, modprobe×1

#### oe_test_veth_config

- 描述：Create namespace and veth
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Add veth into namespace failed."
  CHECK_RESULT $? 0 0 "Add ip failed."
  CHECK_RESULT $? 2 0 "The netns veth can be ping unexpectly."
  CHECK_RESULT $? 0 0 "Check testveth01 in testns failed."
  CHECK_RESULT $? 0 0 "Open namespace bash failed."
```

- 涉及命令：ping×1

#### oe_test_veth_connect_bridge

- 描述：Connect two netns by bridge
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Create testveth01 failed."
  CHECK_RESULT $? 0 0 "Add br-testveth01 into bridge failed."
  CHECK_RESULT $? 0 0 "testns01 up failed."
  CHECK_RESULT $? 0 0 "Add ip1 failed."
  CHECK_RESULT $? 0 0 "Add route failed."
  CHECK_RESULT $? 0 0 "Ping ip1 failed."
  CHECK_RESULT $? 0 0 "Create testveth02 failed."
  CHECK_RESULT $? 0 0 "Add br-testveth02 into bridge failed."
  CHECK_RESULT $? 0 0 "testns02 up failed."
  CHECK_RESULT $? 0 0 "Add ip2 failed."
  CHECK_RESULT $? 0 0 "Add route failed."
  CHECK_RESULT $? 0 0 "Ping ip2 failed."
```

#### oe_test_veth_create

- 描述：Create namespace and veth
- 函数：`run_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Add namespace failed."
  CHECK_RESULT $? 0 0 "Check namespace failed."
  CHECK_RESULT $? 0 0 "Add testveth01,testveth02 failed."
  CHECK_RESULT $? 0 0 "Check testveth01 failed."
  CHECK_RESULT $? 0 0 "Check testveth02 failed."
  CHECK_RESULT $? 0 0 "Delete veth failed."
  CHECK_RESULT $? 1 0 "Check testveth01,testveth02 are deleted failed."
  CHECK_RESULT $? 0 0 "Delete testns failed."
  CHECK_RESULT $? 1 0 "Check namespace is deleted failed."
```
