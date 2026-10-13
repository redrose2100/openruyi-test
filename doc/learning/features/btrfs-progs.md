# btrfs-progs

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/btrfs-progs` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_btrfs-progs_install | btrfs-progs install verification and package check | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_btrfs-progs_cli_global_01 | btrfs global options and filesystem basics test | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_btrfs-progs_cli_global_02 | mkfs.btrfs basic options test | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_btrfs-progs_cli_filesystem_01 | btrfs filesystem df/du/show/sync test | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_btrfs-progs_cli_filesystem_02 | btrfs filesystem defragment/resize test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_btrfs-progs_cli_filesystem_03 | btrfs filesystem label/usage/mkswapfile test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_btrfs-progs_cli_subvolume | btrfs subvolume test - actual command execution | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_btrfs-progs_cli_operation | btrfs operation test - balance, scrub, property actual execution | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_btrfs-progs_cli_quota | btrfs quota and qgroup test - actual command execution | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_btrfs-progs_cli_inspect_01 | btrfs inspect-internal test | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_btrfs-progs_cli_inspect_02 | btrfs device/replace test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_btrfs-progs_cli_inspect_03 | btrfs check/restore/rescue test (offline operations) | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_btrfs-progs_cls_cmd_01 | btrfs send/receive test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_btrfs-progs_cls_cmd_02 | mkfs.btrfs advanced options test | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_btrfs-progs_filesystem | btrfs filesystem operations test - create/mount/format | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_btrfs-progs_install

- 描述：btrfs-progs install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "btrfs-progs package not installed"
  CHECK_RESULT $? 0 0 "Failed to get btrfs-progs package info"
  CHECK_RESULT $? 0 0 "btrfs command not found"
  CHECK_RESULT $? 0 0 "mkfs.btrfs command not found"
  CHECK_RESULT $? 0 0 "btrfs version check failed"
  CHECK_RESULT $? 0 0 "btrfs help check failed"
```

- 涉及命令：rpm×2, command×2

#### oe_test_btrfs-progs_cli_global_01

- 描述：btrfs global options and filesystem basics test
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "btrfs -v version failed"
  CHECK_RESULT $? 0 0 "btrfs --format json version failed"
  CHECK_RESULT $? 0 0 "btrfs --quiet version failed"
  CHECK_RESULT $? 0 0 "btrfs --help failed"
  CHECK_RESULT $? 0 0 "btrfs global help version check failed"
  CHECK_RESULT $? 0 0 "btrfs global help filesystem check failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem df failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem df output verification failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem usage failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem usage output verification failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem show failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem show output verification failed"
  ... 共 15 条（其余见源脚本）
```

#### oe_test_btrfs-progs_cli_global_02

- 描述：mkfs.btrfs basic options test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "mkfs.btrfs -f failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -L failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -d single failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -d dup failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -m single failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -m dup failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -s failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -n failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs help -L check failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs help -d check failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs help -m check failed"
```

- 涉及命令：losetup×1

#### oe_test_btrfs-progs_cli_filesystem_01

- 描述：btrfs filesystem df/du/show/sync test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "btrfs filesystem df failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem df output verification failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem df -h failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem du failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem du on file failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem du -s failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem du --human-readable failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem show failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem show device failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem show output verification failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem sync failed"
```

#### oe_test_btrfs-progs_cli_filesystem_02

- 描述：btrfs filesystem defragment/resize test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "btrfs filesystem defragment failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem defragment -f failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem defragment -r failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem defragment -c failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem defragment -l failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem resize max failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem resize help failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem resize options check failed"
```

#### oe_test_btrfs-progs_cli_filesystem_03

- 描述：btrfs filesystem label/usage/mkswapfile test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "btrfs filesystem label set failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem label get failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem label on device failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem label get from device failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem usage failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem usage output verification failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem usage help failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem sync failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem show failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem df failed"
```

#### oe_test_btrfs-progs_cli_subvolume

- 描述：btrfs subvolume test - actual command execution
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "btrfs subvolume create failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume list verification failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume snapshot failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume list snapshot verification failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume show failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume get-default failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume find-new failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume delete snapshot failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume delete verification failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume sync failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume show after operations failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume snapshot -r failed"
  ... 共 13 条（其余见源脚本）
```

#### oe_test_btrfs-progs_cli_operation

- 描述：btrfs operation test - balance, scrub, property actual execution
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "btrfs property set compression failed"
  CHECK_RESULT $? 0 0 "btrfs property get compression failed"
  CHECK_RESULT $? 0 0 "btrfs property set compression lzo failed"
  CHECK_RESULT $? 0 0 "btrfs property get compression lzo failed"
  CHECK_RESULT $? 0 0 "btrfs property list failed"
  CHECK_RESULT $? 0 0 "btrfs balance start failed"
  CHECK_RESULT $? 0 0 "btrfs balance status failed"
  CHECK_RESULT $? 0 0 "btrfs balance start -musage failed"
  CHECK_RESULT $? 0 0 "btrfs scrub start failed"
  CHECK_RESULT $? 0 0 "btrfs scrub status failed"
  CHECK_RESULT $? 0 0 "btrfs scrub no errors check failed"
  CHECK_RESULT $? 0 0 "btrfs scrub status after completion failed"
  ... 共 16 条（其余见源脚本）
