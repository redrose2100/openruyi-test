# kernel

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/kernel` |
| 注册用例数 | 71 |
| 环境约束 | machine type = physical；add disk = 10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_kernel_cmd_01 | Test kernel command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_kernel_cmd_02 | Test kernel command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_kernel_cmd_03 | Test kernel command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_cpupower | Test cpupower.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_ipip | Test ipip模块加载、卸载 | run_test | 6 |  |  |  |
| oe_test_io_sched | 临时切换IO SCHED策略 | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_cache_rw | Test 缓存读写 | run_test/post_test | 4 |  |  |  |
| oe_test_snd_aloop | Test 驱动加载_snd-aloop | run_test/post_test | 4 |  |  |  |
| oe_test_hinic | 内核增加华为hinic网卡驱动 | pre_test/run_test | 6 |  |  |  |
| oe_test_hqlogic | 内核-HQlogic驱动 | run_test | 9 |  |  |  |
| oe_test_cpu_rand | test CPU是否具有随机数生成功能 | run_test | 1 |  |  |  |
| oe_test_qxl | 内核-驱动-qxl显卡驱动 | run_test | 8 |  |  |  |
| oe_test_vport-geneve | vport-geneve模块加载、卸载 | run_test | 7 |  |  |  |
| oe_test_swap_compress | Test 内核-swap压缩 | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_lpfc | lpfc模块加载、卸载 | run_test | 7 |  |  |  |
| oe_test_check_huge_task | 检查内核是否打开HUNG TASK相关开关 | run_test | 3 |  |  |  |
| oe_test_swappiness | Test kernel swappiness set | run_test/post_test | 2 |  |  |  |
| oe_test_softdog | softdog模块加载、卸载 | run_test | 7 |  |  |  |
| oe_test_cifs | cifs模块加载、卸载 | run_test | 7 |  |  |  |
| oe_test_xfs | xfs模块加载、卸载 | run_test | 7 |  |  |  |
| oe_test_wangxun | 内核-驱动-网讯网卡驱动 | run_test | 10 |  |  |  |
| oe_test_vlan_8021q | Test内核-支持vlan_8021q模块 | run_test | 3 |  |  |  |
| oe_test_nbd | Test 驱动加载_nbd | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_libfc | libfc module test | run_test | 6 |  |  |  |
| oe_test_hpsa | Huawei fnic  module | run_test | 6 |  |  |  |
| oe_test_bnx2fc | Huawei fnic  module | run_test | 6 |  |  |  |
| oe_test_qla2xxx | Test kernel-HQlogic drive（qla2xxx） | run_test | 3 |  |  |  |
| oe_test_qla3xxx | Test kernel-HQlogic drive（qla3xxx） | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_tcm_loop | tcm_loop kernel testing | run_test | 6 |  |  |  |
| oe_test_libcxgbi | Huawei libcxgbi  module | run_test | 7 |  |  |  |
| oe_test_libsas | Huawei libsas  module | run_test | 6 |  |  |  |
| oe_test_qedf | Huawei qedf.ko module | run_test | 7 |  |  |  |
| oe_test_qedi | Huawei qedi.ko module | run_test | 7 |  |  |  |
| oe_test_pcie | Huawei pcie module | run_test | 8 |  |  |  |
| oe_test_acpi | Huawei acpi module | pre_test/run_test | 7 |  |  |  |
| oe_test_uio | Huawei uio module | run_test/post_test | 8 |  |  |  |
| oe_test_clk | Huawei clk module | run_test/post_test | 6 |  |  |  |
| oe_test_mfd | Huawei mfd module | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_bcma | Huawei bcma module | run_test/post_test | 6 |  |  |  |
| oe_test_extcon | Huawei extcon module | run_test/post_test | 6 |  |  |  |
| oe_test_tee | kernel tee module | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_regmap_01 | kernel regmap module | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_regmap_02 | kernel regmap-spi module test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_ceph | Kernel CEPH testing | run_test/post_test | 7 |  |  |  |
| oe_test_radeon | Kernel radeon testing | run_test/post_test | 7 |  |  |  |
| oe_test_target_core_file | Huawei target_core_file.ko module | run_test | 6 |  |  |  |
| oe_test_target_core_iblock | Huawei target_core_iblock.ko module | run_test | 6 |  |  |  |
| oe_test_target_core_mod | Huawei target_core_mod.ko module | run_test | 6 |  |  |  |
| oe_test_target_core_pscsi | Huawei target_core_pscsi.ko module | run_test | 6 |  |  |  |
| oe_test_target_core_user | Huawei target_core_user.ko module | run_test | 6 |  |  |  |
| oe_test_net_ifb | Huawei ifb.ko module | run_test | 6 |  |  |  |
| oe_test_net_veth | Huawei veth.ko module | run_test | 6 |  |  |  |
| oe_test_ngsm | Huawei n_gsm.ko module | run_test | 6 |  |  |  |
| oe_test_nhdlc | Huawei n_hdlc.ko module | run_test | 6 |  |  |  |
| oe_test_mlx4_core | Test kernel-mellanox drive（mlx4_core） | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_mlx5_core | Test kernel-mellanox drive（mlx5_core） | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_mlxfw | Test kernel-mellanox drive（mlxfw） | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_hinic3 | 内核增加华为hinic3网卡驱动 | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_rnpm | Huawei rnpm | pre_test/run_test | 6 |  |  |  |
| oe_test_led-class-flash | kernel led-class-flash module test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_leds_blinkm | kernel leds-blinkm module test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_leds_lm3530 | kernel leds-lm3530 module test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_leds_lp3944 | kernel leds-lp3944 module test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_leds_lt3593 | kernel leds-lt3593 module test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_dax_cxl | test dax_cxl.ko.xz module | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dax_pmem | test dax_pmem.ko.xz module | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dax_hmem | test dax_hmem.ko.xz module | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dax_kmem | test kmem.ko.xz module | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_cxl_acpi | test cxl_acpi.ko.xz module | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_cxl_mem | test cxl_mem.ko.xz module | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_cxl_pci | test cxl_pci.ko.xz module | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_kernel_cmd_01

- 描述：Test kernel command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "check -h usage fail"
  CHECK_RESULT $? 0 0 "check help usage fail"
  CHECK_RESULT $? 0 0 "check analyzing CPU fail"
  CHECK_RESULT $? 0 0 "check 1.0GHz fail"
  CHECK_RESULT $? 0 0 "check current CPU frequency Hz fail"
  CHECK_RESULT $? 0 0 "check analyzing CPU fail"
  CHECK_RESULT $? 0 0 "check idle-set fail"
  CHECK_RESULT $? 0 0 "check analyzing CPU fail"
  CHECK_RESULT $? 0 0 "check Usage: gpio-event-mon fail"
  CHECK_RESULT $? 0 0 "check Usage: gpio-hammer fail"
```

