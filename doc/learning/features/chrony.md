# chrony

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/chrony` |
| 注册用例数 | 3 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_chronyd | Test chronyd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_chrony-wait | Test chrony-wait.service restart | pre_test/run_test/post_test | 0 | ✔ | ✔ |  |
| oe_test_chrony_1 | Test chronyd | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_chronyd

- 描述：Test chronyd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_chrony-wait

- 描述：Test chrony-wait.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_chrony_1

- 描述：Test chronyd
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "chrony time synchronization not normal"
  CHECK_RESULT $? 0 0 "No active NTP server connection"
```
