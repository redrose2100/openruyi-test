# OpenEXR

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/OpenEXR` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_OpenEXR_cmd | exrmultipart exrheader exrenvmap | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_OpenEXR_exrenvmap_exrmakepreview | exrenvmap exrmakepreview | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_OpenEXR_exrenvmap | exrenvmap | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_OpenEXR_exrmaketiled | exrmaketiled | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_OpenEXR_exrstdattr_01 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_OpenEXR_exrstdattr_02 | exrstdattr | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_OpenEXR_exrstdattr_03 | exrstdattr | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_OpenEXR_cmd

- 描述：exrmultipart exrheader exrenvmap
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check exrmultipart -combine -i failed."
  CHECK_RESULT $? 0 0 "Check exrmultipart -separate -i failed."
  CHECK_RESULT $? 0 0 "Check exrmultipart -convert -i failed."
  CHECK_RESULT $? 0 0 "Check exrmultipart -convert view failed."
  CHECK_RESULT $? 0 0 "Check exrmultipart -convert view failed."
  CHECK_RESULT $? 0 0 "Check exrmultipart -convert view failed."
  CHECK_RESULT $? 0 0 "Check exrheader failed."
  CHECK_RESULT $? 0 0 "Check exrheader -h failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -o failed."
  CHECK_RESULT $? 0 0 "Check exrmultiview -z failed."
  CHECK_RESULT $? 0 0 "Check exrmultiview -v failed."
  CHECK_RESULT $? 0 0 "Check exrmultiview -h failed."
```

- 涉及命令：exrmultipart×6, exrmultiview×3, exrheader×1, exrenvmap×1

#### oe_test_OpenEXR_exrenvmap_exrmakepreview

- 描述：exrenvmap exrmakepreview
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check exrenvmap -u failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -z failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -v failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -w failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -f failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -t failed."
  CHECK_RESULT $? 0 0 "Check exrmakepreview -w failed."
  CHECK_RESULT $? 0 0 "Check exrmakepreview -e failed."
  CHECK_RESULT $? 0 0 "Check exrmakepreview -v failed."
  CHECK_RESULT $? 0 0 "Check exrmakepreview -h failed."
```

- 涉及命令：exrenvmap×6, exrmakepreview×4

#### oe_test_OpenEXR_exrenvmap

- 描述：exrenvmap
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check exrenvmap -o failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -m failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -c failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -l failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -ci failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -li failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -b failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -h failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -p failed."
  CHECK_RESULT $? 0 0 "Check exrenvmap -d failed."
```

- 涉及命令：exrenvmap×10

#### oe_test_OpenEXR_exrmaketiled

- 描述：exrmaketiled
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check exrmaketiled -o failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -m failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -r failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -f failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -e failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -t failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -d failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -u failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -z failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -v failed."
  CHECK_RESULT $? 0 0 "Check exrmaketiled -h failed."
```

- 涉及命令：exrmaketiled×11

#### oe_test_OpenEXR_exrstdattr_01

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check exrstdattr -chromaticities failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -whiteLuminance failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -adoptedNeutral failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -renderingTransform failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -lookModTransform failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -xDensity failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -owner failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -comments failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -capDate failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -utcOffset failed."
```

- 涉及命令：exrstdattr×10

#### oe_test_OpenEXR_exrstdattr_02

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check exrstdattr -longitude failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -latitude failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -altitude failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -focus failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -expTime failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -aperture failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -isoSpeed failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -envmap failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -keyCode failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -timeCode failed."
```

- 涉及命令：exrstdattr×10

#### oe_test_OpenEXR_exrstdattr_03

- 描述：exrstdattr
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check exrstdattr -wrapmodes failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -pixelAspectRatio failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -screenWindowWidth failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -screenWindowCenter failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -string failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -float failed."
  CHECK_RESULT $? 0 0 "Check exrstdattr -int failed."
```

- 涉及命令：exrstdattr×7
