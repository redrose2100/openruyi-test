# predixy

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/predixy` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_predixy | Test predixy | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_predixy

- 描述：Test predixy
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check predixy -h failed"
  CHECK_RESULT $? 0 0 "Check predixy --help failed"
  CHECK_RESULT $? 0 0 "Check predixy -v failed"
  CHECK_RESULT $? 0 0 "Check predixy --version failed"
  CHECK_RESULT $? 0 0 "Check predixy --Name failed"
  CHECK_RESULT $? 0 0 "Check predixy --Bind failed"
  CHECK_RESULT $? 0 0 "Check predixy --WorkerThreads failed"
  CHECK_RESULT $? 0 0 "Check predixy --localDC failed"
```

- 涉及命令：kill×5, predixy×2, tar×1
