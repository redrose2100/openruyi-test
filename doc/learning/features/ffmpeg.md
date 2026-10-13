# ffmpeg

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ffmpeg` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ffmpeg | test ffmpeg | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_ffmpeg_01 | test  ffmpeg | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ffmpeg_02 | test ffmpeg | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ffmpeg_03 | test ffmpeg | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ffmpeg_04 | test ffmpeg | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ffmpeg

- 描述：test ffmpeg
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Execution failure"
  CHECK_RESULT $? 0 0 "file not exite"
```

- 涉及命令：ffmpeg×1, test×1

#### oe_test_ffmpeg_01

- 描述：test  ffmpeg
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to obtain information from test.mpg file"
  CHECK_RESULT $? 0 0 "Ffmpeg decoding MPEG-2 video file to YUV format error"
  CHECK_RESULT $? 0 0 "ffplay cannot play generated yuv raw video"
```

- 涉及命令：ffmpeg×1, ffplay×1

#### oe_test_ffmpeg_02

- 描述：test ffmpeg
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "convert to .mkv type failed"
  CHECK_RESULT $? 0 0 ".mkv file not exist"
  CHECK_RESULT $? 0 0 "convert to .avi type failed"
  CHECK_RESULT $? 0 0 ".avi file not exist"
  CHECK_RESULT $? 0 0 "convert to .mp3 type failed"
  CHECK_RESULT $? 0 0 ".mp3 file not exist"
```

- 涉及命令：ffmpeg×3, test×3

#### oe_test_ffmpeg_03

- 描述：test ffmpeg
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "convert with -s option failed"
  CHECK_RESULT $? 0 0 "output_01.mp4 file not exist"
  CHECK_RESULT $? 0 0 "change volume failed"
  CHECK_RESULT $? 0 0 "output_02.mp4 file not exist"
  CHECK_RESULT $? 0 0 "change atempo failed"
  CHECK_RESULT $? 0 0 "output_03.mp3 file not exist"
  CHECK_RESULT $? 0 0 "convert with -vframes option failed"
  CHECK_RESULT $? 0 0 "output_04.png file not exist"
```

- 涉及命令：ffmpeg×4, test×4

#### oe_test_ffmpeg_04

- 描述：test ffmpeg
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "output_01.mp4 file not exist"
  CHECK_RESULT $? 0 0 "output_02.mp4 file not exist"
  CHECK_RESULT $? 0 0 "concat files failed"
  CHECK_RESULT $? 0 0 "output_03.mp3 file not exist"
```

- 涉及命令：ffmpeg×3, test×3
