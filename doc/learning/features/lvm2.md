# lvm2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lvm2` |
| 注册用例数 | 32 |
| 环境约束 | add disk = 10,10,10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_lvm2_snap_001 | lvm-snap test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_lvm2_snap_002 | lvm-snap delete test | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_lvm2_snap_003 | lvm-snap merge test | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_lvm2_snap_004 | lvm-snap merge error param | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_lvm2_snap_005 | lvm-snap merge error param 2 | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_service_blk-availability | Test blk-availability.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_dm-event | Test dm-event.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_lvm2-lvmdbusd | Test lvm2-lvmdbusd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_lvm2-lvmpolld | Test lvm2-lvmpolld.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_lvm2-monitor | Test lvm2-monitor.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_lvmlockd | Test lvmlockd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_lvmlocks | Test lvmlocks.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_dm-event | Test dm-event.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_lvm2-lvmpolld | Test lvm2-lvmpolld.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_lvm2_pvremove_001 | lvm2 command test | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_lvm2_pvcreate_002 | lvm2 command test | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_lvm2_pvresize_001 | lvm2 command test-pvresize | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_lvm2_pvcreate_001 | lvm2 command test | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_lvm2_pvmove_001 | lvm2 command test | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_lvm2_vgcreate_001 | lvm2 command test | pre_test/run_test/post_test | 28 | ✔ |  |  |
| oe_test_lvm2_pvdisplay_002 | lvm2 command test | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_lvm2_vgdisplay_001 | lvm2 command test | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_lvm2_vgrename_001 | lvm2 command test | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_lvm2_pvdisplay_001 | lvm2 command test | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_lvm2_pvmove_002 | lvm2 command test | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_lvm2_pvchange_001 | lvm2 command test | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_lvm2_vgchange_001 | lvm2 command test | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_lvm2_vgextend_002 | lvm2 command test | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_lvm2_vgextend_001 | lvm2 command test | pre_test/run_test/post_test | 25 | ✔ |  |  |
| oe_test_lvm2_vgexport_001 | lvm2 command test | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_lvm2_vgchange_002 | lvm2 command test | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_dmevent-service | dm-event.service restart test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_lvm2_snap_001

- 描述：lvm-snap test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 'pv is creat success'
  CHECK_RESULT $? 0 0 'vg is creat success'
  CHECK_RESULT $? 0 0 'lv is creat success'
  CHECK_RESULT $? 0 0 'mkfs is creat success'
  CHECK_RESULT $? 0 0 'mount is success'
  CHECK_RESULT $? 0 0 'snap is creat success'
```

- 涉及命令：lvcreate×2, lvremove×2, pvcreate×1, vgcreate×1, mkfs.ext4×1, mkdir×1, vgremove×1, pvremove×1

#### oe_test_lvm2_snap_002

- 描述：lvm-snap delete test
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 'pv is creat success'
  CHECK_RESULT $? 0 0 'vg is creat success'
  CHECK_RESULT $? 0 0 'lv is creat success'
  CHECK_RESULT $? 0 0 'mkfs is creat success'
  CHECK_RESULT $? 0 0 'mount is success'
  CHECK_RESULT $? 0 0 'snap 1 is creat success'
  CHECK_RESULT $? 0 0 'snap 2  is creat success'
  CHECK_RESULT $? 0 0 'snap1 snapshot info is right'
  CHECK_RESULT $? 0 0 'snap2 snapshot info is right'
  CHECK_RESULT $? 0 0 'snap1 linear info is right'
  CHECK_RESULT $? 0 0 'snap2 linear info is right'
  CHECK_RESULT $? 0 0 'snap1 snapshot-origin info is right'
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：lvcreate×3, lvremove×3, pvcreate×1, vgcreate×1, mkfs.ext4×1, mkdir×1, vgremove×1, pvremove×1

#### oe_test_lvm2_snap_003

- 描述：lvm-snap merge test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'pv is creat success'
  CHECK_RESULT $? 0 0 'vg is creat success'
  CHECK_RESULT $? 0 0 'lv is creat success'
  CHECK_RESULT $? 0 0 'mkfs is creat success'
  CHECK_RESULT $? 0 0 'mount is success'
  CHECK_RESULT $? 0 0 'snap is creat success'
  CHECK_RESULT $? 0 0 'snap convert is success'
  CHECK_RESULT $? 0 1 'origin data is clean'
  CHECK_RESULT $? 0 1 'origin data is clean'
```

- 涉及命令：lvcreate×2, grep×2, pvcreate×1, vgcreate×1, mkfs.ext4×1, mkdir×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_lvm2_snap_004

