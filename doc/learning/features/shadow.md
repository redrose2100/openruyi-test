# shadow

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/shadow` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_newusers | test  newusers | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_grpunconv | Test case for grpunconv command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_pwck | Test case for pwck command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_basic_del_user_nonexistent | Verify deleting a nonexistent user is rejected | pre_test/run_test/post_test | 3 |  |  |  |

### 断言与命令明细

#### oe_test_newusers

- 描述：test  newusers
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Finish preparing the test environment."
  CHECK_RESULT $? 0 0 "User creation failed"
  CHECK_RESULT $? 0 0 "Check failed"
```

- 涉及命令：userdel×1

#### oe_test_grpunconv

- 描述：Test case for grpunconv command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Help test failed"
  CHECK_RESULT $? 0 0 "gshadow missing before test"
  CHECK_RESULT $? 0 0 "grpunconv execution failed"
  CHECK_RESULT $? 0 0 "gshadow not removed"
  CHECK_RESULT $? 0 0 "Group conversion failed"
```

- 涉及命令：grpunconv×1, test×1

#### oe_test_pwck

- 描述：Test case for pwck command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "pwck should detect errors in test files"
  CHECK_RESULT $? 0 0 "pwck -q should return error status"
  CHECK_RESULT $? 0 0 "pwck should reject bad names without -b"
  CHECK_RESULT $? 0 0 "pwck -b should ignore bad names"
  CHECK_RESULT $? 0 0 "pwck -h should return success"
```

- 涉及命令：pwck×1

#### oe_test_basic_del_user_nonexistent

- 描述：Verify deleting a nonexistent user is rejected
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "userdel should reject nonexistent user ${user}"
  CHECK_RESULT $? 0 1 "nonexistent user ${user} must not appear in passwd database"
  CHECK_RESULT $? 0 1 "home directory /home/${user} must not exist"
```

- 涉及命令：userdel×1, test×1
