# alsa-lib

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/alsa-lib` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_alsa-lib_install | alsa-lib install verification and version check | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_alsa-lib_pcm | alsa-lib PCM API test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_alsa-lib_mixer | alsa-lib Mixer API test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_alsa-lib_control | alsa-lib Control API test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_alsa-lib_install

- 描述：alsa-lib install verification and version check
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "alsa-lib package not installed"
  CHECK_RESULT $? 0 0 "alsa-lib-devel package not installed"
  CHECK_RESULT $? 0 0 "pkg-config alsa module not found"
  CHECK_RESULT $? 0 0 "libasound.so not found"
  CHECK_RESULT $? 0 0 "asoundlib.h header not found"
```

- 涉及命令：rpm×2

#### oe_test_alsa-lib_pcm

- 描述：alsa-lib PCM API test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create test_pcm.c"
  CHECK_RESULT $? 0 0 "Failed to compile test_pcm.c"
  CHECK_RESULT $? 0 0 "PCM API test failed"
```

#### oe_test_alsa-lib_mixer

- 描述：alsa-lib Mixer API test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create test_mixer.c"
  CHECK_RESULT $? 0 0 "Failed to compile test_mixer.c"
  CHECK_RESULT $? 0 0 "Mixer API test failed"
```

#### oe_test_alsa-lib_control

- 描述：alsa-lib Control API test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create test_control.c"
  CHECK_RESULT $? 0 0 "Failed to compile test_control.c"
  CHECK_RESULT $? 0 0 "Control API test failed"
```
