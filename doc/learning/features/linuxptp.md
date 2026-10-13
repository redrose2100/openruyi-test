# linuxptp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/linuxptp` |
| 注册用例数 | 7 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_phc2sys | Test phc2sys.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ptp4l | Test ptp4l.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_nsm | Test cleancss | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_pmc | Test pmc | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_ptp4l_01 | Test ptp4l | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ptp4l_02 | Test ptp4l | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_timemaster | Test timemaster | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_phc2sys

- 描述：Test phc2sys.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×2

#### oe_test_service_ptp4l

- 描述：Test ptp4l.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×4

#### oe_test_nsm

- 描述：Test cleancss
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -v"
  CHECK_RESULT $? 0 0 "test phc2sys -h failed"
  CHECK_RESULT $? 0 0 "test phc2sys -v failed"
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -v"
```

- 涉及命令：nsm×2, hwstamp_ctl×2, phc2sys×2, phc_ctl×2, tar×1

#### oe_test_pmc

- 描述：Test pmc
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check pmc -h failed"
  CHECK_RESULT $? 0 0 "Check pmc -v failed"
  CHECK_RESULT $? 0 0 "Check pmc -b failed"
  CHECK_RESULT $? 0 0 "Check pmc -i failed"
  CHECK_RESULT $? 0 0 "Check pmc -d failed"
  CHECK_RESULT $? 0 0 "Check pmc -s failed"
  CHECK_RESULT $? 0 0 "Check pmc -t failed"
  CHECK_RESULT $? 0 0 "Check pmc -z failed"
  CHECK_RESULT $? 0 0 "Check pmc -2 failed"
  CHECK_RESULT $? 0 0 "Check pmc -4 failed"
  CHECK_RESULT $? 0 0 "Check pmc -6 failed"
```

- 涉及命令：pmc×11, tar×1, ptp4l×1, kill×1

#### oe_test_ptp4l_01

- 描述：Test ptp4l
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ptp4l -A failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -E failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -P failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -2 failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -4 failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -6 failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -i failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -l failed"
```

- 涉及命令：ptp4l×8, kill×8, tar×1

#### oe_test_ptp4l_02

- 描述：Test ptp4l
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check ptp4l -m failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -q failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -v failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -h failed"
  CHECK_RESULT $? 0 0 "Check ptp4l -f failed"
```

- 涉及命令：ptp4l×5, kill×3, pgrep×2, tar×1

#### oe_test_timemaster

- 描述：Test timemaster
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check timemaster -h failed"
  CHECK_RESULT $? 0 0 "Check timemaster -v failed"
  CHECK_RESULT $? 0 0 "Check timemaster -f failed"
  CHECK_RESULT $? 0 0 "Check timemaster -n failed"
  CHECK_RESULT $? 0 0 "Check timemaster -l failed"
  CHECK_RESULT $? 0 0 "Check timemaster -m failed"
  CHECK_RESULT $? 0 0 "Check timemaster -q failed"
```

- 涉及命令：timemaster×7, kill×4, tar×1, sed×1, pgrep×1
