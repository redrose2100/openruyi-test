# fastdfs

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fastdfs` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fastdfs_01 | verification fastdfs's commnd | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_fastdfs_02 | verification fastdfs's commnd | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_fastdfs_03 | verification fastdfs's commnd | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_fastdfs_04 | verification fastdfs's commnd | pre_test/run_test/post_test | 11 |  |  |  |

### 断言与命令明细

#### oe_test_fastdfs_01

- 描述：verification fastdfs's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_append_file --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_append_file failed."
  CHECK_RESULT $? 0 0 "Check fdfs_appender_test --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_appender_test client.conf failed."
  CHECK_RESULT $? 0 0 "Check fdfs_appender_test1 --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_appender_test1 client.conf failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd stop failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged stop failed."
```

- 涉及命令：netstat×2

#### oe_test_fastdfs_02

- 描述：verification fastdfs's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_crc32 failed."
  CHECK_RESULT $? 0 0 "Check fdfs_download_file --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_download_file failed."
  CHECK_RESULT $? 0 0 "Check fdfs_file_info --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_file_info failed."
  CHECK_RESULT $? 0 0 "Check fdfs_delete_file --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_delete_file failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd stop failed."
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：netstat×2

#### oe_test_fastdfs_03

- 描述：verification fastdfs's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_monitor help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_monitor failed."
  CHECK_RESULT $? 0 0 "Check fdfs_regenerate_filename --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_regenerate_filename failed."
  CHECK_RESULT $? 0 0 "Check fdfs_test --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd stop failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged stop failed."
```

- 涉及命令：netstat×2

#### oe_test_fastdfs_04

- 描述：verification fastdfs's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged start error failed."
  CHECK_RESULT $? 0 0 "Check fdfs_test1 --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_upload_appender --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_upload_appender failed."
  CHECK_RESULT $? 0 0 "Check fdfs_upload_file --help failed."
  CHECK_RESULT $? 0 0 "Check fdfs_upload_file failed."
  CHECK_RESULT $? 0 0 "Check fdfs_trackerd stop failed."
  CHECK_RESULT $? 0 0 "Check fdfs_storaged stop failed."
```

- 涉及命令：netstat×2
