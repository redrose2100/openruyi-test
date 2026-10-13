# libguestfs

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libguestfs` |
| 注册用例数 | 50 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libguestfish_guestunmount | verify the uasge of libguestfish guestunmount command | pre_test/run_test/post_test | 6 |  |  | 360m |
| oe_test_libguestfs_guestfish_01 | verify the uasge of libguestfs guestfish command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_guestfish_02 | verify the uasge of libguestfs guestfish command | pre_test/run_test/post_test | 6 |  |  | 360m |
| oe_test_libguestfs_guestfish_03 | verify the uasge of libguestfs guestfish command | pre_test/run_test/post_test | 9 |  |  | 360m |
| oe_test_libguestfs_guestmount_01 | verify the uasge of libguestfs guestmount command | pre_test/run_test/post_test | 10 |  |  | 60m |
| oe_test_libguestfs_guestmount_02 | verify the uasge of libguestfs guestmount command | pre_test/run_test/post_test | 8 |  |  | 60m |
| oe_test_libguestfs_guestmount_03 | verify the uasge of libguestfs guestmount command | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_libguestfs_libguestfs-test-tool | verify the uasge of libguestfs libguestfs-test-tool command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_libguestfs_virt-alignment-scan | verify the uasge of libguestfs virt-alignment-scan command | pre_test/run_test/post_test | 11 |  |  | 180m |
| oe_test_libguestfs_virt-builder | verify the uasge of libguestfs virt-builder command | pre_test/run_test/post_test | 2 | ✔ |  | 360m |
| oe_test_libguestfs_virt-cat | verify the uasge of libguestfs virt-cat command | pre_test/run_test/post_test | 11 |  |  | 360m |
| oe_test_libguestfs_virt-copy-in | verify the uasge of libguestfs virt-copy-in command | pre_test/run_test/post_test | 4 |  |  | 360m |
| oe_test_libguestfs_virt-copy-out | verify the uasge of libguestfs virt-copy-out command | pre_test/run_test/post_test | 4 |  |  | 360m |
| oe_test_libguestfs_virt-customize | verify the uasge of libguestfs virt-customize command | pre_test/run_test/post_test | 2 | ✔ |  | 360m |
| oe_test_libguestfs_virt-df_01 | verify the uasge of libguestfs virt-df command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_virt-df_02 | verify the uasge of libguestfs virt-df command | pre_test/run_test/post_test | 4 |  |  | 360m |
| oe_test_libguestfs_virt-dib | verify the uasge of libguestfs virt-dib command | pre_test/run_test/post_test | 2 | ✔ |  | 360m |
| oe_test_libguestfs_virt-diff_01 | verify the uasge of libguestfs virt-diff command | pre_test/run_test/post_test | 8 | ✔ |  | 360m |
| oe_test_libguestfs_virt-diff_02 | verify the uasge of libguestfs virt-diff command | pre_test/run_test/post_test | 10 | ✔ |  | 360m |
| oe_test_libguestfs_virt-diff_03 | verify the uasge of libguestfs virt-diff command | pre_test/run_test/post_test | 6 | ✔ |  | 360m |
| oe_test_libguestfs_virt-filesystems_01 | verify the uasge of libguestfs virt-filesystems command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_virt-filesystems_02 | verify the uasge of libguestfs virt-filesystems command | pre_test/run_test/post_test | 10 |  |  | 300m |
| oe_test_libguestfs_virt-filesystems_03 | verify the uasge of libguestfs virt-filesystems command | pre_test/run_test/post_test | 3 |  |  | 360m |
| oe_test_libguestfs_virt-format | verify the uasge of libguestfs virt-format command | pre_test/run_test/post_test | 11 |  |  | 360m |
| oe_test_libguestfs_virt-get-kernel_01 | verify the uasge of libguestfs virt-get-kernel command | pre_test/run_test/post_test | 9 |  |  | 150m |
| oe_test_libguestfs_virt-get-kernel_02 | verify the uasge of libguestfs virt-get-kernel command | pre_test/run_test/post_test | 7 |  |  | 90m |
| oe_test_libguestfs_virt-index-validate | verify the uasge of libguestfs virt-index-validate command | pre_test/run_test/post_test | 2 | ✔ |  | 360m |
| oe_test_libguestfs_virt-inspector_01 | verify the uasge of libguestfs virt-inspector command | pre_test/run_test/post_test | 4 |  |  | 360m |
| oe_test_libguestfs_virt-inspector_02 | verify the uasge of libguestfs virt-inspector command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_virt-log | verify the uasge of libguestfs virt-log command | pre_test/run_test/post_test | 11 |  |  | 480m |
| oe_test_libguestfs_virt-ls_01 | verify the uasge of libguestfs virt-ls command | pre_test/run_test/post_test | 11 |  |  | 360m |
| oe_test_libguestfs_virt-ls_02 | verify the uasge of libguestfs virt-ls command | pre_test/run_test/post_test | 12 |  |  | 300m |
| oe_test_libguestfs_virt-make-fs | verify the uasge of libguestfs virt-make-fs command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_virt-p2v-make-disk | verify the uasge of libguestfs virt-p2v-make-disk command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_libguestfs_virt-p2v-make-kickstart | verify the uasge of libguestfs virt-p2v-make-kickstart command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_libguestfs_virt-p2v-make-kiwi | verify the uasge of libguestfs virt-p2v-make-kiwi command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_libguestfs_virt-resize_01 | verify the uasge of libguestfs virt-resize command | pre_test/run_test/post_test | 10 |  |  | 240m |
| oe_test_libguestfs_virt-resize_02 | verify the uasge of libguestfs virt-resize command | pre_test/run_test/post_test | 10 |  |  | 240m |
| oe_test_libguestfs_virt-resize_03 | verify the uasge of libguestfs virt-resize command | pre_test/run_test/post_test | 3 |  |  | 360m |
| oe_test_libguestfs_virt-sparsify | verify the uasge of libguestfs command | pre_test/run_test/post_test | 2 | ✔ |  | 360m |
| oe_test_libguestfs_virt-sysprep_01 | verify the uasge of libguestfs virt-sysprep command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_virt-sysprep_02 | verify the uasge of libguestfs virt-sysprep command | pre_test/run_test/post_test | 10 | ✔ |  | 360m |
| oe_test_libguestfs_virt-sysprep_03 | verify the uasge of libguestfs virt-sysprep command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_virt-sysprep_04 | verify the uasge of libguestfs virt-sysprep command | pre_test/run_test/post_test | 10 |  |  | 360m |
| oe_test_libguestfs_virt-sysprep_05 | verify the uasge of libguestfs virt-sysprep command | pre_test/run_test/post_test | 6 |  |  | 360m |
| oe_test_libguestfs_virt-tar-in | verify the uasge of libguestfs virt-tar-in command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_libguestfs_virt-tar-out | verify the uasge of libguestfs virt-tar-out command | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_libguestfs_virt-v2v | verify the uasge of libguestfs virt-v2v command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_libguestfs_virt-v2v-copy-to-local | verify the uasge of libguestfs virt-v2v-copy-to-local command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_libguestfs_virt-win-reg | verify the uasge of libguestfs virt-win-reg command | pre_test/run_test/post_test | 2 | ✔ |  | 360m |

### 断言与命令明细

#### oe_test_libguestfish_guestunmount

- 描述：verify the uasge of libguestfish guestunmount command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
  CHECK_RESULT $? 0 0 "Check guestunmount -q failed"
  CHECK_RESULT $? 0 0 "Check guestunmount --no-retry failed"
  CHECK_RESULT $? 0 0 "Check guestunmount --retry failed"
  CHECK_RESULT $? 0 0 "Check guestunmount -v failed"
  CHECK_RESULT $? 0 0 "Check guestunmount -V failed"
```

