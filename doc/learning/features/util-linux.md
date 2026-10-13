# util-linux

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/util-linux` |
| 注册用例数 | 22 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_fstrim | Test fstrim.service restart | pre_test/run_test | 0 |  |  |  |
| oe_test_util-linux_fincore | Command test-fincore | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_service_uuidd | Test uuidd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_uuidd | Test uuidd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_util-linux_mcookie | Command test-mcookie | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_libuuid | libuuid function | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_util-linux_utmpdump | Command test-utmpdump | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_unshare | Test unshare | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_hwclock | Test hwclock | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_mkfs_001 | Supports multiple formats of partition management | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_util-linux_chcpu | Test chcpu basic functionality | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_setarch | Test case for setarch command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_mesg | Test case for mesg command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_blkid | Command blkid | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_colcrt | Test case for colcrt command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_colrm | colrm Command test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_findfs_01 | Test command findfs | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_ionice | Ionice sets IO scheduling and priority testing for processes | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_swaplabel | Change partition label | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_script | Test case for script command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_setsid | Setsid backend execution program | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_nsenter | Test case for nsenter command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_fstrim

- 描述：Test fstrim.service restart
- 函数：`pre_test, run_test`
#### oe_test_util-linux_fincore

- 描述：Command test-fincore
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "new file succeeded"
  CHECK_RESULT $? 0 0 "file creation failure"
  CHECK_RESULT $? 0 0 "failed to delete columns 3 through 6 from the file"
  CHECK_RESULT $? 0 0 "description failed to view the dc help information"
  CHECK_RESULT $? 0 1 "description failed to view the dc version"
  CHECK_RESULT $? 0 0 "description failed to view the dc help information"
  CHECK_RESULT $? 0 0 "description failed to view the dc version"
```

- 涉及命令：fincore×4

#### oe_test_service_uuidd

- 描述：Test uuidd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_uuidd

- 描述：Test uuidd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_util-linux_mcookie

- 描述：Command test-mcookie
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "description failed to view the dc version"
  CHECK_RESULT $? 0 0 "failed to create file"
  CHECK_RESULT $? 0 0 "specifying file execution size to make cookie seed failed"
  CHECK_RESULT $? 0 0 "explanation An ongoing operation failed"
  CHECK_RESULT $? 0 0 "the corresponding field was not obtained"
  CHECK_RESULT $? 0 0 "failed to check version"
```

- 涉及命令：mcookie×3

#### oe_test_libuuid

- 描述：libuuid function
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "compilation fail"
  CHECK_RESULT $? 0 0 "excute fail"
  CHECK_RESULT "${num_uuid}" 4 0 "uuid generate fail"
```

#### oe_test_util-linux_utmpdump

- 描述：Command test-utmpdump
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "failed to view the utmp file"
  CHECK_RESULT $? 0 0 "the expected result was not found"
  CHECK_RESULT $? 0 0 "an error occurred when the file generation command was executed"
  CHECK_RESULT $? 0 0 "There is no tmp_output.txt file"
  CHECK_RESULT $? 0 0 "failed to write the dumped data back to the utmp file"
  CHECK_RESULT $? 0 0 "failed to print help information. Procedure"
  CHECK_RESULT $? 0 0 "description failed to view the prlimit version"
```

- 涉及命令：utmpdump×3

#### oe_test_unshare

- 描述：Test unshare
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "unshare is failed"
```

#### oe_test_hwclock

- 描述：Test hwclock
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "hwclock -r is failed!"
  CHECK_RESULT $? 0 0 "hwclock --hctosys is failed"
  CHECK_RESULT $? 0 0 "hwclock --systohc is failed"
  CHECK_RESULT $? 0 0 "hwclock --utc is failed"
  CHECK_RESULT $? 0 0 "hwclock --localtime is failed"
```

- 涉及命令：hwclock×1

#### oe_test_mkfs_001

- 描述：Supports multiple formats of partition management
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "log message: Failed install minimap2 "
  CHECK_RESULT $? 0 0 "formatting fail"
  CHECK_RESULT $? 0 0 "mount fail"
  CHECK_RESULT $? 0 0 "test fail"
  CHECK_RESULT $? 0 0 "umount fail"
```

- 涉及命令：losetup×1

#### oe_test_util-linux_chcpu

- 描述：Test chcpu basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "chcpu --help failed to show Usage"
  CHECK_RESULT $? 0 0 "chcpu -V failed to display version information"
  CHECK_RESULT $? 0 1 "chcpu -e success with invalid CPU number"
  CHECK_RESULT $? 0 1 "chcpu -d success with invalid CPU number"
  CHECK_RESULT $? 0 0 "chcpu -d 1 failed"
  CHECK_RESULT $? 0 0 "cpu1 is not disabled"
  CHECK_RESULT $? 0 0 "chcpu -e 1 failed"
  CHECK_RESULT $? 0 0 "cpu1 is not enabled"
  CHECK_RESULT 0 0 1 "cpu1 is not hotpluggable, current environment is not suitable for test"
