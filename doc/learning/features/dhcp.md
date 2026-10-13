# dhcp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dhcp` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_dhcpd6 | Test dhcpd6.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_dhcpd | Test dhcpd.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_dhcrelay | Test dhcrelay.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_allocate_ipv4_addresses_dhcpd | Test dhcp allocate ipv4 addresses | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_allocate_ipv6_addresses_dhcpd | Test dhcp allocate ipv6 addresses | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_dhcpd6

- 描述：Test dhcpd6.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_dhcpd

- 描述：Test dhcpd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_dhcrelay

- 描述：Test dhcrelay.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_allocate_ipv4_addresses_dhcpd

- 描述：Test dhcp allocate ipv4 addresses
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "add netns0 fail"
  CHECK_RESULT $? 0 0 "add netns1 fail"
  CHECK_RESULT $? 0 0 "netns0 is not exist"
  CHECK_RESULT $? 0 0 "netns1 is not exist"
  CHECK_RESULT $? 0 0 "vnet0 add ip fail"
  CHECK_RESULT $? 0 0 "vnet0 add ip fail"
  CHECK_RESULT $? 0 0 "start dhcpd fail"
  CHECK_RESULT $? 0 0 "allocate ipv4 addr fail"
```

#### oe_test_allocate_ipv6_addresses_dhcpd

- 描述：Test dhcp allocate ipv6 addresses
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "add netns0 fail"
  CHECK_RESULT $? 0 0 "add netns1 fail"
  CHECK_RESULT $? 0 0 "netns0 is not exist"
  CHECK_RESULT $? 0 0 "netns1 is not exist"
  CHECK_RESULT $? 0 0 "vnet0 add ip fail"
  CHECK_RESULT $? 0 0 "vnet0 add ip fail"
  CHECK_RESULT $? 0 0 "start dhcpd fail"
  CHECK_RESULT $? 0 0 "allocate ipv6 addr fail"
```
