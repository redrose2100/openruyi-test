# gegl04

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/gegl04` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gegl04_gegl | Test opensm command | config_params/pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gegl04_gegl-imgcmp | Test opensm command | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gegl04_gegl

- 描述：Test opensm command
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：gegl×1

#### oe_test_gegl04_gegl-imgcmp

- 描述：Test opensm command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```
