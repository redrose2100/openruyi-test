# systemd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/systemd` |
| 注册用例数 | 161 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_console-getty | Test console-getty.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_dbus-org.freedesktop.hostname1 | Test dbus-org.freedesktop.hostname1.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_dbus-org.freedesktop.locale1 | Test dbus-org.freedesktop.locale1.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_dbus-org.freedesktop.login1 | Test dbus-org.freedesktop.login1.service restart | run_test | 0 |  |  |  |
| oe_test_service_dbus-org.freedesktop.machine1 | Test dbus-org.freedesktop.machine1.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_dbus-org.freedesktop.timedate1 | Test dbus-org.freedesktop.timedate1.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_debug-shell | Test debug-shell.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_hwclock-save | Test hwclock-save.service restart | run_test | 0 |  |  |  |
| oe_test_service_initrd-cleanup | Test initrd-cleanup.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_initrd-parse-etc | Test initrd-parse-etc.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_initrd-switch-root | Test initrd-switch-root.service restart | run_test | 0 |  |  |  |
| oe_test_service_initrd-udevadm-cleanup-db | Test initrd-udevadm-cleanup-db.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_kmod-static-nodes | Test kmod-static-nodes.service restart | run_test | 0 |  |  |  |
| oe_test_service_ldconfig | Test ldconfig.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_rc-local | Test rc-local.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_rescue | Test rescue.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-ask-password-console | Test systemd-ask-password-console.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-ask-password-wall | Test systemd-ask-password-wall.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-binfmt | Test systemd-binfmt.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-bless-boot | Test systemd-bless-boot.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-boot-check-no-failures | Test systemd-boot-check-no-failures.service restart | pre_test/run_test/post_test | 8 |  | ✔ |  |
| oe_test_service_systemd-boot-system-token | Test systemd-boot-system-token.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-exit | Test systemd-exit.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-firstboot | Test systemd-firstboot.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-fsck-root | Test systemd-fsck-root.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-halt | Test systemd-halt.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-hibernate | Test systemd-hibernate.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-hostnamed | Test systemd-hostnamed.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-hwdb-update | Test systemd-hwdb-update.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-hybrid-sleep | Test systemd-hybrid-sleep.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-initctl | Test systemd-initctl.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-journal-catalog-update | Test systemd-journal-catalog-update.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-journald | Test systemd-journald.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-journal-flush | Test systemd-journal-flush.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-kexec | Test systemd-kexec.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-localed | Test systemd-localed.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-logind | Test systemd-logind.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-machined | Test systemd-machined.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-machine-id-commit | Test systemd-machine-id-commit.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-modules-load | Test systemd-modules-load.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-networkd | Test systemd-networkd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_systemd-networkd-wait-online | Test systemd-networkd-wait-online.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-network-generator | Test systemd-network-generator.service restart | pre_test/run_test | 0 |  |  |  |
| oe_test_service_systemd-poweroff | Test systemd-poweroff.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-pstore | Test systemd-pstore.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-random-seed | Test systemd-random-seed.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-reboot | Test systemd-reboot.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-soft-reboot | Test systemd-soft-reboot.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-remount-fs | Test systemd-remount-fs.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-resolved | Test systemd-resolved.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_service_systemd-rfkill | Test systemd-rfkill.service restart | pre_test/run_test | 0 |  |  |  |
| oe_test_service_systemd-suspend | Test systemd-suspend.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-suspend-then-hibernate | Test systemd-suspend-then-hibernate.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-sysctl | Test systemd-sysctl.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-sysusers | Test systemd-sysusers.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-timedated | Test systemd-timedated.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-timesyncd | Test systemd-timesyncd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-time-wait-sync | Test systemd-time-wait-sync.service restart | pre_test/run_test/post_test | 0 | ✔ | ✔ |  |
| oe_test_service_systemd-tmpfiles-clean | Test systemd-tmpfiles-clean.service restart | pre_test/run_test | 0 |  |  |  |
| oe_test_service_systemd-tmpfiles-setup-dev | Test systemd-tmpfiles-setup-dev.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-tmpfiles-setup | Test systemd-tmpfiles-setup.service restart | run_test | 5 |  |  |  |
| oe_test_service_systemd-udevd | Test systemd-udevd.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-udev-settle | Test systemd-udev-settle.service restart | run_test/post_test | 0 |  |  |  |
| oe_test_service_systemd-udev-trigger | Test systemd-udev-trigger.service restart | run_test | 5 |  |  |  |
| oe_test_service_systemd-update-done | Test systemd-update-done.service restart | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_service_systemd-update-utmp-runlevel | Test systemd-update-utmp-runlevel.service restart | pre_test/run_test | 0 |  |  |  |
| oe_test_service_systemd-update-utmp | Test systemd-update-utmp.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-user-sessions | Test systemd-user-sessions.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-vconsole-setup | Test systemd-vconsole-setup.service restart | run_test | 0 |  |  |  |
| oe_test_service_systemd-volatile-root | Test systemd-volatile-root.service restart | run_test | 0 |  |  |  |
| oe_test_service_system-update-cleanup | Test system-update-cleanup.service restart | pre_test/run_test | 6 |  | ✔ |  |
| oe_test_socket_syslog | Test syslog.socket restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_socket_systemd-coredump | Test systemd-coredump.socket restart | run_test | 0 |  |  |  |
| oe_test_socket_systemd-initctl | Test systemd-initctl.socket restart | run_test | 0 |  |  |  |
| oe_test_socket_systemd-journald-audit | Test systemd-journald-audit.socket restart | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_socket_systemd-journald-dev-log | Test systemd-journald-dev-log.socket restart | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_socket_systemd-journald | Test systemd-journald.socket restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_socket_systemd-networkd | Test systemd-networkd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_systemd-udevd-control | Test systemd-udevd-control.socket restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_socket_systemd-udevd-kernel | Test systemd-udevd-kernel.socket restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_basic | Test basic.target restart | run_test | 0 |  |  |  |
| oe_test_target_boot-complete | Test boot-complete.target restart | run_test/post_test | 0 |  |  |  |
| oe_test_target_cryptsetup-pre | Test cryptsetup-pre.target restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_target_cryptsetup | Test cryptsetup.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_ctrl-alt-del | Test ctrl-alt-del.target restart | run_test | 0 |  |  |  |
| oe_test_target_default | Test default.target restart | run_test | 0 |  |  |  |
| oe_test_target_exit | Test exit.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_final | Test final.target restart | run_test | 0 |  |  |  |
| oe_test_target_getty-pre | Test getty-pre.target restart | run_test/post_test | 0 |  |  |  |
| oe_test_target_getty | Test getty.target restart | run_test | 0 |  |  |  |
| oe_test_target_graphical | Test graphical.target restart | run_test/post_test | 0 |  |  |  |
| oe_test_target_halt | Test halt.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_hibernate | Test hibernate.target restart | run_test | 0 |  |  |  |
| oe_test_target_hybrid-sleep | Test hybrid-sleep.target restart | run_test | 0 |  |  |  |
| oe_test_target_initrd-fs | Test initrd-fs.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_initrd-root-device | Test initrd-root-device.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_initrd-root-fs | Test initrd-root-fs.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_initrd | Test initrd.target restart | run_test | 0 |  |  |  |
| oe_test_target_initrd-switch-root | Test initrd-switch-root.target restart | run_test | 0 |  |  |  |
| oe_test_target_kexec | Test kexec.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_local-fs-pre | Test local-fs-pre.target restart | run_test | 3 |  |  |  |
| oe_test_target_local-fs | Test local-fs.target restart | run_test | 0 |  |  |  |
| oe_test_target_machines | Test machine.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_multi-user | Test multi-user.target restart | run_test | 0 |  |  |  |
| oe_test_target_network-online | Test network-online.target restart | run_test | 0 |  |  |  |
| oe_test_target_network-pre | Test network-pre.target restart | run_test | 3 |  |  |  |
| oe_test_target_network | Test network.target restart | run_test | 4 |  |  |  |
| oe_test_target_nss-lookup | Test nss-lookup.target restart | run_test | 3 |  |  |  |
| oe_test_target_nss-user-lookup | Test nss-user-lookup.target restart | run_test | 3 |  |  |  |
| oe_test_target_paths | Test paths.target restart | run_test | 0 |  |  |  |
| oe_test_target_poweroff | Test poweroff.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_reboot | Test reboot.target restart | run_test | 0 |  |  |  |
| oe_test_target_soft-reboot | Test soft-reboot.target restart | run_test | 0 |  |  |  |
| oe_test_target_remote-cryptsetup | Test remote-cryptsetup.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_remote-fs-pre | Test remote-fs-pre.target restart | run_test | 3 |  |  |  |
| oe_test_target_remote-fs | Test remote-fs.target restart | run_test | 0 |  |  |  |
| oe_test_target_rescue | Test rescue.target restart | run_test/post_test | 0 |  |  |  |
| oe_test_target_rpcbind | Test rpcbind.target restart | run_test | 3 |  |  |  |
| oe_test_target_runlevel0 | Test runlevel0.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_runlevel1 | Test runlevel1.target restart | run_test/post_test | 0 |  |  |  |
| oe_test_target_runlevel2 | Test runlevel2.target restart | run_test | 0 |  |  |  |
| oe_test_target_runlevel3 | Test runlevel3.target restart | run_test | 0 |  |  |  |
| oe_test_target_runlevel4 | Test runlevel4.target restart | run_test | 0 |  |  |  |
| oe_test_target_runlevel5 | Test runlevel5.target restart | run_test/post_test | 0 |  |  |  |
| oe_test_target_runlevel6 | Test runlevel6.target restart | run_test | 0 |  |  |  |
| oe_test_target_shutdown | Test shutdown.target restart | run_test | 0 |  |  |  |
| oe_test_target_sigpwr | Test sigpwr.target restart | pre_test/run_test | 1 |  |  |  |
| oe_test_target_sleep | Test sleep.target restart | run_test | 0 |  |  |  |
| oe_test_target_slices | Test slices.target restart | run_test | 0 |  |  |  |
| oe_test_target_sockets | Test sockets.target restart | run_test | 0 |  |  |  |
| oe_test_target_suspend | Test suspend.target restart | run_test | 0 |  |  |  |
| oe_test_target_suspend-then-hibernate | Test suspend-then-hibernate.target restart | run_test | 0 |  |  |  |
| oe_test_target_swap | Test swap.target restart | run_test | 0 |  |  |  |
| oe_test_target_sysinit | Test sysinit.target restart | run_test | 0 |  |  |  |
| oe_test_target_system-update-pre | Test system-update-pre.target restart | run_test | 3 |  |  |  |
| oe_test_target_system-update | Test system-update.target restart | run_test/post_test | 0 |  |  |  |
| oe_test_target_timers | Test timers.target restart | run_test | 0 |  |  |  |
| oe_test_target_time-set | Test time-set.target restart | run_test | 4 |  |  |  |
| oe_test_target_time-sync | Test time-sync.target restart | run_test | 4 |  |  |  |
| oe_test_target_umount | Test umount.target restart | run_test | 3 |  |  |  |
| oe_test_service_emergency | Test emergency.service restart | run_test | 0 |  |  |  |
| oe_test_target_emergency | Test emergency.target restart | run_test | 0 |  |  |  |
| oe_test_target_first-boot-complete | Test first-boot-complete.target restart | run_test | 3 |  |  |  |
| oe_test_target_remote-veritysetup | Test remote-veritysetup.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_veritysetup | Test veritysetup.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_veritysetup-pre | Test veritysetup-pre.target restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_target_factory-reset | Test factory-reset.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_integritysetup | Test integritysetup.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-growfs-root | Test systemd-growfs-root.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-tmpfiles-setup-dev-early | Test systemd-tmpfiles-setup-dev-early.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-journal-remote | Test systemd-journal-remote.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-journal-upload | Test systemd-journal-upload.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_quotaon | Test quotaon.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_systemd-quotacheck | Test systemd-quotacheck.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_telinit | Test case for telinit command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_service_systemd-battery-check | Test systemd-battery-check.service restart | run_test | 0 |  |  |  |
| oe_test_target_initrd-usr-fs | Test initrd-usr-fs.target restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_sound | Test sound.target restart | pre_test/run_test | 0 |  |  |  |
| oe_test_target_smartcard | Test smartcard.target restart | pre_test/run_test | 0 |  |  |  |
| oe_test_target_printer | Test printer.target restart | pre_test/run_test | 0 |  |  |  |
| oe_test_target_bluetooth | Test bluetooth.target restart | pre_test/run_test | 0 |  |  |  |

