# fonts-rpm-macros

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fonts-rpm-macros` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fonts_rpm_macros | Test "fonts-rpm-macros" command | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fonts_rpm_macros

- 描述：Test "fonts-rpm-macros" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: fc-weight -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: fc-weight -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: fc-weight -f No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -x No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -y No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -l No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -w No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -o No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -f No Pass"
```

- 涉及命令：gen-fontconf×8, fc-weight×3
