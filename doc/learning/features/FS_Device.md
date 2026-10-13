# FS_Device

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_Device` |
| 注册用例数 | 21 |
| 环境约束 | machine num = 2；add disk = 20 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_check_dm_info | Create lvm to check dm info | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_dm_info | Check available dm on system | run_test/post_test | 4 |  |  |  |
| oe_test_raid_auto_mount | create md to auto mount when reboot | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_raid_compress | Compress to system and act md | config_params/pre_test/run_test/post_test | 3 | ✔ |  | 60m |
| oe_test_raid_faulty_1 | Set one of devices on raid1 is faulty | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_raid_faulty_2 | Set one of devices on raid5 is faulty | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_raid_faulty_3 | Set two of devices on raid5 are faulty | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_raid_faulty_add_device | test one of devices on md is faulty | config_params/pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_raid_faulty_rw | Set one of devices on md is faulty and rw | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_raid_faulty_w | Set one of devices on md is faulty and rw | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_raid_react | Add and remove device on md | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_raid_rm_ko | Add and remove mode for md | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_raid_ro | create md by ro | config_params/pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_raid_rw | create md by rw | config_params/pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_snapshot_dump | Dump data by snapshot | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_snapshot_lvconvert | lvconvert snapshot | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_snapshot_rw | Create snapshot and rw | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_swap_auto_mount | Auto mount swap device | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_swap_close | Close swap and reboot | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_swap_close_temp | Close swap temporary | run_test | 1 |  |  |  |
| oe_test_swap_mkswap | Create lvm to make swab | config_params/pre_test/run_test/post_test | 4 |  |  |  |

### 断言与命令明细

#### oe_test_check_dm_info

- 描述：Create lvm to check dm info
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check blkid info for $lv_name failed."
```

#### oe_test_dm_info

- 描述：Check available dm on system
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check fdisk -l failed."
  CHECK_RESULT $? 0 0 "Check dmsetup ls failed."
  CHECK_RESULT $? 0 0 "Check dmsetup info failed."
  CHECK_RESULT $? 0 0 "Check blkid failed."
```

- 涉及命令：grep×2, fdisk×1

#### oe_test_raid_auto_mount

- 描述：create md to auto mount when reboot
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Create md failed."
  CHECK_RESULT $? 0 0 "Check md failed."
  CHECK_RESULT $? 0 0 "mkfs failed."
  CHECK_RESULT $? 0 0 "Mount md failed."
  CHECK_RESULT $? 0 0 "Auto mount md when reboot failed."
```

#### oe_test_raid_compress

- 描述：Compress to system and act md
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
  CHECK_RESULT $? 0 0 "Remove ${disk_name}2 faulty failed."
  CHECK_RESULT $? 0 0 "Add ${disk_name}2 faulty failed."
```

#### oe_test_raid_faulty_1

- 描述：Set one of devices on raid1 is faulty
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_raid_faulty_2

- 描述：Set one of devices on raid5 is faulty
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_raid_faulty_3

- 描述：Set two of devices on raid5 are faulty
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_raid_faulty_add_device

- 描述：test one of devices on md is faulty
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check md status failed."
  CHECK_RESULT $? 0 0 "Check md status failed."
  CHECK_RESULT $? 0 0 "Check md infos failed."
  CHECK_RESULT $? 0 0 "Check md status failed."
  CHECK_RESULT $? 0 0 "Check md status failed."
  CHECK_RESULT $? 0 0 "Write file failed."
```

- 涉及命令：mdadm×5

#### oe_test_raid_faulty_rw

- 描述：Set one of devices on md is faulty and rw
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_raid_faulty_w

- 描述：Set one of devices on md is faulty and rw
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Set ${disk_name}2 faulty failed."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_raid_react

- 描述：Add and remove device on md
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Remove device part failed."
  CHECK_RESULT $? 0 0 "Add device part failed."
  CHECK_RESULT $? 0 0 "Write file failed."
  CHECK_RESULT $? 0 0 "Read file failed."
