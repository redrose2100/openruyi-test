# nginx

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nginx` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nginx_cli | command test-nginx | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_service_nginx | Test nginx.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_nginx_concurrent | test nginx concurrent | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_nginx_2 | Concurrent access test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_nginx_invalid_configuration | Verify nginx validates a baseline configuration, rejects an invalid directive, and recovers after restore | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nginx_cli

- 描述：command test-nginx
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "nginx.service start failed"
  CHECK_RESULT $? 0 0 "nginx -? execution failed"
  CHECK_RESULT $? 0 0 "nginx -h execution failed"
  CHECK_RESULT $? 0 0 "nginx -v execution failed"
  CHECK_RESULT $? 0 0 "nginx -V failed to check nginx version"
  CHECK_RESULT $? 0 0 "nginx -V failed to check gcc version"
  CHECK_RESULT $? 0 0 "nginx -V failed to check openssl version"
  CHECK_RESULT $? 0 0 "nginx -t execution failed"
  CHECK_RESULT $? 0 0 "nginx -T execution failed"
  CHECK_RESULT $? 0 0 "nginx -t -q execution failed"
  CHECK_RESULT $? 0 0 "curl localhost execution failed"
  CHECK_RESULT $? 0 0 "nginx -s stop execution failed"
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：nginx×12, sed×2, pkill×1

#### oe_test_service_nginx

- 描述：Test nginx.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "nginx.service reload failed"
  CHECK_RESULT $? 0 0 "nginx.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_nginx_concurrent

- 描述：test nginx concurrent
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "nginx.service start fail"
  CHECK_RESULT $? 0 0 "nginx concurrent fail"
```

#### oe_test_service_nginx_2

- 描述：Concurrent access test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "nginx cannot start"
  CHECK_RESULT $? 0 0 "nginx cannot be accessed"
  CHECK_RESULT $? 0 0 "Failed to reach the specified total number of visits"
```

#### oe_test_nginx_invalid_configuration

- 描述：Verify nginx validates a baseline configuration, rejects an invalid directive, and recovers after restore
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "nginx -t should pass with the original configuration"
  CHECK_RESULT $? 0 1 "nginx -t should fail after injecting an invalid directive"
  CHECK_RESULT $? 0 0 "nginx -t should pass after restoring the original configuration"
```

- 涉及命令：test×1