### 断言与命令明细

#### oe_test_service_console-getty

- 描述：Test console-getty.service restart
- 函数：`run_test, post_test`
#### oe_test_service_dbus-org.freedesktop.hostname1

- 描述：Test dbus-org.freedesktop.hostname1.service restart
- 函数：`run_test, post_test`
#### oe_test_service_dbus-org.freedesktop.locale1

- 描述：Test dbus-org.freedesktop.locale1.service restart
- 函数：`run_test, post_test`
#### oe_test_service_dbus-org.freedesktop.login1

- 描述：Test dbus-org.freedesktop.login1.service restart
- 函数：`run_test`
#### oe_test_service_dbus-org.freedesktop.machine1

- 描述：Test dbus-org.freedesktop.machine1.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_dbus-org.freedesktop.timedate1

- 描述：Test dbus-org.freedesktop.timedate1.service restart
- 函数：`run_test, post_test`
#### oe_test_service_debug-shell

- 描述：Test debug-shell.service restart
- 函数：`run_test, post_test`
#### oe_test_service_hwclock-save

- 描述：Test hwclock-save.service restart
- 函数：`run_test`
#### oe_test_service_initrd-cleanup

- 描述：Test initrd-cleanup.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_initrd-parse-etc

- 描述：Test initrd-parse-etc.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_initrd-switch-root