```

#### oe_test_raid_rm_ko

- 描述：Add and remove mode for md
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Remove mode failed."
  CHECK_RESULT $? 0 0 "Add mode failed."
  CHECK_RESULT $? 0 0 "Write file failed."
  CHECK_RESULT $? 0 0 "Read file failed."
```

#### oe_test_raid_ro

- 描述：create md by ro
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Create md failed."
  CHECK_RESULT $? 0 0 "Check md failed."
  CHECK_RESULT $? 0 0 "mkfs failed."
  CHECK_RESULT $? 0 0 "Mount md failed."
  CHECK_RESULT $? 0 0 "Write file unexpectly."
  CHECK_RESULT $? 0 0 "Create directory unexpectly."
```

- 涉及命令：mdadm×1, mkfs×1

#### oe_test_raid_rw

- 描述：create md by rw
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Create md failed."
  CHECK_RESULT $? 0 0 "Check md failed."
  CHECK_RESULT $? 0 0 "mkfs failed."
  CHECK_RESULT $? 0 0 "Mount md failed."
  CHECK_RESULT $? 0 0 "Create file failed."
  CHECK_RESULT $? 0 0 "Read file failed."
```

- 涉及命令：mdadm×1, mkfs×1

#### oe_test_snapshot_dump

- 描述：Dump data by snapshot
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Dump data failed."
  CHECK_RESULT $? 0 0 "The xfsrestorehousekeepingdir doesn't exist."
  CHECK_RESULT $? 0 0 "Dump data failed."
  CHECK_RESULT $? 0 0 "The file restoresymtable doesn't exist."
  CHECK_RESULT $? 0 0 "Check data failed."
```

- 涉及命令：test×2, read×1, xfsdump×1, xfsrestore×1, dump×1, restore×1, grep×1

#### oe_test_snapshot_lvconvert

- 描述：lvconvert snapshot
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Create snapshot failed."
  CHECK_RESULT $? 0 0 "Mount snapshot failed."
  CHECK_RESULT $? 0 0 "Check file in snapshot failed."
  CHECK_RESULT $? 0 0 "Check directory in snapshot failed."
  CHECK_RESULT $? 0 0 "lvconvert snapshot failed."
  CHECK_RESULT $? 0 0 "lvconvert snapshot failed."
```

- 涉及命令：grep×2, read×1, lvcreate×1, mount×1, test×1

#### oe_test_snapshot_rw

- 描述：Create snapshot and rw
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Create snapshot failed."
  CHECK_RESULT $? 0 0 "Mount snapshot failed."
  CHECK_RESULT $? 0 0 "Check file in snapshot failed."
  CHECK_RESULT $? 0 0 "Check directory in snapshot failed."
  CHECK_RESULT $? 0 0 "Umount snapshot failed."
```

- 涉及命令：read×1, lvcreate×1, mount×1, test×1

#### oe_test_swap_auto_mount

- 描述：Auto mount swap device
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Add mount swap on /etc/fstab failed."
  CHECK_RESULT $? 0 0 "Add swap failed."
```

#### oe_test_swap_close

- 描述：Close swap and reboot
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Delete mount swap on /etc/fstab failed."
  CHECK_RESULT $? 0 0 "Close swap failed."
```

#### oe_test_swap_close_temp

- 描述：Close swap temporary
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Close and open swap temporary succeed."
```

- 涉及命令：swapoff×1, swapon×1

#### oe_test_swap_mkswap

- 描述：Create lvm to make swab
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The new device doesn't add to swap."
  CHECK_RESULT $? 0 0 "Check swap device failed."
  CHECK_RESULT $? 0 0 "Remove swap device failed."
  CHECK_RESULT $? 0 0 "The new device doesn't add to swap."
```

- 涉及命令：swapon×1
