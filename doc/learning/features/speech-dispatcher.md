# speech-dispatcher

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/speech-dispatcher` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_speech-dispatcherd | Test speech-dispatcherd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_speech-dispatcher_01 | Test "speech-dispatcher" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_speech-dispatcher_02 | Test "speech-dispatcher" command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_speech-dispatcherd

- 描述：Test speech-dispatcherd.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×4, rpm×1

#### oe_test_speech-dispatcher_01

- 描述：Test "speech-dispatcher" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -d No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -L No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -S No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
```

- 涉及命令：speech-dispatcher×10

#### oe_test_speech-dispatcher_02

- 描述：Test "speech-dispatcher" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -P No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -C No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -D No Pass"
```

- 涉及命令：speech-dispatcher×5