- 描述：Test initrd-switch-root.service restart
- 函数：`run_test`
#### oe_test_service_initrd-udevadm-cleanup-db

- 描述：Test initrd-udevadm-cleanup-db.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_kmod-static-nodes

- 描述：Test kmod-static-nodes.service restart
- 函数：`run_test`
#### oe_test_service_ldconfig

- 描述：Test ldconfig.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：test×2

#### oe_test_service_rc-local

- 描述：Test rc-local.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：chmod×1

#### oe_test_service_rescue

- 描述：Test rescue.service restart
- 函数：`run_test, post_test`
#### oe_test_service_systemd-ask-password-console

- 描述：Test systemd-ask-password-console.service restart
- 函数：`run_test, post_test`
#### oe_test_service_systemd-ask-password-wall

- 描述：Test systemd-ask-password-wall.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-binfmt

- 描述：Test systemd-binfmt.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-bless-boot

- 描述：Test systemd-bless-boot.service restart
- 函数：`run_test`
#### oe_test_service_systemd-boot-check-no-failures

- 描述：Test systemd-boot-check-no-failures.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} enable failed"
  CHECK_RESULT $? 0 0 "${service} disable failed"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "Check ${service} status failed"
  CHECK_RESULT $? 0 0 "There is an error message for the log of ${service}"
