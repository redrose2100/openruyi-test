# pmix

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pmix` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pmix | test pmix | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_pmix_01 | test pmix | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pmix

- 描述：test pmix
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "display all information failed"
  CHECK_RESULT $? 0 0 "display config information failed"
  CHECK_RESULT $? 0 0 "display hostname information failed"
  CHECK_RESULT $? 0 0 "display dumpspecs information failed"
  CHECK_RESULT $? 0 0 "display dumpmachine information failed"
```

- 涉及命令：pmixcc×2

#### oe_test_pmix_01

- 描述：test pmix
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "display a information failed"
  CHECK_RESULT $? 0 0 "display pretty-print information failed"
  CHECK_RESULT $? 0 0 "display help information failed"
  CHECK_RESULT $? 0 0 "display param all all information failed"
```

- 涉及命令：pmix_info×1
