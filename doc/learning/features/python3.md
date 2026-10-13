# python3

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/python3` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_python3-devel | File system common command python3-devel | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_python3-devel_01 | File system common command python3-devel | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_python3-threading | test python3-threading | run_test | 1 |  |  |  |
| oe_test_python3-hashlib | File system common command python3-hashlib | run_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_python3-devel

- 描述：File system common command python3-devel
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "python3-config command execution failure"
  CHECK_RESULT $? 0 0 "header file location display failed"
  CHECK_RESULT $? 0 0 "python parameter display failure"
  CHECK_RESULT $? 0 0 "library file list fails to be displayed"
```

#### oe_test_python3-devel_01

- 描述：File system common command python3-devel
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "header file location display failed"
  CHECK_RESULT $? 0 0 "python parameter display failure"
  CHECK_RESULT $? 0 0 "python parameter display failure"
  CHECK_RESULT $? 0 0 "library file list fails to be displayed"
```

#### oe_test_python3-threading

- 描述：test python3-threading
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "python3-threading test fail"
```

#### oe_test_python3-hashlib

- 描述：File system common command python3-hashlib
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "python3-hashlib test fail"
```
