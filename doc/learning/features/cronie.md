# cronie

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cronie` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_crond | Test crond.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_cronie | command test cronie | pre_test/run_test/post_test | 15 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_crond

- 描述：Test crond.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "crond.service reload failed"
  CHECK_RESULT $? 0 0 "crond.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_cronie

- 描述：command test cronie
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -V"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: echo \"* * * * * \$(pwd)/test.sh\" >>./cron.test && crontab ./cron.test"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -l"
  CHECK_RESULT $? 0 0 "log message: The service may not be running properly"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -r"
  CHECK_RESULT $? 1 0 "log message: Failed to remove the current crontab"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: echo \"* * * * * /home/\"\"\$USER_NAME\"\"/test.sh\" >> /home/\"\$USER_NAME\"/cron.test && crontab /home/\"\$USER_NAME\"/cron.test"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crontab -u \"\$USER_NAME\" -l"
  CHECK_RESULT $? 0 0 "log message: The service may not be running properly"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: echo -ne 'Y' | crontab -u \"\$USER_NAME\" -ri"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: crond -V"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: cronnext -h"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：crontab×8, cronnext×2, anacron×2, crond×1, userdel×1
