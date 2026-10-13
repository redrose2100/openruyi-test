# net-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/net-tools` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_arp-ethers | Test arp-ethers.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_net-tools_netstat | Test netstat command function | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_net-tools_route | Test route command function | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_net-tools_ipmaddr | Test ipmaddr command function | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_net-tools_iptunnel | Use iptunnel case | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_net-tools_netstat_02 | default acl inherit fun02 | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_arp-ethers

- 描述：Test arp-ethers.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_net-tools_netstat

- 描述：Test netstat command function
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Show all sockets fail"
  CHECK_RESULT $? 0 0 "Show udp sockets fail"
  CHECK_RESULT $? 0 0 "Show tcp sockets fail"
  CHECK_RESULT $? 0 0 "Display a table of all network interfaces fail"
  CHECK_RESULT $? 0 0 "Display multicast group membership information fail"
  CHECK_RESULT $? 0 0 "Display summary statistics for each protocol fail"
  CHECK_RESULT $? 0 0 "Show only listening sockets fail"
  CHECK_RESULT $? 0 0 "list all tcp ports fail"
  CHECK_RESULT $? 0 0 "list all udp ports fail"
  CHECK_RESULT $? 0 0 "list all unix ports fail"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：netstat×14

#### oe_test_net-tools_route

- 描述：Test route command function
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 0 0 "Add route fail"
  CHECK_RESULT $? 0 0 "Delete route fail"
  CHECK_RESULT $? 0 0 "Add default route fail"
  CHECK_RESULT $? 0 0 "Delete default route fail"
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：route×4

#### oe_test_net-tools_ipmaddr

- 描述：Test ipmaddr command function
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Display multiaddr fail"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Add multiaddr fail"
  CHECK_RESULT $?
  CHECK_RESULT $? 1 0 "Delete multiaddr fail"
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：ipmaddr×2

#### oe_test_net-tools_iptunnel

- 描述：Use iptunnel case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error,check network name"
  CHECK_RESULT $? 0 0 "Error,fail to add iptunnel"
  CHECK_RESULT $? 0 0 "Error,Fail to delete,Pleasse check the network name"
```

#### oe_test_net-tools_netstat_02

- 描述：default acl inherit fun02
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "display statistics for tcp ports fail"
  CHECK_RESULT $? 0 0 "display statistics for udp ports fail"
  CHECK_RESULT $? 0 0 "show PID and process name fail"
  CHECK_RESULT $? 0 0 "should show in number"
  CHECK_RESULT $? 0 0 "show all ports fail"
  CHECK_RESULT $? 0 0 "show the process of port 22 fail"
  CHECK_RESULT $? 0 0 "should show address families that not supported"
  CHECK_RESULT $? 0 0 "show core routing info fail"
```

- 涉及命令：netstat×7
