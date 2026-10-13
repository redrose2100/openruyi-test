# python-lesscpy

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/python-lesscpy` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_lesscpy | A compiler written in Python for LESS | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_lesscpy

- 描述：A compiler written in Python for LESS
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Help message is misprinted"
  CHECK_RESULT $? 0 0 "version message is misprinted"
  CHECK_RESULT $? 0 0 "Description Failed to print the detailed mode"
  CHECK_RESULT $? 1 0 "Failed to output file"
  CHECK_RESULT $? 0 0 "Minimize output failure"
  CHECK_RESULT $? 0 0 "Minimize output or Block a newline failure"
  CHECK_RESULT $? 0 0 "Failed to use tabs"
  CHECK_RESULT $? 0 0 "Failed to specify 8 Spaces at the beginning"
```

- 涉及命令：lesscpy×8
