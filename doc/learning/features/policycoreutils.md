# policycoreutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/policycoreutils` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_restorecond | Test restorecond.service restart | run_test | 0 |  |  |  |
| oe_test_service_selinux-autorelabel-mark | Test selinux-autorelabel-mark.service restart | run_test | 0 |  |  |  |
| oe_test_service_selinux-autorelabel | Test selinux-autorelabel.service restart | run_test | 0 |  |  |  |
| oe_test_target_selinux-autorelabel | Test selinux-autorelabel.target restart | run_test | 0 |  |  |  |

### 断言与命令明细

#### oe_test_service_restorecond

- 描述：Test restorecond.service restart
- 函数：`run_test`
#### oe_test_service_selinux-autorelabel-mark

- 描述：Test selinux-autorelabel-mark.service restart
- 函数：`run_test`
#### oe_test_service_selinux-autorelabel

- 描述：Test selinux-autorelabel.service restart
- 函数：`run_test`
#### oe_test_target_selinux-autorelabel

- 描述：Test selinux-autorelabel.target restart
- 函数：`run_test`