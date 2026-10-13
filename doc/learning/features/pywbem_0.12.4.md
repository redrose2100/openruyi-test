# pywbem_0.12.4

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pywbem` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pywbem_0.12.4_wbemcli_01 | Test pywbem_wbemcli command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pywbem_0.12.4_wbemcli_02 | Test pywbem_wbemcli command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pywbem_0.12.4_wbemcli_01

- 描述：Test pywbem_wbemcli command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -n"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -t"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -u"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -p"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -nvc"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option --certs"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -certfile"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option --keyfile"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -s"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -v"
```

- 涉及命令：wbemcli×6

#### oe_test_pywbem_0.12.4_wbemcli_02

- 描述：Test pywbem_wbemcli command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "wbemcli: failed to test options -V"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test options --statistics"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test options -l"
  CHECK_RESULT $? 0 0 "wbemcli: failed to test option -h"
```

- 涉及命令：wbemcli×2
