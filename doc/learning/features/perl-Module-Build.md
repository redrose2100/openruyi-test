# perl-Module-Build

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/perl-Module-Build` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_perl-Module-Build | Test perl-Module-Build | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_perl-Module-Build

- 描述：Test perl-Module-Build
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: --config No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --eval No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --feature No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --module No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --set_config No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --set_feature No Pass"
```
