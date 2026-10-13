# nototools_0.2.17

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nototools` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nototools_0.2.17_notodiff | TEST notodiff in nototools options | config_params/pre_test/run_test/post_test | 19 |  |  |  |

### 断言与命令明细

#### oe_test_nototools_0.2.17_notodiff

- 描述：TEST notodiff in nototools options
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --before,--after error"
  CHECK_RESULT $? 0 0 "option: -t area error"
  CHECK_RESULT $? 0 0 "option: --diff-type shape error"
  CHECK_RESULT $? 0 0 "option: -t area-shape-product error"
  CHECK_RESULT $? 0 0 "option: --diff-type rendered error"
  CHECK_RESULT $? 0 0 "option: -t gsub error"
  CHECK_RESULT $? 0 0 "option: --diff-type gpos error"
  CHECK_RESULT $? 0 0 "option: -m error"
  CHECK_RESULT $? 0 0 "option: --match error"
  CHECK_RESULT $? 0 0 "option: -l error"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：notodiff×1