- 涉及命令：guestmount×4, guestunmount×3, mkdir×1

#### oe_test_libguestfs_guestfish_01

- 描述：verify the uasge of libguestfs guestfish command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check guestfish -h failed"
  CHECK_RESULT $? 0 0 "Check guestfish -h cat failed"
  CHECK_RESULT $? 0 0 "Check guestfish --csh failed"
  CHECK_RESULT $? 0 0 "Check guestfish -c failed"
  CHECK_RESULT $? 0 0 "Check guestfish -d failed"
  CHECK_RESULT $? 0 0 "Check guestfish -d failed"
  CHECK_RESULT $? 0 0 "Check guestfish --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check guestfish -f failed"
  CHECK_RESULT $? 0 0 "Check guestfish --format failed"
  CHECK_RESULT $? 0 0 "Check guestfish --help failed"
```

- 涉及命令：guestfish×6

#### oe_test_libguestfs_guestfish_02

- 描述：verify the uasge of libguestfs guestfish command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check guestfish --key failed"
  CHECK_RESULT $? 0 0 "Check guestfish --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check guestfish --listen failed"
  CHECK_RESULT $? 0 0 "Check guestfish -N failed"
  CHECK_RESULT $? 0 0 "Check guestfish -n failed"
  CHECK_RESULT $? 0 0 "Check guestfish --no-dest-paths failed"
```

