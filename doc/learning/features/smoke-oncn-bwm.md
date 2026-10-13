# smoke-oncn-bwm

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-oncn-bwm` |
| 注册用例数 | 2 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_bwm_qos_limit_001 | bwmcli test | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_bwm_qos_limit_002 | bandwidth qos test | pre_test/run_test/post_test | 8 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_bwm_qos_limit_001

- 描述：bwmcli test
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "CHECK bwmcli -e FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -d FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
  CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
```

- 涉及命令：bwmcli×12

#### oe_test_bwm_qos_limit_002

- 描述：bandwidth qos test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 1 "qos test failed."
  CHECK_RESULT $? 0 1 "qos test failed."
  CHECK_RESULT "$target_bdw" 52428800 0 "query failed."
  CHECK_RESULT "$target_bdw" 31457280 0 "query failed."
  CHECK_RESULT $? 0 1 "qos test failed."
  CHECK_RESULT $? 0 1 "qos test failed."
  CHECK_RESULT $? 0 1 "qos test failed."
  CHECK_RESULT $? 0 1 "qos test failed."
```

- 涉及命令：bwmcli×5
