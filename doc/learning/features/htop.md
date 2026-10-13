# htop

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/htop` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_htop_01 | verification htop‘s command | pre_test/run_test/post_test | 23 | ✔ |  |  |
| oe_test_htop_02 | verification htop‘s command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_htop_01

- 描述：verification htop‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

```
  CHECK_RESULT $? 0 0 "Interactive test F1 fails"
  CHECK_RESULT $? 0 0 "Interactive test F2 fails"
  CHECK_RESULT $? 0 0 "Interactive test F3 fails"
  CHECK_RESULT $? 0 0 "Interactive test F4 fails"
  CHECK_RESULT $? 0 0 "Interactive test F5 fails"
  CHECK_RESULT $? 0 0 "Interactive test F6 fails"
  CHECK_RESULT $? 0 0 "Interactive test F7 fails"
  CHECK_RESULT $? 0 0 "Interactive test F8 fails"
  CHECK_RESULT $? 0 0 "Interactive test F9 fails"
  CHECK_RESULT $? 0 0 "Interactive test c fails"
  CHECK_RESULT $? 0 0 "Interactive test U fails"
  CHECK_RESULT $? 0 0 "Interactive test s fails"
  ... 共 23 条（其余见源脚本）
```

#### oe_test_htop_02

- 描述：verification htop‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Option test -d fails"
  CHECK_RESULT $? 0 0 "Option test -C fails"
  CHECK_RESULT $? 0 0 "Option test -p fails"
  CHECK_RESULT $? 0 0 "Option test -s fails"
  CHECK_RESULT $? 0 0 "Option test -u fails"
  CHECK_RESULT $? 0 0 "Option test -U fails"
  CHECK_RESULT $? 0 0 "Option test -t fails"
  CHECK_RESULT $? 0 0 "Option test -m fails"
  CHECK_RESULT $? 0 0 "Option test -v fails"
  CHECK_RESULT $? 0 0 "Option test -h fails"
```

- 涉及命令：htop×2
