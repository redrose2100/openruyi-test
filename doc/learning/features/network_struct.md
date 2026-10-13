# network_struct

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/network-test/network_struct` |
| 注册用例数 | 29 |
| 环境约束 | machine type = physical；machine num = 2；add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_add_ip | Add ip addr | pre_test/run_test | 4 |  |  |  |
| oe_test_bridge_create | Create net bridge | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bridge_create_by_config_reboot | Create net bridge in config file and reboot | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_bridge_create_reboot | Create net bridge and reboot | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_check_ip | Check ip in net | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_check_ip_route | Check ip route show | run_test | 2 |  |  |  |
| oe_test_check_network_status | Check network status | run_test | 5 |  |  |  |
| oe_test_check_tcp_udp | Check udp and tcp connection | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dns_set | Set DNS | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_icmp | Check icmp | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_icmp_change_config | Change icmp | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_ip_route_add | Check ip route set | pre_test/run_test | 4 |  |  |  |
| oe_test_ipv6_add | Add ipv6 | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ipv6_static_setting | Set static ipv6 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_lo | Check ifup/ifdown nic | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nic_change_mac | Change mac | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nic_change_queue | Change nic queue | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nic_check | Check pci | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nic_ifconfig | Check ifconfig nic | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nic_ifup | Check ifup/ifdown nic | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_nic_ip | Check ip link set nic | pre_test/run_test | 4 |  |  |  |
| oe_test_nic_nmcli | Check nmcli up/down nic | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_nic_queue | Check nic queue | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nic_scapy | Use scapy to | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_nic_work_format | Check nic work format | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_nmap_check | Check nmap | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nmap_open_port | Check open port | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nmap_up_down | Check nmcli up/down nic | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_ss | Check ss | run_test | 10 |  |  |  |

### 断言与命令明细

#### oe_test_add_ip

- 描述：Add ip addr
- 函数：`pre_test, run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Add ip addr failed."
  CHECK_RESULT $? 0 0 "Check add ip addr failed."
  CHECK_RESULT $? 0 0 "Delete ip addr failed."
  CHECK_RESULT $? 1 0 "Check delete ip addr failed."
```

#### oe_test_bridge_create

- 描述：Create net bridge
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Add brctl failed."
  CHECK_RESULT $? 0 0 "Add brctl with ${test_nic} failed."
  CHECK_RESULT $? 0 0 "Check brctl created failed."
  CHECK_RESULT $? 0 0 "Delete ${test_nic} from brctl failed."
  CHECK_RESULT $? 0 0 "Delete brctl failed."
  CHECK_RESULT $? 1 0 "Check brctl deleted failed."
```

#### oe_test_bridge_create_by_config_reboot

- 描述：Create net bridge in config file and reboot
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Create br0 config file failed."
  CHECK_RESULT $? 0 0 "Create test nic config file failed."
  CHECK_RESULT $? 0 0 "Add brctl failed."
  CHECK_RESULT $? 0 0 "Add brctl with ${test_nic} failed."
  CHECK_RESULT $? 0 0 "Check brctl created failed."
  CHECK_RESULT $? 0 0 "Check brctl reboot failed."
```

#### oe_test_bridge_create_reboot

- 描述：Create net bridge and reboot
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Add brctl failed."
  CHECK_RESULT $? 0 0 "Add brctl with ${NODE1_NIC} failed."
  CHECK_RESULT $? 0 0 "Check brctl created failed."
  CHECK_RESULT $? 1 0 "Check brctl deleted failed."
```

#### oe_test_check_ip

- 描述：Check ip in net
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check net space failed."
```

- 涉及命令：nmap×1

#### oe_test_check_ip_route

- 描述：Check ip route show
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check ip route show failed."
  CHECK_RESULT $? 0 0 "Check ip route show failed."
```

#### oe_test_check_network_status

- 描述：Check network status
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check net raw failed."
  CHECK_RESULT $? 0 0 "Check net ptype failed."
  CHECK_RESULT $? 0 0 "Check statistic snmp failed."
  CHECK_RESULT $? 0 0 "Check statistic protocols failed."
  CHECK_RESULT $? 0 0 "Check support arp failed."
