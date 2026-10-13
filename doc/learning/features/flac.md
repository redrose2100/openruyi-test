# flac

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/flac` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_flac | test flac | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_metaflac | test metaflac | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_flac

- 描述：test flac
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "--version option failed"
  CHECK_RESULT $? 0 0 "wav file convert to falc failed"
  CHECK_RESULT $? 0 0 "example.flac not exist"
  CHECK_RESULT $? 0 0 "flac -t exec failed"
  CHECK_RESULT $? 0 0 "wav not exist"
  CHECK_RESULT $? 0 0 "ana not exist"
```

- 涉及命令：test×3, flac×3

#### oe_test_metaflac

- 描述：test metaflac
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to display all metadata for FLAC file"
  CHECK_RESULT $? 0 0 "Exporting all tags from FLAC file to one text file failed"
  CHECK_RESULT $? 0 0 "Failed to delete a tag in FLAC file"
  CHECK_RESULT $? 0 0 "Adding a new tag to FLAC file failed"
  CHECK_RESULT $? 0 0 "Failed to retain the original modification time of the file"
  CHECK_RESULT $? 0 0 "Failed to add replay gain"
  CHECK_RESULT $? 0 0 "Failed to remove all tags"
  CHECK_RESULT $? 0 0 "Failed to import tags from file"
```

- 涉及命令：git×2