- 涉及命令：cpupower×1

#### oe_test_kernel_cmd_02

- 描述：Test kernel command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：tmon×3, lsgpio×1

#### oe_test_kernel_cmd_03

- 描述：Test kernel command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "${ret}" 5
  CHECK_RESULT $?
```

- 涉及命令：perf×1

#### oe_test_service_cpupower

- 描述：Test cpupower.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×2

#### oe_test_ipip

- 描述：Test ipip模块加载、卸载
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view module information"
  CHECK_RESULT $? 1 0 "Module loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

#### oe_test_io_sched

- 描述：临时切换IO SCHED策略
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$model" "$i" 0 "Switching failed"
```

#### oe_test_cache_rw

- 描述：Test 缓存读写
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view cache information"
  CHECK_RESULT $? 0 0 "Failed to clear cache"
  CHECK_RESULT $? 0 0 "fail to write to file"
  CHECK_RESULT $? 0 0 "Cache utilization not increasing"
```

- 涉及命令：free×1

#### oe_test_snd_aloop

- 描述：Test 驱动加载_snd-aloop
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view module information"
  CHECK_RESULT $? 1 0 "Module loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
```

#### oe_test_hinic

- 描述：内核增加华为hinic网卡驱动
- 函数：`pre_test, run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_hqlogic

- 描述：内核-HQlogic驱动
- 函数：`run_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "qla2xxx drivers not found"
  CHECK_RESULT $? 0 0 "qla2xxx.ko not exist"
  CHECK_RESULT $? 0 0 "modprobe qla2xxx failed"
  CHECK_RESULT $? 0 0 "lsmod failed"
  CHECK_RESULT $? 0 0 "modinfo qla2xxx failed"
  CHECK_RESULT $? 0 0 "rmmod qla2xxx failed"
  CHECK_RESULT $? 1 0 "qla2xxx info exist"
  CHECK_RESULT $? 0 0 "modinfo qla2xxx failed"
  CHECK_RESULT $? 1 0 "qla2xxx error info exist"
