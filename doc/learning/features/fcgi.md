# fcgi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fcgi` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fcgi | the test of fcgi package | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_fastcgi | fastcgi server basic function | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fcgi

- 描述：the test of fcgi package
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "cgi-fcgi execute connect command unsuccessfully"
  CHECK_RESULT $? 0 0 "cgi-fcgi execute start command unsuccessfully, maybe the address connName is already in use"
  CHECK_RESULT $? 0 0 "cgi-fcgi execute bind command unsuccessfully"
  CHECK_RESULT $? 0 0 "cgi-fcgi execute cmdFile command unsuccessfully"
```

- 涉及命令：cgi-fcgi×4

#### oe_test_fastcgi

- 描述：fastcgi server basic function
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "Compilation failed"
  CHECK_RESULT $? 0 0 "The FastCGI program is not listening to port 8081"
  CHECK_RESULT $? 0 0 "Command execution failed"
  CHECK_RESULT $? 0 0 "File modification failed"
  CHECK_RESULT $? 0 0 "Nginx service restart failed"
  CHECK_RESULT $? 0 0 "FastCGI service access failed"
```

- 涉及命令：spawn-fcgi×1, lsof×1, sed×1
