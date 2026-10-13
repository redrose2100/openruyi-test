# libpwquality

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libpwquality/` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libpwquality_pwscore | Verify pwscore password strength testing functionality | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_libpwquality_pwmake | Verify pwmake password generation functionality | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libpwquality_pwscore

- 描述：Verify pwscore password strength testing functionality
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install libpwquality package"
  CHECK_RESULT $? 0 0 "libpwquality package verification failed"
  CHECK_RESULT $? 0 0 "libpwquality shared library missing"
  CHECK_RESULT $? 0 0 "Failed to detect too short password"
  CHECK_RESULT $? 0 0 "Failed to detect dictionary password"
  CHECK_RESULT $? 0 0 "Failed to detect keyboard sequence password"
  CHECK_RESULT $? 0 0 "Failed to detect simple sequence password"
  CHECK_RESULT $? 0 0 "Failed to detect same character password"
  CHECK_RESULT $? 0 0 "Failed to score low strength password"
  CHECK_RESULT $? 0 0 "Failed to score medium strength password"
  CHECK_RESULT $? 0 0 "Failed to score high strength password"
  CHECK_RESULT $? 0 0 "Failed to detect password change rejection"
```

- 涉及命令：rpm×3, userdel×1

#### oe_test_libpwquality_pwmake

- 描述：Verify pwmake password generation functionality
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install libpwquality package"
  CHECK_RESULT $? 0 0 "libpwquality package verification failed"
  CHECK_RESULT $? 0 0 "libpwquality shared library missing"
  CHECK_RESULT $? 0 0 "Failed to run pwmake --help"
  CHECK_RESULT $? 0 0 "pwmake 12 generated invalid password"
  CHECK_RESULT $? 0 0 "pwmake 56 generated invalid password"
  CHECK_RESULT $? 0 0 "pwmake 128 generated invalid password"
  CHECK_RESULT $? 0 0 "pwmake 256 generated invalid password"
  CHECK_RESULT $? 0 0 "pwmake 512 generated invalid password"
  CHECK_RESULT $? 0 0 "Failed to score pwmake 56 generated password"
  CHECK_RESULT $? 0 0 "Failed to score pwmake 128 generated password"
  CHECK_RESULT $? 0 0 "Failed to score pwmake 256 generated password"
```

- 涉及命令：rpm×3
