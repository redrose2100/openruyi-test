# libvpx

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libvpx` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_vpxenc_01 | Test vpxenc of libvpx | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_vpxenc_02 | Test vpxenc of libvpx | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_vpxenc_03 | Test vpxenc of libvpx | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_vpxenc_04 | Test vpxenc of libvpx | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_vpxenc_05 | Test vpxenc of libvpx | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_vpxenc_06 | Test vpxenc of libvpx | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_vpxdec_07 | Test vpxdec of libvpx | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_vpxdec_08 | Test vpxdec of libvpx | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_set_maps | Test vpxdec of libvpx | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_decode_to_md5 | Test vpxdec of libvpx | pre_test/ver/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libvpx | test libvpx | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_vpxenc_01

- 描述：Test vpxenc of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --help "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc -D "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc -o "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc -w "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc -h "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc -t "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc -u "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --i420 "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --stereo-mode "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --ivf "
```

- 涉及命令：tar×1

#### oe_test_vpxenc_02

- 描述：Test vpxenc of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --target-bitrate "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --timebase "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --passes "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --fpf "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --limit "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --skip "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --deadline "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --quiet "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --verbose"
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --psnr "
```

- 涉及命令：tar×1

#### oe_test_vpxenc_03

- 描述：Test vpxenc of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --webm "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --output-partitions "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --q-his "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --rate-hist "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --disable-warnings "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --disable-warning-prompt "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --test-decode "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --profile "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --fps "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --error-resilient "
```

- 涉及命令：tar×1

#### oe_test_vpxenc_04

- 描述：Test vpxenc of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --test-16bit-internal "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --lag-in-frames "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --drop-frame "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-allowed "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-width "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-height "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-up "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-down "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --end-usage "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --min-q "
```

- 涉及命令：tar×1

#### oe_test_vpxenc_05

- 描述：Test vpxenc of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --max-q "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --undershoot-pct "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --overshoot-pct "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --buf-sz "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --buf-initial-sz "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --buf-optimal-sz "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --bias-pct "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --minsection-pct "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --maxsection-pct "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --corpus-complexity "
```

- 涉及命令：tar×1

#### oe_test_vpxenc_06

- 描述：Test vpxenc of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --kf-min-dist "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --kf-max-dist "
  CHECK_RESULT $? 0 0 "Failed option: vpxenc --disable-kf "
```

- 涉及命令：tar×1

#### oe_test_vpxdec_07

- 描述：Test vpxdec of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --help "
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --codec"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec -o"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --noblit"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --progress"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --limit"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --skip"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --summary "
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --threads "
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --verbose "
```

- 涉及命令：tar×1

#### oe_test_vpxdec_08

- 描述：Test vpxdec of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --scale"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --md5"
  CHECK_RESULT $? 0 0 "Failed option: vpxdec --framestats"
```

- 涉及命令：tar×1

#### oe_test_set_maps

- 描述：Test vpxdec of libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: decode_with_drops"
  CHECK_RESULT $? 0 0 "Failed option: set_maps"
  CHECK_RESULT $? 0 0 "Failed option: decode_to_md5"
  CHECK_RESULT $? 0 0 "Failed option: vp8_simple_decoder"
```

- 涉及命令：tar×1

#### oe_test_decode_to_md5

- 描述：Test vpxdec of libvpx
- 函数：`pre_test, ver, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: vp8_simple_encoder"
  CHECK_RESULT $? 0 0 "Failed option: vp8_twopass_encoder"
  CHECK_RESULT $? 0 0 "Failed option: vp8cx_set_ref"
  CHECK_RESULT $? 0 0 "Failed option: vp9_lossless_encoder"
  CHECK_RESULT $? 0 0 "Failed option: vp8_simple_decoder"
  CHECK_RESULT $? 0 0 "Failed option: vp9cx_set_ref"
  CHECK_RESULT $? 0 0 "Failed option: vpx_temporal_svc_encoder"
```

- 涉及命令：vp9_spatial_svc_encoder×2, tar×1

#### oe_test_libvpx

- 描述：test libvpx
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "running failture"
  CHECK_RESULT $? 0 0 "test.yv12 not exist"
```

- 涉及命令：test×1