- 描述：lvm-snap merge error param
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 'pv is creat success'
  CHECK_RESULT $? 0 0 'vg is creat success'
  CHECK_RESULT $? 0 0 'lv is creat success'
  CHECK_RESULT $? 0 0 'mkfs is creat success'
  CHECK_RESULT $? 0 0 'mount is success'
  CHECK_RESULT $? 0 0 'snap is creat success'
  CHECK_RESULT $? 0 1 "error merge param"
  CHECK_RESULT $? 0 1 "error merge param"
  CHECK_RESULT $? 0 1 "error merge param"
  CHECK_RESULT $? 0 1 "error merge param"
  CHECK_RESULT $? 0 1 "error merge param"
  CHECK_RESULT $? 0 1 "error merge param"
```

- 涉及命令：lvcreate×2, lvremove×2, pvcreate×1, vgcreate×1, mkfs.ext4×1, mkdir×1, lvconvert×1, vgremove×1, pvremove×1

#### oe_test_lvm2_snap_005

- 描述：lvm-snap merge error param 2
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 'pv is creat success'
  CHECK_RESULT $? 0 0 'vg is creat success'
  CHECK_RESULT $? 0 0 'lv is creat success'
  CHECK_RESULT $? 0 0 'mkfs is creat success'
  CHECK_RESULT $? 0 0 'mount is success'
  CHECK_RESULT $? 0 1 "error merge param: --snapshot"
  CHECK_RESULT $? 0 1 "error merge param: --snapshot"
  CHECK_RESULT $? 0 1 "error merge param: --snapshot"
  CHECK_RESULT $? 0 1 "error merge param: --size"
  CHECK_RESULT $? 0 1 "error merge param: --size"
  CHECK_RESULT $? 0 1 "error merge param: --size"
  CHECK_RESULT $? 0 1 "error merge param : size range"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：lvcreate×5, pvcreate×1, vgcreate×1, mkfs.ext4×1, mkdir×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_service_blk-availability

- 描述：Test blk-availability.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_dm-event

- 描述：Test dm-event.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_lvm2-lvmdbusd

- 描述：Test lvm2-lvmdbusd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_lvm2-lvmpolld

- 描述：Test lvm2-lvmpolld.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_lvm2-monitor

- 描述：Test lvm2-monitor.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_lvmlockd

- 描述：Test lvmlockd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_lvmlocks

- 描述：Test lvmlocks.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_dm-event

- 描述：Test dm-event.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_lvm2-lvmpolld

- 描述：Test lvm2-lvmpolld.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_lvm2_pvremove_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：pvcreate×10, pvremove×5

#### oe_test_lvm2_pvcreate_002

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

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
  CHECK_RESULT $?
```

- 涉及命令：pvremove×1

#### oe_test_lvm2_pvresize_001

- 描述：lvm2 command test-pvresize
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

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
  CHECK_RESULT $?
```

- 涉及命令：pvresize×7, pvcreate×1, pvremove×1

#### oe_test_lvm2_pvcreate_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：pvcreate×4, pvremove×1

#### oe_test_lvm2_pvmove_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：pvmove×2, pvremove×2, pvcreate×1, vgremove×1

#### oe_test_lvm2_vgcreate_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（28 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 28 条（其余见源脚本）
```

- 涉及命令：pvcreate×1, pvck×1, vgcreate×1, pvremove×1

#### oe_test_lvm2_pvdisplay_002

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：pvdisplay×3, pvcreate×1, pvremove×1

#### oe_test_lvm2_vgdisplay_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：vgdisplay×3, pvcreate×1, vgremove×1, pvremove×1

#### oe_test_lvm2_vgrename_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：pvcreate×1, vgremove×1, pvremove×1

#### oe_test_lvm2_pvdisplay_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvdisplay×6, pvcreate×1, pvremove×1

#### oe_test_lvm2_pvmove_002

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：pvmove×4, pvremove×2, pvcreate×1, vgremove×1

