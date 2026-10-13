# novnc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/novnc` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_novnc | the test of novnc package | config_params/pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_novnc

- 描述：the test of novnc package
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "vnc server doesn't start up"
  CHECK_RESULT $? 0 0 "novnc_server listen Test --listen --vnc --web FAILED."
  CHECK_RESULT $? 0 0 "novnc_server record Test --listen --vnc --record FAILED."
  CHECK_RESULT $? 0 0 "openssl fail to create self.pem"
  CHECK_RESULT $? 0 0 "novnc_server cert and key Test --listen --vnc --cert --key FAILED."
  CHECK_RESULT $? 0 0 "novnc_server ssl-only Test --listen --vnc --cert --key --ssl-only FAILED."
```

- 涉及命令：kill×4, pgrep×1, test×1, vncserver×1