- 涉及命令：guestfish×2

#### oe_test_libguestfs_guestfish_03

- 描述：verify the uasge of libguestfs guestfish command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check guestfish --pipe-error failed"
  CHECK_RESULT $? 0 0 "Check guestfish --progress-bars failed"
  CHECK_RESULT $? 0 0 "Check guestfish --no-progress-bars failed"
  CHECK_RESULT $? 0 0 "Check guestfish --selinux failed"
  CHECK_RESULT $? 0 0 "Check guestfish --ro failed"
  CHECK_RESULT $? 0 0 "Check guestfish -v failed"
  CHECK_RESULT $? 0 0 "Check guestfish -V failed"
  CHECK_RESULT $? 0 0 "Check guestfish --rw failed"
  CHECK_RESULT $? 0 0 "Check guestfish -x failed"
```

- 涉及命令：guestfish×3

#### oe_test_libguestfs_guestmount_01

- 描述：verify the uasge of libguestfs guestmount command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check guestmount -a -m --ro failed"
  CHECK_RESULT $? 0 0 "Check guestmount --fd failed"
  CHECK_RESULT $? 0 0 "Check guestmount -c failed"
  CHECK_RESULT $? 0 0 "Check guestmount --dir-cache-timeout failed"
  CHECK_RESULT $? 0 0 "Check guestmount -d failed"
  CHECK_RESULT $? 0 0 "Check guestmount -d failed"
  CHECK_RESULT $? 0 0 "Check guestmount --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check guestmount --format failed"
  CHECK_RESULT $? 0 0 "Check guestmount --fuse-help failed"
  CHECK_RESULT $? 0 0 "Check guestmount --help failed"
```

- 涉及命令：guestmount×7

#### oe_test_libguestfs_guestmount_02

- 描述：verify the uasge of libguestfs guestmount command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check guestmount --key failed"
  CHECK_RESULT $? 0 0 "Check guestmount --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check guestmount -echo-keys failed"
  CHECK_RESULT $? 0 0 "Check guestmount -n failed"
  CHECK_RESULT $? 0 0 "Check guestmount -o failed"
  CHECK_RESULT $? 0 0 "Check guestmount --pid-file failed"
  CHECK_RESULT $? 0 0 "Check guestmount --selinux failed"
  CHECK_RESULT $? 0 0 "Check guestmount --no-fork failed"
```

- 涉及命令：guestmount×5

#### oe_test_libguestfs_guestmount_03

- 描述：verify the uasge of libguestfs guestmount command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check guestmount -v failed"
  CHECK_RESULT $? 0 0 "Check guestmount -V failed"
  CHECK_RESULT $? 0 0 "Check guestmount -m failed"
```

- 涉及命令：guestmount×3

#### oe_test_libguestfs_libguestfs-test-tool

