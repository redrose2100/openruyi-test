# libjpeg-turbo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libjpeg-turbo` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libjpeg-turbo | Test libjpeg-turbo package installation and integrity | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_libjpeg-turbo_cjpeg | Test cjpeg command - compress images to JPEG | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_libjpeg-turbo_djpeg | Test djpeg command - decompress JPEG images | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_libjpeg-turbo_jpegtran | Test jpegtran command - lossless JPEG transformation | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_libjpeg-turbo_wrjpgcom | Test wrjpgcom command - write JPEG comments | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_libjpeg-turbo_rdjpgcom | Test rdjpgcom command - read JPEG comments | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libjpeg-turbo_tjbench | Test tjbench command - TurboJPEG benchmark | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libjpeg-turbo

- 描述：Test libjpeg-turbo package installation and integrity
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "libjpeg-turbo library/devel packages are not installed"
  CHECK_RESULT $? 0 0 "failed to get libjpeg-turbo rpm version"
  CHECK_RESULT $? 0 0 "failed to get libjpeg pkg-config version"
  CHECK_RESULT $? 0 0 "version mismatch: rpm=${rpm_version}, pkg-config=${pkg_version}"
  CHECK_RESULT $? 0 0 "failed to compile the libjpeg API program"
  CHECK_RESULT $? 0 0 "libjpeg API program did not run successfully"
