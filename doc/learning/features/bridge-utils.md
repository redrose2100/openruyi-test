# bridge-utils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/bridge-utils/` |
| 注册用例数 | 3 |
| 环境约束 | add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_bridge-utils_brctl_01 | Verify bridge-utils package and basic brctl operations (addbr, delbr, addif, show, --help) | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_bridge-utils_brctl_02 | Verify bridge-utils brctl interface operations (delif, stp on/off, showstp, showmacs) | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_bridge-utils_brctl_03 | Verify bridge-utils brctl configuration operations (setfd, sethello, setmaxage, setageing, hairpin, setpathcost, setportprio, setbridgeprio) | pre_test/run_test/post_test | 17 | ✔ |  |  |

### 断言与命令明细

#### oe_test_bridge-utils_brctl_01

- 描述：Verify bridge-utils package and basic brctl operations (addbr, delbr, addif, show, --help)
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "bridge-utils package not installed"
  CHECK_RESULT $? 0 0 "bridge-utils package verification failed"
  CHECK_RESULT $? 0 0 "Failed to get bridge-utils version"
  CHECK_RESULT $? 0 0 "brctl binary missing"
  CHECK_RESULT $? 0 0 "Failed to show brctl help"
  CHECK_RESULT $? 0 0 "Failed to create bridge ${bridge_name}"
  CHECK_RESULT $? 0 0 "Failed to verify bridge created"
  CHECK_RESULT $? 0 0 "Failed to add NIC ${test_nic} to bridge ${bridge_name}"
  CHECK_RESULT $? 0 0 "Failed to verify NIC added to bridge"
  CHECK_RESULT $? 0 0 "Failed to remove NIC ${test_nic} from bridge ${bridge_name}"
  CHECK_RESULT $? 1 0 "Failed to verify NIC removed from bridge"
  CHECK_RESULT $? 0 0 "Failed to delete bridge ${bridge_name}"
```

- 涉及命令：rpm×3, test×1

#### oe_test_bridge-utils_brctl_02

- 描述：Verify bridge-utils brctl interface operations (delif, stp on/off, showstp, showmacs)
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to verify NIC added to bridge"
  CHECK_RESULT $? 0 0 "Failed to remove NIC ${test_nic} from bridge ${bridge_name}"
  CHECK_RESULT $? 1 0 "Failed to verify NIC removed from bridge"
  CHECK_RESULT $? 0 0 "Failed to enable STP on ${bridge_name}"
  CHECK_RESULT $? 0 0 "Failed to verify STP enabled"
  CHECK_RESULT $? 0 0 "Failed to disable STP on ${bridge_name}"
  CHECK_RESULT $? 0 0 "Failed to verify STP disabled"
  CHECK_RESULT $? 0 0 "Failed to show STP status"
  CHECK_RESULT $? 0 0 "Failed to show MAC addresses"
```

#### oe_test_bridge-utils_brctl_03

- 描述：Verify bridge-utils brctl configuration operations (setfd, sethello, setmaxage, setageing, hairpin, setpathcost, setportprio, setbridgeprio)
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "Failed to verify NIC added to bridge"
  CHECK_RESULT $? 0 0 "Failed to set forward delay"
  CHECK_RESULT $? 0 0 "Failed to verify forward delay"
  CHECK_RESULT $? 0 0 "Failed to set hello time"
  CHECK_RESULT $? 0 0 "Failed to verify hello time"
  CHECK_RESULT $? 0 0 "Failed to set max age"
  CHECK_RESULT $? 0 0 "Failed to verify max age"
  CHECK_RESULT $? 0 0 "Failed to set ageing time"
  CHECK_RESULT $? 0 0 "Failed to verify ageing time"
  CHECK_RESULT $? 0 0 "Failed to enable hairpin"
  CHECK_RESULT $? 0 0 "Failed to verify hairpin mode"
  CHECK_RESULT $? 0 0 "Failed to set path cost"
  ... 共 17 条（其余见源脚本）
```
