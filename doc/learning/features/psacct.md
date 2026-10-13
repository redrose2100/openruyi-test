# psacct

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/psacct` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_psacct | command test psacct | pre_test/run_test/post_test | 34 | ✔ |  |  |
| oe_test_service_psacct | Test psacct.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_psacct

- 描述：command test psacct
- 函数：`pre_test, run_test, post_test`
- 断言（34 条）：

```
  CHECK_RESULT $? 0 0 "log message: Failed to run command: systemctl status psacct.service --no-pager"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: systemctl start psacct.service"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac -V"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac -f /var/log/wtmp"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac --complain"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac --reboots"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac --supplants"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac --timewarps"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac --compatibility"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac -a"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: ac -d"
  ... 共 34 条（其余见源脚本）
```

- 涉及命令：grep×2, lastcomm×2, accton×1

#### oe_test_service_psacct

- 描述：Test psacct.service restart
- 函数：`pre_test, run_test, post_test`