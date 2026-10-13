# rubygem-fluentd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rubygem-fluentd` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fluent_cap_ctl | Test fluent-cap-ctl | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fluent_cap_ctl

- 描述：Test fluent-cap-ctl
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --help failed"
  CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --add failed"
  CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --drop failed"
  CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --clear failed"
  CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --get failed"
  CHECK_RESULT $? 0 0 "Check fluent-cap-ctl --file failed"
```
