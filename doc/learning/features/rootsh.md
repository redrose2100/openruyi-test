# rootsh

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rootsh` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rootsh01 | Test Command rootsh | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_rootsh02 | Test Command rootsh | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rootsh01

- 描述：Test Command rootsh
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: -h"
  CHECK_RESULT $? 0 0 "Failed option: -V"
  CHECK_RESULT $? 0 0 "Failed option: -i"
  CHECK_RESULT $? 0 0 "Failed option: -i"
  CHECK_RESULT $? 0 0 "Failed option: -u"
  CHECK_RESULT $? 0 0 "Failed option: -u"
  CHECK_RESULT $? 1 0 "Failed option: -u"
  CHECK_RESULT $? 0 0 "Failed option: -f"
  CHECK_RESULT $? 0 0 "Failed option: -f"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 0 0 "Failed option: -d"
  CHECK_RESULT $? 1 0 "Failed option: -d"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：grep×6, userdel×1

#### oe_test_rootsh02

- 描述：Test Command rootsh
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: --help"
  CHECK_RESULT $? 0 0 "Failed option: --version"
  CHECK_RESULT $? 0 0 "Failed option: --initial"
  CHECK_RESULT $? 0 0 "Failed option: --initial"
  CHECK_RESULT $? 0 0 "Failed option: --user"
  CHECK_RESULT $? 0 0 "Failed option: --user"
  CHECK_RESULT $? 1 0 "Failed option: --user"
  CHECK_RESULT $? 0 0 "Failed option: --logfile"
  CHECK_RESULT $? 0 0 "Failed option: --logfile"
  CHECK_RESULT $? 0 0 "Failed option: --logdir"
  CHECK_RESULT $? 0 0 "Failed option: --logdir"
  CHECK_RESULT $? 1 0 "Failed option: --logdir"
```

- 涉及命令：grep×4, userdel×1
