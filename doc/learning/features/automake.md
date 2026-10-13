# automake

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/automake` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_automake | automake package test | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_automake

- 描述：automake package test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "autoscan.log fails to run"
  CHECK_RESULT $? 0 0 "autoscan.scan fails to run"
  CHECK_RESULT $? 0 0 "aclocal.m4 is not generated"
  CHECK_RESULT $? 0 0 "configure is not generated"
  CHECK_RESULT $? 0 0 "config.h.in is not generated"
  CHECK_RESULT $? 0 0 "Failed to add script files using automake --add-missing"
  CHECK_RESULT $? 0 0 "./configure fails to run"
  CHECK_RESULT $? 0 0 "Makefile test fails"
  CHECK_RESULT $? 0 0 "main fails to run"
```

- 涉及命令：test×5, sed×3
