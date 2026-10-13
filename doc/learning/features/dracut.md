# dracut

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dracut` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_dracut-cmdline | Test dracut-cmdline.service restart | run_test | 0 |  |  |  |
| oe_test_service_dracut-initqueue | Test dracut-initqueue.service restart | pre_test/run_test | 2 |  |  |  |
| oe_test_service_dracut-mount | Test dracut-mount.service restart | run_test | 0 |  |  |  |
| oe_test_service_dracut-pre-mount | Test dracut-pre-mount.service restart | run_test | 0 |  |  |  |
| oe_test_service_dracut-pre-pivot | Test dracut-pre-pivot.service restart | run_test | 0 |  |  |  |
| oe_test_service_dracut-pre-trigger | Test dracut-pre-trigger.service restart | run_test | 0 |  |  |  |
| oe_test_service_dracut-pre-udev | Test dracut-pre-udev.service restart | run_test | 0 |  |  |  |
| oe_test_service_dracut-shutdown | Test dracut-shutdown.service restart | pre_test/run_test | 7 |  |  |  |
| oe_test_service_dracut-shutdown-onfailure | Test dracut-shutdown-onfailure.service restart | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_service_dracut-initramfs | Test dracut-initramfs function | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_dracut-cmdline

- 描述：Test dracut-cmdline.service restart
- 函数：`run_test`
#### oe_test_service_dracut-initqueue

- 描述：Test dracut-initqueue.service restart
- 函数：`pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

- 涉及命令：journalctl×1

#### oe_test_service_dracut-mount

- 描述：Test dracut-mount.service restart
- 函数：`run_test`
#### oe_test_service_dracut-pre-mount

- 描述：Test dracut-pre-mount.service restart
- 函数：`run_test`
#### oe_test_service_dracut-pre-pivot

- 描述：Test dracut-pre-pivot.service restart
- 函数：`run_test`
#### oe_test_service_dracut-pre-trigger

- 描述：Test dracut-pre-trigger.service restart
- 函数：`run_test`
#### oe_test_service_dracut-pre-udev

- 描述：Test dracut-pre-udev.service restart
- 函数：`run_test`
#### oe_test_service_dracut-shutdown

- 描述：Test dracut-shutdown.service restart
- 函数：`pre_test, run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_dracut-shutdown-onfailure

- 描述：Test dracut-shutdown-onfailure.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of ${service}"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_dracut-initramfs

- 描述：Test dracut-initramfs function
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Create initramfs fail"
  CHECK_RESULT $? 0 0 "Create min initramfs fail"
  CHECK_RESULT $? 0 0 "Check initramfs fail"
  CHECK_RESULT $? 0 0 "Check ld.so.conf.d/*.conf fail"
  CHECK_RESULT $? 0 0 "Check module fail"
```

- 涉及命令：test×1
