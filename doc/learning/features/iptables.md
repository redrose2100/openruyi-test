# iptables

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/iptables` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_ip6tables | Test ip6tables.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_iptables | Test iptables.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_iptables-restore | Test iptables-restore function | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ip6tables-save | Test the basic functions of ip6tables-save | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ip6tables-restore_01 | Test ip6tables-restore function | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_ip6tables

- 描述：Test ip6tables.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ip6tables.service reload failed"
  CHECK_RESULT $? 0 0 "ip6tables.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_iptables

- 描述：Test iptables.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "iptables.service reload failed"
  CHECK_RESULT $? 0 0 "iptables.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_iptables-restore

- 描述：Test iptables-restore function
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "iptables-restore --help command exec fail"
  CHECK_RESULT $? 0 0 "iptables-restore -t exec fail"
  CHECK_RESULT $? 0 0 "iptables-restore -n exec fail"
  CHECK_RESULT $? 0 0 "Failed to restore environment"
```

- 涉及命令：iptables-restore×3, iptables×1

#### oe_test_ip6tables-save

- 描述：Test the basic functions of ip6tables-save
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Rule added successfully"
  CHECK_RESULT $? 0 0 "Rule recovery successful"
  CHECK_RESULT $? 0 0 "Failed to display filter"
  CHECK_RESULT $? 0 1 "Not just filter"
```

- 涉及命令：ip6tables-save×2, ip6tables×1, grep×1

#### oe_test_ip6tables-restore_01

- 描述：Test ip6tables-restore function
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ip6tables-restore --help command exec fail"
  CHECK_RESULT $? 0 0 "ip6tables-restore -t exec fail"
  CHECK_RESULT $? 0 0 "ip6tables-restore -n exec fail"
  CHECK_RESULT $? 0 0 "Failed to restore environment"
```

- 涉及命令：ip6tables-restore×3, ip6tables×1