```

- 涉及命令：grep×3

#### oe_test_check_tcp_udp

- 描述：Check udp and tcp connection
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check netstat -ua failed."
  CHECK_RESULT $? 0 0 "Check netstat -ta failed."
```

- 涉及命令：netstat×2

#### oe_test_dns_set

- 描述：Set DNS
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT 1 0 0 "Check default dns failed."
  CHECK_RESULT $? 1 0 "The port 53 already opened."
  CHECK_RESULT $? 0 0 "Change /etc/named.conf to open port 53 failed."
  CHECK_RESULT $? 0 0 "Restart named server opened."
  CHECK_RESULT $? 0 0 "The port 53 doesn't opened."
  CHECK_RESULT $? 0 0 "Change /etc/resolv.conf failed."
```

- 涉及命令：netstat×2, sed×1

#### oe_test_icmp

- 描述：Check icmp
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Change icmp_echo_ignore_all = 1 failed."
  CHECK_RESULT $? 0 0 "Ping failed."
  CHECK_RESULT $? 0 0 "Change icmp_echo_ignore_all = 0 failed."
  CHECK_RESULT $? 1 0 "Ping unexpectly."
```

#### oe_test_icmp_change_config

- 描述：Change icmp
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Change icmp_echo_ignore_all = 0 failed."
  CHECK_RESULT $? 0 0 "Ping failed."
  CHECK_RESULT $? 0 0 "Ping failed after reboot."
```

- 涉及命令：ping×2

#### oe_test_ip_route_add

- 描述：Check ip route set
- 函数：`pre_test, run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Add ip route failed."
  CHECK_RESULT $? 0 0 "Check add ip route failed."
  CHECK_RESULT $? 0 0 "Delete ip route failed."
  CHECK_RESULT $? 1 0 "Check delete ip route failed."
```

#### oe_test_ipv6_add

- 描述：Add ipv6
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "The kernel dosen't have $target_mod mode."
  CHECK_RESULT $? 0 0 "Add ipv6 failed."
  CHECK_RESULT $? 0 0 "Check ipv6 added failed."
  CHECK_RESULT $? 0 0 "Add route failed."
  CHECK_RESULT $? 0 0 "ping ipv6 failed."
  CHECK_RESULT $? 1 0 "Check ipv6 removed failed."
```

- 涉及命令：ifconfig×2, modinfo×1, route×1

#### oe_test_ipv6_static_setting

- 描述：Set static ipv6
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Restart network failed."
  CHECK_RESULT $? 0 0 "Check ipv6 failed."
```

- 涉及命令：sed×2, ifconfig×1

#### oe_test_lo

- 描述：Check ifup/ifdown nic
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Up lo failed."
  CHECK_RESULT $? 0 0 "Check lo up failed."
  CHECK_RESULT $? 0 0 "Down lo failed."
  CHECK_RESULT $? 1 0 "Check lo down failed."
```

#### oe_test_nic_change_mac

- 描述：Change mac
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Down $test_nic failed."
  CHECK_RESULT $? 0 0 "Change mac failed."
  CHECK_RESULT $? 0 0 "Up $test_nic failed."
  CHECK_RESULT $? 0 0 "Check mac modified failed."
```

#### oe_test_nic_change_queue

- 描述：Change nic queue
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check rx failed."
  CHECK_RESULT $? 0 0 "Check tx failed."
  CHECK_RESULT $? 0 0 "Change rx failed."
  CHECK_RESULT $? 0 0 "Change tx failed."
```

- 涉及命令：ethtool×4

#### oe_test_nic_check

- 描述：Check pci
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check lspci failed."
  CHECK_RESULT $? 0 0 "Check ${test_nic} failed."
  CHECK_RESULT $? 0 0 "Check info for ${test_nic} failed."
  CHECK_RESULT $? 0 0 "Check ${NODE1_IPV4} failed."
