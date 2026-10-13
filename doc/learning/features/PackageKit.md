# PackageKit

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/PackageKit` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_packagekit-offline-update | Test packagekit-offline-update.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_packagekit | Test packagekit.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_packagekit_pkcon | Test pkcon function | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_packagekit-offline-update

- 描述：Test packagekit-offline-update.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_packagekit

- 描述：Test packagekit.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：rpm×1

#### oe_test_packagekit_pkcon

- 描述：Test pkcon function
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "pkcon remove fail"
  CHECK_RESULT $? 1 0 "package installed"
  CHECK_RESULT $? 0 0 "pkcon install fail"
  CHECK_RESULT $? 0 0 "package not installed"
  CHECK_RESULT $? 0 0 "pkcon install fail"
  CHECK_RESULT $? 0 0 "package not installed"
  CHECK_RESULT $? 0 0 "pkcon remove fail"
  CHECK_RESULT $? 1 0 "package installed"
  CHECK_RESULT $? 0 0 "pkcon search fail"
```

- 涉及命令：rpm×4
