# sox

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sox` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sox | test sox | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sox01 | test sox | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_sox02 | test sox -n -i -r | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_sox03 | Test sox audio format support (FLAC, AAC) | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_sox04 | Test sox audio effects (equalization, normalization, etc.) | pre_test/run_test/post_test | 20 | ✔ |  |  |

### 断言与命令明细

#### oe_test_sox

- 描述：test sox
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "sox failure"
  CHECK_RESULT $? 0 0 "output.wav not exist"
  CHECK_RESULT $? 0 0 "output.wav play failure"
  CHECK_RESULT $? 0 0 "Cropping audio failed"
  CHECK_RESULT $? 0 0 "output2.wav not exist"
```

- 涉及命令：test×2

#### oe_test_sox01

- 描述：test sox
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "output_v0.5.wav not exist"
  CHECK_RESULT $? 0 0 "check encoding type not correct"
  CHECK_RESULT $? 0 0 "output_c1.wav not exist"
  CHECK_RESULT "$channel_after" " 1" 0 "check channel data not correct"
  CHECK_RESULT $? 0 0 "output_full.wav not exist"
  CHECK_RESULT $? 0 0 "output_left.wav not exist"
  CHECK_RESULT $? 0 0 "output_right.wav not exist"
  CHECK_RESULT "$channel_left" " 1" 0 "check left_wav channel data not correct"
  CHECK_RESULT "$channel_right" " 1" 0 "check right_wav channel data not correct"
```

- 涉及命令：test×5, sox×2

#### oe_test_sox02

- 描述：test sox -n -i -r
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "test -n stat option failed"
  CHECK_RESULT $? 0 0 "test --i option failed"
  CHECK_RESULT $? 0 0 "output.wav not exist"
  CHECK_RESULT $? 0 0 "output1.wav not exist"
  CHECK_RESULT "$channel_after" "1" 0 "check channel data not correct"
  CHECK_RESULT "$samplerate_after" "48000" 0 "check samplerate not correct"
  CHECK_RESULT "$Precision_after" "16-bit" 0 "check Precision not correct"
  CHECK_RESULT $? 0 0 "output2.wav not exist"
```

- 涉及命令：test×3

#### oe_test_sox03

- 描述：Test sox audio format support (FLAC, AAC)
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "MP3 to FLAC conversion failed"
  CHECK_RESULT $? 0 0 "output.flac not exist"
  CHECK_RESULT $? 0 0 "FLAC to WAV conversion failed"
  CHECK_RESULT $? 0 0 "output_from_flac.wav not exist"
  CHECK_RESULT 0 0 0 "MP3 to AAC conversion succeeded"
  CHECK_RESULT $? 0 0 "output.aac does not exist"
  CHECK_RESULT 0 0 0 "AAC format verified"
  CHECK_RESULT 1 0 0 "AAC format not detected"
  CHECK_RESULT $? 0 0 "FLAC format not detected"
```

- 涉及命令：test×3, sox×1

#### oe_test_sox04

- 描述：Test sox audio effects (equalization, normalization, etc.)
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Audio normalization failed"
  CHECK_RESULT $? 0 0 "output_normalized.wav not exist"
  CHECK_RESULT $? 0 0 "Bass boost failed"
  CHECK_RESULT $? 0 0 "output_bass.wav not exist"
  CHECK_RESULT $? 0 0 "Treble boost failed"
  CHECK_RESULT $? 0 0 "output_treble.wav not exist"
  CHECK_RESULT $? 0 0 "High pass filter failed"
  CHECK_RESULT $? 0 0 "output_highpass.wav not exist"
  CHECK_RESULT $? 0 0 "Low pass filter failed"
  CHECK_RESULT $? 0 0 "output_lowpass.wav not exist"
  CHECK_RESULT $? 0 0 "Echo effect failed"
  CHECK_RESULT $? 0 0 "output_echo.wav not exist"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：test×10, sox×1
