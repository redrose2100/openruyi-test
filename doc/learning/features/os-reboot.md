# os-reboot

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `$OET_PATH/testcases/system-test/os-reboot` |
| 注册用例数 | 31 |
| 环境约束 | machine type = physical；machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_cold_halt_poweroff | Halt calls poweroff | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_init0 | init 0 | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_ipmi_off | Ipmitool remote control server restart | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_cold_ipmi_poweroff | Ipmitool remote control server restart | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_poweroff_force | Forced poweroff | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_poweroff_nowtmp | Don't write wtmp record | pre_test/run_test/post_test | 5 |  | ✔ |  |
| oe_test_cold_reboot_poweroff | Reboot calls poweroff | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_shutdown_force | Forced shutdown | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_shutdown_h | Equivalent to --poweroff, overridden by --halt | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_shutdown_poweroff | Shutdown calls poweroff | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_cold_systemctl_poweroff | Systemctl calls poweroff | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_hot_halt_force | Forced halt | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_hot_halt_nowtmp | Don't write wtmp record | pre_test/run_test/post_test | 5 |  | ✔ |  |
| oe_test_hot_halt_reboot | Halt calls reboot | run_test | 2 |  | ✔ |  |
| oe_test_hot_init6 | init 6 | run_test | 2 |  | ✔ |  |
| oe_test_hot_ipmi_halt | Ipmitool remote control server restart | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_hot_ipmi_reset | Ipmitool remote control server restart | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_hot_poweroff_halt | Poweroff calls halt | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_hot_poweroff_reboot | Poweroff calls reboot | run_test | 2 |  | ✔ |  |
| oe_test_hot_reboot_force | Forced reboot | run_test | 2 |  | ✔ |  |
| oe_test_hot_reboot_halt | Reboot calls halt | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_hot_reboot_nowtmp | Don't write wtmp record | run_test/post_test | 2 |  | ✔ |  |
| oe_test_hot_shutdown_halt | Shutdown calls halt | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_hot_shutdown_reboot | Shutdown calls reboot | run_test | 2 |  | ✔ |  |
| oe_test_hot_systemctl_halt | Systemctl calls halt | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_hot_systemctl_reboot | Systemctl calls reboot | run_test | 2 |  | ✔ |  |
| oe_test_reboot_50_times | Reboot 50 times | run_test | 2 |  | ✔ | 200m |
| oe_test_reboot_delayed | Timed restart | run_test | 3 |  | ✔ |  |
| oe_test_reboot_press | Pressure restart | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_reboot_task_trigger | Scheduled task triggers restart | run_test/post_test | 2 |  | ✔ |  |
| oe_test_reboot_timed | Timed restart | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_cold_halt_poweroff

- 描述：Halt calls poweroff
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'halt -p --poweroff' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_init0

- 描述：init 0
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'init 0' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_ipmi_off

- 描述：Ipmitool remote control server restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'power off' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×4, ping×1

#### oe_test_cold_ipmi_poweroff

- 描述：Ipmitool remote control server restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'poweroff' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_poweroff_force

- 描述：Forced poweroff
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'poweroff -f' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_poweroff_nowtmp

- 描述：Don't write wtmp record
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'poweroff -d' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
  CHECK_RESULT $? 0 1 "The execution of the wtmp failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_reboot_poweroff

- 描述：Reboot calls poweroff
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'reboot -p --poweroff' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_shutdown_force

- 描述：Forced shutdown
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'shutdown -f' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_shutdown_h

- 描述：Equivalent to --poweroff, overridden by --halt
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'shutdown -h' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_shutdown_poweroff

- 描述：Shutdown calls poweroff
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'shutdown -P --poweroff' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_cold_systemctl_poweroff

- 描述：Systemctl calls poweroff
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'systemctl poweroff' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_halt_force

- 描述：Forced halt
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'halt -f' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power reset' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_halt_nowtmp

- 描述：Don't write wtmp record
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'halt -d' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power on' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
  CHECK_RESULT $? 0 1 "The execution of the wtmp failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_halt_reboot

- 描述：Halt calls reboot
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'halt -p --reboot' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1

#### oe_test_hot_init6

- 描述：init 6
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'init 6' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1

#### oe_test_hot_ipmi_halt

- 描述：Ipmitool remote control server restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'halt' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'power reset' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_ipmi_reset

- 描述：Ipmitool remote control server restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1 "The execution of the 'power reset' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_poweroff_halt

- 描述：Poweroff calls halt
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'poweroff --halt' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_poweroff_reboot

- 描述：Poweroff calls reboot
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'poweroff -p --reboot' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1

#### oe_test_hot_reboot_force

- 描述：Forced reboot
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'reboot -f' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1

#### oe_test_hot_reboot_halt

- 描述：Reboot calls halt
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'reboot --halt' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_reboot_nowtmp

- 描述：Don't write wtmp record
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 1 "The execution of the wtmp failed."
```

#### oe_test_hot_shutdown_halt

- 描述：Shutdown calls halt
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'shutdown -H --halt' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_shutdown_reboot

- 描述：Shutdown calls reboot
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'shutdown -r now' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1

#### oe_test_hot_systemctl_halt

- 描述：Systemctl calls halt
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'systemctl halt' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
  CHECK_RESULT $? 0 0 "The startup execution failed."
```

- 涉及命令：ipmitool×2, ping×1

#### oe_test_hot_systemctl_reboot

- 描述：Systemctl calls reboot
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "The execution of the 'systemctl reboot' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1

#### oe_test_reboot_50_times

- 描述：Reboot 50 times
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The execution of the 'reboot' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

#### oe_test_reboot_delayed

- 描述：Timed restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The execution of the 'shutdown -r +1' command failed."
  CHECK_RESULT $? 0 1 "The execution of the 'ping' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1

#### oe_test_reboot_press

- 描述：Pressure restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The execution of the 'df -h' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'reboot' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

#### oe_test_reboot_task_trigger

- 描述：Scheduled task triggers restart
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The execution of the 'date -s' command failed."
  CHECK_RESULT $? 0 0 "The execution of the wtmp failed."
```

#### oe_test_reboot_timed

- 描述：Timed restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The execution of the 'date -s' command failed."
  CHECK_RESULT $? 0 0 "The execution of the 'shutdown -r' command failed."
  CHECK_RESULT $? 0 1 "The execution of the 'ping' command failed."
  CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
```

- 涉及命令：ping×1
