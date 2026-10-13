# xz

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/xz` |
| 注册用例数 | 19 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_xz_xz_01 | The usage of commands in xz package | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_xz_xz_02 | The usage of commands in xz package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xz_xz_03 | The usage of commands in xz package | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_xz_xz_04 | The usage of commands in xz package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_xz_unxz_01 | The usage of commands in xz package | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_xz_unxz_02 | The usage of commands in xz package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xz_unxz_03 | The usage of commands in xz package | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_xz_unxz_04 | The usage of commands in xz package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_xz_xzcat_01 | The usage of commands in xz package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xz_xzcat_02 | The usage of commands in xz package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xz_xzcat_03 | The usage of commands in xz package | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_xz_xzcmp | The usage of commands in xz package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xz_xzdec | The usage of commands in xz package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_xz_xzdiff_01 | The usage of commands in xz package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xz | The usage of commands in xz package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xz_xzdiff_02 | The usage of commands in xz package | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_xz_compression_level | Test xz compression levels from -0 to -9 | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_xz_basic_compress | Test xz basic compress and decompress functionality | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_xz_keep_original | Test xz -k option to keep original file after compression | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_xz_xz_01

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -z"
  CHECK_RESULT $? 0 0 "Compression failed"
  CHECK_RESULT $? 0 0 "Test failed with option -d"
  CHECK_RESULT $? 0 0 "Decompression failed"
  CHECK_RESULT $? 0 0 "Test failed with option -t"
  CHECK_RESULT $? 0 0 "Test failed with option -l"
  CHECK_RESULT $? 0 0 "Test failed with option -k"
  CHECK_RESULT $? 0 0 "File retention failed"
  CHECK_RESULT $? 0 0 "Test failed with option -f"
  CHECK_RESULT $? 0 0 "File overwrite failed"
  CHECK_RESULT $? 0 0 "Test failed with option -c"
  CHECK_RESULT $? 0 0 "Test failed with option -e"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：test×5

#### oe_test_xz_xz_02

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Compression level 0 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 1 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 2 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 3 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 4 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 5 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 6 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 7 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 8 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 9 setting failed"
```

#### oe_test_xz_xz_03

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -S"
  CHECK_RESULT $? 0 0 "testxz.SUF does not exist"
  CHECK_RESULT $? 0 0 "Test failed with option --file"
  CHECK_RESULT $? 0 0 "Test failed with option -F"
  CHECK_RESULT $? 0 0 "testxz.lzma does not exist"
  CHECK_RESULT $? 0 0 "Test failed with option -C"
  CHECK_RESULT $? 0 0 "Test failed with option -l"
  CHECK_RESULT $? 0 0 "Test failed with option --block-size"
  CHECK_RESULT $? 0 0 "Test failed with option --block-list"
  CHECK_RESULT $? 0 0 "Test failed with option --memlimit-compress"
  CHECK_RESULT $? 0 0 "Test failed with option --memlimit-decompress"
  CHECK_RESULT $? 0 0 "Test failed with option --lzma1"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×2

#### oe_test_xz_xz_04

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -vv"
  CHECK_RESULT $? 1 0 "Test failed with option -v"
  CHECK_RESULT $? 0 0 "Test failed with option --info-memory"
  CHECK_RESULT $? 0 0 "Test failed with option -h"
  CHECK_RESULT $? 0 0 "Test failed with option -H"
  CHECK_RESULT $? 0 0 "Test failed with option -V"
  CHECK_RESULT $? 0 0 "Test failed with option -M"
  CHECK_RESULT $? 1 0 "Test failed with option -qq"
  CHECK_RESULT $? 1 0 "The file is not empty"
```

- 涉及命令：test×1

#### oe_test_xz_unxz_01

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -z"
  CHECK_RESULT $? 0 0 "Compression failed"
  CHECK_RESULT $? 0 0 "Test failed with option -d"
  CHECK_RESULT $? 0 0 "Decompression failed"
  CHECK_RESULT $? 0 0 "Test failed with option -t"
  CHECK_RESULT $? 0 0 "Test failed with option -l"
  CHECK_RESULT $? 0 0 "Test failed with option -k"
  CHECK_RESULT $? 0 0 "File retention failed"
  CHECK_RESULT $? 0 0 "Test failed with option -f"
  CHECK_RESULT $? 0 0 "File overwrite failed"
  CHECK_RESULT $? 0 0 "Test failed with option -c"
  CHECK_RESULT $? 0 0 "Test failed with option -e"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：unxz×9, test×5

#### oe_test_xz_unxz_02

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Compression level 0 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 1 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 2 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 3 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 4 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 5 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 6 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 7 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 8 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 9 setting failed"
```