```

#### oe_test_cpu_rand

- 描述：test CPU是否具有随机数生成功能
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The random number generation function is not supported"
```

- 涉及命令：grep×1

#### oe_test_qxl

- 描述：内核-驱动-qxl显卡驱动
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "qxl drivers not found"
  CHECK_RESULT $? 0 0 "qxl.ko not exist"
  CHECK_RESULT $? 0 0 "modprobe qxl failed"
  CHECK_RESULT $? 0 0 "lsmod failed"
  CHECK_RESULT $? 0 0 "modinfo qxl failed"
  CHECK_RESULT $? 0 0 "rmmod qxl failed"
  CHECK_RESULT $? 1 0 "qxl info exist"
  CHECK_RESULT $? 0 0 "modinfo qxl failed"
```

#### oe_test_vport-geneve

- 描述：vport-geneve模块加载、卸载
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
  CHECK_RESULT $? 0 1 "Default installation"
  CHECK_RESULT $? 0 0 "Module loading failure"
  CHECK_RESULT $? 0 0 "vport_geneve not found"
  CHECK_RESULT $? 0 0 "vport-geneve remove failure"
  CHECK_RESULT $? 0 1 "vport_geneve exist"
  CHECK_RESULT $? 1 0 "error message was reported"
```

#### oe_test_swap_compress

- 描述：Test 内核-swap压缩
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "${swap1}" 0 0 "Uninstall Failed"
  CHECK_RESULT $? 0 0 "Erase failed"
  CHECK_RESULT $? 0 0 "Compression failed"
```

- 涉及命令：lvreduce×1, lvextend×1

#### oe_test_lpfc

- 描述：lpfc模块加载、卸载
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
  CHECK_RESULT $? 0 1 "Default installation"
  CHECK_RESULT $? 0 0 "Module loading failure"
  CHECK_RESULT $? 0 0 "vport_geneve not found"
  CHECK_RESULT $? 0 0 "vport-geneve remove failure"
  CHECK_RESULT $? 0 1 "vport_geneve exist"
  CHECK_RESULT $? 1 0 "error message was reported"
```

#### oe_test_check_huge_task

- 描述：检查内核是否打开HUNG TASK相关开关
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "DETECT_HUNG_TASK ERROR"
  CHECK_RESULT $? 0 0 "DETECT_HUNG_TASK_TIMEOUT ERROR"
  CHECK_RESULT $? 0 1 "BOOTPARAM_HUNG_TASK_PANIC_VALUE ERROR"
```

- 涉及命令：grep×3

#### oe_test_swappiness

- 描述：Test kernel swappiness set
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to vim swappiness"
  CHECK_RESULT $res1 60 0 "Failed to view swappiness information"
```

- 涉及命令：sysctl×2

#### oe_test_softdog

- 描述：softdog模块加载、卸载
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
  CHECK_RESULT $? 0 1 "Default uninstallation"
  CHECK_RESULT $? 0 0 "Module start"
  CHECK_RESULT $? 0 0 "softdog found"
  CHECK_RESULT $? 0 0 "softdog remove failure"
  CHECK_RESULT $? 0 1 "softdog stop"
  CHECK_RESULT $? 1 0 "error message was reported"