- 描述：verify the uasge of libguestfs libguestfs-test-tool command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check libguestfs-test-tool --help failed"
  CHECK_RESULT $? 0 0 "Check libguestfs-test-tool --qemu failed"
  CHECK_RESULT $? 0 0 "Check libguestfs-test-tool -t failed"
  CHECK_RESULT $? 0 0 "Check libguestfs-test-tool --version failed"
```

- 涉及命令：libguestfs-test-tool×2

#### oe_test_libguestfs_virt-alignment-scan

- 描述：verify the uasge of libguestfs virt-alignment-scan command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan -a failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan -c failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan -d failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan --format failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan --help failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan -P failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan -q failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan --uuid failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan -v failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan --version failed"
  CHECK_RESULT $? 0 0 "Check virt-alignment-scan -x failed"
```

- 涉及命令：virt-alignment-scan×7

#### oe_test_libguestfs_virt-builder

- 描述：verify the uasge of libguestfs virt-builder command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-builder -V failed"
  CHECK_RESULT $? 0 0 "Check virt-builder -V failed"
```

- 涉及命令：virt-builder×2

#### oe_test_libguestfs_virt-cat

- 描述：verify the uasge of libguestfs virt-cat command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-cat -a failed"
  CHECK_RESULT $? 0 0 "Check virt-cat -c failed"
  CHECK_RESULT $? 0 0 "Check virt-cat -d failed"
  CHECK_RESULT $? 0 0 "Check virt-cat --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check virt-cat --format failed"
  CHECK_RESULT $? 0 0 "Check virt-cat --help failed"
  CHECK_RESULT $? 0 0 "Check virt-cat --key failed"
  CHECK_RESULT $? 0 0 "Check virt-cat --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check virt-cat -v failed"
  CHECK_RESULT $? 0 0 "Check virt-cat -V failed"
  CHECK_RESULT $? 0 0 "Check virt-cat -x failed"
```

- 涉及命令：virt-cat×6, virt-copy-in×2

#### oe_test_libguestfs_virt-copy-in

- 描述：verify the uasge of libguestfs virt-copy-in command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-copy-in -a failed"
  CHECK_RESULT $? 0 0 "Check virt-copy-in -d failed"
  CHECK_RESULT $? 0 0 "Check virt-copy-in -h failed"
  CHECK_RESULT $? 0 0 "Check virt-copy-in -V failed"
```

- 涉及命令：virt-copy-in×4

#### oe_test_libguestfs_virt-copy-out

- 描述：verify the uasge of libguestfs virt-copy-out command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-copy-out -a failed"
  CHECK_RESULT $? 0 0 "Check virt-copy-out -d failed"
  CHECK_RESULT $? 0 0 "Check virt-copy-out -h failed"
  CHECK_RESULT $? 0 0 "Check virt-copy-out -V failed"
```

- 涉及命令：virt-copy-out×4, virt-copy-in×2

#### oe_test_libguestfs_virt-customize

- 描述：verify the uasge of libguestfs virt-customize command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-customize --help failed"
  CHECK_RESULT $? 0 0 "Check virt-customize -V failed"
```

- 涉及命令：virt-customize×2

#### oe_test_libguestfs_virt-df_01

- 描述：verify the uasge of libguestfs virt-df command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -a failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -c failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df --csv failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -d failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df --format failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -h failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -i failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df --one-per-guest failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -P failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df --help failed"
```

- 涉及命令：virt-df×6

#### oe_test_libguestfs_virt-df_02

- 描述：verify the uasge of libguestfs virt-df command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-df virt-df --help failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -v failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -V failed"
  CHECK_RESULT $? 0 0 "Check virt-df virt-df -x failed"
```

- 涉及命令：virt-df×3

#### oe_test_libguestfs_virt-dib

- 描述：verify the uasge of libguestfs virt-dib command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check guestunmount virt-dib --help failed"
  CHECK_RESULT $? 0 0 "Check guestunmount virt-dib -V failed"
```

- 涉及命令：virt-dib×2