```

#### oe_test_service_systemd-boot-system-token

- 描述：Test systemd-boot-system-token.service restart
- 函数：`run_test`
#### oe_test_service_systemd-exit

- 描述：Test systemd-exit.service restart
- 函数：`run_test`
#### oe_test_service_systemd-firstboot

- 描述：Test systemd-firstboot.service restart
- 函数：`run_test`
#### oe_test_service_systemd-fsck-root

- 描述：Test systemd-fsck-root.service restart
- 函数：`run_test`
#### oe_test_service_systemd-halt

- 描述：Test systemd-halt.service restart
- 函数：`run_test`
#### oe_test_service_systemd-hibernate

- 描述：Test systemd-hibernate.service restart
- 函数：`run_test`
#### oe_test_service_systemd-hostnamed

- 描述：Test systemd-hostnamed.service restart
- 函数：`run_test, post_test`
#### oe_test_service_systemd-hwdb-update

- 描述：Test systemd-hwdb-update.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：test×2

#### oe_test_service_systemd-hybrid-sleep

- 描述：Test systemd-hybrid-sleep.service restart
- 函数：`run_test`
#### oe_test_service_systemd-initctl

- 描述：Test systemd-initctl.service restart
- 函数：`run_test, post_test`
#### oe_test_service_systemd-journal-catalog-update

- 描述：Test systemd-journal-catalog-update.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：test×2

#### oe_test_service_systemd-journald

- 描述：Test systemd-journald.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-journal-flush

- 描述：Test systemd-journal-flush.service restart
- 函数：`run_test`
#### oe_test_service_systemd-kexec

- 描述：Test systemd-kexec.service restart
- 函数：`run_test`
#### oe_test_service_systemd-localed

- 描述：Test systemd-localed.service restart
- 函数：`run_test, post_test`
#### oe_test_service_systemd-logind

- 描述：Test systemd-logind.service restart
- 函数：`run_test`
#### oe_test_service_systemd-machined

- 描述：Test systemd-machined.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-machine-id-commit

- 描述：Test systemd-machine-id-commit.service restart
- 函数：`run_test`
#### oe_test_service_systemd-modules-load

- 描述：Test systemd-modules-load.service restart
- 函数：`run_test`
#### oe_test_service_systemd-networkd

- 描述：Test systemd-networkd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "nscd.service reload failed"
  CHECK_RESULT $? 0 0 "nscd.service reload causes the service status to change"
```

