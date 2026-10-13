# pps-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pps-tools` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pps-tools | the test of pps-tools package | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pps-tools

- 描述：the test of pps-tools package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "ppsfind command failed"
  CHECK_RESULT $? 0 0 "ppstest command failed"
  CHECK_RESULT $? 0 0 "ppsldisc command failed"
  CHECK_RESULT $? 0 0 "ppswatch -a command failed"
  CHECK_RESULT $? 0 0 "ppswatch -c command failed"
  CHECK_RESULT $? 0 0 "ppswatch -fa command failed"
  CHECK_RESULT $? 0 0 "ppswatch -Fa command failed"
  CHECK_RESULT $? 0 0 "ppswatch -fc command failed"
  CHECK_RESULT $? 0 0 "ppswatch -Fc command failed"
```

- 涉及命令：pkill×4, ppsctl×4, sed×2, ppswatch×2, make×1, test×1
