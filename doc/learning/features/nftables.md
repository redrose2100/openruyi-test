# nftables

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nftables` |
| 注册用例数 | 12 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nftables_create_counters | Create and debug nftable rules with counters | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nftables_anonymous_map | Use anonymous mapping in nftable | config_params/pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_nftables_listen_package | Listen for packets that match existing debug nftable rules | config_params/pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_nftables_name_sets | Use named sets in nftable | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nftables_variable_map | Using variable decision mapping in nftable | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nftables_chains | Display nftables rule sets, create tables, create chains, insert rules, use anonymous sets | pre_test/config_params/run_test/post_test | 4 | ✔ |  |  |
| oe_test_iptables_to_nftables | Convert iptables rules to nftables rules | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_nftables_backup_rules | Backup and restore nftable rules | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_nftables_replace_counters | replace rules to add counters | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_nftables | Test nftables.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nftables_nft_01 | Verify nftables package and basic options (-h, -v, -V, -c, -D, -o, -I) | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_nftables_nft_02 | Verify nftables output and formatting options (-a, -L, -s, -t, -S, -N, -u, -n, -y, -p, -T, -e, -d) | pre_test/run_test/post_test | 15 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nftables_create_counters

- 描述：Create and debug nftable rules with counters
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$counter_num" 0 0 "byte is not 0"
  CHECK_RESULT "$counter_num" 0 1 "byte is 0"
```

#### oe_test_nftables_anonymous_map

- 描述：Use anonymous mapping in nftable
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "exec 'nft add rule inet $table_name $tcp_chain counter' failed"
  CHECK_RESULT $? 0 0 "exec 'nft add rule inet $table_name $udp_chain counter' failed"
  CHECK_RESULT $? 0 0 "exec 'nft add chain inet $table_name incoming_traffic' failed"
  CHECK_RESULT $? 0 0 "exec 'nft add rule inet $table_name incoming_traffic ip protocol vmap {tcp : jump $tcp_chain, udp : jump $udp_chain }' failed"
  CHECK_RESULT "$counter_packets" 2 0 "add tcp && udp failed"
```

#### oe_test_nftables_listen_package

- 描述：Listen for packets that match existing debug nftable rules
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "exec 'nft add rule inet $table_name $chain_name udp dport 22 accept' failed"
  CHECK_RESULT $? 0 0 "exec 'nft replace' failed"
  CHECK_RESULT $? 0 0 "exec 'nft monitor' failed"
```

- 涉及命令：kill×1

#### oe_test_nftables_name_sets

- 描述：Use named sets in nftable
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "exec add individual_set failed"
  CHECK_RESULT $? 0 0 "exec add multi_set failed"
  CHECK_RESULT $? 0 0 "exec add element individual_set failed"
  CHECK_RESULT $? 0 0 "exec add element multi_set failed"
```

#### oe_test_nftables_variable_map

- 描述：Using variable decision mapping in nftable
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "exec 'nft add element ip' failed"
  CHECK_RESULT $? 0 1 "exec 'nft delete element ip' failed"
```

#### oe_test_nftables_chains

- 描述：Display nftables rule sets, create tables, create chains, insert rules, use anonymous sets
- 函数：`pre_test, config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "exec 'nft add table' failed"
  CHECK_RESULT $? 0 0 "exec 'nft add chain' failed"
  CHECK_RESULT $? 0 0 "exec 'nft add rule' failed"
  CHECK_RESULT $? 0 0 "exec 'nft list table inet $table_name $chain_name tcp dport { 80, 443 } accept' failed"
```

#### oe_test_iptables_to_nftables

- 描述：Convert iptables rules to nftables rules
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "use iptables-translate failed"
  CHECK_RESULT $? 0 0 "exec 'iptables-restore-translate -f /etc/sysconfig/iptables' failed"
  CHECK_RESULT $? 0 0 "exec 'ptables-restore-translate -f /tmp/iptables.dump' failed"
```

- 涉及命令：iptables-restore-translate×2, iptables-translate×1

#### oe_test_nftables_backup_rules

- 描述：Backup and restore nftable rules
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "backup to file.nft failed"
  CHECK_RESULT $? 0 0 "backup to file.json failed"
  CHECK_RESULT $? 1 0 "exec 'nft delete table inet example_table' failed"
  CHECK_RESULT $? 0 0 "restores from file.nft failed"
  CHECK_RESULT $? 1 0 "exec 'nft delete table inet example_table' failed"
  CHECK_RESULT $? 0 0 "restores from file.json failed"
```

- 涉及命令：nft×3, grep×2

#### oe_test_nftables_replace_counters

- 描述：replace rules to add counters
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "exec 'nft add rule inet $table_name $chain_name tcp dport ssh accept' failed"
  CHECK_RESULT $? 0 0 "exec 'nft replace rule inet $table_name $chain_name handle 2 tcp dport 22 counter accept' failed"
```

#### oe_test_service_nftables

- 描述：Test nftables.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "nftables.service reload failed"
  CHECK_RESULT $? 0 0 "nftables.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_nftables_nft_01

- 描述：Verify nftables package and basic options (-h, -v, -V, -c, -D, -o, -I)
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "nftables package not installed"
  CHECK_RESULT $? 0 0 "nftables package verification failed"
  CHECK_RESULT $? 0 0 "Failed to show help"
  CHECK_RESULT $? 0 0 "Failed to show version"
  CHECK_RESULT $? 0 0 "Failed to show extended version"
  CHECK_RESULT $? 0 0 "Failed to add table"
  CHECK_RESULT $? 0 0 "Failed to add chain"
  CHECK_RESULT $? 0 0 "Failed to add rule"
  CHECK_RESULT $? 0 0 "Failed to check rules with -c option"
  CHECK_RESULT $? 0 0 "Failed to define variable with -D option"
  CHECK_RESULT $? 0 0 "Failed to optimize ruleset with -o option"
  CHECK_RESULT $? 0 0 "Failed to use include path with -I option"
```

- 涉及命令：nft×5, rpm×2

#### oe_test_nftables_nft_02

- 描述：Verify nftables output and formatting options (-a, -L, -s, -t, -S, -N, -u, -n, -y, -p, -T, -e, -d)
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Failed to add table"
  CHECK_RESULT $? 0 0 "Failed to add chain"
  CHECK_RESULT $? 0 0 "Failed to add rule"
  CHECK_RESULT $? 0 0 "Failed to show handles with -a option"
  CHECK_RESULT $? 0 0 "Failed to use -s stateless option"
  CHECK_RESULT $? 0 0 "Failed to use -t terse option"
  CHECK_RESULT $? 0 0 "Failed to translate ports with -S option"
  CHECK_RESULT $? 0 0 "Failed to use -N reverse DNS option"
  CHECK_RESULT $? 0 0 "Failed to use -u GUID option"
  CHECK_RESULT $? 0 0 "Failed to use -n numeric option"
  CHECK_RESULT $? 0 0 "Failed to use -y numeric priority option"
  CHECK_RESULT $? 0 0 "Failed to use -p numeric protocol option"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：nft×12