#### oe_test_service_systemd-networkd-wait-online

- 描述：Test systemd-networkd-wait-online.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-network-generator

- 描述：Test systemd-network-generator.service restart
- 函数：`pre_test, run_test`
#### oe_test_service_systemd-poweroff

- 描述：Test systemd-poweroff.service restart
- 函数：`run_test`
#### oe_test_service_systemd-pstore

- 描述：Test systemd-pstore.service restart
- 函数：`run_test`
#### oe_test_service_systemd-random-seed

- 描述：Test systemd-random-seed.service restart
- 函数：`run_test`
#### oe_test_service_systemd-reboot

- 描述：Test systemd-reboot.service restart
- 函数：`run_test`
#### oe_test_service_systemd-soft-reboot

- 描述：Test systemd-soft-reboot.service restart
- 函数：`run_test`
#### oe_test_service_systemd-remount-fs

- 描述：Test systemd-remount-fs.service restart
- 函数：`run_test`
#### oe_test_service_systemd-resolved

- 描述：Test systemd-resolved.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_systemd-rfkill

- 描述：Test systemd-rfkill.service restart
- 函数：`pre_test, run_test`
#### oe_test_service_systemd-suspend

- 描述：Test systemd-suspend.service restart
- 函数：`run_test`
#### oe_test_service_systemd-suspend-then-hibernate

- 描述：Test systemd-suspend-then-hibernate.service restart
- 函数：`run_test`
#### oe_test_service_systemd-sysctl

- 描述：Test systemd-sysctl.service restart
- 函数：`run_test`
#### oe_test_service_systemd-sysusers

- 描述：Test systemd-sysusers.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：test×2

#### oe_test_service_systemd-timedated

- 描述：Test systemd-timedated.service restart
- 函数：`run_test, post_test`
#### oe_test_service_systemd-timesyncd

- 描述：Test systemd-timesyncd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-time-wait-sync

- 描述：Test systemd-time-wait-sync.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_systemd-tmpfiles-clean

- 描述：Test systemd-tmpfiles-clean.service restart
- 函数：`pre_test, run_test`
#### oe_test_service_systemd-tmpfiles-setup-dev

- 描述：Test systemd-tmpfiles-setup-dev.service restart
- 函数：`run_test`
#### oe_test_service_systemd-tmpfiles-setup

- 描述：Test systemd-tmpfiles-setup.service restart
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "There is an error for the status of systemd-tmpfiles-setup.service"
  CHECK_RESULT $? 0 0 "Check systemd-tmpfiles-setup.service failed"
  CHECK_RESULT $? 0 0 "Check systemd-tmpfiles-setup.service failed"
  CHECK_RESULT $? 0 0 "systemd-tmpfiles-setup.service start failed"
  CHECK_RESULT $? 0 0 "There is an error for the status of systemd-tmpfiles-setup.service"
```

#### oe_test_service_systemd-udevd

- 描述：Test systemd-udevd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-udev-settle

- 描述：Test systemd-udev-settle.service restart
- 函数：`run_test, post_test`
#### oe_test_service_systemd-udev-trigger

- 描述：Test systemd-udev-trigger.service restart
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "There is an error for the status of systemd-udev-trigger.service"
  CHECK_RESULT $? 0 0 "Check systemd-udev-trigger.service failed"
  CHECK_RESULT $? 0 0 "Check systemd-udev-trigger.service failed"
  CHECK_RESULT $? 0 0 "Check systemd-udev-trigger.service failed"
  CHECK_RESULT $? 0 0 "There is an error for the status of systemd-udev-trigger.service"
```

#### oe_test_service_systemd-update-done

