# transfig

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/transfig` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_transfig | Test "transfig" command | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_transfig

- 描述：Test "transfig" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check fig2dev -L eps arrows.fig failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -D +50 -L eps arrows.fig failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -K -D +50 -L eps arrows.fig failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -L eps arrows.fig -G .25:1cm failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -j -L eps arrows.fig failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -m 2.0 -L eps arrows.fig failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -s 10 -L eps arrows.fig failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -Z 500 -L eps arrows.fig failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -h failed"
  CHECK_RESULT $? 0 0 "Check fig2dev -V failed"
  CHECK_RESULT $? 0 0 "Check pic2tpic --help failed"
  CHECK_RESULT $? 0 0 "Check pic2tpic --version failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：fig2dev×10, transfig×1
