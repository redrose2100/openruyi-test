# help2man

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/help2man` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_help2man | command test help2man | pre_test/run_test/post_test | 17 | ✔ |  |  |

### 断言与命令明细

#### oe_test_help2man

- 描述：command test help2man
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man --help"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man --version"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -n example echo"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -s 8 echo"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man-S FSF echo"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -m manname echo"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -L C help2man"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -i ./additional.h2m help2man"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -I does_not_exist.h2m help2man"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: help2man -p infoname echo"
  CHECK_RESULT $? 1 0 "log message: Failed to run command: help2man -N echo"
  CHECK_RESULT $? 1 0 "log message: Failed to run command: help2man -l echo"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：help2man×13