- 描述：Test systemd-update-done.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
```

- 涉及命令：test×3

#### oe_test_service_systemd-update-utmp-runlevel

- 描述：Test systemd-update-utmp-runlevel.service restart
- 函数：`pre_test, run_test`
#### oe_test_service_systemd-update-utmp

- 描述：Test systemd-update-utmp.service restart
- 函数：`run_test`
#### oe_test_service_systemd-user-sessions

- 描述：Test systemd-user-sessions.service restart
- 函数：`run_test`
#### oe_test_service_systemd-vconsole-setup

- 描述：Test systemd-vconsole-setup.service restart
- 函数：`run_test`
#### oe_test_service_systemd-volatile-root

- 描述：Test systemd-volatile-root.service restart
- 函数：`run_test`
#### oe_test_service_system-update-cleanup

- 描述：Test system-update-cleanup.service restart
- 函数：`pre_test, run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "The unit files is not static"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "There is an error message for the log of system-update-cleanup.service"
```

#### oe_test_socket_syslog

- 描述：Test syslog.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_systemd-coredump

- 描述：Test systemd-coredump.socket restart
- 函数：`run_test`
#### oe_test_socket_systemd-initctl

- 描述：Test systemd-initctl.socket restart
- 函数：`run_test`
#### oe_test_socket_systemd-journald-audit

- 描述：Test systemd-journald-audit.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "systemd-journald-audit.socket restart failed"
  CHECK_RESULT $? 0 0 "systemd-journald-audit.socket restart failed"
  CHECK_RESULT $? 0 0 "systemd-journald-audit.socket stop failed"
  CHECK_RESULT $? 0 0 "systemd-journald-audit.socket stop failed"
  CHECK_RESULT $? 0 0 "systemd-journald-audit.socket start failed"
  CHECK_RESULT $? 0 0 "systemd-journald-audit.socket start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of systemd-journald-audit.socket"
```

#### oe_test_socket_systemd-journald-dev-log

- 描述：Test systemd-journald-dev-log.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "systemd-journald-dev-log.socket restart failed"
  CHECK_RESULT $? 0 0 "systemd-journald-dev-log.socket restart failed"
  CHECK_RESULT $? 0 0 "systemd-journald-dev-log.socket stop failed"
  CHECK_RESULT $? 0 0 "systemd-journald-dev-log.socket stop failed"
  CHECK_RESULT $? 0 0 "systemd-journald-dev-log.socket start failed"
  CHECK_RESULT $? 0 0 "systemd-journald-dev-log.socket start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of systemd-journald-dev-log.socket"
```

#### oe_test_socket_systemd-journald

- 描述：Test systemd-journald.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_systemd-networkd

- 描述：Test systemd-networkd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_systemd-udevd-control

- 描述：Test systemd-udevd-control.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_systemd-udevd-kernel

- 描述：Test systemd-udevd-kernel.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_basic

- 描述：Test basic.target restart
- 函数：`run_test`
#### oe_test_target_boot-complete

- 描述：Test boot-complete.target restart
- 函数：`run_test, post_test`
#### oe_test_target_cryptsetup-pre

- 描述：Test cryptsetup-pre.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check cryptsetup-pre.target failed"
  CHECK_RESULT $? 0 0 "cryptsetup-pre.target stop failed"
  CHECK_RESULT $? 0 0 "Check cryptsetup-pre.target failed"
```

#### oe_test_target_cryptsetup

- 描述：Test cryptsetup.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_ctrl-alt-del

- 描述：Test ctrl-alt-del.target restart
- 函数：`run_test`
#### oe_test_target_default

- 描述：Test default.target restart
- 函数：`run_test`
#### oe_test_target_exit

- 描述：Test exit.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_final

- 描述：Test final.target restart
- 函数：`run_test`
#### oe_test_target_getty-pre

- 描述：Test getty-pre.target restart
- 函数：`run_test, post_test`
#### oe_test_target_getty

- 描述：Test getty.target restart
- 函数：`run_test`
#### oe_test_target_graphical

- 描述：Test graphical.target restart
- 函数：`run_test, post_test`
#### oe_test_target_halt

- 描述：Test halt.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_hibernate

- 描述：Test hibernate.target restart
- 函数：`run_test`
#### oe_test_target_hybrid-sleep

- 描述：Test hybrid-sleep.target restart
- 函数：`run_test`
#### oe_test_target_initrd-fs

- 描述：Test initrd-fs.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_initrd-root-device

- 描述：Test initrd-root-device.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_initrd-root-fs

