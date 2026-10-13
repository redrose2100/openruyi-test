# smoke-migrate

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-migrate` |
| 注册用例数 | 7 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_migrate_content_hugepage | Test 2M hugepage vm urma onecopy migrate | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_migrate_memlink_balloon | Test memlink vm balloon enable after migration | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_migrate_memlink_fpr | Test memlink vm fpr enable after migration | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_migrate_mode_iterative | Test vm urma iterative migrate | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_migrate_mode_onecopy | Test vm urma onecopy migrate | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_migrate_mode_tcp | Test vm tcp migrate | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_migrate_status_circle | Test 2M hugepage vm urma migrate status circle | pre_test/run_test/post_test | 5 |  |  |  |

### 断言与命令明细

#### oe_test_migrate_content_hugepage

- 描述：Test 2M hugepage vm urma onecopy migrate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"
```

#### oe_test_migrate_memlink_balloon

- 描述：Test memlink vm balloon enable after migration
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check memlink recycle failed"
```

#### oe_test_migrate_memlink_fpr

- 描述：Test memlink vm fpr enable after migration
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check memlink recycle failed"
```

#### oe_test_migrate_mode_iterative

- 描述：Test vm urma iterative migrate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"
```

#### oe_test_migrate_mode_onecopy

- 描述：Test vm urma onecopy migrate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"
```

#### oe_test_migrate_mode_tcp

- 描述：Test vm tcp migrate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"
```

#### oe_test_migrate_status_circle

- 描述：Test 2M hugepage vm urma migrate status circle
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $abort_result 0 0 "migrate cancel failed"
  CHECK_RESULT $? 0 1 "check vm failed, vm should not exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "check vm failed, vm should exist in local: $vm_name"
  CHECK_RESULT $? 0 0 "vm $vm_name status check failed"
```
