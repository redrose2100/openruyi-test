# hyperscan

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hyperscan` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_hyperscan_simplegrep | Test hyperscan simplegrep | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_hyperscan_simplegrep01 | Test hyperscan simplegrep | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_hyperscan_simplegrep

- 描述：Test hyperscan simplegrep
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Compilation failure"
  CHECK_RESULT $? 0 0 "Query failure"
  CHECK_RESULT $? 0 0 "Query failure2"
```

- 涉及命令：gcc×1, test×1, grep×1

#### oe_test_hyperscan_simplegrep01

- 描述：Test hyperscan simplegrep
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Compile simplegrep failed"
  CHECK_RESULT $? 0 0 "simplegrep binary not found after compilation"
  CHECK_RESULT $? 0 0 "simplegrep multiple patterns matching failed"
  CHECK_RESULT $? 0 0 "simplegrep number pattern matching failed"
  CHECK_RESULT $? 0 0 "simplegrep line start pattern matching failed"
  CHECK_RESULT $? 0 0 "simplegrep case-sensitive pattern matching failed"
  CHECK_RESULT $? 0 0 "simplegrep help information query failed"
```

- 涉及命令：gcc×1, test×1
