# munge

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/munge` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_munge | Test munge.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_command_munge | munge command testi | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_munge

- 描述：Test munge.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_command_munge

- 描述：munge command testi
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "munge.key file missing"
  CHECK_RESULT $? 0 0 "munge.key file permissions incorrect (should be 600)"
  CHECK_RESULT $? 0 0 "munge user does not exist"
  CHECK_RESULT $? 0 0 "munge authentication test failed"
  CHECK_RESULT $? 0 0 "munge encryption/decryption test failed"
  CHECK_RESULT $? 0 0 "munged process not running"
  CHECK_RESULT $? 0 0 "munge socket file missing"
  CHECK_RESULT $? 0 0 "munge version check failed"
  CHECK_RESULT $? 0 0 "remunge command not available"
  CHECK_RESULT $? 0 0 "munge log directory missing"
  CHECK_RESULT $? 0 1 "munge service port check"
  CHECK_RESULT $? 0 0 "Service dependencies incorrect"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×3, stat×1, munge×1, pgrep×1, netstat×1, killall×1
