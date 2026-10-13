# espeak-ng

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/espeak-ng` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_espeak_ng | test espeak-ng | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_espeak_ng_2 | test espeak-ng | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_espeak_ng

- 描述：test espeak-ng
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "command success"
  CHECK_RESULT $? 0 0 "file not exist"
```

- 涉及命令：espeak-ng×1, test×1

#### oe_test_espeak_ng_2

- 描述：test espeak-ng
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use voice parameters"
  CHECK_RESULT $? 0 0 "Voice parameters test file not created"
  CHECK_RESULT $? 0 0 "Voice parameters test file too small"
  CHECK_RESULT $? 0 0 "Failed to set amplitude"
  CHECK_RESULT $? 0 0 "Amplitude test file not created"
  CHECK_RESULT $? 0 0 "Amplitude test file too small"
  CHECK_RESULT $? 0 0 "Failed to use US English voice"
  CHECK_RESULT $? 0 0 "US English voice file not created"
  CHECK_RESULT $? 0 0 "Failed to list available voices"
  CHECK_RESULT $? 0 0 "Failed to get version information"
```

- 涉及命令：espeak-ng×3, test×3
