# nodejs-clean-css_3.4.6

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nodejs-clean-css` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_cleancss_3.4.6_01 | Test cleancss | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_cleancss_3.4.6_02 | Test cleancss | pre_test/run_test/post_test | 15 | ✔ |  |  |

### 断言与命令明细

#### oe_test_cleancss_3.4.6_01

- 描述：Test cleancss
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Check cleancss -h failed"
  CHECK_RESULT $? 0 0 "Check cleancss --help failed"
  CHECK_RESULT $? 0 0 "Check cleancss -v failed"
  CHECK_RESULT $? 0 0 "Check cleancss --version failed"
  CHECK_RESULT $? 0 0 "Check cleancss -b failed"
  CHECK_RESULT $? 0 0 "Check cleancss -b failed"
  CHECK_RESULT $? 0 0 "Check cleancss --compatibility failed"
  CHECK_RESULT $? 0 0 "Check cleancss -c failed"
  CHECK_RESULT $? 0 0 "Check cleancss -d failed"
  CHECK_RESULT $? 0 0 "Check cleancss --debug failed"
  CHECK_RESULT $? 0 0 "Check cleancss -o failed"
  CHECK_RESULT $? 0 0 "Check cleancss --output failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：cleancss×8, tar×1

#### oe_test_cleancss_3.4.6_02

- 描述：Test cleancss
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check cleancss -t failed"
  CHECK_RESULT $? 0 0 "Check cleancss --timeout failed"
  CHECK_RESULT $? 0 0 "Check cleancss --rounding-precision failed"
  CHECK_RESULT $? 0 0 "Check cleancss --s0 failed"
  CHECK_RESULT $? 0 0 "Check cleancss --s1 failed"
  CHECK_RESULT $? 0 0 "Check cleancss --semantic-merging failed"
  CHECK_RESULT $? 0 0 "Check cleancss --skip-advanced failed"
  CHECK_RESULT $? 0 0 "Check cleancss --skip-aggressive-merging failed"
  CHECK_RESULT $? 0 0 "Check cleancss --skip-aggressive-merging failed"
  CHECK_RESULT $? 0 0 "Check cleancss --skip-media-merging failed"
  CHECK_RESULT $? 0 0 "Check cleancss --skip-rebase failed"
  CHECK_RESULT $? 0 0 "Check cleancss --skip-restructuring failed"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：tar×1, cleancss×1
