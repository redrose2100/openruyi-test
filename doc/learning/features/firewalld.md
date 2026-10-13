# firewalld

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/firewalld` |
| 注册用例数 | 49 |
| 环境约束 | machine num = 3；add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_firewalld_add_newservice | Add new services to the firewall | pre_test/run_test/post_test | 10 | ✔ | ✔ |  |
| oe_test_firewalld_add_port | Use firewall to control ports | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_addport_udp | Open some ports udp protocol package | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_firewalld_add_service | Firewall add new service | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_firewalld_add_sourceip | Configure all traffic from specific sources in the specified area as allow and remove sources | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_firewalld_add_sourceport | Add and delete source ports | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_firewalld_allow_zones | Use area and source to only allow services from specific domains | pre_test/run_test/post_test | 11 | ✔ | ✔ |  |
| oe_test_firewalld_block_all_icmp | Without providing any information, it completely prevents the opening of ICMP requests and ICMP requests | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_firewalld_block_icmp | Block or unblock ICMP requests | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_change_interface | The network interface is assigned to the designated firewall area | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_firewalld_change_xml | Add rules by modifying xml to allow only B's machine to access the http service | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_firewalld_directrule_acceptdport | Add a rule to allow traffic on port 80 from host B | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_firewalld_dnat | DNAT forwarding | pre_test/run_test/post_test | 19 | ✔ | ✔ |  |
| oe_test_firewalld_dropzone_service | Add service to DROP area | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_forward_nat | NAT forwarding | pre_test/run_test/post_test | 7 | ✔ | ✔ |  |
| oe_test_firewalld_getzone | View firewall area | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_firewalld_ip_camouflage | Configure IP address masquerading | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_firewalld_list | Viewing current firewalld settings | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_firewalld_lockdown | Configure firewall lockout | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_firewalld_log_denied | Log configuration for rejected packets | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_manage_icmp | Firewall management ICMP requests-list and block ICMP requests | pre_test/run_test | 2 |  |  |  |
| oe_test_firewalld_new_zone | Create a new zone for the firewall | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_firewalld_panic_on | Use emergency mode to disable all traffic | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_firewalld_port_map | Port Mapping | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_firewalld_protocol_tcp | Add the protocol tcp to the zone | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_richrule_acceptsource | Add the source address to the whitelist to allow all connections from this source address | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_firewalld_richrule_allowippak | Allow new ipv4 ipv6 to connect to http, and use audit to record every minute | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_richrule_blacklist | Add the source address to the blacklist and disallow all connections from this source address | pre_test/run_test/post_test | 10 | ✔ | ✔ |  |
| oe_test_firewalld_richrule_dropicmppack | Discard icmp request | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_richrule_dropipv4pak | Reject all new ipv4 connections http from machine B for the ipv4 protocol, the log prefix is "http_test", the level is "info", and new ipv4 connections from other initiators are accepted | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_firewalld_richrule_forwardport | Forward traffic from a host to another port | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_firewalld_runtime_permanent | Runtime and permanent switching mode firewall | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_firewalld_set_defaultzone | Firewall change default zone | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_firewalld_set_ipset | Use firewalld to set and control IP set | pre_test/run_test/post_test | 9 | ✔ | ✔ |  |
| oe_test_firewalld_set_priority | Set priority for firewall rules | pre_test/run_test | 2 |  |  |  |
| oe_test_firewalld_set_target | Using zone targets to set default behavior for incoming traffic | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_firewalld_start_check | Check whether the firewall is turned on after the system is started | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_firewalld_start_status | Viewing the current status of firewalld | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_firewalld_start_stop | Starting and stopping the firewall | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_firewalld_whitelist_command | Use CLI configuration command to lock the list option | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_firewalld_whitelist_contexts | Use the CLI to configure the contexts lock list option | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_firewalld_whitelist_uids | Use CLI to configure userID lock list option | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_firewalld_whitelist_user | Use CLI to configure user lock list option | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_firewalld_zone_add_service | Modifying firewalld settings for a certain zone | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_firewalld | Test firewalld.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_firewalld_default_rules | Default rules for firewall | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_firewalld_runtime_rules_in_effect | Runtime firewalld rules in effect | pre_test/run_test/post_test | 8 | ✔ | ✔ |  |
| oe_test_firewalld_permanent_rules_in_effect | Permanent firewalld rules in effect | run_test/post_test | 7 | ✔ | ✔ |  |
| oe_test_firewalld_zone_migration | Test firewalld zone migration | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_firewalld_add_newservice

- 描述：Add new services to the firewall
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_add_port

- 描述：Use firewall to control ports
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
```

