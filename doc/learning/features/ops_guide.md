# ops_guide

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 文档域（doc-test） |
| 套件路径 | `${OET_PATH}/testcases/doc-test/ops_guide` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_system_resources_and_performance | Monitor system resources and performance | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_information_collection | Information collection | pre_test/run_test/post_test | 27 | ✔ |  |  |
| oe_test_common_skill_cfg_network_and_ssh | Common Skill: Configure the network and ssh | pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_common_skill_rpm_commands | Common Skill: Manage rpm packages-rpm commands | pre_test/run_test/post_test | 19 |  |  |  |
| oe_test_common_skill_dnf_commands | Common Skill: Manage rpm packages-dnf commands | pre_test/run_test/post_test | 27 |  |  |  |

### 断言与命令明细

#### oe_test_system_resources_and_performance

- 描述：Monitor system resources and performance
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute uptime"
  CHECK_RESULT $? 0 0 "Failed to get the usage of vmstat"
  CHECK_RESULT $? 0 0 "Failed to execute vmstat"
  CHECK_RESULT $? 0 0 "Failed to execute sar"
  CHECK_RESULT $? 0 0 "Failed to execute ps -le"
  CHECK_RESULT $? 0 0 "Failed to execute ps -l"
  CHECK_RESULT $? 0 0 "Failed to execute top"
  CHECK_RESULT $? 0 0 "Failed to execute free"
  CHECK_RESULT $? 0 0 "Failed to execute vmstat"
  CHECK_RESULT $? 0 0 "Failed to execute sar"
  CHECK_RESULT $? 0 0 "Failed to execute numactl"
  CHECK_RESULT $? 0 0 "Failed to execute numactl"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：vmstat×3, sar×3, top×1, free×1, numactl×1, iostat×1

#### oe_test_information_collection

- 描述：Information collection
- 函数：`pre_test, run_test, post_test`
- 断言（27 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get the OS version info-1"
  CHECK_RESULT $? 0 0 "Failed to get the OS version info-2"
  CHECK_RESULT $? 0 0 "Failed to get the OS version info-3"
  CHECK_RESULT $? 0 0 "Failed to get the kernel version info"
  CHECK_RESULT $? 0 0 "Failed to execute lscpu"
  CHECK_RESULT $? 0 0 "Failed to get CPU parameters"
  CHECK_RESULT $? 0 0 "Failed to get meminfo parameters"
  CHECK_RESULT $? 0 0 "Failed to get memory hard disk info"
  CHECK_RESULT $? 0 0 "Failed to execute lsblk"
  CHECK_RESULT $? 0 0 "Failed to execute fdisk -l"
  CHECK_RESULT $? 0 0 "Failed to execute lspci"
  CHECK_RESULT $? 0 0 "Failed to execute ip a"
  ... 共 27 条（其余见源脚本）
```

- 涉及命令：rpm×4, dmidecode×2, test×2, lshw×1, fdisk×1, grep×1, ifconfig×1, lspci×1

#### oe_test_common_skill_cfg_network_and_ssh

- 描述：Common Skill: Configure the network and ssh
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Failed to config ip address"
  CHECK_RESULT $? 0 0 "Failed to add Nic 192.168.0.10"
  CHECK_RESULT $? 0 0 "Failed to delete ip address"
  CHECK_RESULT $? 1 0 "Failed to delete Nic 192.168.0.10"
  CHECK_RESULT $? 0 0 "Failed to config static routes"
  CHECK_RESULT $? 0 0 "Failed to add a static route to the host address"
  CHECK_RESULT $? 0 0 "Failed to delete static routes"
  CHECK_RESULT $? 1 0 "Failed to del a static route to the host address"
  CHECK_RESULT $? 0 0 "Failed to config static routes"
  CHECK_RESULT $? 0 0 "Failed to add a static route to the network"
  CHECK_RESULT $? 0 0 "Failed to delete static routes"
  CHECK_RESULT $? 1 0 "Failed to delete a static route to the network"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：grep×1, sed×1

#### oe_test_common_skill_rpm_commands

- 描述：Common Skill: Manage rpm packages-rpm commands
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Failed to import gpgkey"
  CHECK_RESULT $? 0 0 "Failed to download lrzsz pkg"
  CHECK_RESULT $? 0 0 "Failed to check RPM signature"
  CHECK_RESULT $? 0 0 "Failed to delete gpgkey"
  CHECK_RESULT $? 0 0 "Failed to install rpm pkg"
  CHECK_RESULT $? 0 0 "Failed to uninstall rpm pkg"
  CHECK_RESULT $? 0 0 "Failed to query the installed RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to query the uninstalled RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to query kernel in all installed RPM pkgs"
  CHECK_RESULT $? 0 0 "Failed to query details about the installed RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to query the list of uninstalled RPM pkgs"
  CHECK_RESULT $? 0 0 "Failed to query uninstalled RPM pkg dependencies"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：rpm×17

#### oe_test_common_skill_dnf_commands

- 描述：Common Skill: Manage rpm packages-dnf commands
- 函数：`pre_test, run_test, post_test`
- 断言（27 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set the OS repository to be unavailable"
  CHECK_RESULT $? 0 0 "Failed to displays the all repository"
  CHECK_RESULT $? 0 0 "Failed to displays the enabled repository"
  CHECK_RESULT $? 0 0 "Failed to displays the disabled OS repository"
  CHECK_RESULT $? 0 0 "Failed to set the OS repository to be available"
  CHECK_RESULT $? 0 0 "Failed to install the RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to reinstall the RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to uninstall the RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to install the RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to uninstall the RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to install the RPM pkg"
  CHECK_RESULT $? 0 0 "Failed to set the root directory for installing the RPM pkg"
  ... 共 27 条（其余见源脚本）
```