```

- 涉及命令：chcpu×5

#### oe_test_setarch

- 描述：Test case for setarch command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "setarch $current_arch uname -m failed"
  CHECK_RESULT $? 0 0 "setarch ${expected_32arch} uname -m failed"
  CHECK_RESULT $? 0 0 "the changed arch not equal with expected 32 arch: $expected_32arch"
  CHECK_RESULT $? 0 1 "setarch with invalid arch should exit with non-zero code"
  CHECK_RESULT $? 0 0 "setarch -I failed"
  CHECK_RESULT $? 0 0 "setarch -F failed"
```

- 涉及命令：setarch×2

#### oe_test_mesg

- 描述：Test case for mesg command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? "$exp" 0 "mesg without arguments failed"
  CHECK_RESULT $? 0 0 "mesg y failed"
  CHECK_RESULT $? 0 0 "mesg y did not set state to allowed"
  CHECK_RESULT $? 1 0 "mesg n failed"
  CHECK_RESULT $? 0 0 "mesg n did not set state to disallowed"
  CHECK_RESULT $? 0 0 "mesg -v y failed"
  CHECK_RESULT $? 0 0 "mesg -v y output missing expected message"
  CHECK_RESULT $? 0 0 "mesg --help failed"
  CHECK_RESULT $? 0 0 "mesg --version failed"
```

#### oe_test_blkid

- 描述：Command blkid
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "BLKID View Help Command Failed"
  CHECK_RESULT $? 0 0 "List all block devices failed"
  CHECK_RESULT $? 0 0 "Failed to list system disk block devices"
  CHECK_RESULT $? 0 0 "Display system block device UUID failed"
  CHECK_RESULT $? 0 0 "Display system block device TYPE failed"
  CHECK_RESULT $? 0 0 "Output system block device failed in export format"
  CHECK_RESULT $? 0 0 "Failed to display BLOCK-SIZE and UUID for system block devices"
  CHECK_RESULT $? 0 0 "BLKID View Help Command Failed"
```

- 涉及命令：blkid×4

#### oe_test_colcrt

- 描述：Test case for colcrt command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "First line content check"
  CHECK_RESULT $? 0 0 "Underline rendering check"
  CHECK_RESULT $? 0 0 "colcrt - (no underlining) failed"
  CHECK_RESULT $? 0 0 "Line count check with no-underlining"
  CHECK_RESULT $? 0 0 "Content check with no-underlining"
  CHECK_RESULT $? 0 0 "Version check"
```

#### oe_test_colrm

- 描述：colrm Command test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "colrm command not found"
  CHECK_RESULT $? 0 0 "Failed to remove columns 3-5"
  CHECK_RESULT $? 0 0 "Failed to remove columns 1-3"
  CHECK_RESULT $? 0 0 "Failed to remove columns from 7 to end"
  CHECK_RESULT $? 0 0 "Failed to process multiple lines"
  CHECK_RESULT $? 0 0 "Failed to process multiple lines"
```

#### oe_test_findfs_01

- 描述：Test command findfs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "cannot find $DEV in system."
```

#### oe_test_ionice

- 描述：Ionice sets IO scheduling and priority testing for processes
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The priority of the sleep process is not 0"
  CHECK_RESULT $? 0 0 "Failed to set priority for sleep process"
  CHECK_RESULT $? 0 0 "The priority of the sleep process is not 4"
```

- 涉及命令：ionice×3, pgrep×1

#### oe_test_swaplabel

- 描述：Change partition label
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display the label of SWAP partition"
  CHECK_RESULT $? 0 0 "Failed to modify the label information of SWAP partition to SWAP1"
  CHECK_RESULT $? 0 0 "SWAP1 failed to filter label information for SWAP partition"
  CHECK_RESULT $? 0 0 "The uuid information of SWAP partition is the same before and after resetting"
```

- 涉及命令：swaplabel×3, fallocate×1

#### oe_test_script

- 描述：Test case for script command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run script with default output"
  CHECK_RESULT $? 0 0 "Default log missing expected output"
  CHECK_RESULT $? 0 0 "Failed to run script with --log-in"
  CHECK_RESULT $? 0 0 "Input log missing expected data"
  CHECK_RESULT $? 0 0 "Failed to run script with --log-out"
  CHECK_RESULT $? 0 0 "Output log missing expected data"
  CHECK_RESULT $? 0 0 "Failed to run script with --log-io"
  CHECK_RESULT $? 0 0 "IO log missing input data"
  CHECK_RESULT $? 1 0 "IO log contains duplicate entries"
```

- 涉及命令：mkdir×1, script×1

#### oe_test_setsid

- 描述：Setsid backend execution program
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Setsid backend execution of test.sh failed"
  CHECK_RESULT $? 0 0 "Numend is less than numstart"
```

- 涉及命令：pgrep×1

#### oe_test_nsenter

- 描述：Test case for nsenter command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "nsenter --help execution failed"
  CHECK_RESULT $? 0 0 "nsenter enter UTS namespace failed"
  CHECK_RESULT $? 0 0 "nsenter enter mount namespace failed"
  CHECK_RESULT $? 0 0 "nsenter enter all namespaces failed"
  CHECK_RESULT $? 0 1 "nsenter should fail with invalid PID, but succeeded"
```

- 涉及命令：nsenter×4, kill×1
