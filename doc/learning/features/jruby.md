# jruby

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jruby` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jruby | jruby formatting test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jruby01 | jruby formatting test | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_jruby

- 描述：jruby formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "jruby test fail"
  CHECK_RESULT $? 0 0 "execute jruby.file fail"
```

- 涉及命令：rpm×1, test×1

#### oe_test_jruby01

- 描述：jruby formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Hash test file creation fail"
  CHECK_RESULT $? 0 0 "HashMap size verification fail"
  CHECK_RESULT $? 0 0 "HashMap get operation fail"
  CHECK_RESULT $? 0 0 "HashMap traversal fail"
  CHECK_RESULT $? 0 0 "Array length verification fail"
  CHECK_RESULT $? 0 0 "Array traversal and concatenation fail"
```

- 涉及命令：grep×5, test×1