- 描述：Test initrd-root-fs.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_initrd

- 描述：Test initrd.target restart
- 函数：`run_test`
#### oe_test_target_initrd-switch-root

- 描述：Test initrd-switch-root.target restart
- 函数：`run_test`
#### oe_test_target_kexec

- 描述：Test kexec.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_local-fs-pre

- 描述：Test local-fs-pre.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check local-fs-pre.target failed"
  CHECK_RESULT $? 0 0 "local-fs-pre.target stop failed"
  CHECK_RESULT $? 0 0 "Check local-fs-pre.target failed"
```

#### oe_test_target_local-fs

- 描述：Test local-fs.target restart
- 函数：`run_test`
#### oe_test_target_machines

- 描述：Test machine.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_multi-user

- 描述：Test multi-user.target restart
- 函数：`run_test`
#### oe_test_target_network-online

- 描述：Test network-online.target restart
- 函数：`run_test`
#### oe_test_target_network-pre

- 描述：Test network-pre.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check network-pre.target failed"
  CHECK_RESULT $? 0 0 "network-pre.target stop failed"
  CHECK_RESULT $? 0 0 "Check network-pre.target failed"
```

#### oe_test_target_network

- 描述：Test network.target restart
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "There is an error for the status of network.target"
  CHECK_RESULT $? 0 0 "Check network.target failed"
  CHECK_RESULT $? 0 0 "network.target stop failed"
  CHECK_RESULT $? 0 0 "Check network.target failed"
```

#### oe_test_target_nss-lookup

- 描述：Test nss-lookup.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check nss-lookup.target failed"
  CHECK_RESULT $? 0 0 "nss-lookup.target stop failed"
  CHECK_RESULT $? 0 0 "Check nss-lookup.target failed"
```

#### oe_test_target_nss-user-lookup

- 描述：Test nss-user-lookup.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check nss-user-lookup.target failed"
  CHECK_RESULT $? 0 0 "nss-user-lookup.target stop failed"
  CHECK_RESULT $? 0 0 "Check nss-user-lookup.target failed"
```

#### oe_test_target_paths

- 描述：Test paths.target restart
- 函数：`run_test`
#### oe_test_target_poweroff

- 描述：Test poweroff.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_reboot

- 描述：Test reboot.target restart
- 函数：`run_test`
#### oe_test_target_soft-reboot

- 描述：Test soft-reboot.target restart
- 函数：`run_test`
#### oe_test_target_remote-cryptsetup

- 描述：Test remote-cryptsetup.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_remote-fs-pre

- 描述：Test remote-fs-pre.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check remote-fs-pre.target failed"
  CHECK_RESULT $? 0 0 "remote-fs-pre.target stop failed"
  CHECK_RESULT $? 0 0 "Check remote-fs-pre.target failed"
```

#### oe_test_target_remote-fs

- 描述：Test remote-fs.target restart
- 函数：`run_test`
#### oe_test_target_rescue

- 描述：Test rescue.target restart
- 函数：`run_test, post_test`
#### oe_test_target_rpcbind

- 描述：Test rpcbind.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check rpcbind.target failed"
  CHECK_RESULT $? 0 0 "rpcbind.target stop failed"
  CHECK_RESULT $? 0 0 "Check rpcbind.target failed"
```

#### oe_test_target_runlevel0

- 描述：Test runlevel0.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_runlevel1

- 描述：Test runlevel1.target restart
- 函数：`run_test, post_test`
#### oe_test_target_runlevel2

- 描述：Test runlevel2.target restart
- 函数：`run_test`
#### oe_test_target_runlevel3

- 描述：Test runlevel3.target restart
- 函数：`run_test`
#### oe_test_target_runlevel4

- 描述：Test runlevel4.target restart
- 函数：`run_test`
#### oe_test_target_runlevel5

- 描述：Test runlevel5.target restart
- 函数：`run_test, post_test`
#### oe_test_target_runlevel6

- 描述：Test runlevel6.target restart
- 函数：`run_test`
#### oe_test_target_shutdown

- 描述：Test shutdown.target restart
- 函数：`run_test`
#### oe_test_target_sigpwr

- 描述：Test sigpwr.target restart
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_target_sleep

- 描述：Test sleep.target restart
- 函数：`run_test`
#### oe_test_target_slices

- 描述：Test slices.target restart
- 函数：`run_test`
#### oe_test_target_sockets

- 描述：Test sockets.target restart
- 函数：`run_test`
#### oe_test_target_suspend

- 描述：Test suspend.target restart
- 函数：`run_test`
#### oe_test_target_suspend-then-hibernate

- 描述：Test suspend-then-hibernate.target restart
- 函数：`run_test`
#### oe_test_target_swap

- 描述：Test swap.target restart
- 函数：`run_test`
#### oe_test_target_sysinit

- 描述：Test sysinit.target restart
- 函数：`run_test`
#### oe_test_target_system-update-pre

- 描述：Test system-update-pre.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check system-update-pre.target failed"
  CHECK_RESULT $? 0 0 "system-update-pre.target stop failed"
  CHECK_RESULT $? 0 0 "Check system-update-pre.target failed"
```

