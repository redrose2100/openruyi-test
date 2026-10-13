# log4cplus

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/log4cplus` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_log4cplus | package log4cplus test | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_log4cplus

- 描述：package log4cplus test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "log4cplus path does not exist"
  CHECK_RESULT $? 0 0 "liblog path does not exist"
  CHECK_RESULT $? 0 0 "test1 execution failed"
  CHECK_RESULT $? 0 0 "test2 execution failed"
  CHECK_RESULT $? 0 0 "Hello not found"
```

- 涉及命令：test×1
