# ntfs-3g

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ntfs-3g` |
| 注册用例数 | 26 |
| 环境约束 | add disk = 5,5 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ntfs-3g_ntfscat | verify the uasge of ntfscat ntfs-3g.probe command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ntfs-3g_ntfscp | verify the uasge of ntfscp command | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_ntfs-3g_mkntfs | verify the uasge of mkntfs command | pre_test/run_test/post_test | 12 |  |  | 40m |
| oe_test_ntfs-3g_mkfs.ntfs | verify the uasge of mkfs.ntfs command | pre_test/run_test/post_test | 12 |  |  | 60m |
| oe_test_ntfs-3g_ntfsclone_01 | verify the uasge of ntfsclone command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ntfs-3g_ntfsclone_02 | verify the uasge of ntfsclone ntfsfix command | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_ntfs-3g_ntfslabel | verify the uasge of ntfslabel ntfscmp command | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_ntfs-3g_ntfsinfo | verify the uasge of ntfsinfo command | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_ntfs-3g_ntfsls | verify the uasge of ntfsls command | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_ntfs-3g_ntfswipe_01 | verify the uasge of ntfswipe command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ntfs-3g_ntfswipe_02 | verify the uasge of ntfswipe command | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_ntfs-3g_ntfsresize | verify the uasge of ntfsresize command | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_ntfs-3g_ntfscluster | verify the uasge of ntfscluster command | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_ntfs-3g_ntfsmove | verify the uasge of ntfsmove command | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_ntfs-3g_ntfssecaudit | verify the uasge of ntfssecaudit command | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_ntfs-3g_ntfstruncate | verify the uasge of ntfstruncate command | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_ntfs-3g_ntfsundelete_01 | verify the uasge of ntfsundelete command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ntfs-3g_ntfsundelete_02 | verify the uasge of ntfsundelete command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_ntfs-3g_ntfs-3g_01 | verify the uasge of ntfs-3g command | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_ntfs-3g_ntfs-3g_02 | verify the uasge of ntfs-3g command | pre_test/run_test/post_test | 20 |  |  |  |
| oe_test_ntfs-3g_ntfs-3g_03 | verify the uasge of ntfs-3g command | pre_test/run_test/post_test | 26 |  |  |  |
| oe_test_ntfs-3g_lowntfs-3g_01 | verify the uasge of lowntfs-3g command | pre_test/run_test/post_test | 18 |  |  |  |
| oe_test_ntfs-3g_lowntfs-3g_02 | verify the uasge of lowntfs-3g command | pre_test/run_test/post_test | 20 |  |  |  |
| oe_test_ntfs-3g_lowntfs-3g_03 | verify the uasge of lowntfs-3g command | pre_test/run_test/post_test | 28 |  |  |  |
| oe_test_ntfs-3g_ntfsfallocate | verify the uasge of ntfsfallocate command | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_fsck-ntfs | Command fsck.ntfs test | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ntfs-3g_ntfscat

- 描述：verify the uasge of ntfscat ntfs-3g.probe command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfscat --help failed."
  CHECK_RESULT $? 0 0 "Check ntfscat --version failed."
  CHECK_RESULT $? 0 0 "Check ntfscat --attribute failed."
  CHECK_RESULT $? 0 0 "Check ntfscat --attribute-name failed."
  CHECK_RESULT $? 0 0 "Check ntfscat --force failed."
  CHECK_RESULT $? 0 0 "Check ntfscat --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfscat --verbose failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g.probe --help failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g.probe --readonly failed."
  CHECK_RESULT $? 0 0 "Check ntfscat ntfs-3g.probe --readwrite failed."
```

#### oe_test_ntfs-3g_ntfscp

- 描述：verify the uasge of ntfscp command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfscp --help failed."
  CHECK_RESULT $? 0 0 "Check ntfscp --version failed."
  CHECK_RESULT $? 0 0 "Check ntfscp --attribute failed."
  CHECK_RESULT $? 0 0 "Check ntfscp --attr-name failed."
  CHECK_RESULT $? 0 0 "Check ntfscp --no-action failed."
  CHECK_RESULT $? 0 0 "Check ntfscp --force failed."
  CHECK_RESULT $? 0 0 "Check ntfscp --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfscp --verbose failed."
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_mkntfs

- 描述：verify the uasge of mkntfs command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check mkntfs --help failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --version failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --fast failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --quick failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --label failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --enable-compression failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --no-indexing failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --no-action failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --cluster-size --sector-size --partition-start --heads --sectors-per-track --mft-zone-multiplier --zero-time --force failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --quiet failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --verbose failed."
  CHECK_RESULT $? 0 0 "Check mkntfs --license failed."
