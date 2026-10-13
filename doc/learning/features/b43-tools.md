# b43-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/b43-tools` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_b43-tools_b43-asm | verify the uasge of b43-tools command | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_b43-tools_b43-asm

- 描述：verify the uasge of b43-tools command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check b43-asm -h failed"
  CHECK_RESULT $? 0 0 "Check b43-asm --help failed"
  CHECK_RESULT $? 0 0 "Check b43-dasm -h failed"
  CHECK_RESULT $? 0 0 "Check b43-dasm --help failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier -h failed"
  CHECK_RESULT $? 0 0 "Check b43-beautifier --help failed"
```

- 涉及命令：ssb-sprom×2, b43-asm×1, b43-dasm×1, b43-beautifier×1, b43-fwdump×1