- 涉及命令：test×1

#### oe_test_firewalld_addport_udp

- 描述：Open some ports udp protocol package
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_firewalld_add_service

- 描述：Firewall add new service
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_firewalld_add_sourceip

- 描述：Configure all traffic from specific sources in the specified area as allow and remove sources
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_add_sourceport

- 描述：Add and delete source ports
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_allow_zones

- 描述：Use area and source to only allow services from specific domains
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_firewalld_block_all_icmp

- 描述：Without providing any information, it completely prevents the opening of ICMP requests and ICMP requests
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_block_icmp

- 描述：Block or unblock ICMP requests
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_firewalld_change_interface

- 描述：The network interface is assigned to the designated firewall area
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_change_xml

- 描述：Add rules by modifying xml to allow only B's machine to access the http service
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_directrule_acceptdport

- 描述：Add a rule to allow traffic on port 80 from host B
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_dnat

- 描述：DNAT forwarding
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：sysctl×1, read×1

#### oe_test_firewalld_dropzone_service

- 描述：Add service to DROP area
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_forward_nat

- 描述：NAT forwarding
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sysctl×1

#### oe_test_firewalld_getzone

- 描述：View firewall area
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_ip_camouflage

- 描述：Configure IP address masquerading
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_list

- 描述：Viewing current firewalld settings
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_lockdown

- 描述：Configure firewall lockout
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_log_denied

- 描述：Log configuration for rejected packets
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_firewalld_manage_icmp

- 描述：Firewall management ICMP requests-list and block ICMP requests
- 函数：`pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_new_zone

- 描述：Create a new zone for the firewall
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_panic_on

- 描述：Use emergency mode to disable all traffic
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_port_map

- 描述：Port Mapping
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_protocol_tcp

- 描述：Add the protocol tcp to the zone
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_richrule_acceptsource

- 描述：Add the source address to the whitelist to allow all connections from this source address
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 0
  CHECK_RESULT $?
```

#### oe_test_firewalld_richrule_allowippak

- 描述：Allow new ipv4 ipv6 to connect to http, and use audit to record every minute
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_richrule_blacklist

- 描述：Add the source address to the blacklist and disallow all connections from this source address
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：kill×1

#### oe_test_firewalld_richrule_dropicmppack

- 描述：Discard icmp request
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_firewalld_richrule_dropipv4pak

- 描述：Reject all new ipv4 connections http from machine B for the ipv4 protocol, the log prefix is "http_test", the level is "info", and new ipv4 connections from other initiators are accepted
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

#### oe_test_firewalld_richrule_forwardport

- 描述：Forward traffic from a host to another port
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_runtime_permanent

- 描述：Runtime and permanent switching mode firewall
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_set_defaultzone

- 描述：Firewall change default zone
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_set_ipset

- 描述：Use firewalld to set and control IP set
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_firewalld_set_priority

- 描述：Set priority for firewall rules
- 函数：`pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

#### oe_test_firewalld_set_target

- 描述：Using zone targets to set default behavior for incoming traffic
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_start_check

- 描述：Check whether the firewall is turned on after the system is started
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_start_status

- 描述：Viewing the current status of firewalld
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_firewalld_start_stop

- 描述：Starting and stopping the firewall
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0
  CHECK_RESULT $? 0 1
```

#### oe_test_firewalld_whitelist_command

- 描述：Use CLI configuration command to lock the list option
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

#### oe_test_firewalld_whitelist_contexts

- 描述：Use the CLI to configure the contexts lock list option
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

#### oe_test_firewalld_whitelist_uids

