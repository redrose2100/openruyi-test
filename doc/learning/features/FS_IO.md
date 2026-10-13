# FS_IO

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_IO` |
| 注册用例数 | 42 |
| 环境约束 | add disk = 20 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_FSIO_aio_cancel | aio cancel the aio write file | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_aio_libaio | libaio rw file | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_aio_read | aio read file | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_aio_suspend | aio suspend the aio write file | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_aio_write | aio write file | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_cat_page_fault | Cat process to check its page fault | pre_test/run_test | 2 |  |  |  |
| oe_test_FSIO_delay_write_sync | Sync file data | run_test/post_test | 3 |  |  |  |
| oe_test_FSIO_dirty_page_more_than_bg_ratio | Check dirty page writeback when it is more than dirty_background_ratio | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dirty_page_more_than_ratio | Check dirty page writeback when it is more than dirty_ratio | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_dirty_page_writeback_centisecs | Check dirty page writeback after dirty_writeback_centisecs | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_fopen_a | fopen file by a | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fopen_a+ | fopen file by a+ | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fopen_r | fopen file by r | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fopen_r+ | fopen file by r+ | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fopen_w | fopen file by w | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fopen_w+ | fopen file by w+ | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fread_unlimit_count | frread file | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_frw_fseek_cur | fopen file by set fseek = SEEK_CUR | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_frw_fseek_end | fopen file by set fseek = SEEK_END | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_frw_fseek_set | fopen file by set fseek = SEEK_SET | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fs_IO | Test io rw on fs | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_fwrite_unlimit_count | fwrite file | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_hdparm | Test disk read access | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_lio_listio | lio_listio the aio write cmd | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_loop_fopen_fclose | loop create file by fopen/fclose | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_loop_open_close_file | loop create file by open/close | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_open_direct_file | open file by O_RDWR | O_DIRECTR | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_open_excel_file | open file by O_RDWR | O_CREAT | O_EXCL | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_open_noctty_trun_file | open file by O_RDWR | O_TRUNC | O_NOCTTY | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_open_ro_file | open file by O_RDONLY | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_open_rw_append_file | open file by O_RDWR | O_APPEND | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_open_wo_create_file | open file by O_WRONLY | O_CREAT | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_page_cache | read file with clear page cache | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_prw_file | open file and set lseek=SEEK_CUR | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_FSIO_read_larger_filesize | read file | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_readahead | set readahead to read file | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_rw_file_lseek_cur | open file and set lseek=SEEK_CUR | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_rw_file_lseek_end | open file and set lseek=SEEK_END | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_rw_file_lseek_set | open file and set lseek=SEEK_SET | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_FSIO_splice | Copy file by splice | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_FSIO_sync_dirty_page | Check dirty page writeback after executing sync | run_test/post_test | 1 |  |  |  |
| oe_test_FSIO_truncate | Truncate file by truncate/ftruncate | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_FSIO_aio_cancel

- 描述：aio cancel the aio write file
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Aio cancel file failed."
  CHECK_RESULT $? 1 0 "Write info to file unexpectly."
  CHECK_RESULT $? 0 0 "There has aio request."
```

#### oe_test_FSIO_aio_libaio

- 描述：libaio rw file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "libaio rw file failed."
  CHECK_RESULT $? 0 0 "The file infos are error."
```

#### oe_test_FSIO_aio_read

- 描述：aio read file
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $readbytes $filebytes 0 "Aio read file failed."
```

#### oe_test_FSIO_aio_suspend

- 描述：aio suspend the aio write file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Aio suspend file failed."
  CHECK_RESULT $? 0 0 "Write info to file failed."
```

#### oe_test_FSIO_aio_write

- 描述：aio write file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Aio write file failed."
  CHECK_RESULT $? 0 0 "Write info to file failed."
```

#### oe_test_FSIO_cat_page_fault

- 描述：Cat process to check its page fault
- 函数：`pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check page for ${pid} failed."
  CHECK_RESULT $? 0 0 "Verify page for bash failed."
```

#### oe_test_FSIO_delay_write_sync

- 描述：Sync file data
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The page data doesn't sync by sync."
  CHECK_RESULT $? 0 0 "The page data doesn't sync by fdatasync."
  CHECK_RESULT $? 0 0 "The page data doesn't sync by fsync."
```

- 涉及命令：sync×1

#### oe_test_FSIO_dirty_page_more_than_bg_ratio

- 描述：Check dirty page writeback when it is more than dirty_background_ratio
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The dirty page doesn't writeback when its size more than dirty_background_ratio."
```

- 涉及命令：sysctl×2

#### oe_test_FSIO_dirty_page_more_than_ratio

- 描述：Check dirty page writeback when it is more than dirty_ratio
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The dirty page doesn't writeback when its size more than dirty_ratio."
```

#### oe_test_FSIO_dirty_page_writeback_centisecs

- 描述：Check dirty page writeback after dirty_writeback_centisecs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The dirty page doesn't writeback after dirty_writeback_centisecs."
```

#### oe_test_FSIO_fopen_a

- 描述：fopen file by a
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file unexpectly while fopen file by a."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_FSIO_fopen_a+

- 描述：fopen file by a+
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file unexpectly while fopen file by a+."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_FSIO_fopen_r

- 描述：fopen file by r
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file unexpectly while fopen file by read only."
  CHECK_RESULT $? 1 0 "Check file failed."