- 涉及命令：unxz×10

#### oe_test_xz_unxz_03

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -S"
  CHECK_RESULT $? 0 0 "testxz.SUF does not exist"
  CHECK_RESULT $? 0 0 "Test failed with option --file"
  CHECK_RESULT $? 0 0 "Test failed with option -F"
  CHECK_RESULT $? 0 0 "testxz.lzma does not exist"
  CHECK_RESULT $? 0 0 "Test failed with option -C"
  CHECK_RESULT $? 0 0 "Test failed with option -l"
  CHECK_RESULT $? 0 0 "Test failed with option --block-size"
  CHECK_RESULT $? 0 0 "Test failed with option --block-list"
  CHECK_RESULT $? 0 0 "Test failed with option --memlimit-compress"
  CHECK_RESULT $? 0 0 "Test failed with option --memlimit-decompress"
  CHECK_RESULT $? 0 0 "Test failed with option --lzma1"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：unxz×11, test×2

#### oe_test_xz_unxz_04

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -vv"
  CHECK_RESULT $? 1 0 "Test failed with option -v"
  CHECK_RESULT $? 0 0 "Test failed with option --info-memory"
  CHECK_RESULT $? 0 0 "Test failed with option -h"
  CHECK_RESULT $? 0 0 "Test failed with option -H"
  CHECK_RESULT $? 0 0 "Test failed with option -V"
  CHECK_RESULT $? 0 0 "Test failed with option -M"
  CHECK_RESULT $? 1 0 "Test failed with option -qq"
  CHECK_RESULT $? 1 0 "The file is not empty"
```

- 涉及命令：unxz×8, test×1

#### oe_test_xz_xzcat_01

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -t"
  CHECK_RESULT $? 0 0 "Test failed with option -l"
  CHECK_RESULT $? 0 0 "Test failed with option -c"
  CHECK_RESULT $? 0 0 "Test failed with option -e"
  CHECK_RESULT $? 0 0 "Test failed with option -T"
  CHECK_RESULT $? 0 0 "Test failed with option -vv"
  CHECK_RESULT $? 1 0 "Test failed with option -v"
  CHECK_RESULT $? 0 0 "Test failed with option --info-memory"
  CHECK_RESULT $? 0 0 "Test failed with option -h"
  CHECK_RESULT $? 0 0 "Test failed with option -H"
```

- 涉及命令：xzcat×10

#### oe_test_xz_xzcat_02

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Compression level 0 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 1 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 2 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 3 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 4 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 5 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 6 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 7 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 8 setting failed"
  CHECK_RESULT $? 0 0 "Compression level 9 setting failed"
```

- 涉及命令：xzcat×10

#### oe_test_xz_xzcat_03

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option --file"
  CHECK_RESULT $? 0 0 "Test failed with option -F"
  CHECK_RESULT $? 0 0 "testxz.lzma does not exist"
  CHECK_RESULT $? 0 0 "Test failed with option --block-size"
  CHECK_RESULT $? 0 0 "Test failed with option --block-list"
  CHECK_RESULT $? 0 0 "Test failed with option --memlimit-compress"
  CHECK_RESULT $? 0 0 "Test failed with option --memlimit-decompress"
  CHECK_RESULT $? 0 0 "Test failed with option --lzma1"
  CHECK_RESULT $? 0 0 "Test failed with option --lzma2"
  CHECK_RESULT $? 0 0 "Test failed with option -V"
  CHECK_RESULT $? 0 0 "Test failed with option -M"
  CHECK_RESULT $? 1 0 "Test failed with option -qq"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：xzcat×11, test×2

#### oe_test_xz_xzcmp

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -b"
  CHECK_RESULT $? 0 0 "Test failed with option --ignore-initial"
  CHECK_RESULT $? 0 0 "Test failed with option --ignore-initial=3:1"
  CHECK_RESULT $? 0 0 "Test failed with option -l"
  CHECK_RESULT $? 0 0 "Test failed with option -n3"
  CHECK_RESULT $? 0 1 "The first three bytes of two files are different"
  CHECK_RESULT $? 0 0 "Test failed with option -n13"
  CHECK_RESULT $? 0 1 "Test failed with option -s"
  CHECK_RESULT $? 0 1 "The file is not empty"
  CHECK_RESULT $? 0 0 "Test failed with option -b"
```

- 涉及命令：xzcmp×5, test×2

