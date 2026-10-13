# libnftnl

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libnftnl` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libnftnl | Test libnftnl package installation completeness | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_libnftnl_table | Test libnftnl basic table operations (table/chain/rule/set/counter/map) | pre_test/run_test/post_test | 25 | ✔ |  |  |
| oe_test_libnftnl_filter | Test libnftnl network rule filtering (IP/protocol/NAT/queue) | pre_test/run_test/post_test | 35 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libnftnl

- 描述：Test libnftnl package installation completeness
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "libnftnl package not installed"
  CHECK_RESULT $? 0 0 "libnftnl version not found"
  CHECK_RESULT $? 0 0 "libnftnl release not found"
  CHECK_RESULT $? 0 0 "libnftnl architecture not found"
  CHECK_RESULT $? 0 0 "libnftnl vendor not found"
  CHECK_RESULT $? 0 0 "libnftnl summary not found or invalid"
  CHECK_RESULT $? 0 0 "libnftnl package files missing"
  CHECK_RESULT $? 0 0 "libnftnl.so not found"
  CHECK_RESULT $? 0 0 "libnftnl.so.11 not found"
  CHECK_RESULT $? 0 0 "libnftnl.so.11 symlink broken"
  CHECK_RESULT $? 0 0 "libnftnl.so.11 not in ldconfig cache"
  CHECK_RESULT $? 0 0 "nftables package not installed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：rpm×3, ldconfig×1

#### oe_test_libnftnl_table

- 描述：Test libnftnl basic table operations (table/chain/rule/set/counter/map)
- 函数：`pre_test, run_test, post_test`
- 断言（25 条）：

```
  CHECK_RESULT $? 0 0 "nft add table failed"
  CHECK_RESULT $? 0 0 "nft list table verification failed"
  CHECK_RESULT $? 0 0 "nft add chain failed"
  CHECK_RESULT $? 0 0 "nft list chain verification failed"
  CHECK_RESULT $? 0 0 "nft add rule failed"
  CHECK_RESULT $? 0 0 "nft list rule verification failed"
  CHECK_RESULT $? 0 0 "nft add set failed"
  CHECK_RESULT $? 0 0 "nft list set verification failed"
  CHECK_RESULT $? 0 0 "nft add set element failed"
  CHECK_RESULT $? 0 0 "nft list set element verification failed"
  CHECK_RESULT $? 0 0 "nft add counter failed"
  CHECK_RESULT $? 0 0 "nft list counter verification failed"
  ... 共 25 条（其余见源脚本）
```

#### oe_test_libnftnl_filter

- 描述：Test libnftnl network rule filtering (IP/protocol/NAT/queue)
- 函数：`pre_test, run_test, post_test`
- 断言（35 条）：

```
  CHECK_RESULT $? 0 0 "nft add table failed"
  CHECK_RESULT $? 0 0 "nft add chain failed"
  CHECK_RESULT $? 0 0 "nft add src ip rule failed"
  CHECK_RESULT $? 0 0 "nft list src ip rule verification failed"
  CHECK_RESULT $? 0 0 "nft add dst ip rule failed"
  CHECK_RESULT $? 0 0 "nft list dst ip rule verification failed"
  CHECK_RESULT $? 0 0 "nft add udp rule failed"
  CHECK_RESULT $? 0 0 "nft list udp rule verification failed"
  CHECK_RESULT $? 0 0 "nft add icmp rule failed"
  CHECK_RESULT $? 0 0 "nft list icmp rule verification failed"
  CHECK_RESULT $? 0 0 "nft add tcp rule failed"
  CHECK_RESULT $? 0 0 "nft list tcp rule verification failed"
  ... 共 35 条（其余见源脚本）
```
