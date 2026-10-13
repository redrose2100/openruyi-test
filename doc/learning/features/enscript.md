# enscript

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/enscript` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_enscript01 | Test enscript use 01 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_enscript02 | Test enscript use 02 | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_enscript01

- 描述：Test enscript use 01
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "check --version failed"
  CHECK_RESULT $? 0 0 "check --help failed"
  CHECK_RESULT $? 0 0 "check -o failed"
  CHECK_RESULT $? 0 0 "check -f failed"
  CHECK_RESULT $? 0 0 "check --list-media failed"
```

- 涉及命令：enscript×2, test×1

#### oe_test_enscript02

- 描述：Test enscript use 02
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "check stdin input failed"
  CHECK_RESULT $? 0 0 "check --columns failed"
  CHECK_RESULT $? 0 0 "check --landscape failed"
  CHECK_RESULT $? 0 0 "check --line-numbers failed"
  CHECK_RESULT $? 0 0 "check non-existent file failed"
```
