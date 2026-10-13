# zopfli

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/zopfli` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_zopfli | test zopfli | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_zopflipng | test zopflipng | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_zopfli

- 描述：test zopfli
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Basic compression execution failed"
  CHECK_RESULT $? 0 0 "Failed to specify output gz format"
  CHECK_RESULT $? 0 0 "Failed to specify output zlib format"
  CHECK_RESULT $? 0 0 "Failed to specify output deflate format"
  CHECK_RESULT $? 0 0 "Compression with iterations failed"
  CHECK_RESULT $? 0 0 "Failed to decompress gzip file"
  CHECK_RESULT $? 0 0 "Decompressed file content does not match original"
  CHECK_RESULT $? 0 0 "Compression with 15 iterations failed"
  CHECK_RESULT $? 0 0 "Higher iteration count did not improve compression"
  CHECK_RESULT 1 0 0 "Failed to get file sizes for compression comparison"
```

- 涉及命令：gunzip×1

#### oe_test_zopflipng

- 描述：test zopflipng
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Basic compression execution failed"
  CHECK_RESULT $? 0 0 "Failed to execute fast compression"
  CHECK_RESULT $? 0 0 "More compression failed to execute"
  CHECK_RESULT $? 0 0 "Compression failed to execute the specified number of iterations"
  CHECK_RESULT $? 0 0 "PNG compression is not lossless - pixel data changed"
  CHECK_RESULT $? 0 0 "Image dimensions changed after compression"
  CHECK_RESULT $? 0 0 "Compressed file is larger than original"
  CHECK_RESULT $? 0 0 "Failed to compress gradient image"
  CHECK_RESULT $? 0 0 "Gradient image compression failed"
```

- 涉及命令：convert×2, zopflipng×2
