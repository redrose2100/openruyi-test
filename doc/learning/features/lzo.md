# lzo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lzo` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_lzo-lzop | package lzo-lzop test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_lzo-lzop_01 | package lzo-lzop test | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_lzo-lzop

- 描述：package lzo-lzop test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compress the file and output details"
  CHECK_RESULT $? 0 0 "Compressed file integrity test failed"
  CHECK_RESULT $? 0 0 "Failed to list the contents of the compressed file"
  CHECK_RESULT $? 0 0 "fail to write to file"
  CHECK_RESULT $? 0 0 "View file error"
  CHECK_RESULT $? 0 0 "lzop_ File2.lzo compressed file creation failed"
  CHECK_RESULT $? 0 0 "Failed to extract the file"
```

- 涉及命令：lzop×3, test×1

#### oe_test_lzo-lzop_01

- 描述：package lzo-lzop test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "the example.txt.lzo file does not exist "
  CHECK_RESULT $? 0 0 "the example_uncompressed.txt file does not exist"
  CHECK_RESULT $? 0 0 "no method found"
  CHECK_RESULT $? 0 0 "execution failed"
```

- 涉及命令：test×2, lzop×2
