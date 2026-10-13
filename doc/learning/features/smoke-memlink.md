# smoke-memlink

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-memlink` |
| 注册用例数 | 5 |
| 环境约束 | machine num = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_memlink_balloon | Test memlink vm balloon | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_memlink_fpr | Test memlink vm fpr | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_memlink_dumpxml_proportion | Test memlink vm proportion | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_memlink_oom_running | Test memlink vm oom during runtime | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_memlink_oom_start | Test memlink vm oom during startup | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_memlink_balloon

- 描述：Test memlink vm balloon
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check memlink recycle failed"
```

#### oe_test_memlink_fpr

- 描述：Test memlink vm fpr
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check memlink recycle failed"
```

#### oe_test_memlink_dumpxml_proportion

- 描述：Test memlink vm proportion
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "check $vm_name proportion failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check memlink recycle failed"
```

#### oe_test_memlink_oom_running

- 描述：Test memlink vm oom during runtime
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "vm running oom failed"
  CHECK_RESULT $? 0 0 "check memlink recycle failed"
```

#### oe_test_memlink_oom_start

- 描述：Test memlink vm oom during startup
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check memlink recycle failed"
```
