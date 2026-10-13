# libpng

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libpng/` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libpng | Verify libpng package and basic image encode/decode functions | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_libpng_pngfix_01 | Verify pngfix tool (part 1) | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_libpng_pngfix_02 | Verify pngfix tool (part 2) | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libpng_png_fix_itxt | Verify png-fix-itxt and libpng16-config tools | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_libpng_config | Verify libpng-config and libpng16-config tools | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_libpng16_config | Verify libpng16-config tool | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libpng

- 描述：Verify libpng package and basic image encode/decode functions
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "libpng package not installed"
  CHECK_RESULT $? 0 0 "libpng package verification failed"
  CHECK_RESULT $? 0 0 "libpng header file png.h missing"
  CHECK_RESULT $? 0 0 "libpng shared library missing"
  CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
  CHECK_RESULT $? 0 0 "libpng version test failed"
  CHECK_RESULT $? 0 0 "libpng create RGB image failed"
  CHECK_RESULT $? 0 0 "libpng create grayscale image failed"
  CHECK_RESULT $? 0 0 "libpng create RGBA image failed"
  CHECK_RESULT $? 0 0 "libpng create palette image failed"
  CHECK_RESULT $? 0 0 "libpng read image failed"
  CHECK_RESULT $? 0 0 "libpng compression test failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：rpm×3, test×1

#### oe_test_libpng_pngfix_01

- 描述：Verify pngfix tool (part 1)
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "libpng-tools package not installed"
  CHECK_RESULT $? 0 0 "pngfix binary missing"
  CHECK_RESULT $? 0 0 "pngfix --help failed"
  CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
  CHECK_RESULT $? 0 0 "Failed to generate test PNG"
  CHECK_RESULT $? 0 0 "pngfix default check failed"
  CHECK_RESULT $? 0 0 "pngfix --out failed"
  CHECK_RESULT $? 0 0 "pngfix --out output invalid"
  CHECK_RESULT $? 0 0 "pngfix --optimize failed"
  CHECK_RESULT $? 0 0 "pngfix --optimize output invalid"
  CHECK_RESULT $? 0 0 "pngfix --strip=all failed"
  CHECK_RESULT $? 0 0 "pngfix --strip=all output invalid"
```

- 涉及命令：test×4, rpm×1

#### oe_test_libpng_pngfix_02

- 描述：Verify pngfix tool (part 2)
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
  CHECK_RESULT $? 0 0 "Failed to generate test PNG"
  CHECK_RESULT $? 0 0 "pngfix --max failed"
  CHECK_RESULT $? 0 0 "pngfix --max output invalid"
  CHECK_RESULT $? 0 0 "pngfix --quiet failed"
  CHECK_RESULT $? 0 0 "pngfix --errors failed"
  CHECK_RESULT $? 0 0 "pngfix --warnings failed"
  CHECK_RESULT $? 0 0 "pngfix --strip=crc failed"
  CHECK_RESULT $? 0 0 "pngfix --strip=crc output invalid"
  CHECK_RESULT $? 0 0 "pngfix invalid arg should show usage"
  CHECK_RESULT $? 255 0 "pngfix invalid arg should exit 255"
```

- 涉及命令：test×2

#### oe_test_libpng_png_fix_itxt

- 描述：Verify png-fix-itxt and libpng16-config tools
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "libpng-tools package not installed"
  CHECK_RESULT $? 0 0 "png-fix-itxt binary missing"
  CHECK_RESULT $? 0 0 "Failed to compile iTXt PNG generator"
  CHECK_RESULT $? 0 0 "Failed to generate iTXt PNG"
  CHECK_RESULT $? 0 0 "png-fix-itxt output missing PNG magic bytes"
  CHECK_RESULT $? 0 0 "png-fix-itxt output not recognized as PNG"
  CHECK_RESULT $? 0 0 "png-fix-itxt output missing IEND chunk"
  CHECK_RESULT $? 0 0 "png-fix-itxt idempotent run output invalid"
  CHECK_RESULT $? 0 0 "png-fix-itxt idempotent output missing IHDR chunk"
  CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
  CHECK_RESULT $? 0 0 "Failed to generate regular RGB PNG"
  CHECK_RESULT $? 0 0 "png-fix-itxt regular PNG output invalid"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：grep×2, rpm×1, test×1

#### oe_test_libpng_config

- 描述：Verify libpng-config and libpng16-config tools
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "libpng-tools package not installed"
  CHECK_RESULT $? 0 0 "libpng-config binary missing"
  CHECK_RESULT $? 0 0 "libpng-config --help failed"
  CHECK_RESULT $? 0 0 "libpng-config --version failed"
  CHECK_RESULT $? 0 0 "libpng-config --prefix failed"
  CHECK_RESULT $? 0 0 "libpng-config --libdir failed"
  CHECK_RESULT $? 0 0 "libpng-config --cflags failed"
  CHECK_RESULT $? 0 0 "libpng-config --I_opts failed"
  CHECK_RESULT $? 0 0 "libpng-config --L_opts failed"
  CHECK_RESULT $? 0 0 "libpng-config --ldflags failed"
  CHECK_RESULT $? 0 0 "libpng-config --libs failed"
  CHECK_RESULT $? 0 0 "libpng-config --static failed"
```

- 涉及命令：rpm×1, test×1

#### oe_test_libpng16_config

- 描述：Verify libpng16-config tool
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "libpng-tools package not installed"
  CHECK_RESULT $? 0 0 "libpng16-config binary missing"
  CHECK_RESULT $? 0 0 "libpng16-config --help failed"
  CHECK_RESULT $? 0 0 "libpng16-config --version failed"
  CHECK_RESULT $? 0 0 "libpng16-config --prefix failed"
  CHECK_RESULT $? 0 0 "libpng16-config --libdir failed"
  CHECK_RESULT $? 0 0 "libpng16-config --cflags failed"
  CHECK_RESULT $? 0 0 "libpng16-config --I_opts failed"
  CHECK_RESULT $? 0 0 "libpng16-config --L_opts failed"
  CHECK_RESULT $? 0 0 "libpng16-config --ldflags failed"
  CHECK_RESULT $? 0 0 "libpng16-config --libs failed"
  CHECK_RESULT $? 0 0 "libpng16-config --static failed"
```

- 涉及命令：rpm×1, test×1