```

- 涉及命令：grep×1, ethtool×1

#### oe_test_nic_ifconfig

- 描述：Check ifconfig nic
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ifconfig ${test_nic} down failed."
  CHECK_RESULT $? 1 0 "Check down failed."
  CHECK_RESULT $? 0 0 "ifconfig ${test_nic} up failed."
  CHECK_RESULT $? 0 0 "Check up failed."
```

#### oe_test_nic_ifup

- 描述：Check ifup/ifdown nic
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ifup ${test_nic} failed."
  CHECK_RESULT $? 0 0 "ifdown ${test_nic} down failed."
```

- 涉及命令：sed×2

#### oe_test_nic_ip

- 描述：Check ip link set nic
- 函数：`pre_test, run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 " ip link set ${test_nic} down failed."
  CHECK_RESULT $? 1 0 "Check down failed."
  CHECK_RESULT $? 0 0 " ip link set ${test_nic} up failed."
  CHECK_RESULT $? 0 0 "Check up failed."
```

#### oe_test_nic_nmcli

- 描述：Check nmcli up/down nic
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "nmcli con down ${test_nic} down failed."
  CHECK_RESULT $? 1 0 "Check down failed."
  CHECK_RESULT $? 0 0 "nmcli con up ${test_nic} up failed."
  CHECK_RESULT $? 0 0 "Check up failed."
```

- 涉及命令：sed×2

#### oe_test_nic_queue

- 描述：Check nic queue
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The queue of ${test_nic} is less than 1."
  CHECK_RESULT $? 0 0 "Check ${i} rx_queue failed."
```

- 涉及命令：ethtool×2

#### oe_test_nic_scapy

- 描述：Use scapy to
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} by TCP failed."
  CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} with return_packets failed."
  CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} failed."
  CHECK_RESULT $? 0 0 "Send package to ${NODE2_IPV4} by ICMP failed."
```

#### oe_test_nic_work_format

- 描述：Check nic work format
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check original nic work format failed."
  CHECK_RESULT $? 0 0 "Check directory failed."
  CHECK_RESULT $? 0 0 "Check device failed."
  CHECK_RESULT $? 0 0 "Change work format to ${mode} failed."
  CHECK_RESULT $? 0 0 "Check work format ${mode} changed failed."
  CHECK_RESULT $? 0 0 "Check up failed."
```

- 涉及命令：mii-tool×3, readlink×1

#### oe_test_nmap_check

- 描述：Check nmap
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check open port failed."
  CHECK_RESULT $? 0 0 "Check point open port failed."
```

- 涉及命令：nmap×1

#### oe_test_nmap_open_port

- 描述：Check open port
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Open port 8080 failed."
  CHECK_RESULT $? 0 0 "Check port 8080 status open failed."
  CHECK_RESULT $? 0 0 "Close port 8080 failed."
  CHECK_RESULT $? 0 0 "Check port 8080 status closed failed."
```

#### oe_test_nmap_up_down

- 描述：Check nmcli up/down nic
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Up ${test_nic} failed."
  CHECK_RESULT $? 0 0 "Check ${test_nic} up failed."
  CHECK_RESULT $? 0 0 "Down ${test_nic} failed."
  CHECK_RESULT $? 1 0 "Check ${test_nic} down failed."
```

- 涉及命令：sed×2

#### oe_test_ss

- 描述：Check ss
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ss failed."
  CHECK_RESULT $? 0 0 "Check ss -o failed."
  CHECK_RESULT $? 0 0 "Check ss -m failed."
  CHECK_RESULT $? 0 0 "Check ss -p failed."
  CHECK_RESULT $? 0 0 "Check ss -t state established failed."
  CHECK_RESULT $? 0 0 "Check ss -t state listening failed."
  CHECK_RESULT $? 0 0 "Check ss -t sport failed."
  CHECK_RESULT $? 0 0 "Check ss -t dport failed."
  CHECK_RESULT $? 0 0 "Check ss -4 -t failed."
  CHECK_RESULT $? 0 0 "Check ss -6 -t failed."
```
