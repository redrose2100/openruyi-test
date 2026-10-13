# libwebp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libwebp` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libwebp_install | libwebp package installation verification | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libwebp_tools_cwebp | cwebp command test - image encoding to WebP format | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_libwebp_tools_dwebp | dwebp command test - WebP decoding to other formats | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libwebp_tools_webpinfo | webpinfo command test - WebP file information display | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libwebp_tools_webpmux | webpmux command test - WebP container manipulation | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_libwebp_tools_gif2webp | gif2webp command test - GIF to WebP conversion | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libwebp_devel | libwebp-devel development library test - header files and compilation | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libwebp_java | libwebp-java package verification - Java WebP bindings | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libwebp_install

- 描述：libwebp package installation verification
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "libwebp main package not installed"
  CHECK_RESULT $? 0 0 "libwebp-tools package not installed"
  CHECK_RESULT $? 0 0 "libwebp-devel package not installed"
  CHECK_RESULT $? 0 0 "libwebp-java package not installed"
  CHECK_RESULT $? 0 0 "libwebp.so library not found"
  CHECK_RESULT $? 0 0 "pkg-config libwebp module not found"
  CHECK_RESULT $? 0 0 "libwebp.pc file not found"
```

- 涉及命令：rpm×4

#### oe_test_libwebp_tools_cwebp

- 描述：cwebp command test - image encoding to WebP format
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "base64 decoding failed"
  CHECK_RESULT $? 0 0 "cwebp basic encoding failed"
  CHECK_RESULT $? 0 0 "cwebp output file not created"
  CHECK_RESULT $? 0 0 "cwebp quality parameter test failed"
  CHECK_RESULT $? 0 0 "cwebp lossless mode test failed"
  CHECK_RESULT $? 0 0 "cwebp compression level test failed"
  CHECK_RESULT $? 0 0 "cwebp help information not displayed"
  CHECK_RESULT $? 0 0 "cwebp version information not displayed"
```

- 涉及命令：cwebp×5, base64×1

#### oe_test_libwebp_tools_dwebp

- 描述：dwebp command test - WebP decoding to other formats
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "base64 decoding failed"
  CHECK_RESULT $? 0 0 "Failed to create test WebP file"
  CHECK_RESULT $? 0 0 "dwebp basic decoding to PNG failed"
  CHECK_RESULT $? 0 0 "dwebp output PNG file not created"
  CHECK_RESULT $? 0 0 "dwebp decoding to PPM failed"
  CHECK_RESULT $? 0 0 "dwebp decoding to PGM failed"
  CHECK_RESULT $? 0 0 "dwebp decoding to PAM failed"
  CHECK_RESULT $? 0 0 "dwebp help information not displayed"
  CHECK_RESULT $? 0 0 "dwebp version information not displayed"
```

- 涉及命令：dwebp×2, base64×1

#### oe_test_libwebp_tools_webpinfo

- 描述：webpinfo command test - WebP file information display
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "base64 decoding failed"
  CHECK_RESULT $? 0 0 "Failed to create test WebP file"
  CHECK_RESULT $? 0 0 "webpinfo basic test failed"
  CHECK_RESULT $? 0 0 "webpinfo verbose mode test failed"
  CHECK_RESULT $? 0 0 "webpinfo summary mode test failed"
  CHECK_RESULT $? 0 0 "webpinfo output does not contain expected information"
  CHECK_RESULT $? 0 0 "webpinfo help information not displayed"
```

- 涉及命令：webpinfo×3, base64×1

#### oe_test_libwebp_tools_webpmux

- 描述：webpmux command test - WebP container manipulation
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "base64 decoding failed"
  CHECK_RESULT $? 0 0 "Failed to create test WebP file"
  CHECK_RESULT $? 0 0 "webpmux info command failed"
  CHECK_RESULT $? 0 0 "webpmux help information not displayed"
  CHECK_RESULT $? 0 0 "webpmux version information not displayed"
  CHECK_RESULT $? 0 0 "webpmux set ICC profile failed"
  CHECK_RESULT $? 0 0 "webpmux get ICC profile failed"
  CHECK_RESULT $? 0 0 "webpmux extracted ICC profile file not created"
```

- 涉及命令：webpmux×5, base64×1

#### oe_test_libwebp_tools_gif2webp

- 描述：gif2webp command test - GIF to WebP conversion
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "base64 decoding failed"
  CHECK_RESULT $? 0 0 "gif2webp basic conversion failed"
  CHECK_RESULT $? 0 0 "gif2webp output file not created"
  CHECK_RESULT $? 0 0 "gif2webp quality parameter test failed"
  CHECK_RESULT $? 0 0 "gif2webp mixed mode test failed"
  CHECK_RESULT $? 0 0 "gif2webp help information not displayed"
  CHECK_RESULT $? 0 0 "gif2webp version information not displayed"
```

- 涉及命令：gif2webp×4, base64×1

#### oe_test_libwebp_devel

- 描述：libwebp-devel development library test - header files and compilation
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "webp/decode.h header file not found"
  CHECK_RESULT $? 0 0 "webp/encode.h header file not found"
  CHECK_RESULT $? 0 0 "webp/types.h header file not found"
  CHECK_RESULT $? 0 0 "webp/mux.h header file not found"
  CHECK_RESULT $? 0 0 "webp/demux.h header file not found"
  CHECK_RESULT $? 0 0 "Failed to create test_webp_encode.c"
  CHECK_RESULT $? 0 0 "Failed to compile test_webp_encode.c"
  CHECK_RESULT $? 0 0 "WebP encoding test program failed"
  CHECK_RESULT $? 0 0 "Failed to create test_webp_decode.c"
  CHECK_RESULT $? 0 0 "Failed to compile test_webp_decode.c"
  CHECK_RESULT $? 0 0 "WebP decoding test program failed"
```

- 涉及命令：grep×2

#### oe_test_libwebp_java

- 描述：libwebp-java package verification - Java WebP bindings
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "libwebp-java package not installed"
  CHECK_RESULT $? 0 0 "Java is not properly installed"
  CHECK_RESULT $? 0 0 "libwebp.jar file not found"
  CHECK_RESULT $? 0 0 "libwebp JNI library not found"
  CHECK_RESULT $? 0 0 "Failed to create Testlibwebp.java"
  CHECK_RESULT $? 0 0 "Failed to compile Testlibwebp.java"
  CHECK_RESULT $? 0 0 "Java test class failed"
```

- 涉及命令：java×2, rpm×1, javac×1