```

- 涉及命令：mkdir×1, rpm×1, gcc×1

#### oe_test_libjpeg-turbo_cjpeg

- 描述：Test cjpeg command - compress images to JPEG
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
  CHECK_RESULT $? 0 0 "cjpeg -h does not show usage"
  CHECK_RESULT $? 0 0 "cjpeg failed to encode PPM with -quality 90"
  CHECK_RESULT $? 0 0 "cjpeg did not create a non-empty JPEG image"
  CHECK_RESULT $? 0 0 "encoded output does not have a JPEG SOI marker"
  CHECK_RESULT $? 0 0 "cjpeg -quality 30 failed"
  CHECK_RESULT $? 0 0 "cjpeg -quality 95 failed"
  CHECK_RESULT $? 0 0 "higher quality should produce a larger JPEG file"
  CHECK_RESULT $? 0 0 "cjpeg -grayscale failed"
  CHECK_RESULT $? 0 0 "cjpeg -grayscale did not create a non-empty JPEG"
  CHECK_RESULT $? 0 0 "cjpeg -optimize failed"
  CHECK_RESULT $? 0 0 "cjpeg -optimize did not create a non-empty JPEG"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：cjpeg×7, test×4, mkdir×1

#### oe_test_libjpeg-turbo_djpeg

- 描述：Test djpeg command - decompress JPEG images
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
  CHECK_RESULT $? 0 0 "failed to encode the test JPEG image"
  CHECK_RESULT $? 0 0 "djpeg -h does not show usage"
  CHECK_RESULT $? 0 0 "djpeg failed to decode the JPEG image"
  CHECK_RESULT $? 0 0 "djpeg did not create a non-empty PPM image"
  CHECK_RESULT $? 0 0 "decoded output is not a valid PPM (P6) image"
  CHECK_RESULT $? 0 0 "djpeg -grayscale failed"
  CHECK_RESULT $? 0 0 "djpeg -grayscale did not create a non-empty PPM"
  CHECK_RESULT $? 0 0 "decoded grayscale output is not a PGM (P5) image"
  CHECK_RESULT $? 0 0 "djpeg -scale 1/2 failed"
  CHECK_RESULT $? 0 0 "djpeg -scale 1/2 did not create a non-empty PPM"
  CHECK_RESULT $? 0 0 "djpeg -scale 1/2 did not produce half-size image"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：djpeg×6, test×5, head×3, mkdir×1

#### oe_test_libjpeg-turbo_jpegtran

- 描述：Test jpegtran command - lossless JPEG transformation
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
  CHECK_RESULT $? 0 0 "failed to encode the test JPEG image"
  CHECK_RESULT $? 0 0 "jpegtran -h does not show usage"
  CHECK_RESULT $? 0 0 "jpegtran failed to copy the JPEG image"
  CHECK_RESULT $? 0 0 "jpegtran did not create a non-empty JPEG"
  CHECK_RESULT $? 0 0 "jpegtran output does not have a JPEG SOI marker"
  CHECK_RESULT $? 0 0 "jpegtran -copy none failed"
  CHECK_RESULT $? 0 0 "jpegtran -copy none did not create a non-empty JPEG"
  CHECK_RESULT $? 0 0 "jpegtran -optimize failed"
  CHECK_RESULT $? 0 0 "jpegtran -optimize did not create a non-empty JPEG"
  CHECK_RESULT $? 0 0 "jpegtran -progressive failed"
  CHECK_RESULT $? 0 0 "jpegtran -progressive did not create a non-empty JPEG"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：jpegtran×8, test×7, mkdir×1

#### oe_test_libjpeg-turbo_wrjpgcom

- 描述：Test wrjpgcom command - write JPEG comments
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
  CHECK_RESULT $? 0 0 "failed to encode the test JPEG image"
  CHECK_RESULT $? 0 0 "wrjpgcom -h does not show usage"
  CHECK_RESULT $? 0 0 "wrjpgcom -comment failed to write a JPEG comment"
  CHECK_RESULT $? 0 0 "wrjpgcom did not create a non-empty JPEG"
  CHECK_RESULT $? 0 0 "rdjpgcom could not read back the -comment text"
  CHECK_RESULT $? 0 0 "wrjpgcom stdin comment failed"
  CHECK_RESULT $? 0 0 "rdjpgcom could not read back the stdin comment text"
  CHECK_RESULT $? 0 0 "wrjpgcom -cfile failed"
  CHECK_RESULT $? 0 0 "rdjpgcom could not read back the -cfile comment text"
  CHECK_RESULT $? 0 0 "wrjpgcom first -comment failed"
  CHECK_RESULT $? 0 0 "wrjpgcom -replace failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：wrjpgcom×5, mkdir×1, test×1

#### oe_test_libjpeg-turbo_rdjpgcom

- 描述：Test rdjpgcom command - read JPEG comments
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
  CHECK_RESULT $? 0 0 "failed to encode the test JPEG image"
  CHECK_RESULT $? 0 0 "failed to prepare a JPEG with a comment"
  CHECK_RESULT $? 0 0 "rdjpgcom -h does not show usage"
  CHECK_RESULT $? 0 0 "rdjpgcom did not return the expected comment text"
  CHECK_RESULT $? 0 0 "rdjpgcom stdin read did not return the expected comment"
  CHECK_RESULT $? 0 0 "rdjpgcom -raw did not return the expected comment"
  CHECK_RESULT $? 0 0 "rdjpgcom failed on a JPEG with no comment"
  CHECK_RESULT $? 0 0 "rdjpgcom on a comment-less JPEG should produce empty output"
```

- 涉及命令：rdjpgcom×2, mkdir×1, wrjpgcom×1, test×1

#### oe_test_libjpeg-turbo_tjbench

- 描述：Test tjbench command - TurboJPEG benchmark
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
  CHECK_RESULT $? 0 0 "failed to encode the test JPEG image"
  CHECK_RESULT $? 0 0 "tjbench -h does not show usage"
  CHECK_RESULT $? 0 0 "tjbench failed to run decode benchmark on JPEG"
  CHECK_RESULT $? 0 0 "tjbench decode benchmark did not produce metrics"
  CHECK_RESULT $? 0 0 "tjbench failed to run encode+decode benchmark on PPM"
  CHECK_RESULT $? 0 0 "tjbench encode+decode benchmark did not produce metrics"
  CHECK_RESULT $? 0 0 "tjbench -subsamp 444 failed"
  CHECK_RESULT $? 0 0 "tjbench -subsamp 444 did not produce output"
  CHECK_RESULT $? 0 0 "tjbench -benchtime 1 failed"
  CHECK_RESULT $? 0 0 "tjbench -benchtime did not produce output"
  CHECK_RESULT $? 0 0 "tjbench -componly failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：grep×3, test×2, mkdir×1, tjbench×1
