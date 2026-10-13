# perl-Date-Manip

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/perl-Date-Manip` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_perl-Date-Manip_dm_date | Test "dm_date and dm_zdump" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_perl-Date-Manip_dm_zdump | Test "dm_date and dm_zdump" command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_perl-Date-Manip_dm_date

- 描述：Test "dm_date and dm_zdump" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option--help is error"
  CHECK_RESULT $? 0 0 "option--date is error"
  CHECK_RESULT $? 0 0 "option-d is error"
  CHECK_RESULT $? 0 0 "option--file is error"
  CHECK_RESULT $? 0 0 "option-f is error"
  CHECK_RESULT $? 0 0 "option--reference is error"
  CHECK_RESULT $? 0 0 "option-r is error"
  CHECK_RESULT $? 0 0 "option--rfc is error"
  CHECK_RESULT $? 0 0 "option--utc is error"
  CHECK_RESULT $? 0 0 "option--universal is error"
```

- 涉及命令：dm_date×3

#### oe_test_perl-Date-Manip_dm_zdump

- 描述：Test "dm_date and dm_zdump" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "option--help is error"
  CHECK_RESULT $? 0 0 "option-v is error"
  CHECK_RESULT $? 0 0 "option-verbose is error"
  CHECK_RESULT $? 0 0 "option-c is error"
  CHECK_RESULT $? 0 0 "option-cutoff is error"
```

- 涉及命令：dm_zdump×2