#### oe_test_libguestfs_virt-diff_01

- 描述：verify the uasge of libguestfs virt-diff command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-diff -a -A failed"
  CHECK_RESULT $? 0 0 "Check virt-diff -d -D failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --atime failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --checksum failed"
  CHECK_RESULT $? 0 0 "Check virt-diff -c failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --csv failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --dir-links failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --dir-times failed"
```

- 涉及命令：virt-diff×2, unzip×1

#### oe_test_libguestfs_virt-diff_02

- 描述：verify the uasge of libguestfs virt-diff command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-diff --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --extra-stats failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --format failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --help failed"
  CHECK_RESULT $? 0 0 "Check virt-diff -h failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --key failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --times failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --time-days failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --xattrs failed"
```

- 涉及命令：unzip×1, virt-diff×1

#### oe_test_libguestfs_virt-diff_03

- 描述：verify the uasge of libguestfs virt-diff command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-diff --time-relative failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --time-t failed"
  CHECK_RESULT $? 0 0 "Check virt-diff --uids failed"
  CHECK_RESULT $? 0 0 "Check virt-diff -v failed"
  CHECK_RESULT $? 0 0 "Check virt-diff -V failed"
  CHECK_RESULT $? 0 0 "Check virt-diff -x failed"
```

- 涉及命令：virt-diff×3, unzip×1

#### oe_test_libguestfs_virt-filesystems_01

- 描述：verify the uasge of libguestfs virt-filesystems command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-filesystems -a failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --all failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --blkdevs failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems -c failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --csv failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems -d failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --extra failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems -a failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --format failed"
```

- 涉及命令：virt-filesystems×3

#### oe_test_libguestfs_virt-filesystems_02

- 描述：verify the uasge of libguestfs virt-filesystems command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-filesystems -h failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --help failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --long failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --lvs failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --no-title failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --parts failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --pvs failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --uuid failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems -v failed"
```

- 涉及命令：virt-filesystems×1

#### oe_test_libguestfs_virt-filesystems_03

- 描述：verify the uasge of libguestfs virt-filesystems command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-filesystems -V failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems --vgs failed"
  CHECK_RESULT $? 0 0 "Check virt-filesystems -x failed"
```

- 涉及命令：virt-filesystems×2

#### oe_test_libguestfs_virt-format

- 描述：verify the uasge of libguestfs virt-format command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
  CHECK_RESULT $? 0 0 "Check virt-format --help failed"
```

- 涉及命令：virt-format×4

#### oe_test_libguestfs_virt-get-kernel_01

- 描述：verify the uasge of libguestfs virt-get-kernel command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -a failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -c failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -d failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --format failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --help failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --key failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --machine-readable failed"
```

- 涉及命令：virt-get-kernel×3

#### oe_test_libguestfs_virt-get-kernel_02

- 描述：verify the uasge of libguestfs virt-get-kernel command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -o failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --prefix failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -q failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel --unversioned-names failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -V failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -v failed"
  CHECK_RESULT $? 0 0 "Check virt-get-kernel -x failed"
```

- 涉及命令：virt-get-kernel×5

#### oe_test_libguestfs_virt-index-validate

- 描述：verify the uasge of libguestfs virt-index-validate command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-index-validate --help failed"
  CHECK_RESULT $? 0 0 "Check virt-index-validate -V failed"
```

- 涉及命令：virt-index-validate×2

#### oe_test_libguestfs_virt-inspector_01

- 描述：verify the uasge of libguestfs virt-inspector command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-inspector -v failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector -V failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector -x failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --xpath failed"
```

- 涉及命令：virt-inspector×4

#### oe_test_libguestfs_virt-inspector_02

- 描述：verify the uasge of libguestfs virt-inspector command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-inspector -a failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector -c failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector -d failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --format failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --help failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --key failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --help failed"
  CHECK_RESULT $? 0 0 "Check virt-inspector --no-applications failed"
```

