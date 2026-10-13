# sysget

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sysget` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sysget_01 | package sysget test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_sysget_02 | package sysget test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_sysget_01

- 描述：package sysget test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Sysget update execution error"
  CHECK_RESULT $? 0 0 "Search for specific package failed"
  CHECK_RESULT $? 0 0 "Upgrade a single package and report an error"
```

#### oe_test_sysget_02

- 描述：package sysget test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Sysget update execution error"
  CHECK_RESULT $? 0 0 "Installation of software package failed"
  CHECK_RESULT $? 0 0 "Uninstalling package failed"
```
