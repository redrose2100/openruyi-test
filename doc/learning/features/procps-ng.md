# procps-ng

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/procps-ng` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_procps-ng-pmap | package procps-ng-pmap | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_procps-ng-pwdx | Use procps-ng-pwdx case | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_procps-ng-pmap

- 描述：package procps-ng-pmap
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Compilation failed"
  CHECK_RESULT $? 0 0 "Pmap execution failed"
  CHECK_RESULT $? 0 0 "Pmap -x execution failed"
  CHECK_RESULT $? 0 0 "Pmap -d execution failed"
  CHECK_RESULT $? 0 0 "Pmap -V  execution failed"
  CHECK_RESULT $? 0 0 "Pmap -X execution failed"
```

- 涉及命令：pmap×4, kill×1

#### oe_test_procps-ng-pwdx

- 描述：Use procps-ng-pwdx case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error, Fail to create test.c"
  CHECK_RESULT $? 0 0 "Error,Check if gcc is installed ？"
  CHECK_RESULT $? 0 0 "Error, Failed to obtain directory"
```

- 涉及命令：kill×1