```

#### oe_test_btrfs-progs_cli_quota

- 描述：btrfs quota and qgroup test - actual command execution
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "btrfs quota enable failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume create for quota failed"
  CHECK_RESULT $? 0 0 "Create test data failed"
  CHECK_RESULT $? 0 0 "btrfs quota rescan failed"
  CHECK_RESULT $? 0 0 "btrfs qgroup show failed"
  CHECK_RESULT $? 0 0 "btrfs qgroup show verification failed"
  CHECK_RESULT $? 0 0 "btrfs qgroup create failed"
  CHECK_RESULT $? 0 0 "btrfs qgroup limit failed"
  CHECK_RESULT $? 0 0 "btrfs qgroup limit verification failed"
  CHECK_RESULT $? 0 0 "btrfs qgroup show -r failed"
  CHECK_RESULT $? 0 0 "btrfs subvolume create quota_vol2 failed"
  CHECK_RESULT $? 0 0 "btrfs qgroup assign failed"
  ... 共 19 条（其余见源脚本）
```

#### oe_test_btrfs-progs_cli_inspect_01

- 描述：btrfs inspect-internal test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "btrfs inspect-internal rootid failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal min-dev-size failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal min-dev-size output verification failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal inode-resolve failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal inode-resolve output verification failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal subvolid-resolve failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal dump-super failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal dump-super output verification failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal tree-stats failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal logical-resolve help failed"
  CHECK_RESULT $? 0 0 "btrfs inspect-internal dump-tree help failed"
```

#### oe_test_btrfs-progs_cli_inspect_02

- 描述：btrfs device/replace test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "btrfs device usage failed"
  CHECK_RESULT $? 0 0 "btrfs device usage output verification failed"
  CHECK_RESULT $? 0 0 "btrfs device stats failed"
  CHECK_RESULT $? 0 0 "btrfs device stats path failed"
  CHECK_RESULT $? 0 0 "btrfs device scan failed"
  CHECK_RESULT $? 0 0 "btrfs device scan help failed"
  CHECK_RESULT $? 0 0 "btrfs device add failed"
  CHECK_RESULT $? 0 0 "btrfs device remove failed"
  CHECK_RESULT $? 0 0 "btrfs replace status failed"
  CHECK_RESULT $? 0 0 "btrfs replace options check failed"
```

- 涉及命令：losetup×1

#### oe_test_btrfs-progs_cli_inspect_03

- 描述：btrfs check/restore/rescue test (offline operations)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "btrfs check device failed"
  CHECK_RESULT $? 0 0 "btrfs check --force failed"
  CHECK_RESULT $? 0 0 "btrfs check output verification failed"
  CHECK_RESULT $? 0 0 "btrfs restore failed"
  CHECK_RESULT $? 0 0 "btrfs restore output verification failed"
  CHECK_RESULT $? 0 0 "btrfs restore help failed"
  CHECK_RESULT $? 0 0 "btrfs rescue help failed"
  CHECK_RESULT $? 0 0 "btrfs rescue zero-log help failed"
  CHECK_RESULT $? 0 0 "remount failed"
  CHECK_RESULT $? 0 0 "btrfs filesystem show after remount failed"
```

- 涉及命令：mkdir×1

#### oe_test_btrfs-progs_cls_cmd_01

- 描述：btrfs send/receive test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "btrfs send -f snapshot to file failed"
  CHECK_RESULT $? 0 0 "btrfs send file not created"
  CHECK_RESULT $? 0 0 "btrfs send --no-data failed"
  CHECK_RESULT $? 0 0 "btrfs send -p parent incremental failed"
  CHECK_RESULT $? 0 0 "btrfs send -c clone failed"
  CHECK_RESULT $? 0 0 "btrfs send -q quiet failed"
  CHECK_RESULT $? 0 0 "btrfs receive --dump failed"
  CHECK_RESULT $? 0 0 "btrfs receive -f from file failed"
  CHECK_RESULT $? 0 0 "btrfs receive subvolume verification failed"
  CHECK_RESULT $? 0 0 "btrfs receive incremental failed"
```

#### oe_test_btrfs-progs_cls_cmd_02

- 描述：mkfs.btrfs advanced options test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "mkfs.btrfs --csum crc32c failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs --csum sha256 failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -O no-holes failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -O mixed-bg failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -n nodesize failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -s sectorsize failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -d single failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -m dup failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -O extref failed"
  CHECK_RESULT $? 0 0 "mkfs.btrfs -L label failed"
```

#### oe_test_btrfs-progs_filesystem

- 描述：btrfs filesystem operations test - create/mount/format
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed to format device with btrfs"
  CHECK_RESULT $? 0 0 "Failed to create mount point"
  CHECK_RESULT $? 0 0 "Failed to mount btrfs filesystem"
  CHECK_RESULT $? 0 0 "btrfs filesystem not mounted"
  CHECK_RESULT $? 0 0 "Failed to create test file"
  CHECK_RESULT $? 0 0 "File content verification failed"
  CHECK_RESULT $? 0 0 "Failed to create btrfs subvolume"
  CHECK_RESULT $? 0 0 "Failed to list btrfs subvolume"
  CHECK_RESULT $? 0 0 "Failed to create btrfs snapshot"
  CHECK_RESULT $? 0 0 "Failed to get btrfs filesystem usage"
  CHECK_RESULT $? 0 0 "Failed to show btrfs filesystem info"
  CHECK_RESULT $? 0 0 "Failed to set btrfs property"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：mkfs.btrfs×1, mkdir×1