```

#### oe_test_ntfs-3g_mkfs.ntfs

- 描述：verify the uasge of mkfs.ntfs command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --help failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --version failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --fast failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --quick failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --label failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --enable-compression failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --no-indexing failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --no-action failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --cluster-size --sector-size --partition-start --heads --sectors-per-track --mft-zone-multiplier --zero-time --force failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --quiet failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --verbose failed."
  CHECK_RESULT $? 0 0 "Check mkfs.ntfs --license failed."
```

#### oe_test_ntfs-3g_ntfsclone_01

- 描述：verify the uasge of ntfsclone command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsclone --help failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --version failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --output failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --overwrite failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --save-image failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --restore-image failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --metadata failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --rescue failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --no-action failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --ignore-fs-check failed."
```

#### oe_test_ntfs-3g_ntfsclone_02

- 描述：verify the uasge of ntfsclone ntfsfix command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsclone --new-serial failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --new-half-serial failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --preserve-timestamps failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --force failed."
  CHECK_RESULT $? 0 0 "Check ntfsclone --full-logfile failed."
  CHECK_RESULT $? 0 0 "Check ntfsfix --help failed."
  CHECK_RESULT $? 0 0 "Check ntfsfix --version failed."
  CHECK_RESULT $? 0 0 "Check ntfsfix --clear-bad-sectors failed."
  CHECK_RESULT $? 0 0 "Check ntfsfix --clear-dirty failed."
  CHECK_RESULT $? 0 0 "Check ntfsfix --no-action failed."
```

#### oe_test_ntfs-3g_ntfslabel

- 描述：verify the uasge of ntfslabel ntfscmp command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfslabel --help failed"
  CHECK_RESULT $? 0 0 "Check ntfslabel --version failed"
  CHECK_RESULT $? 0 0 "Check ntfslabel --no-action failed"
  CHECK_RESULT $? 0 0 "Check ntfslabel --force failed"
  CHECK_RESULT $? 0 0 "Check ntfslabel --new-serial failed"
  CHECK_RESULT $? 0 0 "Check ntfslabel --new-half-serial failed"
  CHECK_RESULT $? 0 0 "Check ntfslabel --quiet failed"
  CHECK_RESULT $? 0 0 "Check ntfslabel --verbose failed"
  CHECK_RESULT $? 0 0 "Check ntfscmp --help failed"
  CHECK_RESULT $? 0 0 "Check ntfscmp --version failed"
  CHECK_RESULT $? 0 0 "Check ntfscmp --no-progress-bar failed"
  CHECK_RESULT $? 0 0 "Check ntfscmp --verbose failed"
```

#### oe_test_ntfs-3g_ntfsinfo

- 描述：verify the uasge of ntfsinfo command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsinfo --help failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --version failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --inode failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --file failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --mft failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --notime failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --force failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfsinfo --verbose failed."
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfsls

- 描述：verify the uasge of ntfsls command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsls --help failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --version failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --all failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --classify failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --force failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --inode failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --long failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --path failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --recursive failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --system failed."
  CHECK_RESULT $? 0 0 "Check ntfsls --dos --path failed."
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfswipe_01

- 描述：verify the uasge of ntfswipe command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfswipe --help failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --version failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --info failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --directory failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --logfile failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --mft failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --pagefile failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --tails failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --unused failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --unused-fast failed."
```

#### oe_test_ntfs-3g_ntfswipe_02

- 描述：verify the uasge of ntfswipe command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfswipe --undel failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --all failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --count failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --bytes failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --no-action failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --force failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfswipe --verbose failed."
```

#### oe_test_ntfs-3g_ntfsresize

- 描述：verify the uasge of ntfsresize command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsresize --help failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --version failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --check failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --info failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --info-mb-only failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --size failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --expand failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --no-action failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --bad-sectors failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --no-progress-bar failed."
  CHECK_RESULT $? 0 0 "Check ntfsresize --verbose failed."
```

#### oe_test_ntfs-3g_ntfscluster

- 描述：verify the uasge of ntfscluster command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfscluster --help failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --version failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --info failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --cluster failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --sector failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --inode failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --filename failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfscluster --verbose failed."
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfsmove

- 描述：verify the uasge of ntfsmove command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsmove --help failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --version failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --start failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --best failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --end failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --cluster failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --no-dirty failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --no-action failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --force failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --quiet failed."
  CHECK_RESULT $? 0 0 "Check ntfsmove --verbose failed."
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfssecaudit

- 描述：verify the uasge of ntfssecaudit command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfssecaudit --help failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit --version failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit -t failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit -h failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit -arv failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit -v failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit -rv failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit -bv failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit -sev failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit perms file failed."
  CHECK_RESULT $? 0 0 "Check ntfssecaudit perms directory failed."
