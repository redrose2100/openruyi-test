# plymouth

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/plymouth` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_plymouth-halt | Test plymouth-halt.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-kexec | Test plymouth-kexec.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-poweroff | Test plymouth-poweroff.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-quit | Test plymouth-quit.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-quit-wait | Test plymouth-quit-wait.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-read-write | Test plymouth-read-write.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-reboot | Test plymouth-reboot.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-start | Test plymouth-start.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-switch-root | Test plymouth-switch-root.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-ask-password-plymouth | Test systemd-ask-password-plymouth.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_plymouth-switch-root-initramfs | Test plymouth-switch-root-initramfs.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_plymouth-halt

- 描述：Test plymouth-halt.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-kexec

- 描述：Test plymouth-kexec.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-poweroff

- 描述：Test plymouth-poweroff.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-quit

- 描述：Test plymouth-quit.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-quit-wait

- 描述：Test plymouth-quit-wait.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-read-write

- 描述：Test plymouth-read-write.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-reboot

- 描述：Test plymouth-reboot.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-start

- 描述：Test plymouth-start.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-switch-root

- 描述：Test plymouth-switch-root.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-ask-password-plymouth

- 描述：Test systemd-ask-password-plymouth.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_plymouth-switch-root-initramfs

- 描述：Test plymouth-switch-root-initramfs.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×1