```

#### oe_test_FSIO_fopen_r+

- 描述：fopen file by r+
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file failed while fopen file by r+."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_FSIO_fopen_w

- 描述：fopen file by w
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file unexpectly while fopen file by w."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_FSIO_fopen_w+

- 描述：fopen file by w+
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file unexpectly while fopen file by w."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_FSIO_fread_unlimit_count

- 描述：frread file
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "fread file failed."
```

#### oe_test_FSIO_frw_fseek_cur

- 描述：fopen file by set fseek = SEEK_CUR
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Read or write file failed while set fseek = SEEK_CUR."
  CHECK_RESULT $? 0 0 "Read file failed."
```

#### oe_test_FSIO_frw_fseek_end

- 描述：fopen file by set fseek = SEEK_END
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Read or write file failed while set fseek = SEEK_END."
  CHECK_RESULT $? 0 0 "Read file failed."
```

#### oe_test_FSIO_frw_fseek_set

- 描述：fopen file by set fseek = SEEK_SET
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Read or write file failed while set fseek = SEEK_SET."
  CHECK_RESULT $? 0 0 "Read file failed."
```

#### oe_test_FSIO_fs_IO

- 描述：Test io rw on fs
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "read speed slow."
  CHECK_RESULT $? 0 0 "write speed slow."
```

- 涉及命令：read×1

#### oe_test_FSIO_fwrite_unlimit_count

- 描述：fwrite file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "fwrite file unexpectly."
  CHECK_RESULT $? 0 0 "fwrite file faile."
```

#### oe_test_FSIO_hdparm

- 描述：Test disk read access
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The device read of $i is slow."
```

#### oe_test_FSIO_lio_listio

- 描述：lio_listio the aio write cmd
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "lio_listio cmd failed."
```

#### oe_test_FSIO_loop_fopen_fclose

- 描述：loop create file by fopen/fclose
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "The file descriptor is changed."
```

#### oe_test_FSIO_loop_open_close_file

- 描述：loop create file by open/close
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "The file descriptor is changed."
```

#### oe_test_FSIO_open_direct_file

- 描述：open file by O_RDWR | O_DIRECTR
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Direct read file is slower than sync."
```

#### oe_test_FSIO_open_excel_file

- 描述：open file by O_RDWR | O_CREAT | O_EXCL
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Read or write file failed while set O_EXCL."
  CHECK_RESULT $? 0 0 "The access of file is error."
```

#### oe_test_FSIO_open_noctty_trun_file

- 描述：open file by O_RDWR | O_TRUNC | O_NOCTTY
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Read or write file failed while open file by O_NOCTTY|O_TRUNC."
  CHECK_RESULT $? 1 0 "The orginal message on file doesn't be cleared."
```

#### oe_test_FSIO_open_ro_file

- 描述：open file by O_RDONLY
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file unexpectly while open file by read only."
  CHECK_RESULT $? 1 0 "Write value to file unexpectly."
```

#### oe_test_FSIO_open_rw_append_file

- 描述：open file by O_RDWR | O_APPEND
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Open, read or write file failed."
  CHECK_RESULT $? 0 0 "The orginal message on file doesn't exist."
```

#### oe_test_FSIO_open_wo_create_file

- 描述：open file by O_WRONLY | O_CREAT
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Write file failed while open file by write only."
  CHECK_RESULT $? 0 0 "The value is not written to file."
  CHECK_RESULT $? 0 0 "The access of file is error."
```

#### oe_test_FSIO_page_cache

- 描述：read file with clear page cache
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The read speed is not faster when it has page cache."
```

#### oe_test_FSIO_prw_file

- 描述：open file and set lseek=SEEK_CUR
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "pread or pwrite file failed."
```

#### oe_test_FSIO_read_larger_filesize

- 描述：read file
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Read file failed."
  CHECK_RESULT $? 0 0 "Check file failed."
```

#### oe_test_FSIO_readahead

- 描述：set readahead to read file
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Read file faster when close readahead."
```

#### oe_test_FSIO_rw_file_lseek_cur

- 描述：open file and set lseek=SEEK_CUR
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The lseek offset is not 1."
  CHECK_RESULT $? 0 0 "The read set is not $expect."
  CHECK_RESULT $? 0 0 "The write set is not $actual."
```

#### oe_test_FSIO_rw_file_lseek_end

- 描述：open file and set lseek=SEEK_END
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The lseek offset is not $ori_byte."
  CHECK_RESULT $? 0 0 "The read set is not 0."
  CHECK_RESULT $? 0 0 "The write set is not $actual."
```

#### oe_test_FSIO_rw_file_lseek_set

- 描述：open file and set lseek=SEEK_SET
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The lseek offset is not 0."
  CHECK_RESULT $? 0 0 "The read set is not $ori_byte."
  CHECK_RESULT $? 0 0 "The write set is not $actual."
```

#### oe_test_FSIO_splice

- 描述：Copy file by splice
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Splce file failed."
  CHECK_RESULT $? 0 0 "The splice file infos are error."
```

#### oe_test_FSIO_sync_dirty_page

- 描述：Check dirty page writeback after executing sync
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The dirty page doesn't writeback after executing sync."
```

#### oe_test_FSIO_truncate

- 描述：Truncate file by truncate/ftruncate
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Truncate file failed by truncate."
  CHECK_RESULT $? 0 0 "Truncate file failed by truncate."
```