#### oe_test_lvm2_pvchange_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

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
```

- 涉及命令：pvcreate×1, pvchange×1, pvremove×1

#### oe_test_lvm2_vgchange_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "create PV failed"
  CHECK_RESULT $? 0 0 "create PV failed"
  CHECK_RESULT $? 0 0 "create VG failed"
  CHECK_RESULT $? 0 0 "create VG failed"
  CHECK_RESULT $? 0 0 "vgchange logicalvolume size failed"
  CHECK_RESULT $? 0 0 "create LV failed"
  CHECK_RESULT $? 0 0 "Maximum number of logical volumes (1) reached"
  CHECK_RESULT $? 0 0 "set maxphysicalvolumes failed"
  CHECK_RESULT $? 0 0 "create PV failed"
  CHECK_RESULT $? 0 0 "vgextend failed"
  CHECK_RESULT $? 0 0 "lvremove failed"
  CHECK_RESULT $? 0 0 "vgchange -u failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：pvcreate×2, lvremove×1, vgchange×1, vgremove×1, pvremove×1

#### oe_test_lvm2_vgextend_002

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "failed to creat PV"
  CHECK_RESULT $? 0 0 "failed to creat PV"
  CHECK_RESULT $? 0 0 "failed to creat VG"
  CHECK_RESULT $? 0 0 "failed to creat PV"
  CHECK_RESULT $? 0 0 "failed to vgextend --dataalignment"
  CHECK_RESULT $? 0 0 "failed to creat PV"
  CHECK_RESULT $? 0 0 "failed to creat VG"
  CHECK_RESULT $? 0 0 "failed to vgextend --dataalignmentoffset"
  CHECK_RESULT $? 0 0 "failed to creat VG"
  CHECK_RESULT $? 0 0 "failed to vgextend --reportformat basic"
  CHECK_RESULT $? 0 0 "failed to vgextend --help"
  CHECK_RESULT $? 0 0 "failed to test extend version"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：vgremove×6, vgextend×3, pvcreate×1, pvremove×1

#### oe_test_lvm2_vgextend_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（25 条）：

```
  CHECK_RESULT $? 0 0 "failed to create PV"
  CHECK_RESULT $? 0 0 "failed to create PV"
  CHECK_RESULT $? 0 0 "failed to create VG"
  CHECK_RESULT $? 0 0 "failed to create VG"
  CHECK_RESULT $? 0 0 "failed to extend VG test"
  CHECK_RESULT $? 0 0 "failed to create PV"
  CHECK_RESULT $? 0 0 "failed to create VG"
  CHECK_RESULT $? 0 0 "failed to extend VG test -- autobackup y"
  CHECK_RESULT $? 0 0 "failed to create VG"
  CHECK_RESULT $? 0 0 "failed to extend VG -d"
  CHECK_RESULT $? 0 0 "failed to create VG"
  CHECK_RESULT $? 0 0 "failed to extend VG -f"
  ... 共 25 条（其余见源脚本）
```

- 涉及命令：vgremove×11, pvcreate×1, pvremove×1

#### oe_test_lvm2_vgexport_001

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "create PV failed"
  CHECK_RESULT $? 0 0 "create PV failed"
  CHECK_RESULT $? 0 0 "create VG failed"
  CHECK_RESULT $? 0 0 "create VG failed"
  CHECK_RESULT $? 0 0 "failed to export VG test"
  CHECK_RESULT $? 0 0 "failed to export VG test"
  CHECK_RESULT $? 0 0 "failed to export VG test --reportformat basic"
  CHECK_RESULT $? 0 0 "failed to export VG test --reportformat basic"
  CHECK_RESULT $? 0 0 "failed to export VG test -v"
  CHECK_RESULT $? 0 0 "failed to export VG test -t"
  CHECK_RESULT $? 0 0 "failed to export VG test -q"
  CHECK_RESULT $? 0 0 "vgexport --help failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：vgexport×5, pvcreate×1, vgremove×1, pvremove×1

#### oe_test_lvm2_vgchange_002

- 描述：lvm2 command test
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "create PV failed"
  CHECK_RESULT $? 0 0 "create PV failed"
  CHECK_RESULT $? 0 0 "create VG failed"
  CHECK_RESULT $? 0 0 "create VG failed"
  CHECK_RESULT $? 0 0 "vgchange --longhelp failed"
  CHECK_RESULT $? 0 0 "vgchange --help failed"
  CHECK_RESULT $? 0 0 "failed to test vgchange --version"
  CHECK_RESULT $? 0 0 "failed to test vgchange --poll y"
  CHECK_RESULT $? 0 0 "failed to test vgchange --refresh --autobackup y"
  CHECK_RESULT $? 0 0 "failed to test vgchange --refresh --sysinit"
  CHECK_RESULT $? 0 0 "failed to test vgchange --refresh --reportformat basic"
  CHECK_RESULT $? 0 0 "vgchange --refresh --reportformat json"
```

- 涉及命令：pvcreate×1, vgremove×1, pvremove×1

#### oe_test_dmevent-service

- 描述：dm-event.service restart test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "dm-event service status failed"
  CHECK_RESULT $? 0 0 "stop dm-event service failed"
  CHECK_RESULT $? 0 0 "restart  dm-event service failed"
```
