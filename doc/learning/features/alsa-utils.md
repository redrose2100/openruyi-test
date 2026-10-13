# alsa-utils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/alsa-utils` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_alsa-restore | Test alsa-restore.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_alsa-state | Test alsa-state.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_alsa_tools | Test alsa-tools | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_alsa-restore

- 描述：Test alsa-restore.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_alsa-state

- 描述：Test alsa-state.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_alsa_tools

- 描述：Test alsa-tools
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "aplay -L is failed!"
  CHECK_RESULT $? 0 0 "arecord -L is failed!"
  CHECK_RESULT $? 0 0 "amixer is failed!"
  CHECK_RESULT $? 0 0 "arecord is failed!"
  CHECK_RESULT $? 0 0 "aplay is failed"
  CHECK_RESULT $? 0 0 "speaker-test is failed"
```

- 涉及命令：aplay×2, arecord×2, speaker-test×1