```

#### oe_test_cifs

- 描述：cifs模块加载、卸载
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
  CHECK_RESULT $? 0 1 "Default installation"
  CHECK_RESULT $? 0 0 "Module loading failure"
  CHECK_RESULT $? 0 0 "cifs not found"
  CHECK_RESULT $? 0 0 "cifs remove failure"
  CHECK_RESULT $? 0 1 "cifs exist"
  CHECK_RESULT $? 1 0 "error message was reported"
```

- 涉及命令：grep×3, modprobe×1

#### oe_test_xfs

- 描述：xfs模块加载、卸载
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Description Module information failed to be displayed"
  CHECK_RESULT $? 0 1 "Default uninstallation"
  CHECK_RESULT $? 0 0 "Module start"
  CHECK_RESULT $? 0 0 "xfs found"
  CHECK_RESULT $? 0 0 "xfs remove failure"
  CHECK_RESULT $? 0 1 "xfs stop"
  CHECK_RESULT $? 1 0 "error message was reported"
```

#### oe_test_wangxun

- 描述：内核-驱动-网讯网卡驱动
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Module ngbe not found"
  CHECK_RESULT $? 0 0 "modprobe ngbe failed"
  CHECK_RESULT $? 0 0 "lsmod failed"
  CHECK_RESULT $? 0 0 "unload ngbe failed"
  CHECK_RESULT $? 0 1 "ngbe info exist"
  CHECK_RESULT $? 0 0 "Module txgbe not found"
  CHECK_RESULT $? 0 0 "modprobe txgbe failed"
  CHECK_RESULT $? 0 0 "lsmod failed"
  CHECK_RESULT $? 0 0 "unload txgbe failed"
  CHECK_RESULT $? 0 1 "txgbe info exist"
```

- 涉及命令：modprobe×2

#### oe_test_vlan_8021q

- 描述：Test内核-支持vlan_8021q模块
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view information"
  CHECK_RESULT $? 0 0 "Module loading failed"
  CHECK_RESULT $? 0 1 "Module uninstallation failed"
```

#### oe_test_nbd

- 描述：Test 驱动加载_nbd
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view module information"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $rv 1 0 "Module not uninstalled"
```

- 涉及命令：rmmod×2

#### oe_test_libfc

- 描述：libfc module test
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_hpsa

- 描述：Huawei fnic  module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_bnx2fc

- 描述：Huawei fnic  module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_qla2xxx

- 描述：Test kernel-HQlogic drive（qla2xxx）
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view module information"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 1 0 "Module not uninstalled"
```

- 涉及命令：rmmod×1

#### oe_test_qla3xxx

- 描述：Test kernel-HQlogic drive（qla3xxx）
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_tcm_loop

- 描述：tcm_loop kernel testing
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_libcxgbi

- 描述：Huawei libcxgbi  module
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
  CHECK_RESULT $? 0 0 "Failed to detect information"
```

- 涉及命令：test×1

#### oe_test_libsas

- 描述：Huawei libsas  module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_qedf

- 描述：Huawei qedf.ko module
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
  CHECK_RESULT $? 0 0 "Failed to detect information"
```

- 涉及命令：test×1

#### oe_test_qedi

- 描述：Huawei qedi.ko module
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
  CHECK_RESULT $? 0 0 "Failed to detect information"
```

- 涉及命令：test×1

#### oe_test_pcie

- 描述：Huawei pcie module
- 函数：`run_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：modprobe×2, test×1

#### oe_test_acpi

- 描述：Huawei acpi module
- 函数：`pre_test, run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：modprobe×2, test×1

#### oe_test_uio

- 描述：Huawei uio module
- 函数：`run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：modprobe×4, test×1

#### oe_test_clk

- 描述：Huawei clk module
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module not loaded"
```

