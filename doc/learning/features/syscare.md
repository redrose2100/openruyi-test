# syscare

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/syscare` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_syscare_build_kpatch | Pressure load : concurrent operations | pre_test/run_test/post_test | 7 |  |  | 720m |
| oe_test_syscare_build_all_param | Pressure load : concurrent operations | pre_test/run_test/post_test | 6 |  |  | 720m |
| oe_test_syscare_build_error_param | Pressure load : concurrent operations | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_service_syscare | Test syscare.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_syscare_build_kpatch

- 描述：Pressure load : concurrent operations
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rpm×2

#### oe_test_syscare_build_all_param

- 描述：Pressure load : concurrent operations
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rpm×2

#### oe_test_syscare_build_error_param

- 描述：Pressure load : concurrent operations
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 2 0 "syscare build fail"
  CHECK_RESULT $? 2 0 "syscare build fail"
  CHECK_RESULT $? 2 0 "syscare build fail"
  CHECK_RESULT $? 255 0 "syscare build fail"
  CHECK_RESULT $? 2 0 "syscare build fail"
  CHECK_RESULT $? 255 0 "syscare build fail"
  CHECK_RESULT $? 2 0 "syscare build fail"
  CHECK_RESULT $? 255 0 "syscare build fail"
```

#### oe_test_service_syscare

- 描述：Test syscare.service restart
- 函数：`pre_test, run_test, post_test`