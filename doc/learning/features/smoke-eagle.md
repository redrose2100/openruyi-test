# smoke-eagle

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-eagle` |
| 注册用例数 | 5 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_eagle_40 | set watt_sched_enable as 0 cannot set attrs test | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_eagle_41 | load and init test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_42 | Set sched_service as change should not work test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_43 | Set watt_sched_enable as 1 cannot set firstdomain test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_eagle_44 | set watt attrs false test | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_eagle_40

- 描述：set watt_sched_enable as 0 cannot set attrs test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 "Check watt_sched_enable = 0 cannot set watt param failed"
  CHECK_RESULT $? 0 0 "Check watt_sched_enable = 0 cannot set watt threshold failed"
  CHECK_RESULT $? 0 0 "Check watt_sched_enable = 0 cannot set watt interval ms failed"
  CHECK_RESULT $? 0 0 "Check watt_sched_enable = 1 set watt param failed"
  CHECK_RESULT $? 0 0 "Check watt_sched_enable = 1 set watt threshold failed"
  CHECK_RESULT $? 0 0 "Check watt_sched_enable = 1 set watt interval failed"
```

- 涉及命令：sed×6

#### oe_test_eagle_41

- 描述：load and init test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check load part exist failed"
  CHECK_RESULT $? 0 0 "Check init part exist failed"
```

#### oe_test_eagle_42

- 描述：Set sched_service as change should not work test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check set param as 90 set failed"
  CHECK_RESULT $? 0 0 "Check set param as 0 do nothing failed"
```

- 涉及命令：sed×2

#### oe_test_eagle_43

- 描述：Set watt_sched_enable as 1 cannot set firstdomain test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check set first domain failed"
  CHECK_RESULT $? 0 0 "Check set first domain failed"
```

- 涉及命令：sed×4

#### oe_test_eagle_44

- 描述：set watt attrs false test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check bad policy change return failed"
```

- 涉及命令：sed×1
