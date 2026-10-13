# dosfstools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dosfstools` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dosfsck | dosfsck command testing | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_dosfsck_02 | Filesystem check command testing (ext2/ext4) | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dosfsck

- 描述：dosfsck command testing
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "dd command execution failed"
  CHECK_RESULT $? 0 0 "mkdosfs command execution failed"
  CHECK_RESULT $? 0 0 "not display mkfs.fat"
  CHECK_RESULT $? 0 0 "dosfsck command execution failed"
```

- 涉及命令：mkdosfs×1, dosfsck×1

#### oe_test_dosfsck_02

- 描述：Filesystem check command testing (ext2/ext4)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create ext4 filesystem"
  CHECK_RESULT $? 0 0 "Basic filesystem check failed"
  CHECK_RESULT $? 0 0 "Failed to repair corrupted filesystem"
  CHECK_RESULT $? 0 0 "Failed to change filesystem label"
  CHECK_RESULT $? 0 0 "Filesystem label not changed correctly"
```

- 涉及命令：fsck.ext4×2, mkfs.ext4×1, blkid×1