- 涉及命令：test×1

#### oe_test_mfd

- 描述：Huawei mfd module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module not loaded"
```

- 涉及命令：test×1

#### oe_test_bcma

- 描述：Huawei bcma module
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module not loaded"
```

- 涉及命令：test×1

#### oe_test_extcon

- 描述：Huawei extcon module
- 函数：`run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module not loaded"
```

- 涉及命令：test×1

#### oe_test_tee

- 描述：kernel tee module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module not loaded"
```

- 涉及命令：test×1

#### oe_test_regmap_01

- 描述：kernel regmap module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module not loaded"
```

- 涉及命令：test×1

#### oe_test_regmap_02

- 描述：kernel regmap-spi module test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "regmap-spi.ko.xz file does not exist"
  CHECK_RESULT $? 0 0 "regmap-spi module load failed"
  CHECK_RESULT $? 0 0 "regmap-spi module version info check failed"
  CHECK_RESULT $? 0 0 "regmap-spi module loaded check failed"
  CHECK_RESULT $? 0 0 "regmap-spi module unload failed"
  CHECK_RESULT $? 1 0 "regmap-spi module not unloaded completely"
```

- 涉及命令：test×1

#### oe_test_ceph

- 描述：Kernel CEPH testing
- 函数：`run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
  CHECK_RESULT $? 0 0 "Failed to detect information"
```

- 涉及命令：test×1, grep×1

#### oe_test_radeon

- 描述：Kernel radeon testing
- 函数：`run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "radeon not loaded"
  CHECK_RESULT $? 0 0 "radeon loaded failed"
  CHECK_RESULT $? 0 0 "radeon uninstall failed"
  CHECK_RESULT $? 1 0  "Module loaded"
  CHECK_RESULT $? 0 0 "Failed to detect information"
```

- 涉及命令：test×1

#### oe_test_target_core_file

- 描述：Huawei target_core_file.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_target_core_iblock

- 描述：Huawei target_core_iblock.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_target_core_mod

- 描述：Huawei target_core_mod.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_target_core_pscsi

- 描述：Huawei target_core_pscsi.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_target_core_user

- 描述：Huawei target_core_user.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_net_ifb

- 描述：Huawei ifb.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_net_veth

- 描述：Huawei veth.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_ngsm

- 描述：Huawei n_gsm.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_nhdlc

- 描述：Huawei n_hdlc.ko module
- 函数：`run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_mlx4_core

- 描述：Test kernel-mellanox drive（mlx4_core）
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_mlx5_core

- 描述：Test kernel-mellanox drive（mlx5_core）
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_mlxfw

- 描述：Test kernel-mellanox drive（mlxfw）
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_hinic3

- 描述：内核增加华为hinic3网卡驱动
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_rnpm

- 描述：Huawei rnpm
- 函数：`pre_test, run_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "file does not exist"
  CHECK_RESULT $? 0 0 "Information display failed"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Module loaded failed"
  CHECK_RESULT $? 0 0 "Module uninstall failed"
  CHECK_RESULT $? 1 0 "Module loaded"
```

- 涉及命令：test×1

#### oe_test_led-class-flash

- 描述：kernel led-class-flash module test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Module file missing"
  CHECK_RESULT $? 0 0 "Load failed"
  CHECK_RESULT $? 0 0 "Version info missing"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Unload failed"
  CHECK_RESULT $? 0 0 "Module still loaded"
```

- 涉及命令：modprobe×3, test×1, grep×1

#### oe_test_leds_blinkm

- 描述：kernel leds-blinkm module test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Module file missing"
  CHECK_RESULT $? 0 0 "Load failed"
  CHECK_RESULT $? 0 0 "Version info missing"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Unload failed"
  CHECK_RESULT $? 0 0 "Module still loaded"
```

- 涉及命令：modprobe×3, test×1, grep×1

#### oe_test_leds_lm3530