```

- 涉及命令：ntfssecaudit×8, mkdir×1

#### oe_test_ntfs-3g_ntfstruncate

- 描述：verify the uasge of ntfstruncate command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfstruncate --help failed."
  CHECK_RESULT $? 0 0 "Check ntfstruncate --version failed."
  CHECK_RESULT $? 0 0 "Check ntfstruncate -n failed."
  CHECK_RESULT $? 0 0 "Check ntfstruncate -f failed."
  CHECK_RESULT $? 0 0 "Check ntfstruncate -q failed."
  CHECK_RESULT $? 0 0 "Check ntfstruncate -v failed."
  CHECK_RESULT $? 0 0 "Check ntfstruncate -vv failed."
  CHECK_RESULT $? 0 0 "Check ntfstruncate -l failed."
```

- 涉及命令：ntfstruncate×6

#### oe_test_ntfs-3g_ntfsundelete_01

- 描述：verify the uasge of ntfsundelete command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsundelete --help failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --version failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --scan failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --percentage failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --match failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --case failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --size failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --time failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --undelete failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --inode failed."
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfsundelete_02

- 描述：verify the uasge of ntfsundelete command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsundelete -output failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --optimistic failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --destination failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --byte failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --truncate failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --parent failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --copy failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --quiet failed."
  CHECK_RESULT $? 0 0 "Check file failed."
  CHECK_RESULT $? 0 0 "Check ntfsundelete --verbose failed."
```

- 涉及命令：mkdir×1, test×1

#### oe_test_ntfs-3g_ntfs-3g_01

- 描述：verify the uasge of ntfs-3g command
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfs-3g --help failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g --version failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o uid gid failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o umask failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o dmask failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o usermapping failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o permissions failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfs-3g_02

- 描述：verify the uasge of ntfs-3g command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o locale failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o recover failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o norecover failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o emove_hiberfile failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o atime failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o noatime failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfs-3g_03

- 描述：verify the uasge of ntfs-3g command
- 函数：`pre_test, run_test, post_test`
- 断言（26 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o hide_dot_files failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o windows_names failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o allow_other failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o max_read failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o silent failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check ntfs-3g -o no_def_opts failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  ... 共 26 条（其余见源脚本）
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_lowntfs-3g_01

- 描述：verify the uasge of lowntfs-3g command
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check lowntfs-3g --help failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g --version failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o uid gid failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o umask failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o dmask failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o usermapping failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o permissions failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_lowntfs-3g_02

- 描述：verify the uasge of lowntfs-3g command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o locale failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o recover failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o norecover failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o emove_hiberfile failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o atime failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o noatime failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_lowntfs-3g_03

- 描述：verify the uasge of lowntfs-3g command
- 函数：`pre_test, run_test, post_test`
- 断言（28 条）：

```
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o hide_dot_files failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o windows_names failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o allow_other failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o max_read failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o silent failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  CHECK_RESULT $? 0 0 "Check lowntfs-3g -o no_def_opts failed."
  CHECK_RESULT $? 0 0 "Check disk mount failed."
  ... 共 28 条（其余见源脚本）
```

- 涉及命令：mkdir×1

#### oe_test_ntfs-3g_ntfsfallocate

- 描述：verify the uasge of ntfsfallocate command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -h failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -V failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -l failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -f failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -n failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -o failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -v failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate -vv failed."
  CHECK_RESULT $? 0 0 "Check ntfsfallocate attr-name failed."
```

- 涉及命令：ntfsfallocate×9, mkdir×1

#### oe_test_fsck-ntfs

- 描述：Command fsck.ntfs test
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Create test directory failed"
  CHECK_RESULT $? 0 0 "Create ntfs image file failed"
  CHECK_RESULT $? 0 0 "Create MBR label failed"
  CHECK_RESULT $? 0 0 "Create primary ntfs partition failed"
  CHECK_RESULT $? 0 0 "Setup loop device failed"
  CHECK_RESULT $? 0 0 "Format to NTFS failed"
  CHECK_RESULT $? 0 0 "Mount NTFS partition failed"
  CHECK_RESULT $? 0 0 "Write test file failed"
  CHECK_RESULT $? 0 0 "Umount NTFS partition failed"
  CHECK_RESULT $? 0 2 "fsck.ntfs basic check failed"
  CHECK_RESULT $? 0 1 "fsck.ntfs auto fix failed"
  CHECK_RESULT $? 0 0 "Remount NTFS failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：losetup×2, parted×2, mount×2, mkdir×1, mkntfs×1, fsck.ntfs×1, umount×1
