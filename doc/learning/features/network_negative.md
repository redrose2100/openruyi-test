# network_negative

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/network-test/network_negative` |
| 注册用例数 | 4 |
| 环境约束 | add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_act_nonexist_nic | Act non-exist nic | pre_test/run_test | 2 |  |  |  |
| oe_test_add_mac_failed | Add mac failed | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_bridge_nonexist_nic | Add non-exist nic for bridge | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_modify_mac_failed | Change mac failed | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_act_nonexist_nic

- 描述：Act non-exist nic
- 函数：`pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The message is error when set up."
  CHECK_RESULT $? 0 0 "The message is error when set down."
```

#### oe_test_add_mac_failed

- 描述：Add mac failed
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Add mac unexpectly by 52uurrr:5555gggg:eeee:eee."
  CHECK_RESULT $? 0 0 "Add mac unexpectly by www.baidu.com."
```

- 涉及命令：arp×2

#### oe_test_bridge_nonexist_nic

- 描述：Add non-exist nic for bridge
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The message is error."
```

#### oe_test_modify_mac_failed

- 描述：Change mac failed
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "Change mac unexpectly to 52uurrr:5555gggg:eeee:eee"
  CHECK_RESULT $? 1 0 "Change mac unexpectly to www.baidu.com."
```