- 涉及命令：virt-inspector×3

#### oe_test_libguestfs_virt-log

- 描述：verify the uasge of libguestfs virt-log command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
  CHECK_RESULT $? 0 0 "Check virt-log --help failed"
```

- 涉及命令：virt-log×6

#### oe_test_libguestfs_virt-ls_01

- 描述：verify the uasge of libguestfs virt-ls command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-ls -a failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -m failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -lR failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -c failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --csv failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -d failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --extra-stats failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --format failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --help failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -h failed"
```

- 涉及命令：virt-ls×7

#### oe_test_libguestfs_virt-ls_02

- 描述：verify the uasge of libguestfs virt-ls command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-ls --key failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -lR failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -R failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --times failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --time-days failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --time-relative failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -time-t failed"
  CHECK_RESULT $? 0 0 "Check virt-ls --uids failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -v failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -V failed"
  CHECK_RESULT $? 0 0 "Check virt-ls -x failed"
```

- 涉及命令：virt-ls×10

#### oe_test_libguestfs_virt-make-fs

- 描述：verify the uasge of libguestfs virt-make-fs command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-make-fs --floppy failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs --format failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs --help failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs --label failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs --partition failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs --size failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs --type failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs -v failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs -V failed"
  CHECK_RESULT $? 0 0 "Check virt-make-fs -x failed"
```

- 涉及命令：virt-make-fs×3

#### oe_test_libguestfs_virt-p2v-make-disk

- 描述：verify the uasge of libguestfs virt-p2v-make-disk command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-p2v-make-disk --help failed"
  CHECK_RESULT $? 0 0 "Check virt-p2v-make-disk -V failed"
```

- 涉及命令：virt-p2v-make-disk×1

#### oe_test_libguestfs_virt-p2v-make-kickstart

- 描述：verify the uasge of libguestfs virt-p2v-make-kickstart command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check irt-p2v-make-kickstart --help failed"
  CHECK_RESULT $? 0 0 "Check virt-p2v-make-kickstart --verbose failed"
  CHECK_RESULT $? 0 0 "Check virt-p2v-make-disk virt-p2v-make-kickstart -o failed"
```

- 涉及命令：virt-p2v-make-kickstart×1

#### oe_test_libguestfs_virt-p2v-make-kiwi

- 描述：verify the uasge of libguestfs virt-p2v-make-kiwi command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-p2v-make-kiwi --help failed"
  CHECK_RESULT $? 0 0 "Check virt-p2v-make-kiwi -V failed"
```

- 涉及命令：virt-p2v-make-kiwi×1

#### oe_test_libguestfs_virt-resize_01

- 描述：verify the uasge of libguestfs virt-resize command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-resize --align-first failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --alignment failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --color failed"
  CHECK_RESULT $? 0 0 "Check virt-resize -d failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --delete failed"
  CHECK_RESULT $? 0 0 "Check virt-resize -n failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --expand failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --format failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --help failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --ignore failed"
```

- 涉及命令：virt-resize×2

#### oe_test_libguestfs_virt-resize_02

- 描述：verify the uasge of libguestfs virt-resize command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-resize --machine-readable failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --no-copy-boot-loader failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --no-expand-content failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --no-extra-partition failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --no-sparse failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --ntfsresize-force failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --output-format failed"
  CHECK_RESULT $? 0 0 "Check virt-resize -q failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --resize-force failed"
  CHECK_RESULT $? 0 0 "Check virt-resize --unknown-filesystems failed"
```

- 涉及命令：virt-resize×1

#### oe_test_libguestfs_virt-resize_03

- 描述：verify the uasge of libguestfs virt-resize command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-resize -V failed"
  CHECK_RESULT $? 0 0 "Check virt-resize -v failed"
  CHECK_RESULT $? 0 0 "Check virt-resize -x failed"
```

- 涉及命令：virt-resize×3

#### oe_test_libguestfs_virt-sparsify

