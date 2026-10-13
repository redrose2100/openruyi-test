# mc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mc` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mc_base_01 | verify the uasge of mc command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_mcdiff_01 | verify the uasge of mc command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mcedit_base_01 | verify the uasge of mc command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mcview_base_01 | verify the uasge of mc command | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_mc_base_01

- 描述：verify the uasge of mc command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check mc -h failed"
  CHECK_RESULT $? 0 0 "Check mc --help failed"
  CHECK_RESULT $? 0 0 "Check mc -V  failed"
  CHECK_RESULT $? 0 0 "Check mc --version  failed"
  CHECK_RESULT $? 0 0 "Check mc -f  failed"
  CHECK_RESULT $? 0 0 "Check mc --datadir  failed"
  CHECK_RESULT $? 0 0 "Check mc -F  failed"
  CHECK_RESULT $? 0 0 "Check mc --datadir-info  failed"
  CHECK_RESULT $? 0 0 "Check mc --configure-options  failed"
```

#### oe_test_mcdiff_01

- 描述：verify the uasge of mc command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mcdiff -h failed"
  CHECK_RESULT $? 0 0 "Check mcdiff --help failed"
  CHECK_RESULT $? 0 0 "Check mcdiff --help-all failed"
  CHECK_RESULT $? 0 0 "Check mcdiff --help-terminal failed"
  CHECK_RESULT $? 0 0 "Check mcdiff --help-color failed"
  CHECK_RESULT $? 0 0 "Check mcdiff -V  failed"
  CHECK_RESULT $? 0 0 "Check mcdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check mcdiff -F  failed"
  CHECK_RESULT $? 0 0 "Check mcdiff --datadir-info  failed"
  CHECK_RESULT $? 0 0 "Check mcdiff --configure-options  failed"
```

- 涉及命令：mcdiff×3

#### oe_test_mcedit_base_01

- 描述：verify the uasge of mc command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mcedit --help failed"
  CHECK_RESULT $? 0 0 "Check mcedit -h failed"
  CHECK_RESULT $? 0 0 "Check mcedit --help-all failed"
  CHECK_RESULT $? 0 0 "Check mcedit --help-terminal failed"
  CHECK_RESULT $? 0 0 "Check mcedit --help-color failed"
  CHECK_RESULT $? 0 0 "Check mcedit -V failed"
  CHECK_RESULT $? 0 0 "Check mcedit --version failed"
  CHECK_RESULT $? 0 0 "Check mcedit -F failed"
  CHECK_RESULT $? 0 0 "Check mcedit --datadir-info failed"
  CHECK_RESULT $? 0 0 "Check mcedit --configure-options  failed"
```

- 涉及命令：mcedit×3

#### oe_test_mcview_base_01

- 描述：verify the uasge of mc command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check mcview --help failed"
  CHECK_RESULT $? 0 0 "Check mcview -h failed"
  CHECK_RESULT $? 0 0 "Check mcview --help-all failed"
  CHECK_RESULT $? 0 0 "Check mcview --help-terminal failed"
  CHECK_RESULT $? 0 0 "Check mcview -V failed"
  CHECK_RESULT $? 0 0 "Check mcview --version failed"
  CHECK_RESULT $? 0 0 "Check mcview -F failed"
  CHECK_RESULT $? 0 0 "Check mcview --datadir-info failed"
  CHECK_RESULT $? 0 0 "Check mcview --configure-options failed"
```

- 涉及命令：mcview×3
