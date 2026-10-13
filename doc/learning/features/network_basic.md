# network_basic

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/network-test/network_basic` |
| 注册用例数 | 18 |
| 环境约束 | machine num = 2；add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_act_arp | Check arp | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_act_route | Act route to add/delete/check | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_change_config_hostname | Modify config file to change hostname | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_change_hostname | Change hostname | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_check_arp | Check arp | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_check_pci | Check pci | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_check_route | Check route | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_ethtool_config | Check ping ip | pre_test/run_test | 8 |  |  |  |
| oe_test_ethtool_info | Check ping ip | run_test | 3 |  |  |  |
| oe_test_ifconfig | Check ifconfig | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_iperf | Check iperf3 | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_netstat_port | Check netstat | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_network_manager_service | Check NetworkManager service | run_test/post_test | 4 |  |  |  |
| oe_test_ping | Check ping ip | run_test | 1 |  |  |  |
| oe_test_tcpdump | Check tcpdump | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_traceroute | Check traceroute | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_wget | Check ping ip | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_check_nslookup | Check nslookup | run_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_act_arp

- 描述：Check arp
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Add mac failed."
  CHECK_RESULT $? 0 0 "Check mac added failed."
  CHECK_RESULT $? 0 0 "Delete arp failed."
  CHECK_RESULT $? 1 0 "Check mac deleted failed."
```

- 涉及命令：arp×4

#### oe_test_act_route

- 描述：Act route to add/delete/check
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Add route failed."
  CHECK_RESULT $? 0 0 "Check ${new_route} added failed."
  CHECK_RESULT $? 0 0 "Delete route failed."
  CHECK_RESULT $? 1 0 "Check ${new_route} deleted failed."
```

- 涉及命令：route×2

#### oe_test_change_config_hostname

- 描述：Modify config file to change hostname
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Write /etc/hostname config failed."
  CHECK_RESULT $? 0 0 "Check hostname failed."
  CHECK_RESULT $? 0 0 "Check hostname failed after reboot."
```

#### oe_test_change_hostname

- 描述：Change hostname
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Change hostname failed."
  CHECK_RESULT $? 0 0 "Check hostname failed."
  CHECK_RESULT $? 1 0 "The hostname is still remained."
```

#### oe_test_check_arp

- 描述：Check arp
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check arp failed."
```

- 涉及命令：arp×1

#### oe_test_check_pci

- 描述：Check pci
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check lspci failed."
```

#### oe_test_check_route

- 描述：Check route
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check nic failed."
```

#### oe_test_ethtool_config

- 描述：Check ping ip
- 函数：`pre_test, run_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Set ${test_nic}: speed 10 failed."
  CHECK_RESULT $? 0 0 "Set ${test_nic}: speed 100 failed."
  CHECK_RESULT $? 0 0 "Set ${test_nic}: speed 1000 failed."
  CHECK_RESULT $? 0 0 "Set ${test_nic}: autoneg off failed."
  CHECK_RESULT $? 0 0 "Set ${test_nic}: duplex half failed."
  CHECK_RESULT $? 0 0 "Set ${test_nic}: duplex full failed."
  CHECK_RESULT $? 0 0 "Set ${test_nic}: autoneg on failed."
  CHECK_RESULT $? 0 0 "Reset ${test_nic} failed."
```

- 涉及命令：ethtool×8

#### oe_test_ethtool_info

- 描述：Check ping ip
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check basic settings for ${NODE1_NIC} failed."
  CHECK_RESULT $? 0 0 "Check info for ${NODE1_NIC} failed."
  CHECK_RESULT $? 0 0 "get send and receive pkg from ${NODE1_NIC} failed."
```

- 涉及命令：ethtool×2

#### oe_test_ifconfig

- 描述：Check ifconfig
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check ip failed."
  CHECK_RESULT $? 0 0 "Check nic failed."
```

#### oe_test_iperf

- 描述：Check iperf3
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Start iperf3 tcp server failed."
  CHECK_RESULT $? 0 0 "Check tcp failed."
  CHECK_RESULT $? 0 0 "Check udp failed."
```

- 涉及命令：iperf3×2

#### oe_test_netstat_port

- 描述：Check netstat
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check nic failed."
  CHECK_RESULT $? 0 0 "Check lo net failed."
```

- 涉及命令：netstat×2

#### oe_test_network_manager_service

- 描述：Check NetworkManager service
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Start NetworkManager service failed."
  CHECK_RESULT $? 0 0 "Check NetworkManager service status failed."
  CHECK_RESULT $? 0 0 "Stop NetworkManager service failed."
  CHECK_RESULT $? 0 0 "Check  NetworkManager service status failed."
```

#### oe_test_ping

- 描述：Check ping ip
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "ping ip failed."
```

- 涉及命令：ping×1

#### oe_test_tcpdump

- 描述：Check tcpdump
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check tcpdump failed."
```

- 涉及命令：tcpdump×1

#### oe_test_traceroute

- 描述：Check traceroute
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check traceroute failed."
  CHECK_RESULT $? 0 0 "Check traceroute url failed."
```

- 涉及命令：traceroute×2

#### oe_test_wget

- 描述：Check ping ip
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "wget file failed."
  CHECK_RESULT $? 0 0 "get file failed."
```

- 涉及命令：test×1

#### oe_test_check_nslookup

- 描述：Check nslookup
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check domain Server failed."
  CHECK_RESULT $? 0 0 "Check domain Address failed."
  CHECK_RESULT $? 0 0 "Check domain Address failed."
```