- 描述：verify the uasge of libguestfs command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-sparsify --help failed"
  CHECK_RESULT $? 0 0 "Check virt-sparsify -V failed"
```

- 涉及命令：virt-sparsify×2

#### oe_test_libguestfs_virt-sysprep_01

- 描述：verify the uasge of libguestfs virt-sysprep command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-sysprep -a failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --append-line failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --chmod failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --color failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --commands-from-file failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --copy failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --copy-in failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -d failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --delete failed"
```

- 涉及命令：virt-sysprep×6, virt-copy-in×1

#### oe_test_libguestfs_virt-sysprep_02

- 描述：verify the uasge of libguestfs virt-sysprep command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-sysprep -n failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --echo-keys failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --edit failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --enable failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --firstboot-command failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --firstboot-install failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --format failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --hostname failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --key failed"
```

- 涉及命令：mkdir×2, virt-sysprep×2, unzip×1, virt-copy-in×1

#### oe_test_libguestfs_virt-sysprep_03

- 描述：verify the uasge of libguestfs virt-sysprep command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-sysprep --keys-from-stdin failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --list-operations failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --mkdir failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --mount-options failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --move failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --no-network failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --no-selinux-relabel failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --operation failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --password failed"
```

- 涉及命令：virt-copy-in×1, virt-sysprep×1

#### oe_test_libguestfs_virt-sysprep_04

- 描述：verify the uasge of libguestfs virt-sysprep command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-sysprep --password failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --password-crypto failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -q failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --root-password failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep ---run-command failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --scriptdir failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --scrub failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --selinux-relabel failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --timezone failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --touch failed"
```

- 涉及命令：virt-copy-in×1, virt-sysprep×1

#### oe_test_libguestfs_virt-sysprep_05

- 描述：verify the uasge of libguestfs virt-sysprep command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-sysprep --truncate failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --truncate-recursive failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -V failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -v failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep --write failed"
  CHECK_RESULT $? 0 0 "Check virt-sysprep -x failed"
```

- 涉及命令：virt-sysprep×3, virt-copy-in×1

#### oe_test_libguestfs_virt-tar-in

- 描述：verify the uasge of libguestfs virt-tar-in command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-tar-in -d failed"
  CHECK_RESULT $? 0 0 "Check virt-tar-in -V failed"
  CHECK_RESULT $? 0 0 "Check virt-tar-in -a failed"
  CHECK_RESULT $? 0 0 "Check virt-tar-in -h failed"
```

- 涉及命令：virt-tar-in×4, tar×1

#### oe_test_libguestfs_virt-tar-out

- 描述：verify the uasge of libguestfs virt-tar-out command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-tar-out -d failed"
  CHECK_RESULT $? 0 0 "Check virt-tar-out -a failed"
  CHECK_RESULT $? 0 0 "Check virt-tar-out -V failed"
  CHECK_RESULT $? 0 0 "Check virt-tar-out -h failed"
```

- 涉及命令：virt-tar-out×4, tar×1

#### oe_test_libguestfs_virt-v2v

- 描述：verify the uasge of libguestfs virt-v2v command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-v2v --help failed"
  CHECK_RESULT $? 0 0 "Check virt-copy-in -V failed"
```

- 涉及命令：virt-v2v×1

#### oe_test_libguestfs_virt-v2v-copy-to-local

- 描述：verify the uasge of libguestfs virt-v2v-copy-to-local command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check virt-v2v-copy-to-local --help failed"
  CHECK_RESULT $? 0 0 "Check virt-v2v-copy-to-local -V failed"
  CHECK_RESULT $? 0 0 "Check virt-v2v-copy-to-local --version failed"
```

- 涉及命令：virt-v2v-copy-to-local×1

#### oe_test_libguestfs_virt-win-reg

- 描述：verify the uasge of libguestfs virt-win-reg command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check guestunmount --help failed"
  CHECK_RESULT $? 0 0 "Check guestunmount --version failed"
```
