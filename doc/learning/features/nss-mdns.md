# nss-mdns

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nss-mdns` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nss-mdns_install | nss-mdns install verification and package check | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_nss-mdns_config | nss-mdns configuration test (nsswitch.conf) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nss-mdns_resolve | nss-mdns mDNS hostname resolution test | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nss-mdns_install

- 描述：nss-mdns install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "nss-mdns package not installed"
  CHECK_RESULT $? 0 0 "libnss_mdns4_minimal.so not found"
  CHECK_RESULT $? 0 0 "libnss_mdns4.so not found"
  CHECK_RESULT $? 0 0 "libnss_mdns6.so not found"
  CHECK_RESULT $? 0 0 "libnss_mdns6_minimal.so not found"
```

- 涉及命令：rpm×1

#### oe_test_nss-mdns_config

- 描述：nss-mdns configuration test (nsswitch.conf)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to configure nsswitch.conf"
  CHECK_RESULT $? 0 0 "mdns not configured in nsswitch.conf"
```

- 涉及命令：sed×1, grep×1

#### oe_test_nss-mdns_resolve

- 描述：nss-mdns mDNS hostname resolution test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get short hostname"
  CHECK_RESULT $? 0 0 "mDNS resolution failed"
```

- 涉及命令：sed×1
