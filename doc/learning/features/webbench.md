# webbench

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/webbench` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_webbench | Webbench tests | config_params/pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_webbench

- 描述：Webbench tests
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "webbench Help Test -h FAILED."
  CHECK_RESULT $? 0 0 "webbench Version Test -V FAILED"
  CHECK_RESULT $? 0 0 "webbench GET Test --get FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench HEAD Test --head FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench OPTIONS Test --options FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench TRACE Test --trace FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench HTTP/0.9 Test -9 FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench HTTP/1.0 Test -1 FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench HTTP/1.1 Test -2 FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench Force Test -f FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench Reload Test -r FAILED,the return value is not 0."
  CHECK_RESULT $? 0 0 "webbench Proxy Test -p FAILED,the return value is not 0."
```

- 涉及命令：webbench×12
