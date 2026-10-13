# lmdb

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lmdb` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_lmdb | lmdb basic function | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_lmdb

- 描述：lmdb basic function
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Decompression failed"
  CHECK_RESULT $? 0 0 "Failed to view LMDB data"
  CHECK_RESULT $? 0 0 "Failed to view LMDB data"
  CHECK_RESULT "$result" 0 1 "Failed to export LMDB data"
```

- 涉及命令：mdb_copy×1, mdb_load×1
