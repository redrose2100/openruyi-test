# smoke-findutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-findutils` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_find_FUN.001 | user identity authentication sm test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_find_FUN.002 | user identity authentication sm test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_find_FUN.003 | user identity authentication sm test | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_find_FUN.001

- 描述：user identity authentication sm test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：find×1

#### oe_test_find_FUN.002

- 描述：user identity authentication sm test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

#### oe_test_find_FUN.003

- 描述：user identity authentication sm test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```
