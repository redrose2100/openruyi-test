# yelp-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/yelp-tools` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_yelp-build | yelp build | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_yelp-check | yelp check | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_yelp-new | yelp new | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_yelp-build

- 描述：yelp build
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "html failed"
  CHECK_RESULT $? 0 0  "find html failed"
  CHECK_RESULT $? 0 0 "cache failed"
  CHECK_RESULT $? 0 0 "find cache failed"
  CHECK_RESULT $? 0 0 "epub failed"
  CHECK_RESULT $? 0 0 "find epub failed"
```

- 涉及命令：test×3

#### oe_test_yelp-check

- 描述：yelp check
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "build failed"
  CHECK_RESULT $? 0 0 "check failed"
```

#### oe_test_yelp-new

- 描述：yelp new
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "stub failed"
  CHECK_RESULT $? 0 0 "find first failed"
  CHECK_RESULT $? 0 0 "tmpl failed"
  CHECK_RESULT $? 0 0 "find second failed"
```

- 涉及命令：test×2