- 描述：kernel leds-lm3530 module test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Module file missing"
  CHECK_RESULT $? 0 0 "Load failed"
  CHECK_RESULT $? 0 0 "Version info missing"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Unload failed"
  CHECK_RESULT $? 0 0 "Module still loaded"
```

- 涉及命令：modprobe×3, test×1, grep×1

#### oe_test_leds_lp3944

- 描述：kernel leds-lp3944 module test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Module file missing"
  CHECK_RESULT $? 0 0 "Load failed"
  CHECK_RESULT $? 0 0 "Version info missing"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Unload failed"
  CHECK_RESULT $? 0 0 "Module still loaded"
```

- 涉及命令：modprobe×3, test×1, grep×1

#### oe_test_leds_lt3593

- 描述：kernel leds-lt3593 module test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Module file missing"
  CHECK_RESULT $? 0 0 "Load failed"
  CHECK_RESULT $? 0 0 "Version info missing"
  CHECK_RESULT $? 0 0 "Module not loaded"
  CHECK_RESULT $? 0 0 "Unload failed"
  CHECK_RESULT $? 0 0 "Module still loaded"
```

- 涉及命令：modprobe×3, test×1, grep×1

#### oe_test_dax_cxl

- 描述：test dax_cxl.ko.xz module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
  CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"
  CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"
  CHECK_RESULT $? 0 0 "${mod_name} is not loaded"
  CHECK_RESULT $? 0 0 "modprobe -r ${mod_name} failed"
  CHECK_RESULT $? 1 0 "${mod_name} is not unloaded"
```

- 涉及命令：grep×2, modprobe×2

#### oe_test_dax_pmem

- 描述：test dax_pmem.ko.xz module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
  CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"
  CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"
  CHECK_RESULT $? 0 0 "${mod_name} is not loaded"
  CHECK_RESULT $? 0 0 "modprobe -r ${mod_name} failed"
  CHECK_RESULT $? 1 0 "${mod_name} is not unloaded"
```

- 涉及命令：grep×2, modprobe×2

#### oe_test_dax_hmem

- 描述：test dax_hmem.ko.xz module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
  CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"
  CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"
  CHECK_RESULT $? 0 0 "${mod_name} is not loaded"
  CHECK_RESULT $? 0 0 "modprobe -r ${mod_name} failed"
  CHECK_RESULT $? 1 0 "${mod_name} is not unloaded"
```

- 涉及命令：grep×2, modprobe×2

#### oe_test_dax_kmem

- 描述：test kmem.ko.xz module
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
  CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"
  CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"
  CHECK_RESULT $? 0 0 "${mod_name} is not loaded"
```

- 涉及命令：grep×1

#### oe_test_cxl_acpi

- 描述：test cxl_acpi.ko.xz module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
  CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"
  CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"
  CHECK_RESULT $? 0 0 "${mod_name} is not loaded"
  CHECK_RESULT $? 0 0 "modprobe -r ${mod_name} failed"
  CHECK_RESULT $? 1 0 "${mod_name} is not unloaded"
```

- 涉及命令：grep×2, modprobe×2

#### oe_test_cxl_mem

- 描述：test cxl_mem.ko.xz module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
  CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"
  CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"
  CHECK_RESULT $? 0 0 "${mod_name} is not loaded"
  CHECK_RESULT $? 0 0 "modprobe -r ${mod_name} failed"
  CHECK_RESULT $? 1 0 "${mod_name} is not unloaded"
```

- 涉及命令：grep×2, modprobe×2

#### oe_test_cxl_pci

- 描述：test cxl_pci.ko.xz module
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check ${mod_name} file exist failed"
  CHECK_RESULT $? 0 0 "modinfo ${mod_name} failed"
  CHECK_RESULT $? 0 0 "modprobe ${mod_name} failed"
  CHECK_RESULT $? 0 0 "${mod_name} is not loaded"
  CHECK_RESULT $? 0 0 "modprobe -r ${mod_name} failed"
  CHECK_RESULT $? 1 0 "${mod_name} is not unloaded"
```

- 涉及命令：grep×2, modprobe×2
