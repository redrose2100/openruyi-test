# lxc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lxc` |
| 注册用例数 | 14 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_lxc-net | Test lxc-net.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_lxc | Test lxc.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_lxc-monitord | Test lxc-monitord.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_lxc_create_attach | verification lxc‘s attach command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_lxc_ls_monitor | verification lxc‘s attach command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_lxc_unfreeze_destroy | verification lxc‘s attach command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_lxc_autostart_cgroup | verification lxc‘s attach command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_lxc_device_copy | verification lxc‘s attach command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_lxc_snapshot_start | verification lxc‘s attach command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_lxc_unshare_update | verification lxc‘s attach command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_lxc_checkconfig_console | verification lxc‘s attach command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_lxc_execute_freeze | verification lxc‘s attach command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_lxc_stop_top | verification lxc‘s attach command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_lxc_info | verification lxc‘s info command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_lxc-net

- 描述：Test lxc-net.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_lxc

- 描述：Test lxc.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "lxc.service reload failed"
  CHECK_RESULT $? 0 0 "lxc.service reload causes the service status to change"
```

- 涉及命令：sed×2, lxc-create×1, lxc-destroy×1

#### oe_test_service_lxc-monitord

- 描述：Test lxc-monitord.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_lxc_create_attach

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check lxc-create --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-create --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-create --version failed."
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-attach --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-attach --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-attach --version failed."
```

- 涉及命令：lxc-create×1

#### oe_test_lxc_ls_monitor

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-ls --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-ls --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-ls --version failed."
  CHECK_RESULT $? 0 0 "Failed to list myEuler1."
  CHECK_RESULT $? 0 0 "Check lxc-ls --stopped failed."
  CHECK_RESULT $? 0 0 "Check lxc-ls --defined failed."
  CHECK_RESULT $? 0 0 "Check lxc-monitor --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-monitor --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-monitor --version failed."
```

- 涉及命令：lxc-create×1

#### oe_test_lxc_unfreeze_destroy

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-unfreeze --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-unfreeze --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-unfreeze --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-unfreeze failed."
  CHECK_RESULT $? 0 0 "Check lxc-destroy --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-destroy --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-destroy --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-destroy -n failed."
  CHECK_RESULT $? 1 0 "Check lxc-ls failed."
```

- 涉及命令：lxc-create×1, lxc-unfreeze×1, lxc-destroy×1

#### oe_test_lxc_autostart_cgroup

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-autostart --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-autostart --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-autostart --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-autostart -L failed."
  CHECK_RESULT $? 0 0 "Check lxc-cgroup --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-cgroup --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-cgroup --version failed."
```

- 涉及命令：lxc-create×1, lxc-autostart×1

#### oe_test_lxc_device_copy

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-copy --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-copy --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-copy --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-copy -s failed."
  CHECK_RESULT $? 0 0 "Check lxc-ls failed."
  CHECK_RESULT $? 0 0 "Check lxc-device --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-device --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-device --version failed."
```

- 涉及命令：lxc-create×1, lxc-copy×1

#### oe_test_lxc_snapshot_start

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-start --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-start --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-start --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-snapshot --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-snapshot --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-snapshot --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-snapshot -L failed."
```

- 涉及命令：lxc-create×1, lxc-snapshot×1

#### oe_test_lxc_unshare_update

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-unshare --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-unshare --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-unshare --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-update-config --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-update-config -c failed."
  CHECK_RESULT $? 0 0 "Check lxc-wait --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-wait --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-wait --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-wait -n failed."
  CHECK_RESULT $? 0 0 "Check lxc-wait process failed."
```

- 涉及命令：lxc-create×1, lxc-update-config×1, lxc-wait×1

#### oe_test_lxc_checkconfig_console

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check lxc-checkconfig failed."
  CHECK_RESULT $? 0 0 "Check lxc-checkpoint --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-checkpoint --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-checkpoint --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-config -h failed."
  CHECK_RESULT $? 0 0 "Check lxc-config -l failed."
  CHECK_RESULT $? 0 0 "Check lxc-console --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-console --usage failed."
  CHECK_RESULT $?  0 0 "Check lxc-console --version failed."
```

- 涉及命令：lxc-config×2

#### oe_test_lxc_execute_freeze

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check lxc-execute --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-execute --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-execute --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-freeze --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-freeze --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-freeze --version failed."
```

#### oe_test_lxc_stop_top

- 描述：verification lxc‘s attach command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-stop --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-stop --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-stop --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-info failed."
  CHECK_RESULT $? 0 0 "Check lxc-top --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-top --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-top --version failed."
```

- 涉及命令：lxc-create×1

#### oe_test_lxc_info

- 描述：verification lxc‘s info command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to set up container."
  CHECK_RESULT $? 0 0 "Check lxc-info --help failed."
  CHECK_RESULT $? 0 0 "Check lxc-info --usage failed."
  CHECK_RESULT $? 0 0 "Check lxc-info --version failed."
  CHECK_RESULT $? 0 0 "Check lxc-info -s failed."
  CHECK_RESULT $? 0 0 "Check lxc-info -n failed."
```

- 涉及命令：lxc-info×2, lxc-create×1
