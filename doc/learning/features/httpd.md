# httpd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/httpd` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_htcacheclean | Test htcacheclean.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_httpd-init | Test httpd-init.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_httpd | Test httpd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_socket_httpd | Test httpd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_httpd_invalid_configuration_recover | Verify httpd starts with a valid configuration, rejects an invalid directive, and recovers after restore | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_htcacheclean

- 描述：Test htcacheclean.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_httpd-init

- 描述：Test httpd-init.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_httpd

- 描述：Test httpd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "httpd.service reload failed"
  CHECK_RESULT $? 0 0 "httpd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_socket_httpd

- 描述：Test httpd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_httpd_invalid_configuration_recover

- 描述：Verify httpd starts with a valid configuration, rejects an invalid directive, and recovers after restore
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "apachectl -t should pass with the original configuration"
  CHECK_RESULT $? 0 0 "httpd should restart successfully with the original configuration"
  CHECK_RESULT $? 0 0 "httpd service should be active before injecting invalid configuration"
  CHECK_RESULT $? 0 1 "apachectl -t should fail after injecting an invalid directive"
  CHECK_RESULT $? 0 1 "httpd restart should fail with invalid configuration"
  CHECK_RESULT $? 0 0 "apachectl -t should pass after restoring the original configuration"
  CHECK_RESULT $? 0 0 "httpd should restart successfully after restoring the original configuration"
  CHECK_RESULT $? 0 0 "httpd service should be active after configuration recovery"
```

- 涉及命令：apachectl×3, test×1