#### oe_test_target_system-update

- 描述：Test system-update.target restart
- 函数：`run_test, post_test`
#### oe_test_target_timers

- 描述：Test timers.target restart
- 函数：`run_test`
#### oe_test_target_time-set

- 描述：Test time-set.target restart
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "There is an error for the status of time-set.target"
  CHECK_RESULT $? 0 0 "Check time-set.target failed"
  CHECK_RESULT $? 0 0 "time-set.target stop failed"
  CHECK_RESULT $? 0 0 "Check time-set.target failed"
```

#### oe_test_target_time-sync

- 描述：Test time-sync.target restart
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "There is an error for the status of time-sync.target"
  CHECK_RESULT $? 0 0 "Check time-sync.target failed"
  CHECK_RESULT $? 0 0 "time-sync.target stop failed"
  CHECK_RESULT $? 0 0 "Check time-sync.target failed"
```

#### oe_test_target_umount

- 描述：Test umount.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check umount.target failed"
  CHECK_RESULT $? 0 0 "umount.target stop failed"
  CHECK_RESULT $? 0 0 "Check umount.target failed"
```

#### oe_test_service_emergency

- 描述：Test emergency.service restart
- 函数：`run_test`
#### oe_test_target_emergency

- 描述：Test emergency.target restart
- 函数：`run_test`
#### oe_test_target_first-boot-complete

- 描述：Test first-boot-complete.target restart
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check first-boot-complete.target failed"
  CHECK_RESULT $? 0 0 "first-boot-complete.target stop failed"
  CHECK_RESULT $? 0 0 "Check first-boot-complete.target failed"
```

#### oe_test_target_remote-veritysetup

- 描述：Test remote-veritysetup.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_veritysetup

- 描述：Test veritysetup.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_veritysetup-pre

- 描述：Test veritysetup-pre.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check veritysetup-pre.target failed"
  CHECK_RESULT $? 0 0 "veritysetup-pre.target stop failed"
  CHECK_RESULT $? 0 0 "Check veritysetup-pre.target failed"
```

#### oe_test_target_factory-reset

- 描述：Test factory-reset.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_integritysetup

- 描述：Test integritysetup.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-growfs-root

- 描述：Test systemd-growfs-root.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-tmpfiles-setup-dev-early

- 描述：Test systemd-tmpfiles-setup-dev-early.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-journal-remote

- 描述：Test systemd-journal-remote.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×1

#### oe_test_service_systemd-journal-upload

- 描述：Test systemd-journal-upload.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_quotaon

- 描述：Test quotaon.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_systemd-quotacheck

- 描述：Test systemd-quotacheck.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_telinit

- 描述：Test case for telinit command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "telinit q failed to reload init config"
  CHECK_RESULT $? 0 0 "telinit Q failed to reload init config"
  CHECK_RESULT $? 0 0 "telinit u failed to reexecute init"
```

#### oe_test_service_systemd-battery-check

- 描述：Test systemd-battery-check.service restart
- 函数：`run_test`
#### oe_test_target_initrd-usr-fs

- 描述：Test initrd-usr-fs.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_sound

- 描述：Test sound.target restart
- 函数：`pre_test, run_test`
#### oe_test_target_smartcard

- 描述：Test smartcard.target restart
- 函数：`pre_test, run_test`
#### oe_test_target_printer

- 描述：Test printer.target restart
- 函数：`pre_test, run_test`
#### oe_test_target_bluetooth

- 描述：Test bluetooth.target restart
- 函数：`pre_test, run_test`