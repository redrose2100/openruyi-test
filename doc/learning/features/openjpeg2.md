# openjpeg2

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openjpeg2` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_openjpeg2-tools | test openjpeg2-tools | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openjpeg2-tools_01 | test openjpeg2-tools | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openjpeg2-tools_02 | test openjpeg2-tools | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_openjpeg2-tools

- 描述：test openjpeg2-tools
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compress test.tif to JPEG 2000 format and save output as test.jp2"
  CHECK_RESULT $? 0 0 "Failed to compress test.tif to JPEG 2000 format and save output as test.j2k"
  CHECK_RESULT $? 0 0 "Compression bit rate set to 0.5 bits per pixel failed"
  CHECK_RESULT $? 0 0 "Compression bit rate set to 0.5 bits per pixel failed"
```

- 涉及命令：opj2_compress×4

#### oe_test_openjpeg2-tools_01

- 描述：test openjpeg2-tools
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compress test.tif to JPEG 2000 format and save output as test.j2c"
  CHECK_RESULT $? 0 0 "Compressing image files and setting compression quality to 50 failed"
  CHECK_RESULT $? 0 0 "Compress image file and set width and height, with 3 color components and 3 color components. Multi resolution encoding failed"
  CHECK_RESULT $? 0 0 "Failed to input the number of bits to be retained for each component in the image"
```

- 涉及命令：opj2_compress×4

#### oe_test_openjpeg2-tools_02

- 描述：test openjpeg2-tools
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compress test.jp2 to test.tif"
  CHECK_RESULT $? 0 0 "-D 5 specifies a decomposition level quantity of 5, failed"
  CHECK_RESULT $? 0 0 "Compression bit rate set to 0.5 bits per pixel failed"
```

- 涉及命令：opj2_decompress×3
