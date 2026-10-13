# smoke-baseinfo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-baseinfo` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dmesg_messages_log | Test dmesg and messages | run_test | 2 |  |  |  |
| oe_test_baseinfo | Basic information of test system | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_firewalld | Test firewalld and iptables | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_partition | View partition information | run_test | 7 |  |  |  |
| oe_test_selinux | Test selinux | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_system_level | Test system level | pre_test/run_test | 6 |  |  |  |
| oe_test_systemctl | Test basic service status | run_test | 10 |  |  |  |
| oe_test_ssh | Test SSH link | run_test/post_test | 4 |  |  |  |
| oe_test_rpm_suffix_name | Check rpm package suffix name of rpm package | pre_test/run_test | 1 |  |  |  |
| oe_test_cpu_model_name | Test CPU model | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_export | test export | pre_test/run_test/post_test | 4 |  |  |  |

### 断言与命令明细

#### oe_test_dmesg_messages_log

- 描述：Test dmesg and messages
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "Dmesg has false information."
  CHECK_RESULT $? 1 0 "file /var/log/messages has false information."
```

- 涉及命令：grep×2

#### oe_test_baseinfo

- 描述：Basic information of test system
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed command: free"
  CHECK_RESULT $? 0 0 "Failed command: lscpu"
  CHECK_RESULT $? 0 0 "Failed command: fdisk"
  CHECK_RESULT $? 0 0 "/etc/os-release file view failed"
  CHECK_RESULT $? 0 0 "Failed command: timedatectl"
  CHECK_RESULT $? 0 0 "Time zone information display failed"
  CHECK_RESULT $? 1 0 "The time zone is Tokyo"
  CHECK_RESULT $? 0 0 "Failed to set time zone"
  CHECK_RESULT $? 0 0 "The time zone isn't Tokyo"
  CHECK_RESULT $? 0 0 "Failed to recover time zone"
  CHECK_RESULT $? 0 0 "The system language does not belong to us"
  CHECK_RESULT $? 0 0 "The system language does not contain Chinese"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：grep×3, fdisk×1

#### oe_test_firewalld

- 描述：Test firewalld and iptables
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Failed to stop cockpit service"
  CHECK_RESULT $? 0 0 "Failed to stop cockpit service"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Failed to restart cockpit service"
  CHECK_RESULT $? 0 0 "Failed to restart cockpit service"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
  CHECK_RESULT $? 0 0 "Failed to start cockpit service"
  CHECK_RESULT $? 0 0 "Failed to start cockpit service"
  CHECK_RESULT $? 0 0 "Iptables execution failed"
```

- 涉及命令：iptables×4, ip6tables×4

#### oe_test_partition

- 描述：View partition information
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "No / partition"
  CHECK_RESULT $? 0 0 "No boot partition"
  CHECK_RESULT $? 0 0 "No swap partition"
  CHECK_RESULT $? 0 0 "lsblk -h info error"
  CHECK_RESULT $? 0 0 "lsblk -t info error"
  CHECK_RESULT $? 0 0 "lsblk -m info error"
  CHECK_RESULT $? 0 0 "lsblk -b info error"
```

- 涉及命令：lsblk×3

#### oe_test_selinux

- 描述：Test selinux
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to close SELinux"
  CHECK_RESULT $? 0 0 "Failed to close SELinux"
  CHECK_RESULT $? 0 0 "Failed to open SELinux"
  CHECK_RESULT $? 0 0 "Failed to open SELinux"
```

#### oe_test_system_level

- 描述：Test system level
- 函数：`pre_test, run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "set-default execution failed"
  CHECK_RESULT $? 0 0 "list-units execution failed"
  CHECK_RESULT $? 0 0 "isolate execution failed"
  CHECK_RESULT $? 0 0 "list-units execution failed"
  CHECK_RESULT $? 0 0 "isolate execution failed"
  CHECK_RESULT $? 1 0 "list-units execution failed"
```

#### oe_test_systemctl

- 描述：Test basic service status
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display service list"
  CHECK_RESULT $? 0 0 "service status is not running"
  CHECK_RESULT $? 0 0 "Failed to stop rsyslog service"
  CHECK_RESULT $? 0 0 "Failed to stop rsyslog service"
  CHECK_RESULT $? 0 0 "Failed to start rsyslog service"
  CHECK_RESULT $? 0 0 "Failed to start rsyslog service"
  CHECK_RESULT $? 0 0 "Failed to start rsyslog service"
  CHECK_RESULT $? 0 0 "Failed to start rsyslog service"
  CHECK_RESULT $? 1 0 "There are failed services"
  CHECK_RESULT $? 0 0 "Failed command: journalctl"
```

- 涉及命令：systemctl×1

#### oe_test_ssh

- 描述：Test SSH link
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start sshd service"
  CHECK_RESULT $? 0 0 "Failed to start sshd service"
  CHECK_RESULT $? 0 0 "uanme -a execution failed"
  CHECK_RESULT $? 0 0 "ip a execution failed"
```

#### oe_test_rpm_suffix_name

- 描述：Check rpm package suffix name of rpm package
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "Check rpm package name: failed!"
```

#### oe_test_cpu_model_name

- 描述：Test CPU model
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "The lscpu command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The lspci command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The dmidecode command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The lshw command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The lscpu command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The dmidecode command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The /proc/cpuinfo displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The lscpu command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The lspci command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The dmidecode command displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The /proc/cpuinfo displays an incorrect CPU model"
  CHECK_RESULT $? 0 0 "The lshw command displays an incorrect CPU model"
```

- 涉及命令：grep×7, dmidecode×3, lshw×2

#### oe_test_export

- 描述：test export
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "test argrument -f failure"
  CHECK_RESULT $? 0 0 "test argrument -p failure"
  CHECK_RESULT $? 0 0 "test env set failure"
  CHECK_RESULT $? 0 0 "test argrument -n failure"
```

- 涉及命令：export×2
