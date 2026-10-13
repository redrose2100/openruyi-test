# lsyncd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lsyncd` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_lsyncd | Test lsyncd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_rsync_lsyncd | Test lsyncd -rsync | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_direct_lsyncd | Test lsyncd -direct | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_rsyncssh_lsyncd | Test lsyncd -rsyncssh | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_command_lsyncd | verification lsyncd's command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_lsyncd

- 描述：Test lsyncd.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：mkdir×2, kill×1

#### oe_test_rsync_lsyncd

- 描述：Test lsyncd -rsync
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "This is to test the rsync function of lsyncd"
```

- 涉及命令：mkdir×1, lsyncd×1, test×1, kill×1

#### oe_test_direct_lsyncd

- 描述：Test lsyncd -direct
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "This is to test the direct function of lsyncd"
```

- 涉及命令：mkdir×1, lsyncd×1, test×1, kill×1

#### oe_test_rsyncssh_lsyncd

- 描述：Test lsyncd -rsyncssh
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "This is to test the rsyncssh function of lsyncd"
```

- 涉及命令：mkdir×1, lsyncd×1, test×1, kill×1

#### oe_test_command_lsyncd

- 描述：verification lsyncd's command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check dealy failed"
  CHECK_RESULT $? 0 0 "Check insist failed"
  CHECK_RESULT $? 0 0 "Check pidfile failed"
  CHECK_RESULT $? 0 0 "Check nodaemon failed"
  CHECK_RESULT $? 0 0 "Check log all failed"
  CHECK_RESULT $? 0 0 "Check log exec failed"
  CHECK_RESULT $? 0 0 "Check logfile failed"
  CHECK_RESULT $? 0 0 "Check log scarce failed"
```

- 涉及命令：lsyncd×7, mkdir×1, kill×1
