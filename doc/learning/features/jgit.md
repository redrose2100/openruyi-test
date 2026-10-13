# jgit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jgit` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jgit_01 | Test jgit | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_jgit_02 | Test jgit | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_jgit_03 | Test jgit | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_jgit_01

- 描述：Test jgit
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check jgit -h failed"
  CHECK_RESULT $? 0 0 "Check jgit --help failed"
  CHECK_RESULT $? 0 0 "Check jgit --version failed"
  CHECK_RESULT $? 0 0 "Check jgit clone failed"
  CHECK_RESULT $? 0 0 "Check jgit add failed"
  CHECK_RESULT $? 0 0 "Check jgit archive failed"
  CHECK_RESULT $? 0 0 "Check jgit branch failed"
  CHECK_RESULT $? 0 0 "Check jgit checkout failed"
  CHECK_RESULT $? 1 0 "Check jgit clean failed"
  CHECK_RESULT $? 0 0 "Check jgit commit failed"
  CHECK_RESULT $? 0 0 "Check jgit config failed"
  CHECK_RESULT $? 0 0 "Check jgit daemon failed"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：test×3, tar×1, jgit×1, java×1, pgrep×1, kill×1

#### oe_test_jgit_02

- 描述：Test jgit
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check jgit gc failed"
  CHECK_RESULT $? 0 0 "Check jgit init failed"
  CHECK_RESULT $? 0 0 "Check jgit log failed"
  CHECK_RESULT $? 0 0 "Check jgit ls-files failed"
  CHECK_RESULT $? 0 0 "Check jgit ls-remote failed"
  CHECK_RESULT $? 0 0 "Check jgit ls-tree failed"
  CHECK_RESULT $? 0 0 "Check jgit merge failed"
  CHECK_RESULT $? 0 0 "Check jgit push failed"
  CHECK_RESULT $? 0 0 "Check jgit reflog failed"
```

- 涉及命令：tar×1, test×1

#### oe_test_jgit_03

- 描述：Test jgit
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check jgit reset failed"
  CHECK_RESULT $? 1 0 "Check jgit rm failed"
  CHECK_RESULT $? 0 0 "Check jgit show failed"
  CHECK_RESULT $? 0 0 "Check jgit status failed"
  CHECK_RESULT $? 0 0 "Check jgit tag failed"
  CHECK_RESULT $? 0 0 "Check jgit version failed"
  CHECK_RESULT $? 0 0 "Check jgit repo failed"
```

- 涉及命令：tar×1, test×1