#### oe_test_xz_xzdec

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -d"
  CHECK_RESULT $? 0 0 "Test failed with option -k"
  CHECK_RESULT $? 0 0 "The file is not exsit"
  CHECK_RESULT $? 0 0 "Test failed with option -c"
  CHECK_RESULT $? 1 0 "Test failed with option -qq"
  CHECK_RESULT $? 0 1 "The file is not empty"
  CHECK_RESULT $? 0 1 "Test failed with option -Q"
  CHECK_RESULT $? 0 0 "Test failed with option -h"
  CHECK_RESULT $? 0 0 "Test failed with option -V"
```

- 涉及命令：xzdec×7, test×2

#### oe_test_xz_xzdiff_01

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option --normal"
  CHECK_RESULT $? 0 0 "Test failed with option -q"
  CHECK_RESULT $? 0 0 "Test failed with option -s"
  CHECK_RESULT $? 0 0 "Test failed with option -c"
  CHECK_RESULT $? 0 0 "Test failed with option -u"
  CHECK_RESULT $? 0 0 "Test failed with option -e"
  CHECK_RESULT $? 0 0 "Test failed with option -n"
  CHECK_RESULT $? 0 0 "Test failed with option -y"
  CHECK_RESULT $? 0 0 "Test failed with option -p"
  CHECK_RESULT $? 0 0 "Test failed with option -T"
```

- 涉及命令：xzdiff×9

#### oe_test_xz

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "The command xzgrep failed to execute"
  CHECK_RESULT $? 0 0 "The command xzegrep failed to execute"
  CHECK_RESULT $? 0 0 "The command xzfgrep failed to execute"
  CHECK_RESULT $? 0 0 "The command xzmore failed to execute"
  CHECK_RESULT $? 0 0 "The command xzless failed to execute"
  CHECK_RESULT $? 0 0 "xzgrep does not display help information"
  CHECK_RESULT $? 0 0 "xzegrep does not display help information"
  CHECK_RESULT $? 0 0 "xzfgrep does not display help information"
  CHECK_RESULT $? 0 0 "xzmore does not display help information"
  CHECK_RESULT $? 0 0 "xzless does not display help information"
```

#### oe_test_xz_xzdiff_02

- 描述：The usage of commands in xz package
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Test failed with option -r"
  CHECK_RESULT $? 0 0 "Test failed with option -N"
  CHECK_RESULT $? 0 0 "Test failed with option --unidirectional-new-file"
  CHECK_RESULT $? 0 0 "Test failed with option -S"
  CHECK_RESULT $? 0 0 "Test failed with option -i"
  CHECK_RESULT $? 1 0 "The difference in case of file content is not ignored"
  CHECK_RESULT $? 0 0 "Test failed with option -Z"
  CHECK_RESULT $? 1 0 "Space at the end of each line not ignored"
  CHECK_RESULT $? 0 0 "Test failed with option -b"
  CHECK_RESULT $? 1 0 "Differences caused by different number of spaces not ignored"
  CHECK_RESULT $? 0 0 "Test failed with option -w"
  CHECK_RESULT $? 1 0 "Not ignoring all spaces"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：xzdiff×8, test×4

#### oe_test_xz_compression_level

- 描述：Test xz compression levels from -0 to -9
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "xz level 1 compression failed"
  CHECK_RESULT $? 0 0 "xz level 6 compression failed"
  CHECK_RESULT $? 0 0 "xz level 9 compression failed"
  CHECK_RESULT 1 0 0 "Failed to get compressed file sizes"
  CHECK_RESULT 0 0 0 "Compression level 9 produces smaller or equal file than level 1 (OK)"
  CHECK_RESULT 0 0 0 "Compression levels comparison passed (warning only)"
  CHECK_RESULT 0 0 0 "Compression level 6 compression works correctly"
  CHECK_RESULT 0 0 0 "Compression level 6 comparison passed (warning only)"
  CHECK_RESULT $? 0 0 "Failed to decompress level 1 file"
  CHECK_RESULT $? 0 0 "Failed to decompress level 9 file"
  CHECK_RESULT $? 0 0 "Decompressed level 1 content does not match original"
  CHECK_RESULT $? 0 0 "Decompressed level 9 content does not match original"
```

#### oe_test_xz_basic_compress

- 描述：Test xz basic compress and decompress functionality
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "xz basic compression failed"
  CHECK_RESULT $? 0 0 "xz compressed file not created"
  CHECK_RESULT $? 0 0 "unxz decompression failed"
  CHECK_RESULT $? 0 0 "Decompressed content mismatch"
```

- 涉及命令：test×1

#### oe_test_xz_keep_original

- 描述：Test xz -k option to keep original file after compression
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "xz -k option failed to execute"
  CHECK_RESULT $? 0 0 "Original file was not preserved after xz -k"
  CHECK_RESULT $? 0 0 "Compressed file was not created by xz -k"
```

- 涉及命令：test×2
