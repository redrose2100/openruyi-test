# gyp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gyp` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gyp_01 | Test gyp | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_gyp_02 | Test gyp | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gyp_01

- 描述：Test gyp
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check gyp --help failed"
  CHECK_RESULT $? 0 0 "Check gyp --depth failed"
  CHECK_RESULT $? 0 0 "Check gyp --format failed"
  CHECK_RESULT $? 0 0 "Check gyp -f failed"
  CHECK_RESULT $? 0 0 "Check gyp -d failed"
  CHECK_RESULT $? 0 0 "Check gyp --debug failed"
  CHECK_RESULT $? 0 0 "Check gyp -D failed"
  CHECK_RESULT $? 0 0 "Check gyp --ignore-environment failed"
  CHECK_RESULT $? 0 0 "Check gyp --include failed"
  CHECK_RESULT $? 0 0 "Check gyp -I failed"
  CHECK_RESULT $? 0 0 "Check gyp --no-circular-check failed"
```

- 涉及命令：tar×1

#### oe_test_gyp_02

- 描述：Test gyp
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check gyp --help failed"
  CHECK_RESULT $? 0 0 "Check gyp --no-duplicate-basename-check failed"
  CHECK_RESULT $? 0 0 "Check gyp --no-parallel failed"
  CHECK_RESULT $? 0 0 "Check gyp -S failed"
  CHECK_RESULT $? 0 0 "Check gyp --suffix failed"
  CHECK_RESULT $? 0 0 "Check gyp --toplevel-dir failed"
  CHECK_RESULT $? 0 0 "Check gyp -R failed"
  CHECK_RESULT $? 0 0 "Check gyp --root-target failed"
  CHECK_RESULT $? 0 0 "Check gyp --generator-output failed"
  CHECK_RESULT $? 0 0 "Check gyp --config-dir failed"
```

- 涉及命令：tar×1
