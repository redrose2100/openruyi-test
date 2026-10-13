# tomcat

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tomcat` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_tomcat-jsvc | Test tomcat-jsvc.service restart | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_service_tomcat | Test tomcat.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_tomcat_001 | tomcat command test | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_tomcat-jsvc

- 描述：Test tomcat-jsvc.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "tomcat-jsvc.service start failed"
  CHECK_RESULT $? 0 0 "tomcat-jsvc.service start failed"
  CHECK_RESULT $? 0 0 "tomcat-jsvc.service stop failed"
  CHECK_RESULT $? 0 0 "tomcat-jsvc.service stop failed"
  CHECK_RESULT $? 0 0 "tomcat-jsvc.service restart failed"
  CHECK_RESULT $? 0 0 "tomcat-jsvc.service restart failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of tomcat-jsvc.service"
```

#### oe_test_service_tomcat

- 描述：Test tomcat.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×2

#### oe_test_tomcat_001

- 描述：tomcat command test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：tomcat-digest×5, tomcat-tool-wrapper×1
