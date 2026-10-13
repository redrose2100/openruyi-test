# keepalived

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/keepalived` |
| 注册用例数 | 5 |
| 环境约束 | machine num = 3；add network interface = 4 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_keepalived_cli | command test - keepalived | pre_test/run_test/post_test | 9 | ✔ | ✔ |  |
| oe_test_service_keepalived | Test keepalived.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_tworoute_keepalived | Processing VRRP instances with unicast multiple interfaces | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_vrrp_bond_vlan_keepalived | Instance 20 vrrps to 20 VLAN subnets of bond, enable use vmac | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_vrrp_garp_keepalived | VRRP_ garp_ Interval is set to a value of 0.2, and five groups of gratuitous ARP messages are sent every 120 seconds | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_keepalived_cli

- 描述：command test - keepalived
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT ${checkip_flag}
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×7, keepalived×5, kill×5, mkdir×2, genhash×2, pgrep×2, test×1, grep×1

#### oe_test_service_keepalived

- 描述：Test keepalived.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "keepalived.service reload failed"
  CHECK_RESULT $? 0 0 "keepalived.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_tworoute_keepalived

- 描述：Processing VRRP instances with unicast multiple interfaces
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to vrrp advertisement captured!"
```

- 涉及命令：sysctl×3, dnf×2, command×1, sed×1, keepalived×1, kill×1, grep×1, pgrep×1

#### oe_test_vrrp_bond_vlan_keepalived

- 描述：Instance 20 vrrps to 20 VLAN subnets of bond, enable use vmac
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：command×1

#### oe_test_vrrp_garp_keepalived

- 描述：VRRP_ garp_ Interval is set to a value of 0.2, and five groups of gratuitous ARP messages are sent every 120 seconds
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：command×1, tail×1, kill×1