- 描述：Use CLI to configure userID lock list option
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：userdel×1

#### oe_test_firewalld_whitelist_user

- 描述：Use CLI to configure user lock list option
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：userdel×1

#### oe_test_firewalld_zone_add_service

- 描述：Modifying firewalld settings for a certain zone
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_service_firewalld

- 描述：Test firewalld.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "firewalld.service reload failed"
  CHECK_RESULT $? 0 0 "firewalld.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_firewalld_default_rules

- 描述：Default rules for firewall
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT "$(firewall-cmd --state)" "running" 0 "firewalld.service not running"
  CHECK_RESULT $? 0 0 "check default exists zone fail"
  CHECK_RESULT $? 0 0 "check default target fail"
  CHECK_RESULT $? 0 0 "check default zone fail"
  CHECK_RESULT $? 0 0 "check values of interfaces in runtime public zone fail"
  CHECK_RESULT $? 0 0 "check values of interfaces in permanent public zone fail"
  CHECK_RESULT $? 0 0 "runtime public zone status fail"
  CHECK_RESULT $? 0 0 "permanent public zone fail"
  CHECK_RESULT $? 0 0 "compare other values of runtime permanent fail"
```

#### oe_test_firewalld_runtime_rules_in_effect

- 描述：Runtime firewalld rules in effect
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT "$?" 0 0 "firewalld not running. Start failed?" 1
  CHECK_RESULT "$?" 0 1 "rich rule already exists, test exit." 1
  CHECK_RESULT "$?" 0 0 "add rich rule failed."
  CHECK_RESULT "$?" 0 0 "rich rule not exists, add failed?" 1
  CHECK_RESULT "$?" 0 0 "remove rich rule failed."
  CHECK_RESULT "$?" 0 1 "rich rule still exists, remove failed?" 1
  CHECK_RESULT "$?" 0 0 "rich rule not exists, add failed?" 1
  CHECK_RESULT "$?" 0 1 "rich rule still exists after system reboot"
```

#### oe_test_firewalld_permanent_rules_in_effect

- 描述：Permanent firewalld rules in effect
- 函数：`run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT "$(P_SSH_CMD --node 2 --cmd "firewall-cmd --state")" "running" 0 "firewalld.service not running"
  CHECK_RESULT "$(P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" |grep -v ^$)" "" 0 "default runtime firewall rich rule check fail"
  CHECK_RESULT "$(P_SSH_CMD --node 2 --cmd "firewall-cmd --permanent --list-rich-rules" |grep -v ^$)" "" 0 "default permanent firewall rich rule check fail"
  CHECK_RESULT "$(P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" |grep -v ^$)" "" 0 "add permanent firewall rich rule, runtime firewall rich rule check fail"
  CHECK_RESULT "$(P_SSH_CMD --node 2 --cmd "firewall-cmd --permanent --list-rich-rules" |grep -v ^$)" "${RichRule}" 0 "add permanent firewall rich rule, permanent firewall rich rule check fail"
  CHECK_RESULT "$(P_SSH_CMD --node 2 --cmd "firewall-cmd --list-rich-rules" |grep -v ^$)" "${RichRule}" 0 "after reboot, runtime firewall rich rule check fail"
  CHECK_RESULT "$(P_SSH_CMD --node 2 --cmd "firewall-cmd --permanent --list-rich-rules" |grep -v ^$)" "${RichRule}" 0 "after reboot, permanent firewall rich rule check fail"
```

#### oe_test_firewalld_zone_migration

- 描述：Test firewalld zone migration
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$?" 0 0 "ssh NODE1_IPV4 fail"
  CHECK_RESULT "$?" 0 0 "zone not exists: $tstz"
  CHECK_RESULT "$?" 0 0 "add source fail for $tstz"
  CHECK_RESULT "$?" 0 0 "add ports fail for $tstz"
  CHECK_RESULT "$?" 0 1 "ssh NODE1_IPV4 succeeds unexpectedly. Firewalld zone migration failed"
  CHECK_RESULT "$?" 0 0 "ssh NODE1_IPV4 failed"
```
